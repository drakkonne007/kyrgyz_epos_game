
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/components/CountTimer.dart';
import 'package:game_flame/components/DBHandler.dart';
import 'package:game_flame/components/game_worlds.dart';
import 'dart:math' as math;

import 'package:game_flame/kyrgyz_game.dart';

class MetaDataForNewItem
{
  double health = 0;
  double mana = 0;
  double energy = 0;
  double maxHealth = 0;
  double maxMana = 0;
  double maxEnergy = 0;
  double armor = 0;
  double chanceOfLoot = 0;
  double hurtMiss = 0;
  double damage = 0;
  double attackSpeed = 0;
  double permanentDamage = 0;
  double secsOfPermanentDamage = 0;
  MagicDamage magicDamage = MagicDamage.none;
}

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

enum MagicSpellVariant
{
  none,
  circle,
  forward,
}

class GameConsts
{  //9504 тайла
  GameConsts(this.visibleBounds)
  {
    maxColumn = visibleBounds.x ~/ lengthOfTileSquareInTiles.x + (visibleBounds.x % lengthOfTileSquareInTiles.x != 0 ? 1 : 0);
    maxRow = visibleBounds.y ~/ lengthOfTileSquareInTiles.y + (visibleBounds.y % lengthOfTileSquareInTiles.y != 0 ? 1 : 0);
  }
  static final Vector2 lengthOfTileSquare = Vector2(32*12,32*7);
  final Vector2 lengthOfTileSquareInTiles = Vector2(12,7);
  int maxColumn = 0;
  int maxRow = 0;
  Vector2 visibleBounds;
}

class PlayerData
{

  PlayerData(this._game)
  {
    playerLevel.addListener(_recalcAfterChangeDress);
    extraArmor.addListener(_recalcAfterChangeDress);
    extraHurtMiss.addListener(_recalcAfterChangeDress);
    extraDamage.addListener(_recalcAfterChangeDress);
    extraChanceOfLoot.addListener(_recalcAfterChangeDress);
    extraAttackSpeed.addListener(_recalcAfterChangeDress);
    helmetDress.addListener(_recalcAfterChangeDress);
    armorDress.addListener(_recalcAfterChangeDress);
    glovesDress.addListener(_recalcAfterChangeDress);
    swordDress.addListener(_recalcAfterChangeDress);
    ringDress.addListener(_recalcAfterChangeDress);
    bootsDress.addListener(_recalcAfterChangeDress);
  }

  void setDress(Item item)
  {
    switch(item.dressType){
      case DressType.helmet: helmetDress.value == item ?  helmetDress.value = NullItem() : helmetDress.value = item; break;
      case DressType.armor:  armorDress.value == item ?  armorDress.value = NullItem() : armorDress.value = item; break;
      case DressType.gloves: glovesDress.value == item ?  glovesDress.value = NullItem() : glovesDress.value = item; break;
      case DressType.sword:  swordDress.value = item; break;
      case DressType.ring:   ringDress.value == item ?  ringDress.value = NullItem() : ringDress.value = item; break;
      case DressType.boots:  bootsDress.value == item ?  bootsDress.value = NullItem() : bootsDress.value = item; break;
      case DressType.none: throw 'DressType none';
    }
  }

  MetaDataForNewItem? calcNewChoice(Item? newItem)
  {
    if(newItem == null){
      return null;
    }
    Item helmet, armor, gloves, sword, ring, boots;
    helmet = helmetDress.value;
    armor = armorDress.value;
    gloves = glovesDress.value;
    sword = swordDress.value;
    ring = ringDress.value;
    boots = bootsDress.value;
    switch(newItem.dressType){
      case DressType.helmet:  helmet = newItem; break;
      case DressType.armor: armor = newItem; break;
      case DressType.gloves: gloves = newItem; break;
      case DressType.sword: sword = newItem; break;
      case DressType.ring: ring = newItem; break;
      case DressType.boots: boots = newItem; break;
      case DressType.none: return null;
    }
    MetaDataForNewItem answer = MetaDataForNewItem();
    double procentOfHealth = health.value / maxHealth.value;
    double procentOfMana = mana.value / maxMana.value;
    double procentOfEnergy = energy.value / maxEnergy.value;
    answer.maxHealth =
        armor.hp + helmet.hp + gloves.hp +
            sword.hp + ring.hp + boots.hp +
            _beginHealth + (_beginHealth * playerLevel.value) / 100;
    answer.maxMana = armor.mana + helmet.mana + gloves.mana +
        sword.mana + ring.mana + boots.mana +
        _beginMana + (_beginMana * playerLevel.value) / 100;
    answer.maxEnergy = armor.energy + helmet.energy +
        gloves.energy + sword.energy +
        ring.energy + boots.energy + _beginEnergy +
        (_beginEnergy * playerLevel.value) / 100;
    answer.armor = armor.armor + helmet.armor +
        gloves.armor + sword.armor +
        ring.armor + boots.armor + extraArmor.value;
    answer.chanceOfLoot =
        armor.chanceOfLoot + helmet.chanceOfLoot +
            gloves.chanceOfLoot + sword.chanceOfLoot +
            ring.chanceOfLoot + boots.chanceOfLoot +
            extraChanceOfLoot.value;
    answer.hurtMiss = armor.hurtMiss + helmet.hurtMiss +
        gloves.hurtMiss + sword.hurtMiss +
        ring.hurtMiss + boots.hurtMiss +
        extraHurtMiss.value;
    answer.damage = armor.damage + helmet.damage +
        gloves.damage + sword.damage +
        ring.damage + boots.damage + extraDamage.value;
    answer.attackSpeed =
        armor.attackSpeed + helmet.attackSpeed +
            gloves.attackSpeed + sword.attackSpeed +
            ring.attackSpeed + boots.attackSpeed +
            extraAttackSpeed.value;
    answer.permanentDamage = sword.permanentDamage;
    answer.secsOfPermanentDamage = sword.secsOfPermDamage;
    answer.magicDamage = sword.magicDamage ?? MagicDamage.none;
    answer.health = procentOfHealth * answer.maxHealth;
    answer.mana = procentOfMana * answer.maxMana;
    answer.energy = procentOfEnergy * answer.maxEnergy;
    return answer;
  }


  void _recalcAfterChangeDress()
  {
    double procentOfHealth = health.value / maxHealth.value;
    double procentOfMana = mana.value / maxMana.value;
    double procentOfEnergy = energy.value / maxEnergy.value;
    maxHealth.value = armorDress.value.hp + helmetDress.value.hp + glovesDress.value.hp + swordDress.value.hp + ringDress.value.hp + bootsDress.value.hp + _beginHealth + (_beginHealth * playerLevel.value) / 100;
    maxMana.value = armorDress.value.mana + helmetDress.value.mana + glovesDress.value.mana + swordDress.value.mana + ringDress.value.mana + bootsDress.value.mana + _beginMana + (_beginMana * playerLevel.value) / 100;
    maxEnergy.value = armorDress.value.energy + helmetDress.value.energy + glovesDress.value.energy + swordDress.value.energy + ringDress.value.energy + bootsDress.value.energy + _beginEnergy + (_beginEnergy * playerLevel.value) / 100;
    armor.value = armorDress.value.armor + helmetDress.value.armor + glovesDress.value.armor + swordDress.value.armor + ringDress.value.armor + bootsDress.value.armor + extraArmor.value;
    chanceOfLoot.value = armorDress.value.chanceOfLoot + helmetDress.value.chanceOfLoot + glovesDress.value.chanceOfLoot + swordDress.value.chanceOfLoot + ringDress.value.chanceOfLoot + bootsDress.value.chanceOfLoot + extraChanceOfLoot.value;
    hurtMiss.value = armorDress.value.hurtMiss + helmetDress.value.hurtMiss + glovesDress.value.hurtMiss + swordDress.value.hurtMiss + ringDress.value.hurtMiss + bootsDress.value.hurtMiss + extraHurtMiss.value;
    damage.value = armorDress.value.damage + helmetDress.value.damage + glovesDress.value.damage + swordDress.value.damage + ringDress.value.damage + bootsDress.value.damage + extraDamage.value;
    attackSpeed.value = armorDress.value.attackSpeed + helmetDress.value.attackSpeed + glovesDress.value.attackSpeed + swordDress.value.attackSpeed + ringDress.value.attackSpeed + bootsDress.value.attackSpeed + extraAttackSpeed.value;
    permanentDamage.value = swordDress.value.permanentDamage;
    secsOfPermanentDamage.value = swordDress.value.secsOfPermDamage;
    magicDamage.value = swordDress.value.magicDamage ?? MagicDamage.none;
    health.value = procentOfHealth * maxHealth.value;
    mana.value = procentOfMana * maxMana.value;
    energy.value = procentOfEnergy * maxEnergy.value;
    statChangeTrigger.notifyListeners();
  }

  void addEnergy(double val, {bool extra = false, bool full = false})
  {
    if(full){
      energy.value = math.max(maxEnergy.value, energy.value);
      return;
    }
    if(extra){
      energy.value += val;
    }else if(energy.value < maxEnergy.value && val > 0) {
      energy.value += val;
      energy.value = math.min(energy.value, maxEnergy.value);
    }else if(val < 0){
      energy.value += val;
    }
    energy.value = math.max(0, energy.value);
  }

  void addMana(double val, {bool extra = false, bool full = false})
  {
    if(full){
      mana.value = math.max(maxMana.value, mana.value);
      return;
    }
    if(extra){
      mana.value += val;
    }else if(mana.value < maxMana.value && val > 0) {
      mana.value += val;
      mana.value = math.min(mana.value, maxMana.value);
    }else if(val < 0){
      mana.value += val;
    }
    mana.value = math.max(0, mana.value);
  }

  void addHealth(double val, {bool extra = false, bool full = false})
  {
    if(full){
      health.value = math.max(maxHealth.value, health.value);
      return;
    }
    if(extra){
      health.value += val;
    }else if(health.value < maxHealth.value && val > 0) {
      health.value += val;
      health.value = math.min(health.value, maxHealth.value);
    }else if(val < 0){
      health.value += val;
    }
    health.value = math.max(0, health.value);
  }


  final ValueNotifier<int> statChangeTrigger = ValueNotifier<int>(0);
  final ValueNotifier<double> playerLevel = ValueNotifier<double>(1);
  final ValueNotifier<double> playerMagicLevel = ValueNotifier<double>(1);
  final ValueNotifier<double> health = ValueNotifier<double>(0);
  final ValueNotifier<double> mana = ValueNotifier<double>(0);
  final ValueNotifier<double> energy = ValueNotifier<double>(0);
  final ValueNotifier<double> armor = ValueNotifier<double>(0);
  final ValueNotifier<double> chanceOfLoot = ValueNotifier<double>(0);
  final ValueNotifier<double> hurtMiss = ValueNotifier<double>(0);
  final ValueNotifier<double> damage = ValueNotifier<double>(0);
  final ValueNotifier<double> attackSpeed = ValueNotifier<double>(0);
  final ValueNotifier<MagicDamage> magicDamage = ValueNotifier<MagicDamage>(MagicDamage.none);
  final ValueNotifier<double> permanentDamage = ValueNotifier<double>(0);
  final ValueNotifier<double> secsOfPermanentDamage = ValueNotifier<double>(0);

  final ValueNotifier<double> extraArmor = ValueNotifier<double>(0);
  final ValueNotifier<double> extraHurtMiss = ValueNotifier<double>(0);
  final ValueNotifier<double> extraDamage = ValueNotifier<double>(0);
  final ValueNotifier<double> extraChanceOfLoot = ValueNotifier<double>(0);
  final ValueNotifier<double> extraAttackSpeed = ValueNotifier<double>(0);
  final double _beginEnergy = 100;
  final double _beginHealth = 100;
  final double _beginMana = 100;
  final ValueNotifier<double> maxHealth = ValueNotifier<double>(0);
  final ValueNotifier<double> maxMana = ValueNotifier<double>(0);
  final ValueNotifier<double> maxEnergy = ValueNotifier<double>(0);
  final ValueNotifier<Item> helmetDress = ValueNotifier<Item>(NullItem());
  final ValueNotifier<Item> armorDress = ValueNotifier<Item>(NullItem());
  final ValueNotifier<Item> glovesDress = ValueNotifier<Item>(NullItem());
  final ValueNotifier<Item> swordDress = ValueNotifier<Item>(NullItem());
  final ValueNotifier<Item> ringDress = ValueNotifier<Item>(NullItem());
  final ValueNotifier<Item> bootsDress = ValueNotifier<Item>(NullItem());

  void addToInventar(InventarType type, String itemId)
  {
    Map<String,int> hash = {};
    switch(type){
      case InventarType.sword:
        hash = swordInventar;
        break;
      case InventarType.bodyArmor:
        hash = bodyArmorInventar;
        break;
      case InventarType.flask:
        hash = flaskInventar;
        break;
      case InventarType.item:
        hash = itemInventar;
        break;
      case InventarType.helmet:
        hash = helmetInventar;
        break;
      case InventarType.gloves:
        hash = glovesInventar;
        break;
      case InventarType.boots:
        hash = bootsInventar;
        break;
      case InventarType.ring:
        hash = ringInventar;
        break;
    }
    if(hash.containsKey(itemId)){
      int val = hash[itemId]!;
      hash[itemId] = val + 1;
      hash[itemId] = val;
    }else{
      hash[itemId] = 1;
    }
  }

  KyrgyzGame _game;

  bool isLockEnergy = false;
  bool isLockMove = false;
  Set<String> killedBosses = {};
  ValueNotifier<int> money = ValueNotifier<int>(0);

  Map<String,int> helmetInventar = {};
  Map<String,int> bodyArmorInventar = {};
  Map<String,int> glovesInventar = {};
  Map<String,int> bootsInventar = {};
  Map<String,int> flaskInventar = {};
  Map<String,int> itemInventar = {};
  Map<String,int> swordInventar = {};
  Map<String,int> ringInventar = {};

  Vector2 location = Vector2(-1,-1);
  Vector2 curPosition = Vector2(-1,-1);
  double gameTime = 720;
  double milisecsInGame = 0;
  GameWorldData playerBigMap = TopLeftVillage();
  Vector2 startLocation = Vector2(1772,3067);


  // void setStartValues({Item? helmet, Item? armor, Item? gloves, Item? sword, Item? ring, Item? boots, int gold = 0, double energy = 0, double health = 0
  // ,double extraArmor = 0, double extraHurtMiss = 0, double extraDamage = 0, double extraChanceOfLoot = 0, double extraAttackSpeed = 0
  // ,Map<String,int>? weaponInventar, Map<String,int>? armorInventar, Map<String,int>? flaskInventar, Map<String,int>? itemInventar})
  // {
  //   helmetDress.value = helmet ?? NullItem();
  //   armorDress.value = armor ?? NullItem();
  //   glovesDress.value = gloves ?? NullItem();
  //   swordDress.value = sword ?? NullItem();
  //   ringDress.value = ring ?? NullItem();
  //   bootsDress.value = boots ?? NullItem();
  //   this.extraArmor.value = extraArmor;
  //   this.extraHurtMiss.value = extraHurtMiss;
  //   this.extraDamage.value = extraDamage;
  //   this.extraChanceOfLoot.value = extraChanceOfLoot;
  //   this.extraAttackSpeed.value = extraAttackSpeed;
  //   money.value = gold;
  //   this.weaponInventar = weaponInventar ?? {};
  //   this.armorInventar = armorInventar ?? {};
  //   this.flaskInventar = flaskInventar ?? {};
  //   this.itemInventar = itemInventar ?? {};
  //   this.energy.value = energy == 0 ? maxEnergy.value : energy;
  //   this.health.value = health == 0 ? maxHealth.value : health;
  // }

  void loadGame(SavedGame svg)
  {
    armorDress.value = NullItem();
    helmetDress.value = NullItem();
    glovesDress.value  = NullItem();
    swordDress.value = NullItem();
    ringDress.value = NullItem();
    bootsDress.value = NullItem();
    for(final cur in svg.currentInventar){
      Item it = itemFromName(cur);
      switch(it.dressType){
        case DressType.armor:  armorDress.value = it; break;
        case DressType.helmet: helmetDress.value = it; break;
        case DressType.gloves: glovesDress.value = it; break;
        case DressType.sword:  swordDress.value = it; break;
        case DressType.ring:   ringDress.value = it; break;
        case DressType.boots:  bootsDress.value = it; break;
        case DressType.none: break;
      }
    }
    money.value = svg.gold;
    swordInventar = svg.swordInventar;
    ringInventar = svg.ringInventar;
    helmetInventar = svg.helmetInventar;
    bodyArmorInventar = svg.bodyArmorInventar;
    glovesInventar = svg.glovesInventar;
    bootsInventar = svg.bootsInventar;
    flaskInventar = svg.flaskInventar;
    itemInventar = svg.itemInventar;
    health.value = svg.health;
    mana.value = svg.mana;
    energy.value = svg.energy;
    playerLevel.value = svg.level;
    playerBigMap =  getWorldFromName(svg.world);
    startLocation = Vector2(svg.x, svg.y);

    _game.gameMap.effectComponent.removeAll(_game.gameMap.effectComponent.children);

    for(final cur in svg.tempEffects){
      final it = itemFromName(cur.parentId);
      it.getEffect(_game);
      it.getEffectFromInventar(_game, duration: cur.dur);
    }
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
  static const double physicScale = 0.1;
  static double maxSpeed = 80;
  static double startSpeed = 200;
  static const double runCoef = 1.3;
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
  static const int backgroundTile = 0;
  static const int backgroundTileAnim = 1;
  static const int players = 2;
  static const int foregroundTile = 10000;
  static const int high = 11000;
  static const int maxPriority = 99999999;
// static const int high = 4294967296;
// static const int maxPriority = 4294967296;
}


