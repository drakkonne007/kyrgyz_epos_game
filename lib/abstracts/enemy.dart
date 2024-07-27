import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';

class KyrgyzEnemy extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  ObstacleWhere whereObstacle = ObstacleWhere.none;
  bool isRefresh = true;
  double health = 0;
  double armor = 0;
  int maxLoots = 0;
  int column=0;
  int row=0;
  int id=-1;
  double chanceOfLoot = 0.01; // 0 - never
  List<String> loots = [];
  Map<MagicDamage,int> magicDamages = {};
  Ground? groundBody;
  BodyDef bodyDef = BodyDef(type: BodyType.dynamic,userData: BodyUserData(isQuadOptimizaion: false),linearDamping: 6,
      angularDamping: 6,fixedRotation: true);
  Vector2 speed = Vector2(0,0);
  double maxSpeed = 0;
  EnemyHitbox? hitBox;
  DefaultEnemyWeapon? weapon;
  bool wasHit = false;

  @override
  @mustCallSuper
  Future<void> onLoad() async
  {
    setChance();
  }

  void setChance()
  {
    math.Random rand = math.Random(DateTime.now().microsecondsSinceEpoch);
    for(int i=0;i<maxLoots;i++){
      double chance = rand.nextDouble();
      if(chance <= chanceOfLoot){
        var item = 'gold';
        loots.add(item);
      }
    }
  }

  bool internalPhysHurt(double hurt,bool inArmor)
  {
    weapon?.collisionType = DCollisionType.inactive;
    if(inArmor){
      double dd = math.max(hurt - armor, 0);
      if(dd == 0){
        gameRef.gameMap.orthoPlayer!.endHit();
        return false;
      }
      health -= dd;
    }else{
      health -= hurt;
    }
    return true;
  }

  void doHurt({required double hurt, bool inArmor=true}){}

  void doMagicHurt({required double hurt,required MagicDamage magicDamage}){}

  void onGround(Object obj, Contact contact)
  {
      print('enemy(((');
  }

  void death(SpriteAnimation? anim)
  {
    speed.x = 0;
    speed.y = 0;
    groundBody?.clearForces();
    groundBody?.setActive(false);
    groundBody?.destroy();
    if(loots.isNotEmpty) {
      if(loots.length > 1){
        var temp = Chest(0, myItems: loots, position: positionOfAnchor(anchor));
        gameRef.gameMap.container.add(temp);
      }else{
        var temp = LootOnMap(itemFromName(loots.first), position: positionOfAnchor(anchor));
        gameRef.gameMap.container.add(temp);
      }
    }
    animation = anim;
    hitBox?.collisionType = DCollisionType.inactive;
    animationTicker?.onComplete = () {
      add(OpacityEffect.by(-1,EffectController(duration: animationTicker?.totalDuration()),onComplete: (){
        gameRef.gameMap.loadedLivesObjs.remove(id);
        removeFromParent();
      }));
    };
    if(id > -1) {
      gameRef.dbHandler.changeItemState(id: id,
          worldName: gameRef.gameMap.currentGameWorldData!.nameForGame,
          usedAsString: '1');
    }
  }

  bool isNearPlayer(double squaredDistance)
  {
    var pl = gameRef.gameMap.orthoPlayer!;
    if(pl.hitBox == null){
      return false;
    }
    if(position.distanceToSquared(pl.position) > squaredDistance){
      return false;
    }
    if(hitBox == null){
      return false;
    }
    if(pl.hitBox!.getMinVector().y > hitBox!.getMaxVector().y || pl.hitBox!.getMaxVector().y < hitBox!.getMinVector().y){
      return false;
    }
    return true;
  }

  bool checkIsNeedSelfRemove(int column, int row,KyrgyzGame  gameRef, Vector2 startPos)
  {
    int diffCol = (column - gameRef.gameMap.column()).abs();
    int diffRow = (row - gameRef.gameMap.row()).abs();
    if(diffCol > 2 || diffRow > 2){
      gameRef.gameMap.loadedLivesObjs.remove(id);
      if(groundBody != null){
        gameRef.world.destroyBody(groundBody!);
      }
      removeFromParent();
    }
    if(diffCol > 1 || diffRow > 1){
      isRefresh = false;
      return false;
    }else{
      isRefresh = true;
      return true;
    }
  }


}