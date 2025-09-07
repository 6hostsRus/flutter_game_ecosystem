# Screen Size & Device Targets (V2)

Updated: 2025-09-07

## Phones

-    Primary release. Orientation locked per template.
-    Use Flutter MediaQuery/LayoutBuilder.

## Tablets

-    Scale up; test iPads + Android tablets.

## Desktops

-    macOS: separate target.
-    ChromeOS: Android build runs but test scaling.
-    Windows: separate publishing.

## Strategy

-    Ship mobile-first (iOS + Android phones).
-    Build responsive scaling for tablets.
-    Add desktop later.
