import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as pp;

class IsarDb {
  static Isar? _instance;
  static Future<Isar> instance(List<CollectionSchema> schemas) async {
    if (_instance != null) return _instance!;
    final dir = await pp.getApplicationDocumentsDirectory();
    _instance = await Isar.open(schemas, directory: dir.path);
    return _instance!;
  }
}
