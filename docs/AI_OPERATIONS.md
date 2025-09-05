# AI Operations

Core operational commands & validation sequence.

## Validation Steps

1. dart pub get (root + touched packages)
2. dart analyze
3. If tests added/changed: dart test --reporter=compact
4. Optional: dart format --output=none --set-exit-if-changed .

## Common Commands

-    /release-candidate <x.y.z>
-    /screenshots ios|android
-    /submit-ios
-    /promote android internal|production [percent]
-    /store sync ios|android
-    /hotfix start <ver>
-    /hotfix release <ver>

## Change Classification Header

Add at top of modified files:

```dart
// change-class: doc|feature|refactor|test|infra
```

## Multi-Step Execution Flow

Enumerate → Plan → Execute sequentially → Validate after each → Summarize.
