import 'dart:io';
import 'dart:convert';
import 'package:core_services/core_services.dart'
    show walletProvider, WalletState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'isar_db.dart';
import 'wallet_dao.dart';

/// Persists the [WalletState] using Isar. Simple two-field mirror.
/// Delegate abstraction so tests can override persistence without Isar.
abstract class WalletPersistenceDelegate {
  Future<void> init();
  Future<WalletState> load();
  Future<void> save(WalletState state);
}

class FileWalletDelegate implements WalletPersistenceDelegate {
  final File _file;
  FileWalletDelegate(this._file);
  @override
  Future<void> init() async {
    if (!await _file.exists()) {
      await _file.writeAsString('{"coins":0,"premium":0}');
    }
  }

  @override
  Future<WalletState> load() async {
    try {
      final txt = await _file.readAsString();
      final map =
          txt.isNotEmpty ? (jsonDecode(txt) as Map<String, dynamic>) : const {};
      return WalletState(
        coins: (map['coins'] as num?)?.toDouble() ?? 0,
        premium: (map['premium'] as num?)?.toDouble() ?? 0,
      );
    } catch (_) {
      return const WalletState();
    }
  }

  @override
  Future<void> save(WalletState state) async {
    final data = jsonEncode({'coins': state.coins, 'premium': state.premium});
    await _file.writeAsString(data, flush: true);
  }
}

class WalletServiceIsar implements WalletPersistenceDelegate {
  final Isar _isar;
  WalletServiceIsar(this._isar);

  Future<void> init() async {
    await _isar.writeTxn(() async {
      await _isar.walletEntitys
          .put(WalletEntity()); // ensure singleton row exists
    });
  }

  @override
  Future<WalletState> load() async {
    final e = await _isar.walletEntitys.get(0);
    if (e == null) return const WalletState();
    return WalletState(coins: e.coins, premium: e.premium);
  }

  @override
  Future<void> save(WalletState state) async {
    final entity = WalletEntity(coins: state.coins, premium: state.premium);
    await _isar.writeTxn(() async => _isar.walletEntitys.put(entity));
  }
}

final walletServiceIsarProvider = Provider<WalletServiceIsar>((ref) {
  throw StateError('walletServiceIsarProvider not initialized');
});

/// Creates a provider that wires the existing in-memory [walletProvider]
/// to persist changes on every state update, and load initial state.
/// Optional override for tests: provide a custom [WalletPersistenceDelegate].
final walletPersistenceDelegateProvider =
    Provider<WalletPersistenceDelegate?>((_) => null);

final walletPersistenceInitializerProvider = FutureProvider<void>((ref) async {
  WalletPersistenceDelegate? delegate =
      ref.read(walletPersistenceDelegateProvider);
  if (delegate == null) {
    try {
      final isar = await IsarDb.instance([WalletEntitySchema]);
      delegate = WalletServiceIsar(isar);
    } catch (e) {
      // Fallback for environments where native Isar lib is unavailable (e.g. flutter test vm)
      final tempDir = Directory.systemTemp.createTempSync('wallet_persist_');
      delegate = FileWalletDelegate(File('${tempDir.path}/wallet.json'));
    }
  }
  await delegate.init();
  final walletNotifier = ref.read(walletProvider.notifier);
  walletNotifier.setState(await delegate.load());
  ref.listen<WalletState>(walletProvider, (_, next) async {
    await delegate!.save(next);
  });
});
