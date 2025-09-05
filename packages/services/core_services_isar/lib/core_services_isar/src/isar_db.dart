import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as pp;

class IsarDb {
  static Isar? _instance;

  /// Optional test override directory. If set, skips path_provider.
  static String? overrideDirectory;

  static Future<Isar> instance(List<CollectionSchema> schemas) async {
    if (_instance != null) return _instance!;
    final dirPath = overrideDirectory ?? (await _resolveDefaultDir()).path;
    _instance = await Isar.open(schemas, directory: dirPath);
    return _instance!;
  }

  static Future<Directory> _resolveDefaultDir() async {
    try {
      return await pp.getApplicationDocumentsDirectory();
    } catch (_) {
      // Fallback for headless test environments with no platform channels.
      return Directory.systemTemp.createTempSync('isar_fallback_');
    }
  }

  /// Close and reset singleton (test support to simulate app restarts).
  static Future<void> closeAndReset() async {
    final i = _instance;
    _instance = null;
    if (i != null && i.isOpen) {
      await i.close();
    }
  }
}
