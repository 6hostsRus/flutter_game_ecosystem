# Controls Module (V1)

## Purpose
Abstract touch/gesture/tilt into game actions; supply virtual joysticks & buttons.

## Key Types
```dart
enum GameAction { jump, dash, attack, pause, moveX, moveY }
abstract class InputSource { GameInputSnapshot poll(); }
class GameInputSnapshot { Map<GameAction, double> axes; Set<GameAction> buttons; }
```

## Features
- **Adapters**: gesture (tap/swipe), virtual joystick, accelerometer, keyboard (desktop debug).
- **Deadzones & smoothing** for analog inputs.
- **Rebinding** config with presets per template.

## UI Widgets
- `VirtualStick`, `ActionButton`, `PauseButton`

## Deliverables (v1)
- Input abstraction + gesture adapter
- Virtual joystick + 1–2 action buttons
- Example mappings for each template
