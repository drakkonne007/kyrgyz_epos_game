import 'dart:ffi';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/components/game_worlds.dart';
import 'dart:math' as math;



class MetaEnemyData
{
  MetaEnemyData(this.id, this.column, this.row);
  int id;
  int column;
  int row;
}

enum PlayerDirectionMove{
  NoMove,
  Left,
  Right,
  Up,
  Down,
  LeftUp,
  LeftDown,
  RightUp,
  RightDown,
}

class GameConsts
{  //9504 тайла
  GameConsts({this.maxColumn, this.maxRow, this.visibleBounds})
  {
    maxColumn ??= 25;
    maxRow ??= 43;
    visibleBounds ??= Vector2.all(297);
  }
  final Vector2 lengthOfTileSquare = Vector2(32*12,32*7);
  int? maxColumn;
  int? maxRow;
  Vector2? visibleBounds;
}

class PlayerData
{

  void setDress(Item item)
  {
    switch(item.dressType){
      case DressType.helmet: helmetDress.value = item; break;
      case DressType.armor: armorDress.value = item; break;
      case DressType.gloves: glovesDress.value = item; break;
      case DressType.sword: swordDress.value = item; break;
      case DressType.ring: ringDress.value = item; break;
      case DressType.boots: bootsDress.value = item; break;
      case DressType.none: throw 'DressType none';
    }
  }


  double getCurrentArmor()
  {
    return armorDress.value.armor + helmetDress.value.armor + glovesDress.value.armor + swordDress.value.armor + ringDress.value.armor + bootsDress.value.armor + extraArmor.value;
  }

  double getMaxHealth()
  {
    return armorDress.value.hp + helmetDress.value.hp + glovesDress.value.hp + swordDress.value.hp + ringDress.value.hp + bootsDress.value.hp + _maxHealth.value + (_maxHealth.value * playerLevel.value) / 100;
  }

  double getMaxEnergy()
  {
    return armorDress.value.energy + helmetDress.value.energy + glovesDress.value.energy + swordDress.value.energy + ringDress.value.energy + bootsDress.value.energy + _maxEnergy.value + (_maxEnergy.value * playerLevel.value) / 100;
  }

  double getHurtMiss()
  {
    return armorDress.value.hurtMiss + helmetDress.value.hurtMiss + glovesDress.value.hurtMiss + swordDress.value.hurtMiss + ringDress.value.hurtMiss + bootsDress.value.hurtMiss + extraHurtMiss.value;
  }

  double getDamage()
  {
    return armorDress.value.damage + helmetDress.value.damage + glovesDress.value.damage + swordDress.value.damage + ringDress.value.damage + bootsDress.value.damage + extraDamage.value + _maxDamage.value + (_maxDamage.value * playerLevel.value) / 100;
  }

  void addEnergy(double val, {bool extra = false, bool full = false})
  {
    if(full){
      energy.value = math.max(_maxEnergy.value, energy.value);
      return;
    }
    if(extra){
        energy.value += val;
    }else if(energy.value < _maxEnergy.value && val > 0) {
      energy.value += val;
      energy.value = math.min(energy.value, _maxEnergy.value);
    }else if(val < 0){
      energy.value += val;
    }
    energy.value = math.max(0, energy.value);
  }

  void addHealth(double val, {bool extra = false, bool full = false})
  {
    if(full){
      health.value = math.max(_maxHealth.value, health.value);
      return;
    }
    if(extra){
      health.value += val;
    }else if(health.value < _maxHealth.value && val > 0) {
      health.value += val;
      health.value = math.min(health.value, _maxHealth.value);
    }else if(val < 0){
      health.value += val;
    }
    health.value = math.max(0, health.value);
  }

  final ValueNotifier<int> playerLevel = ValueNotifier<int>(1);
  final ValueNotifier<double> health = ValueNotifier<double>(0);
  final ValueNotifier<double> energy = ValueNotifier<double>(0);
  final double extraArmor = 0;
  final double extraHurtMiss = 0;
  final double extraDamage = 0;
  final ValueNotifier<double> _maxHealth = ValueNotifier<double>(0);
  final ValueNotifier<double> _maxEnergy = ValueNotifier<double>(0);
  final ValueNotifier<double> _maxDamage = ValueNotifier<double>(1);
  final ValueNotifier<Item> helmetDress = ValueNotifier<Item>(NullItem());
  final ValueNotifier<Item> armorDress = ValueNotifier<Item>(NullItem());
  final ValueNotifier<Item> glovesDress = ValueNotifier<Item>(NullItem());
  final ValueNotifier<Item> swordDress = ValueNotifier<Item>(NullItem());
  final ValueNotifier<Item> ringDress = ValueNotifier<Item>(NullItem());
  final ValueNotifier<Item> bootsDress = ValueNotifier<Item>(NullItem());

  void addToInventar(Map<String,int> hash, Item item)
  {
    if(hash.containsKey(item.id)){
      int val = hash[item.id]!;
      hash[item.id] = val + 1;
      hash[item.id] = val;
    }else{
      hash[item.id] = 1;
    }
  }


  bool isLockEnergy = false;
  bool isLockMove = false;
  Set<int> killedBosses = {};
  ValueNotifier<int> money = ValueNotifier<int>(0);
  int curWeapon = -1;
  Map<String,int> weaponInventar = {};
  Map<String,int> armorInventar = {};
  Map<String,int> flaskInventar = {};
  Map<String,int> itemInventar = {
    'hpSmall':10,
    'hpMedium':10,
    'hpBig':10,
    'hpFull':10,
    'energySmall':10,
    'energyMedium':10,
    'energyBig':10,
    'energyFull':10
  };


  List<Item> curDress = [];
  Vector2 location = Vector2(-1,-1);
  Vector2 curPosition = Vector2(-1,-1);
  double gameTime = 720;
  double milisecsInGame = 0;
  GameWorldData playerBigMap = TopLeftVillage();
  Vector2 startLocation = Vector2(1772,3067);


  void setStartValues()
  {
    // playerBigMap = BigTopLeft();
    _maxHealth.value = 100;
    _maxEnergy.value = 15;
    health.value = _maxHealth.value;
    energy.value = _maxEnergy.value;
    killedBosses = killedBosses ?? {};
    curWeapon = curWeapon ?? -1;

    location = location ?? Vector2(10,10);
    curPosition = curPosition ?? Vector2.all(-1);
    gameTime = gameTime ?? 720;
    milisecsInGame = milisecsInGame ?? 0;
    //
    // if(curDress == null){
    //   this.curDress = [];
    // }else{
    //   for(int i=0;i<curDress.length;i++){
    //     var item = itemFromId(curDress[i]);
    //     this.curDress.add(item);
    //     armor.value += item.armor;
    //     maxHealth.value += item.hp;
    //     this.maxEnergy.value += item.energy;
    //   }
    // }
    // if(inventoryItems == null){
    //   this.inventoryItems = [];
    // }else{
    //   for(int i=0;i<inventoryItems.length;i++){
    //     var item = itemFromId(inventoryItems[i]);
    //     this.inventoryItems.add(item);
    //   }
    // }
  }



// static void doNewGame(){
//   health.value = maxHealth;
//   energy.value = maxEnergy;
//   armor.value  = maxArmor;
//   isLockEnergy = false;
// }
}

class PhysicVals
{
  static double maxSpeed = 130;
  static double startSpeed = 400;
  static double runCoef = 1.3;
  static double runMinimum = 1;
  static double gravity = 20;
  static double rigidy = 0.5;
  static double stopSpeed = 800;
  static const double right1 = math.pi/3;
  static const double right2 = math.pi * 2/3;
  static const double rightUp1 = 5 * math.pi/6;
  static const double up1 = -5 * math.pi/6;
  static const double left1 = math.pi / 6;
}

class PhysicFrontVals
{
  static const double gravity = 100;
  static Vector2 maxSpeeds = Vector2(PhysicVals.maxSpeed,gravity*500);
}

class GamePriority
{
  static const int ground = 0;
  static const int road = 1;
  static const int items = 2;
  static const int woods = 3;
  static const int loot = 40;
  static const int player = 100;
  static const int high = 150;
  static const int maxPriority = 999999;
}


