// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:riverpod/riverpod.dart';

/// Engines we can target in the configurator.
enum EngineId { match, idle, survivor, rpg }

/// Simple bus for telemetry overlay.
class TelemetryBus {
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _controller.stream;
  void emit(Map<String, dynamic> event) => _controller.add(event);
  void dispose() => _controller.close();
}

final telemetryProvider = Provider<TelemetryBus>((ref) {
  final bus = TelemetryBus();
  ref.onDispose(bus.dispose);
  return bus;
});

/// Selected engine & pack identifiers (to be set by the UI drawer).
final selectedEngineProvider = StateProvider<EngineId>((ref) => EngineId.match);
final selectedPackIdProvider = StateProvider<String?>((ref) => null);

/// Merge chain representation for the diff view.
class MergeChain {
  final Map<String, dynamic> defaults;
  final Map<String, dynamic> pack;
  final Map<String, dynamic> envFlags;
  final Map<String, dynamic> deviceOverrides;
  final Map<String, dynamic> devOverrides;
  final Map<String, dynamic> finalMerged;
  const MergeChain({
    required this.defaults,
    required this.pack,
    required this.envFlags,
    required this.deviceOverrides,
    required this.devOverrides,
    required this.finalMerged,
  });
}

Map<String, dynamic> _deepMerge(
    Map<String, dynamic> a, Map<String, dynamic> b) {
  final out = <String, dynamic>{}..addAll(a);
  b.forEach((k, v) {
    if (v is Map && a[k] is Map) {
      out[k] =
          _deepMerge(a[k] as Map<String, dynamic>, v as Map<String, dynamic>);
    } else {
      out[k] = v;
    }
  });
  return out;
}

/// Placeholder loaders; wire these to your file-watcher in the configurator.
typedef Loader = Future<Map<String, dynamic>> Function(
    EngineId engine, String? packId);

final defaultsLoaderProvider =
    Provider<Loader>((_) => (engine, packId) async => <String, dynamic>{});
final packLoaderProvider =
    Provider<Loader>((_) => (engine, packId) async => <String, dynamic>{});
final envFlagsLoaderProvider =
    Provider<Loader>((_) => (engine, packId) async => <String, dynamic>{});
final deviceOverridesLoaderProvider =
    Provider<Loader>((_) => (engine, packId) async => <String, dynamic>{});
final devOverridesLoaderProvider =
    Provider<Loader>((_) => (engine, packId) async => <String, dynamic>{});

/// Produces the full merge chain and final merged map for the selected engine/pack.
final mergeChainProvider = FutureProvider<MergeChain>((ref) async {
  final engine = ref.watch(selectedEngineProvider);
  final packId = ref.watch(selectedPackIdProvider);
  final defaults = await ref.watch(defaultsLoaderProvider)(engine, packId);
  final pack = await ref.watch(packLoaderProvider)(engine, packId);
  final flags = await ref.watch(envFlagsLoaderProvider)(engine, packId);
  final device = await ref.watch(deviceOverridesLoaderProvider)(engine, packId);
  final dev = await ref.watch(devOverridesLoaderProvider)(engine, packId);

  // Merge order: defaults < pack < env flags < device < dev
  final merged = _deepMerge(
    _deepMerge(
      _deepMerge(
        _deepMerge(defaults, pack),
        flags,
      ),
      device,
    ),
    dev,
  );

  return MergeChain(
    defaults: defaults,
    pack: pack,
    envFlags: flags,
    deviceOverrides: device,
    devOverrides: dev,
    finalMerged: merged,
  );
});

/// Hooks are simple callables you can attach to engine lifecycles.
abstract class BoardEventHook {
  void onSwap(Map<String, dynamic> ctx) {}
  void onMatch(Map<String, dynamic> ctx) {}
  void onCascadeEnd(Map<String, dynamic> ctx) {}
  void onBoardStable(Map<String, dynamic> ctx) {}
}

final hooksProvider = Provider<List<BoardEventHook>>((ref) {
  // TODO: assemble from registry & flags
  return const [];
});
