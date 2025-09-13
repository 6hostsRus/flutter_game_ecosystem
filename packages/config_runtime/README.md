# config_runtime

-    Discovers packs via `packs.index.yaml`
-    Loads layers: defaults → pack → env flags → device → local
-    Ingests CSV shards
-    Validates with JSON Schemas + semantic hooks
-    Emits merge diff for the drawer
