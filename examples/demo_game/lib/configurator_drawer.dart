import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:providers/config/config_provider.dart";

class ConfiguratorDrawer extends ConsumerWidget {
  const ConfiguratorDrawer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merged = ref.watch(mergedConfigProvider);
    final report = ref.watch(validationReportProvider);
    return Drawer(
        child: SafeArea(
            child: DefaultTabController(
                length: 6,
                child: Column(children: [
                  const TabBar(isScrollable: true, tabs: [
                    Tab(text: "Engines"),
                    Tab(text: "Packs"),
                    Tab(text: "Seed"),
                    Tab(text: "Telemetry"),
                    Tab(text: "Validation"),
                    Tab(text: "Diff")
                  ]),
                  Expanded(
                      child: TabBarView(children: [
                    _engines(context, ref),
                    _packs(context, ref),
                    _seed(context, ref),
                    const Center(child: Text("Telemetry WIP")),
                    _validation(report),
                    _diff(merged),
                  ])),
                ]))));
  }

  Widget _engines(BuildContext c, WidgetRef r) =>
      r.watch(mergedConfigProvider).when(
          data: (m) => ListView(padding: const EdgeInsets.all(12), children: [
                Text("Engine: ${m.manifest.engine}",
                    style: Theme.of(c).textTheme.titleMedium),
                Text("Pack: ${m.manifest.name}"),
                Text("Risk: ${m.manifest.risk}"),
                Text("Locales: ${m.manifest.locales.join(", ")}"),
              ]),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Padding(
              padding: const EdgeInsets.all(12), child: Text("Error: $e")));
  Widget _packs(BuildContext c, WidgetRef r) {
    final sel = r.watch(selectedPackProvider);
    return Padding(
        padding: const EdgeInsets.all(12),
        child: TextFormField(
            initialValue: sel,
            decoration: const InputDecoration(labelText: "Selected Pack"),
            onChanged: (v) => r.read(selectedPackProvider.notifier).state = v));
  }

  Widget _seed(BuildContext c, WidgetRef r) {
    final lock = r.watch(lockSeedProvider);
    final seed = r.watch(seedProvider);
    return Padding(
        padding: const EdgeInsets.all(12),
        child: TextFormField(
            enabled: !lock,
            initialValue: seed.toString(),
            decoration: InputDecoration(
                labelText: "Seed",
                helperText: lock ? "Locked by pack" : "Editable"),
            onChanged: (v) =>
                r.read(seedProvider.notifier).state = int.tryParse(v) ?? seed));
  }

  Widget _validation(AsyncValue rep) => rep.when(
      data: (r) {
        final ok = r.ok as bool;
        final errs = (r.errors as List).cast<String>();
        final warns = (r.warnings as List).cast<String>();
        return ListView(padding: const EdgeInsets.all(12), children: [
          Text(ok ? "Validation: OK" : "Validation: FAILED",
              style: TextStyle(color: ok ? Colors.green : Colors.red)),
          const SizedBox(height: 8),
          if (warns.isNotEmpty)
            const Text("Warnings:",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ...warns.map(Text.new),
          if (errs.isNotEmpty) const SizedBox(height: 12),
          if (errs.isNotEmpty)
            const Text("Errors:",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ...errs
              .map((e) => Text(e, style: const TextStyle(color: Colors.red))),
        ]);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Padding(padding: const EdgeInsets.all(12), child: Text("Error: $e")));
  Widget _diff(AsyncValue merged) => merged.when(
      data: (m) => SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: SelectableText(
              const JsonEncoder.withIndent("  ").convert(m.diffTree))),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Padding(padding: const EdgeInsets.all(12), child: Text("Error: $e")));
}
