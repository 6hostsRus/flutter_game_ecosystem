import "package:riverpod/riverpod.dart";
import "package:config_runtime/config_runtime.dart";

final configRootProvider =
    Provider<String>((_) => "examples/configurator/config");
final selectedPackProvider = StateProvider<String>((_) => "demo_pack");
final deviceIdProvider = StateProvider<String?>((_) => null);
final envFlagsProvider = StateProvider<List<String>>((_) => const []);

final mergedConfigProvider = FutureProvider<MergedConfig>((ref) async {
  return LayeredLoader(
    configRoot: ref.watch(configRootProvider),
    selectedPack: ref.watch(selectedPackProvider),
    deviceId: ref.watch(deviceIdProvider),
    envFlags: ref.watch(envFlagsProvider),
  ).load();
});

final seedProvider = StateProvider<int>((ref) {
  final m = ref
      .watch(mergedConfigProvider)
      .maybeWhen(data: (m) => m, orElse: () => null);
  final d = 42;
  return m?.effective["seed"] is int ? m!.effective["seed"] as int : d;
});

final lockSeedProvider = Provider<bool>((ref) {
  final m = ref
      .watch(mergedConfigProvider)
      .maybeWhen(data: (m) => m, orElse: () => null);
  return m?.manifest.lockSeed ?? false;
});

final validationReportProvider = FutureProvider((ref) async {
  final m = await ref.watch(mergedConfigProvider.future);
  return validateWithSchemas(m,
      schemasRoot: "packages/config_runtime/assets/schemas");
});
