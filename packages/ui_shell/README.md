# ui_shell

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
