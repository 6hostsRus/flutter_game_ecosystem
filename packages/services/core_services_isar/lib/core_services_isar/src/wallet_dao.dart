import 'package:isar/isar.dart';

part 'wallet_dao.g.dart';

@collection
class WalletEntity {
  Id id = 0; // singleton row
  double coins;
  double premium;
  WalletEntity({this.coins = 0, this.premium = 0});
}
