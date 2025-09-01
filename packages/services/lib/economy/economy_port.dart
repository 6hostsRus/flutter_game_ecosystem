library services.economy_port;

class CurrencyDelta {
  final String currency;
  final int amount;
  final String reason;
  const CurrencyDelta({required this.currency, required this.amount, required this.reason});
}

class Offer {
  final String sku;
  final Map<String, dynamic> meta;
  const Offer({required this.sku, this.meta = const {}});
}

class InsufficientFunds implements Exception {
  final String currency;
  final int needed;
  final int available;
  const InsufficientFunds(this.currency, this.needed, this.available);
  @override
  String toString() => 'InsufficientFunds(currency=$currency, needed=$needed, available=$available)';
}

class UnknownCurrency implements Exception {
  final String currency;
  const UnknownCurrency(this.currency);
  @override
  String toString() => 'UnknownCurrency(currency=$currency)';
}

abstract class EconomyPort {
  int checkBalance(String currency);
  void apply(CurrencyDelta delta);
  void award(String currency, int amount, {String reason = 'reward'}) =>
      apply(CurrencyDelta(currency: currency, amount: amount, reason: reason));
  void spend(String currency, int amount, {String reason = 'spend'}) {
    if (amount <= 0) throw ArgumentError.value(amount, 'amount', 'must be > 0');
    apply(CurrencyDelta(currency: currency, amount: -amount, reason: reason));
  }
  List<Offer> offerCatalog();
}
