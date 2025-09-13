import "dart:convert";
import "dart:io";
import "package:json_schema2/json_schema.dart" as js2;
import "package:path/path.dart" as p;
import "models.dart";

class ValidationReport {
  final bool ok;
  final List<String> errors;
  final List<String> warnings;

  const ValidationReport({
    required this.ok,
    this.errors = const [],
    this.warnings = const [],
  });
}

Future<ValidationReport> validateWithSchemas(
  MergedConfig merged, {
  String? schemasRoot,
}) async {
  final errors = <String>[];
  final warnings = List<String>.from(merged.warnings);

  final engine = merged.manifest.engine;
  schemasRoot ??= "assets/schemas";
  final path = p.join(schemasRoot, "$engine.v1.json");
  final f = File(path);
  if (!f.existsSync()) {
    warnings.add("No JSON Schema found for engine \"$engine\" at $path");
    return ValidationReport(
      ok: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  final schemaJson = json.decode(f.readAsStringSync());
  final schema = await js2.JsonSchema.create(schemaJson);
  final result = schema.validate(merged.effective);
  if (!result.isValid) {
    for (final e in result.errors) {
      errors.add(e.toString());
    }
  }
  return ValidationReport(
    ok: errors.isEmpty,
    errors: errors,
    warnings: warnings,
  );
}
