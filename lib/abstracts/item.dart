import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/Items/flasks.dart';
import 'package:game_flame/Items/helmetDress.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/kyrgyz_game.dart';

enum DressType
{
  none,
  helmet,
  armor,
  gloves,
  sword,
  ring,
  boots,
}

enum MagicDamage
{
  fire,
  ice,
  poison,
  lightning,
}

Item itemFromName(String id)
{
  switch(id){
    case 'pureHat':   return PureHat();
    case 'strongHat':   return StrongHat();
    case 'hpSmall':   return HpSmall();
    case 'hpMedium':   return HpMedium();
    case 'hpBig':     return HpBig();
    case 'hpFull':    return HpFull();
    case 'energySmall': return EnergySmall();
    case 'energyMedium': return EnergyMedium();
    case 'energyBig': return EnergyBig();
    case 'energyFull': return EnergyFull();
    case 'gold': return Gold();
    default: return NullItem();
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
  Item()
  {
    assert(attackSpeed <= - 0.06, 'Некорректное значение скорости атаки');
  }

  String id = '';
  void getEffect(KyrgyzGame game)
  {
    throw 'Not override catch item';
  }
  void getEffectFromInventar(KyrgyzGame game)
  {
    throw 'Not override catch item from inventar';
  }

  bool isStaticObject = false;
  double hp = 0;
  double energy = 0;
  double armor = 0;
  double chanceOfLoot = 0;
  double hurtMiss = 0;
  double damage = 0;
  bool enabled = true;
  double attackSpeed = 0; //Отнимается/прибавляется к скорости атаки
  DressType dressType = DressType.none;
  String source = '';
  int cost = 0;
  int? countOfUses;
  MagicDamage? magicDamage;
  double permanentDamage = 0;
  double secsOfPermDamage = 0;


  @override
  bool operator ==(Object other) {
    if(other is! Item){
      return false;
    }
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

