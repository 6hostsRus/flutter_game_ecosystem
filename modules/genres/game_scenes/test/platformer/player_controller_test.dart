import 'package:flutter_test/flutter_test.dart';
import 'package:game_scenes/platformer.dart';

void main() {
  test('grounded jump sets vy and enables double jump', () {
    final c = PlayerController();
    c.grounded = true;
    c.jump();
    expect(c.vy, -400);
    expect(c.grounded, isFalse);
    expect(c.canDoubleJump, isTrue);
  });

  test('double jump sets vy and disables further double jump', () {
    final c = PlayerController();
    c.grounded = false;
    c.canDoubleJump = true;
    c.jump();
    expect(c.vy, -320);
    expect(c.canDoubleJump, isFalse);
  });

  test('move sets horizontal velocity', () {
    final c = PlayerController();
    c.move(1);
    expect(c.vx, 160);
    c.move(-0.5);
    expect(c.vx, -80);
  });

  test('tick applies gravity to vy', () {
    final c = PlayerController();
    c.vy = 0;
    c.tick(0.5);
    expect(c.vy, closeTo(490, 1e-9));
  });
}
