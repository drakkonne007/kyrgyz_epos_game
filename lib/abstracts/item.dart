
import 'package:flame/components.dart';
import 'package:game_flame/Items/loot.dart';

enum LootItems
{
  noItem,
  pureHat,
  strongHat,
}

Item getDescriptOfItems(LootItems id)
{
  switch(id){
    case LootItems.noItem:    return Item();
    case LootItems.pureHat:   return PureHat();
    case LootItems.strongHat: return StrongHat();
  }
}

class Item
{
  LootItems id = LootItems.noItem;
  double hp = -1;
  double energy = -1;
  double armor = -1;
  bool enabled = false;
  bool isDress = false;
  bool isAnimated = false;
  String source = '';
  int cost = -1;
  int column = -1;
  int row = -1;
  Vector2 srcSize = Vector2.all(0);
  int countOfUses = 0;
}