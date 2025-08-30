# Integration Steps
1) Copy `snippets/dart/core/*.dart` into your core/services module.
2) Copy the category snippets into their respective feature modules.
3) Add `--dart-define` flags to enable categories per build target.
4) Register scenes/routes using `CategoryRegistry`.
5) Wire analytics to your chosen provider using the event keys provided.
