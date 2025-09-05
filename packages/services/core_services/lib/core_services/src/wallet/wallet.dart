import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletState {
  final double coins;
  final double premium;
  const WalletState({this.coins = 0, this.premium = 0});
  WalletState copyWith({double? coins, double? premium}) =>
      WalletState(coins: coins ?? this.coins, premium: premium ?? this.premium);
}

class WalletNotifier extends StateNotifier<WalletState> {
  WalletNotifier() : super(const WalletState());
  void setState(WalletState newState) => state = newState;
  void addCoins(double amount) =>
      state = state.copyWith(coins: state.coins + amount);
  bool spendCoins(double amount) {
    if (state.coins >= amount) {
      state = state.copyWith(coins: state.coins - amount);
      return true;
    }
    return false;
  }
}

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>(
    (ref) => WalletNotifier());
