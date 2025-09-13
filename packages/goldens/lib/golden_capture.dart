import "dart:convert";
import "dart:io";
import "package:path/path.dart" as p;

class GoldenCapture {
  final String outDir;
  GoldenCapture(this.outDir);

  void writeSnapshot({
    required Map<String, dynamic> mergedConfig,
    required int seed,
    required Stream<Map<String, dynamic>> events,
    String sessionName = "session",
  }) async {
    final dir = Directory(outDir);
    if (!dir.existsSync()) dir.createSync(recursive: true);
    final base = p.join(outDir, sessionName);
    File("$base.config.json").writeAsStringSync(
      const JsonEncoder.withIndent(
        "  ",
      ).convert({"seed": seed, "config": mergedConfig}),
    );
    final sink = File("$base.events.jsonl").openWrite(mode: FileMode.writeOnly);
    await for (final e in events) {
      sink.writeln(jsonEncode(e));
    }
    await sink.flush();
    await sink.close();
  }
}
