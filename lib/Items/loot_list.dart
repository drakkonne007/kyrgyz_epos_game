import 'package:flame/components.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/kyrgyz_game.dart';

class Gold extends Item
{
  Gold(super.id)
  {
    row = 12;
    column = 13;
    gold = 10;
    enabled = true;
    source = 'tiles/map/loot/loot.png';
    srcSize = Vector2.all(24);
  }

  @override
  void getEffect(KyrgyzGame game)
  {
      game.playerData.money += gold;
  }
}

class PureHat extends Item
{
  PureHat(super.id)
  {
    source = 'tiles/map/loot/loot.png';
    column = 1;
    row = 0;
    armor = 1;
    cost = 100;
    isDress = true;
    countOfUses = 100;
  }

  @override
  void getEffect(KyrgyzGame game)
  {

  }
}

class StrongHat extends Item
{
  StrongHat(super.id)
  {
    column = 4;
    row = 6;
    srcSize = Vector2.all(24);
    source = 'tiles/map/loot/loot.png';
    armor = 1.5;
    cost = 100;
    isDress = true;
    countOfUses = 200;
  }

  @override
  void getEffect(KyrgyzGame game)
  {

  }
}