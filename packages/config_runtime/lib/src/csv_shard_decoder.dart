import "dart:io";
import "package:csv/csv.dart";

Map<String, List<Map<String, dynamic>>> loadCsvShards(String dir) {
  final out = <String, List<Map<String, dynamic>>>{};
  final root = Directory(dir);
  if (!root.existsSync()) return out;

  for (final f in root.listSync(recursive: true).whereType<File>()) {
    if (!f.path.toLowerCase().endsWith(".csv")) continue;
    final rows = const CsvToListConverter(
      eol: "\n",
    ).convert(f.readAsStringSync());
    if (rows.isEmpty) {
      out[_stem(f.path)] = <Map<String, dynamic>>[];
      continue;
    }
    final headers = rows.first.map((e) => e.toString()).toList();
    final list = <Map<String, dynamic>>[];
    for (int i = 1; i < rows.length; i++) {
      final r = rows[i];
      final m = <String, dynamic>{};
      for (int c = 0; c < headers.length && c < r.length; c++) {
        m[headers[c]] = r[c];
      }
      list.add(m);
    }
    out[_stem(f.path)] = list;
  }
  return out;
}

String _stem(String path) {
  final base = path.split(Platform.pathSeparator).last;
  final i = base.lastIndexOf(".");
  return i == -1 ? base : base.substring(0, i);
}
