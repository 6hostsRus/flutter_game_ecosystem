library services.simple_economy;

import 'economy_port.dart';

/// A minimal in-memory implementation of [EconomyPort] used for tests/demo.
class SimpleEconomy implements EconomyPort {
  final Map<String, int> _balances = {};
  final Set<String> _knownCurrencies;
  final List<Offer> _offers;
  final void Function(CurrencyDelta delta)? onApply;
  final void Function(String event, Map<String, Object?> props)? onEvent;

  SimpleEconomy({
    Set<String> currencies = const {'coins', 'premium'},
    List<Offer> offers = const [],
    this.onApply,
    this.onEvent,
  })  : _knownCurrencies = currencies,
        _offers = offers;

  @override
  int checkBalance(String currency) {
    if (!_knownCurrencies.contains(currency)) throw UnknownCurrency(currency);
    return _balances[currency] ?? 0;
  }

  @override
  void apply(CurrencyDelta delta) {
    if (!_knownCurrencies.contains(delta.currency)) {
      throw UnknownCurrency(delta.currency);
    }
    final current = _balances[delta.currency] ?? 0;
    final next = current + delta.amount;
    if (next < 0) {
      throw InsufficientFunds(delta.currency, -delta.amount, current);
    }
    _balances[delta.currency] = next;
    onApply?.call(delta);
    onEvent?.call('economy_delta', {
      'currency': delta.currency,
      'amount': delta.amount,
      'reason': delta.reason,
      'balance': _balances[delta.currency],
    });
  }

  @override
  List<Offer> offerCatalog() => List.unmodifiable(_offers);

  @override
  void award(String currency, int amount, {String reason = 'reward'}) {
    apply(CurrencyDelta(currency: currency, amount: amount, reason: reason));
  }

  @override
  void spend(String currency, int amount, {String reason = 'spend'}) {
    if (amount <= 0) {
      throw ArgumentError.value(amount, 'amount', 'must be > 0');
    }
    apply(CurrencyDelta(currency: currency, amount: -amount, reason: reason));
  }
}
