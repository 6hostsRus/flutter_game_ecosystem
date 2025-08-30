# Items Module (V1)

## Purpose
Inventory, pickups, powerups, and simple crafting/combining.

## Key Types
```dart
class ItemDef { String id; String name; Map<String, num> props; }
class ItemStack { ItemDef def; int qty; }
abstract class ItemEffect { void apply(GameContext ctx); }
class Inventory { final List<ItemStack> slots; bool add(ItemStack s); }
```

## Features
- **Pickups**: collisions spawn `ItemEffect` (e.g., +coins, +speed, shield).
- **Consumables vs. Equipment**: hooks for equip/unequip.
- **Rarity & Drops**: table‑driven loot for enemies/boxes.
- **Crafting (v1-lite)**: combine A+B → C via simple rules.

## Config
- Items and effects defined in JSON (`id`, icon, rarity, effect params).

## Deliverables (v1)
- Inventory + pickup pipeline
- Effect registry (speed boost, shield, coin, magnet)
- Drop table utility
