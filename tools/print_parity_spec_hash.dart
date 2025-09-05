// Emits the current parity spec hash used for gating.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

void main() {
  final specFiles = [
    'tools/check_stub_parity.dart',
    'packages/in_app_purchase/lib/in_app_purchase.dart',
    'packages/services/core_services_isar/lib/core_services_isar/src/wallet_service_isar.dart',
  ];
  final buffer = BytesBuilder();
  for (final p in specFiles) {
    final f = File(p);
    if (!f.existsSync()) continue;
    buffer.add(utf8.encode(p));
    buffer.add(f.readAsBytesSync());
  }
  final hash = sha1.convert(buffer.toBytes()).toString();
  stdout.write(hash);
}
