import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/components/game_worlds.dart';

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
  GameConsts({this.maxColumn, this.maxRow})
  {
    maxColumn ??= 27;
    maxRow ??= 33;
  }
  final Vector2 lengthOfTileSquare = Vector2(32*11,32*9);
  int? maxColumn;
  int? maxRow;
}

class PlayerData
{
  ValueNotifier<double> health = ValueNotifier<double>(0);
  ValueNotifier<double> energy = ValueNotifier<double>(0);
  ValueNotifier<double> armor =ValueNotifier<double>(0);
  ValueNotifier<double> maxHealth = ValueNotifier<double>(0);
  ValueNotifier<double> maxEnergy = ValueNotifier<double>(0);
  bool isLockEnergy = false;
  bool isLockMove = false;
  Set<int> killedBosses = {};
  int money = 0;
  int curWeapon = -1;
  List<Item> inventoryItems = [];
  List<Item> curDress = [];
  Vector2 location = Vector2(-1,-1);
  Vector2 curPosition = Vector2(-1,-1);
  double gameTime = 720;
  double milisecsInGame = 0;
  GameWorldData playerBigMap = TopLeftVillage();
  Vector2 startLocation = Vector2(1773,3118);


  void setStartValues()
  {
    // playerBigMap = BigTopLeft();
    maxHealth.value = 100;
    this.maxEnergy.value = 9999999;
    health.value = maxHealth.value;
    energy.value = this.maxEnergy.value;
    this.killedBosses = killedBosses ?? {};
    this.money = money ?? 0;
    this.curWeapon = curWeapon ?? -1;

    this.location = location ?? Vector2(10,10);
    this.curPosition = curPosition ?? Vector2.all(-1);
    this.gameTime = gameTime ?? 720;
    this.milisecsInGame = milisecsInGame ?? 0;
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
  static double runMinimum = 0.2;
  static double gravity = 20;
  static double rigidy = 0.5;
  static double stopSpeed = 800;
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


