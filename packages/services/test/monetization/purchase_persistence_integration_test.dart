import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:core_services_isar/core_services_isar.dart';
import 'package:services/monetization/in_app_purchase_adapter.dart';
import 'package:services/monetization/gateway_port.dart';
import 'package:services/monetization/sku_rewards.dart';

void main() {
  group('PurchasePersistenceIntegration', () {
    late InAppPurchase iap;
    late ProviderContainer container;
    const skuCoins100 = 'coins_100';
    const skuPremium5 = 'premium_5';
    late File persistFile;

    setUp(() async {
      iap = InAppPurchase.instance;
      WidgetsFlutterBinding.ensureInitialized();
      // Seed a product worth 100 coins (implicit mapping). Price raw micros optional.
      iap.seedProducts([
        ProductDetails(
          id: skuCoins100,
          title: '100 Coins',
          description: 'Grants 100 coins',
          price: const ProductPrice(price: '2.99', raw: '2990000'),
          currencyCode: 'USD',
        ),
        ProductDetails(
          id: skuPremium5,
          title: '5 Premium Gems',
          description: 'Grants 5 premium currency',
          price: const ProductPrice(price: '0.99', raw: '990000'),
          currencyCode: 'USD',
        ),
      ]);

      // Use temp directory override for deterministic Isar path.
      final tmp = await Directory.systemTemp.createTemp('isar_test_');
      IsarDb.overrideDirectory = tmp.path;
      await IsarDb.closeAndReset();

      persistFile = File('${IsarDb.overrideDirectory}/wallet.json');
      container = ProviderContainer(overrides: [
        walletPersistenceDelegateProvider.overrideWithValue(
          FileWalletDelegate(persistFile),
        ),
      ]);
    });

    tearDown(() async {
      await IsarDb.closeAndReset();
      container.dispose();
    });

    Future<void> _initPersistence() async {
      await container.read(walletPersistenceInitializerProvider.future);
    }

    test('successful coin purchase updates wallet and persists across restart',
        () async {
      final adapter = InAppPurchaseMonetizationAdapter({skuCoins100}, iap: iap);
      await adapter.init();

      // Initialize persistence (loads initial wallet state, expected 0).
      await _initPersistence();
      expect(container.read(walletProvider).coins, 0);

      // Listen to purchase stream and credit coins when success.
      final sub = adapter.purchaseStream.listen((r) {
        applyRewardForPurchase(container.read, r);
      });

      // Trigger checkout (pending result returned immediately).
      final pending =
          await adapter.checkout(CheckoutRequest(skuId: skuCoins100));
      expect(pending.state, PurchaseState.pending);

      // Allow automatic stub success event dispatch (buyConsumable triggers success).
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(container.read(walletProvider).coins, 100);

      // Give persistence listener a moment to flush.
      await Future<void>.delayed(const Duration(milliseconds: 20));

      // Simulate app restart: close DB + new container.
      await IsarDb.closeAndReset();
      // keep same override directory for persistence continuity
      final newContainer = ProviderContainer(overrides: [
        walletPersistenceDelegateProvider.overrideWithValue(
          FileWalletDelegate(persistFile),
        ),
      ]);
      addTearDown(newContainer.dispose);
      // Reuse directory; re-init.
      await newContainer.read(walletPersistenceInitializerProvider.future);
      // Wallet should restore prior 100 coins.
      expect(newContainer.read(walletProvider).coins, 100);
      await sub.cancel();
    });

    test('restart without purchases keeps zero balance', () async {
      final adapter = InAppPurchaseMonetizationAdapter(
          {skuCoins100, skuPremium5},
          iap: iap);
      await adapter.init();
      await _initPersistence();
      expect(container.read(walletProvider).coins, 0);
      await IsarDb.closeAndReset();
      final newContainer = ProviderContainer(overrides: [
        walletPersistenceDelegateProvider.overrideWithValue(
          FileWalletDelegate(persistFile),
        ),
      ]);
      addTearDown(newContainer.dispose);
      await newContainer.read(walletPersistenceInitializerProvider.future);
      expect(newContainer.read(walletProvider).coins, 0);
    });

    test('premium purchase credits premium balance (simulated) and persists',
        () async {
      final adapter = InAppPurchaseMonetizationAdapter(
          {skuCoins100, skuPremium5},
          iap: iap);
      await adapter.init();
      await _initPersistence();
      expect(container.read(walletProvider).premium, 0);

      final sub = adapter.purchaseStream.listen((r) {
        applyRewardForPurchase(container.read, r);
      });
      await adapter.checkout(CheckoutRequest(skuId: skuPremium5));
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(container.read(walletProvider).premium, 5);

      await IsarDb.closeAndReset();
      final newContainer = ProviderContainer(overrides: [
        walletPersistenceDelegateProvider.overrideWithValue(
          FileWalletDelegate(persistFile),
        ),
      ]);
      addTearDown(newContainer.dispose);
      await newContainer.read(walletPersistenceInitializerProvider.future);
      expect(newContainer.read(walletProvider).premium, 5);
      await sub.cancel();
    });

    test('duplicate success events do not double credit', () async {
      final adapter = InAppPurchaseMonetizationAdapter({skuCoins100}, iap: iap);
      await adapter.init();
      await _initPersistence();
      expect(container.read(walletProvider).coins, 0);
      final sub = adapter.purchaseStream.listen((r) {
        applyRewardForPurchase(container.read, r);
      });
      final orderId = 'dup_test';
      iap.debugEmitStatus(skuCoins100, PurchaseStatus.purchased,
          orderId: orderId); // first
      iap.debugEmitStatus(skuCoins100, PurchaseStatus.purchased,
          orderId: orderId); // duplicate
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(container.read(walletProvider).coins, 100); // only one credit
      await sub.cancel();
    });
  });
}
