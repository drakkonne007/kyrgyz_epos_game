
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/components/DBHandler.dart';
import 'package:game_flame/components/game_worlds.dart';
import 'dart:math' as math;
import 'package:game_flame/kyrgyz_game.dart';

double levelCount = 18000;

int getLevel(double experience)
{
  double startExp = 0;
  int count = 0;
  while(experience > 0){
    startExp = startExp + startExp * 1.1;
    if(startExp == 0){
      startExp = levelCount;
    }
    experience -= startExp;
    count++;
  }
  if(experience == 0){
    count = 1;
  }
  return count;
}

double percentOfLevel(double experience)
{
  if(experience == 0){
    return 0;
  }
  double startExp = 0;
  double percent = 0;
  while(experience > 0){
    startExp = startExp + startExp * 1.1;
    if(startExp == 0){
      startExp = levelCount;
    }
    experience -= startExp;
  }
  experience += startExp;
  percent = experience / startExp;
  if(experience == 0){
    percent = 0;
  }
  return percent;
}


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
  final _statScale = 30;

  Map<String,int> getInventarMap(InventarType type)
  {
    switch(type){
      case InventarType.sword: return swordInventar;
      case InventarType.bodyArmor: return bodyArmorInventar;
      case InventarType.flask: return flaskInventar;
      case InventarType.item: return itemInventar;
      case InventarType.helmet: return helmetInventar;
      case InventarType.gloves: return glovesInventar;
      case InventarType.boots: return bootsInventar;
      case InventarType.ring: return ringInventar;
      default: return {};
    }
  }

  int getFreeSpellPoints()
  {
    return playerLevel.value
        - levelHealthSpells
        - levelStaminaSpells
        - levelManaSpells - 1;
  }

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
      case InventarType.helmet: helmetDress.value == item ?  helmetDress.value = NullItem() : helmetDress.value = item; break;
      case InventarType.bodyArmor:  armorDress.value == item ?  armorDress.value = NullItem() : armorDress.value = item; break;
      case InventarType.gloves: glovesDress.value == item ?  glovesDress.value = NullItem() : glovesDress.value = item; break;
      case InventarType.sword:  swordDress.value = item; break;
      case InventarType.ring:   ringDress.value == item ?  ringDress.value = NullItem() : ringDress.value = item; break;
      case InventarType.boots:  bootsDress.value == item ?  bootsDress.value = NullItem() : bootsDress.value = item; break;
      default: throw 'DressType wrong: ${item.dressType}';
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
      case InventarType.helmet:  helmet = newItem; break;
      case InventarType.bodyArmor: armor = newItem; break;
      case InventarType.gloves: gloves = newItem; break;
      case InventarType.sword: sword = newItem; break;
      case InventarType.ring: ring = newItem; break;
      case InventarType.boots: boots = newItem; break;
      default: return null;
    }
    MetaDataForNewItem answer = MetaDataForNewItem();
    double procentOfHealth = health.value / maxHealth.value;
    double procentOfMana = mana.value / maxMana.value;
    double procentOfEnergy = energy.value / maxEnergy.value;
    answer.maxHealth =
        armor.hp + helmet.hp + gloves.hp +
            sword.hp + ring.hp + boots.hp +
            _beginHealth + (_beginHealth * playerLevel.value) / _statScale + spellBonusHp;
    answer.maxMana = armor.mana + helmet.mana + gloves.mana +
        sword.mana + ring.mana + boots.mana +
        _beginMana + (_beginMana * playerLevel.value) / _statScale + spellBonusMana;
    answer.maxEnergy = armor.energy + helmet.energy +
        gloves.energy + sword.energy +
        ring.energy + boots.energy + _beginEnergy +
        (_beginEnergy * playerLevel.value) / _statScale;
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
        extraHurtMiss.value + spellHurtMiss;
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
    maxHealth.value = armorDress.value.hp + helmetDress.value.hp + glovesDress.value.hp + swordDress.value.hp
        + ringDress.value.hp + bootsDress.value.hp + _beginHealth + (_beginHealth * playerLevel.value) / _statScale + spellBonusHp;
    maxMana.value = armorDress.value.mana + helmetDress.value.mana + glovesDress.value.mana + swordDress.value.mana
        + ringDress.value.mana + bootsDress.value.mana + _beginMana + (_beginMana * playerLevel.value) / _statScale + spellBonusMana;
    maxEnergy.value = armorDress.value.energy + helmetDress.value.energy + glovesDress.value.energy + swordDress.value.energy
        + ringDress.value.energy + bootsDress.value.energy + _beginEnergy + (_beginEnergy * playerLevel.value) / _statScale;
    armor.value = armorDress.value.armor + helmetDress.value.armor + glovesDress.value.armor + swordDress.value.armor + ringDress.value.armor + bootsDress.value.armor + extraArmor.value;
    chanceOfLoot.value = armorDress.value.chanceOfLoot + helmetDress.value.chanceOfLoot + glovesDress.value.chanceOfLoot + swordDress.value.chanceOfLoot + ringDress.value.chanceOfLoot + bootsDress.value.chanceOfLoot + extraChanceOfLoot.value;
    hurtMiss.value = armorDress.value.hurtMiss + helmetDress.value.hurtMiss + glovesDress.value.hurtMiss + swordDress.value.hurtMiss + ringDress.value.hurtMiss + bootsDress.value.hurtMiss + extraHurtMiss.value + spellHurtMiss;
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

  void addLevel(double level)
  {
    experience.value += level;
    int tempLevel = getLevel(experience.value);
    if(playerLevel.value != tempLevel){
      health.value = maxHealth.value;
      mana.value = maxMana.value;
      energy.value = maxEnergy.value;
      playerLevel.value = tempLevel;
      _recalcAfterChangeDress();
    }
  }

  void recalcSpells()
  {
    spellVampirism = levelHealthSpells > 4;
    spellBonusHp = levelHealthSpells > 0 ? 10 : 0;
    spellRegenHp = levelHealthSpells > 1 ? 0.1 : 0;
    spellHurtMiss = levelHealthSpells > 2 ? 0.05 : 0;
    spellHurtMiss = levelHealthSpells > 3 ? 0.1 : spellHurtMiss;
    spellHurtMiss = levelHealthSpells > 5 ? 0.15 : spellHurtMiss;
    spellBonusHp = levelHealthSpells > 6 ? 20 : spellBonusHp;
    spellBonusHp = levelHealthSpells > 7 ? 30 : spellBonusHp;
    shieldBlock.value = levelStaminaSpells > 0 ? 10 : 5;
    shieldBlock.value = levelStaminaSpells > 2 ? 15 : shieldBlock.value;
    shieldBlock.value = levelStaminaSpells > 5 ? 9999999999 : shieldBlock.value;
    spellRegenStamina = levelStaminaSpells > 1 ? 0.1 : 0;
    spellNonEnergyBlock = levelStaminaSpells > 3;
    spellAllPhysDamage = levelStaminaSpells > 5;
    spellReducePartOfMagicDamage = levelStaminaSpells > 7;
    spellBonusStamina = levelStaminaSpells > 4 ? 10 : 0;
    spellBonusStamina = levelStaminaSpells > 6 ? 20 : spellBonusStamina;

    spellBonusMana = levelManaSpells > 0 ? 10 : 0;
    spellBonusMana = levelManaSpells > 2 ? 20 : spellBonusMana;
    spellBonusMana = levelManaSpells > 5 ? 30 : spellBonusMana;
    spellRegenMana = levelManaSpells > 1 ? 0.2 : 0;
    spellHitWithDash = levelManaSpells > 4;
    playerMagicLevel.value = levelManaSpells > 3 ? 2 : 1;
    playerMagicLevel.value = levelManaSpells > 6 ? 3 : playerMagicLevel.value;

    _recalcAfterChangeDress();
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
    if(val <= 0){
      hurtMainPlayerChanger.value++;
      _game.gameMap.add(TimerComponent(period: 1, removeOnFinish: true, onTick: (){
        hurtMainPlayerChanger.value--;
      }));
    }
    health.value = math.max(0, health.value);
  }


  final ValueNotifier<int> hurtMainPlayerChanger = ValueNotifier<int>(0);
  final ValueNotifier<int> plusHealthMainPlayerChanger = ValueNotifier<int>(0);
  final ValueNotifier<int> plusManaMainPlayerChanger = ValueNotifier<int>(0);
  final ValueNotifier<int> plusStaminaMainPlayerChanger = ValueNotifier<int>(0);
  final ValueNotifier<int> statChangeTrigger = ValueNotifier<int>(0);
  final ValueNotifier<int> playerLevel = ValueNotifier<int>(1);
  final ValueNotifier<double> experience = ValueNotifier<double>(0);
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
  final ValueNotifier<double> shieldBlock = ValueNotifier<double>(5);
  final ValueNotifier<double> shieldBlockEnergy = ValueNotifier<double>(5);
  final ValueNotifier<double> extraHurtMiss = ValueNotifier<double>(0);
  final ValueNotifier<double> extraDamage = ValueNotifier<double>(0);
  final ValueNotifier<double> extraChanceOfLoot = ValueNotifier<double>(0);
  final ValueNotifier<double> extraAttackSpeed = ValueNotifier<double>(0);
  final double _beginEnergy = 40;
  final double _beginHealth = 100;
  final double _beginMana = 10;
  int _currentSecsInGame = 0;
  int _currentSecsSinceEpoch = 0;
  int levelHealthSpells = 0;
  int levelManaSpells = 0;
  int levelStaminaSpells = 0;
  String playerName = '';
  String? companion;
  bool canShrines = false;
  bool canRings = false;
  bool canDash = false;
  final ValueNotifier<String?> bigDialog = ValueNotifier<String?>(null);

  double spellHurtMiss = 0;
  double spellBonusHp = 0;
  double spellBonusStamina = 0;
  double spellBonusMana = 0;
  double spellRegenHp = 0;
  double spellRegenStamina = 0;
  double spellRegenMana = 0;
  bool   spellNonEnergyBlock = false;
  bool   spellAllPhysDamage = false;
  bool   spellReducePartOfMagicDamage = false;
  bool   spellHitWithDash = false;
  bool   spellVampirism = false;
  // TimerComponent? shrineStaminaBuff;
  // TimerComponent? shrineBloodBuff;
  final ValueNotifier<double> maxHealth = ValueNotifier<double>(0);
  final ValueNotifier<double> maxMana = ValueNotifier<double>(0);
  final ValueNotifier<double> maxEnergy = ValueNotifier<double>(0);
  final ValueNotifier<Item> helmetDress = ValueNotifier<Item>(NullItem());
  final ValueNotifier<Item> armorDress = ValueNotifier<Item>(NullItem());
  final ValueNotifier<Item> glovesDress = ValueNotifier<Item>(NullItem());
  final ValueNotifier<Item> swordDress = ValueNotifier<Item>(NullItem());
  final ValueNotifier<Item> ringDress = ValueNotifier<Item>(NullItem());
  final ValueNotifier<Item> bootsDress = ValueNotifier<Item>(NullItem());

  int getGameSeconds()
  {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000 - _currentSecsSinceEpoch + _currentSecsInGame;
  }

  String getStringGameSeconds()
  {
    int seconds = getGameSeconds() % 60;
    int minutes = getGameSeconds() ~/ 60;
    int hours = minutes ~/ 60;
    minutes -= hours * 60;
    int days = hours ~/ 24;
    return "$daysд:$hoursч:$minutesм:$secondsс";
  }

  void addToInventar(InventarType type, String itemId)
  {
    Map<String,int> hash;
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
      hash.update(itemId, (val) => val + 1);
    }else{
      hash[itemId] = 1;
    }
    currentFlask1.notifyListeners();
    currentFlask2.notifyListeners();
  }

  KyrgyzGame _game;

  bool isLockEnergy = false;
  bool isLockMove = false;
  Set<String> killedBosses = {};
  ValueNotifier<int> money = ValueNotifier<int>(0);

  ValueNotifier<String?> currentFlask1 = ValueNotifier<String?>(null);
  ValueNotifier<String?> currentFlask2 = ValueNotifier<String?>(null);

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

  void loadGame(SavedGame svg)
  {
    canShrines = svg.canUseShrine;
    canRings = svg.canUseRing;
    canDash = svg.canUseDash;
    levelManaSpells = svg.levelMana;
    levelHealthSpells = svg.levelHeart;
    levelStaminaSpells = svg.levelStamina;

    _currentSecsInGame = svg.currentGameTime;
    _currentSecsSinceEpoch = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    armorDress.value = NullItem();
    helmetDress.value = NullItem();
    glovesDress.value  = NullItem();
    swordDress.value = NullItem();
    ringDress.value = NullItem();
    bootsDress.value = NullItem();

    currentFlask1.value = svg.currentFlask1;
    currentFlask2.value = svg.currentFlask2;


    for(final cur in svg.currentInventar){
      Item it = itemFromName(cur);
      switch(it.dressType){
        case InventarType.bodyArmor:  armorDress.value = it; break;
        case InventarType.helmet: helmetDress.value = it; break;
        case InventarType.gloves: glovesDress.value = it; break;
        case InventarType.sword:  swordDress.value = it; break;
        case InventarType.ring:   ringDress.value = it; break;
        case InventarType.boots:  bootsDress.value = it; break;
        default: break;
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
    experience.value = svg.level;
    playerLevel.value = getLevel(experience.value);
    mana.value = svg.mana;
    energy.value = svg.energy;
    health.value = svg.health;
    playerBigMap =  getWorldFromName(svg.world);
    startLocation = Vector2(svg.x, svg.y);

    _game.gameMap.effectComponent.removeAll(_game.gameMap.effectComponent.children);

    for(final cur in svg.tempEffects){
      final it = itemFromName(cur.parentId);
      it.getEffect(_game);
      it.getEffectFromInventar(_game, duration: cur.dur);
    }
    companion = svg.companion;

    recalcSpells();
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
  static double maxSpeed = 60;
  static double startSpeed = 168;
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


