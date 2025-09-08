import 'dart:math' as math;

abstract class Rng {
  int nextInt(int maxExclusive);
  double nextDouble();
}

class SystemRng implements Rng {
  final math.Random _random = math.Random();

  @override
  int nextInt(int maxExclusive) => _random.nextInt(maxExclusive);

  @override
  double nextDouble() => _random.nextDouble();
}

class DeterministicRng implements Rng {
  final math.Random _random;
  DeterministicRng(int seed) : _random = math.Random(seed);

  @override
  int nextInt(int maxExclusive) => _random.nextInt(maxExclusive);

  @override
  double nextDouble() => _random.nextDouble();
}
