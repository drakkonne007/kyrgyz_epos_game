import 'package:flame/components.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/kyrgyz_game.dart';

Item itemFromId(int id)
{
  switch(id){
    case 0:   return PureHat(0);
    case 1:   return StrongHat(1);
    case 2:   return Gold(2);
    default: return PureHat(0);
  }
}

abstract class Item
{
  Item(this.id);
  int id;
  void getEffect(KyrgyzGame game){
    throw 'Not override catch item';
  }
  bool hideAfterUse = true;
  double hp = 0;
  double energy = 0;
  double armor = 0;
  int gold = 0;
  bool enabled = true;
  bool isDress = false;
  bool isAnimated = false;
  String source = '';
  int cost = 0;
  int column = 0;
  int row = 0;
  Vector2 srcSize = Vector2.all(0);
  int countOfUses = 0;
}

