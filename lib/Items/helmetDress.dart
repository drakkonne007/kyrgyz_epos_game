
import 'package:game_flame/abstracts/item.dart';

class PureHat extends Item
{
  PureHat()
  {
    id = 'pureHat';
    source = 'tiles/map/loot/loot.png';
    armor = 0.01;
    cost = 10;
    countOfUses = 100;
  }
}

class StrongHat extends Item
{
  StrongHat()
  {
    id = 'strongHat';
    source = 'tiles/map/loot/loot.png';
    armor = 0.02;
    cost = 15;
    countOfUses = 200;
  }
}