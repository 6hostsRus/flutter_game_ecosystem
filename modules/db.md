# Database Module (V1)

## Purpose
Save/load player progress, settings, and (optional) cloud sync.

## Local Store
- **Isar** (recommended) or **Hive** for schema‑lite speed.
- Namespaced boxes/collections per game.

## Types
```dart
class SaveSlot { String id; int version; Map<String, dynamic> data; }
abstract class SaveDriver {
  Future<void> write(SaveSlot slot);
  Future<SaveSlot?> read(String id);
  Future<void> delete(String id);
}
```

## Cloud (optional, v1-lite)
- Firebase Auth (anonymous → upgrade)
- Firestore doc mirroring of `SaveSlot`
- Conflict policy: last‑write‑wins with version check

## Deliverables (v1)
- Local driver (Isar/Hive)
- Simple sync stub with toggles
- Migration guard (versioned slots)
