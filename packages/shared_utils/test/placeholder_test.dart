import 'package:flutter_test/flutter_test.dart';
import 'package:shared_utils/shared_utils.dart';

void main() {
  test('unawaited exists and is callable', () {
    // Call with a completed future to ensure it doesn't throw.
    unawaited(Future<void>.value());
    expect(true, isTrue);
  });
}
