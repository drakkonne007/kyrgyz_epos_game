import 'package:flame/components.dart';
import 'package:game_flame/abstracts/item.dart';

class PureHat implements Item
{
  PureHat(this.id);
  @override
  int gold = 0;
  @override
  int column = 1;
  @override
  int row = 0;
  @override
  Vector2 srcSize = Vector2.all(24);
  @override
  String source = 'tiles/map/loot/loot.png';
  @override
  double armor = 1;
  @override
  int cost = 100;
  @override
  bool enabled = true;
  @override
  double energy = 0;
  @override
  double hp = 0;
  @override
  bool isDress = true;
  @override
  bool isAnimated = false;
  @override
  int countOfUses = 100;
  @override
  int id;
}

class StrongHat implements Item
{
  StrongHat(this.id);
  @override
  int gold = 0;
  @override
  int column = 4;
  @override
  int row = 6;
  @override
  Vector2 srcSize = Vector2.all(24);
  @override
  String source = 'tiles/map/loot/loot.png';
  @override
  double armor = 1.5;
  @override
  int cost = 100;
  @override
  bool enabled = true;
  @override
  double energy = 0;
  @override
  double hp = 0;
  @override
  bool isDress = true;
  @override
  bool isAnimated = false;
  @override
  int countOfUses = 200;
  @override
  int id;
}