import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/kyrgyz_game.dart';

Item itemFromName(String id)
{
  switch(id){
    case 'pureHat':   return PureHat('pureHat');
    case 'strongHat':   return StrongHat('strongHat');
    case 'gold':   return Gold('gold');
    default: return PureHat('gold');
  }
}

// Widget itemWidgetFromName(String id)
// {
//   switch(id){
//     case 'pureHat':   return PureHat('pureHat');
//     case 'strongHat':   return StrongHat('strongHat');
//     case 'gold':   return Gold('gold');
//     default: return PureHat('gold');
//   }
// }

abstract class Item
{
  Item(this.id);
  String id;
  void getEffect(KyrgyzGame game)
  {
    throw 'Not override catch item';
  }
  void gerEffectFromInventar(KyrgyzGame game)
  {

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
  String? sourceForInventar;
  int cost = 0;
  int column = 0;
  int row = 0;
  Vector2 srcSize = Vector2.all(0);
  int countOfUses = 0;

  @override
  bool operator ==(Object other) {
    if(other is! Item){
      return false;
    }
    return id == other.id;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
}

