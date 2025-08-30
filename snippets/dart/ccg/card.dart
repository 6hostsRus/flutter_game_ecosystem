
enum Rarity { common, rare, epic, legendary }
class Card { final String id; final String name; final int cost; final Rarity rarity; final List<String> tags; final String text;
  Card(this.id, this.name, this.cost, this.rarity, this.tags, this.text);
}
