import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'idle_dao.dart';
import 'wallet_dao.dart';
import 'isar_db.dart';

class IdleServiceIsar {
  final Isar _isar;
  IdleServiceIsar(this._isar);

  Future<void> init() async {
    await _isar.writeTxn(() async {
      await _isar.idleStateEntitys.put(IdleStateEntity()); // ensure row exists
      await _isar.walletEntitys.put(WalletEntity());
    });
  }

  Future<double> computeOfflineYield({double capSeconds = 8 * 3600}) async {
    final now = DateTime.now();
    IdleStateEntity? state;
    await _isar.txn(() async {
      state = await _isar.idleStateEntitys.get(0);
    });
    state ??= IdleStateEntity();
    final delta =
        now.difference(state!.lastSeen ?? DateTime.now()).inSeconds.toDouble();
    final clamped = delta.clamp(0, capSeconds);
    final yieldVal = clamped * state!.totalRatePerSec;
    await _isar.writeTxn(() async {
      state!.lastSeen = now;
      await _isar.idleStateEntitys.put(state!);
    });
    return yieldVal;
  }

  Future<void> grantCoins(double amount) async {
    await _isar.writeTxn(() async {
      final w = (await _isar.walletEntitys.get(0)) ?? WalletEntity();
      w.coins += amount;
      await _isar.walletEntitys.put(w);
    });
  }
}

// Providers
final isarProvider = FutureProvider<Isar>((ref) async {
  return await IsarDb.instance([IdleStateEntitySchema, WalletEntitySchema]);
});

final idleServiceIsarProvider = FutureProvider<IdleServiceIsar>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  final svc = IdleServiceIsar(isar);
  await svc.init();
  return svc;
});
