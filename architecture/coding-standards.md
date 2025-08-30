# Coding Standards (V1)

- **Null‑safe, linted**: use `flutter_lints` + `very_good_analysis`.
- **Public APIs**: small, noun‑based classes; verbs as methods; avoid leaking engine types.
- **Events**: prefer `Stream` or lightweight event bus; keep UI decoupled from simulation.
- **Time**: pass `dt` (deltaTime) explicitly; no `DateTime.now()` in core logic.
- **Serialization**: use `json_serializable` for DTOs/configs.
- **Testing**: fast unit tests for logic; golden tests for widgets; integration tests for ad gates/save/load.
