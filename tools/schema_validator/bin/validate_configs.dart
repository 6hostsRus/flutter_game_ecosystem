import "dart:io";
import "package:args/args.dart";
import "package:config_runtime/config_runtime.dart";

void main(List<String> argv) async {
  final p = ArgParser()
    ..addOption("root", defaultsTo: "examples/configurator/config")
    ..addOption("pack", defaultsTo: "demo_pack")
    ..addOption("device")
    ..addMultiOption("flag")
    ..addOption("out", defaultsTo: "goldens/_ci");
  final a = p.parse(argv);
  final merged = LayeredLoader(
          configRoot: a["root"],
          selectedPack: a["pack"],
          deviceId: a["device"],
          envFlags: (a["flag"] as List).cast<String>())
      .load();
  final report = await validateWithSchemas(merged,
      schemasRoot: "packages/config_runtime/assets/schemas");
  final d = Directory(a["out"])..createSync(recursive: true);
  File("${d.path}/effective.json").writeAsStringSync(merged.toPrettyJson());
  File("${d.path}/diff.json")
      .writeAsStringSync(merged.toPrettyJson(merged.diffTree));
  File("${d.path}/warnings.txt").writeAsStringSync(merged.warnings.join("\n"));
  File("${d.path}/errors.txt").writeAsStringSync(report.errors.join("\n"));
  if (!report.ok) {
    stderr.writeln("Validation FAILED.");
    exitCode = 2;
  } else {
    stdout.writeln("Validation OK.");
  }
}
