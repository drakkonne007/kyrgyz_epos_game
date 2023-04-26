
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

Item itemFromId(int id)
{
  switch(id){
    case 0:   return PureHat(1);
    case 1:   return StrongHat(2);
    default: return PureHat(1);
  }
}

abstract class Item
{
  int id = 0;
  double hp = 0;
  double energy = 0;
  double armor = 0;
  int gold = 0;
  bool enabled = false;
  bool isDress = false;
  bool isAnimated = false;
  String source = '';
  int cost = 0;
  int column = 0;
  int row = 0;
  Vector2 srcSize = Vector2.all(0);
  int countOfUses = 0;
}

