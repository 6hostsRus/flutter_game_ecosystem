# ui_shell

<!-- Badges -->
<p>
          <a href="https://github.com/6hostsRus/flutter_game_ecosystem/blob/main/docs/METRICS.md">
               <img alt="Coverage (ui_shell)" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/coverage_ui_shell.json" />
          <img alt="Packages" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/packages.json" />
          <img alt="Stub parity" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/stub_parity.json" />
               <img alt="Analytics (ui_shell)" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/analytics_ui_shell.json" />
               <img alt="Pkg warnings (ui_shell)" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/pkg_warn_ui_shell.json" />
     </a>
 </p>

Lightweight UI scaffolding and components for the demo game and modules.

## Stable widget keys

These keys are intentionally stable to support widget tests and automation:

-    GameNavScaffold

     -    Scaffold: Key('GameNavScaffold')
     -    NavigationBar: Key('nav:bar')
     -    NavigationDestination for each tab: Key('nav:dest:<tabName>')
     -    Active tab body subtree: Key('tab:<tabName>')

-    Store
     -    StoreButton: Key('store:button')
     -    Store sheet title: Key('store:sheet:title')
     -    Store sheet list: Key('store:sheet:list')
     -    Per item (index i):
          -    Card: Key('store:item:i')
          -    ListTile: Key('store:item:i:tile')
          -    Title text: Key('store:item:i:title')
          -    Subtitle text: Key('store:item:i:subtitle')
          -    Buy button: Key('store:item:i:buy')

Conventions:

-    Prefix by domain (nav:, store:), use lowercase and ':' separators.
-    Include dynamic suffixes for repeated content (e.g., index or enum name).
