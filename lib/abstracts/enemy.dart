import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/kyrgyz_game.dart';

mixin KyrgyzEnemy
{
  void setChance()
  {
    math.Random rand = math.Random(DateTime.now().microsecondsSinceEpoch);
    for(int i=0;i<maxLoots;i++){
      double chance = rand.nextDouble();
      if(chance <= chanceOfLoot){
        var item = Gold();
        loots.add(item);
      }
    }
  }

  void onGround(Object obj, Contact contact)
  {
      print('enemy(((');
  }

  bool checkIsNeedSelfRemove(int column, int row,KyrgyzGame  gameRef, Vector2 startPos,SpriteAnimationComponent object)
  {
    int diffCol = (column - gameRef.gameMap.column()).abs();
    int diffRow = (row - gameRef.gameMap.row()).abs();
    if(diffCol > 2 || diffRow > 2){
      gameRef.gameMap.loadedLivesObjs.remove(id);
      if(groundBody != null){
        gameRef.world.destroyBody(groundBody!);
      }
      object.removeFromParent();
    }
    if(diffCol > 1 || diffRow > 1){
      isRefresh = false;
      return false;
    }else{
      isRefresh = true;
      return true;
    }
  }

  ObstacleWhere whereObstacle = ObstacleWhere.none;
  bool isRefresh = true;
  double health = 0;
  double armor = 0;
  int maxLoots = 0;
  int column=0;
  int row=0;
  int id=-1;
  double chanceOfLoot = 0.01; // 0 - never
  void doHurt({required double hurt, bool inArmor=true}){}
  void doMagicHurt({required double hurt,required MagicDamage magicDamage}){}
  List<Item> loots = [];
  Map<MagicDamage,int> magicDamages = {};
  Ground? groundBody;
  BodyDef bodyDef = BodyDef(type: BodyType.dynamic,userData: BodyUserData(isQuadOptimizaion: false),linearDamping: 6,
  angularDamping: 6,fixedRotation: true);
}