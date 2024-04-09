import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/abstracts/dVector2.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

mixin KyrgyzEnemy
{
  setChance()
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

  bool checkIsNeedSelfRemove(int column, int row,KyrgyzGame  gameRef, Vector2 startPos,SpriteAnimationComponent object)
  {
    int diffCol = (column - gameRef.gameMap.column()).abs();
    int diffRow = (row - gameRef.gameMap.row()).abs();
    if(diffCol > GameConsts.worldWidth || diffRow > GameConsts.worldWidth){
      gameRef.gameMap.loadedLivesObjs.remove(startPos);
      object.removeFromParent();
    }
    if(diffCol > GameConsts.visibleWorldWidth || diffRow > GameConsts.visibleWorldWidth){
      isRefresh = false;
      return false;
    }else{
      isRefresh = true;
      return true;
    }
  }

  void obstacleBehaviour(Set<dVector2> intersectionPoints, DCollisionEntity other, GroundHitBox groundBox, PositionComponent object)
  {
    Map<dVector2,AxesDiff> diffs = {};
    bool isUp = false;
    bool isDown = false;
    bool isLeft = false;
    bool isRight = false;
    double maxLeft = 0;
    double maxRight = 0;
    double maxUp = 0;
    double maxDown = 0;

    for(final point in intersectionPoints){
      if(dVector2(groundBox.getMinVector().x,groundBox.getMinVector().y).distanceToSquared(point) < 4){
        continue;
      }
      if(dVector2(groundBox.getMinVector().x,groundBox.getMaxVector().y).distanceToSquared(point) < 4){
        continue;
      }
      if(dVector2(groundBox.getMaxVector().x,groundBox.getMaxVector().y).distanceToSquared(point) < 4){
        continue;
      }
      if(dVector2(groundBox.getMaxVector().x,groundBox.getMinVector().y).distanceToSquared(point) < 4){
        continue;
      }


      double leftDiffX  = point.x - groundBox.getMinVector().x;
      double rightDiffX = point.x - groundBox.getMaxVector().x;
      double upDiffY = point.y - groundBox.getMinVector().y;
      double downDiffY = point.y - groundBox.getMaxVector().y;

      // print('diffs: $leftDiffX $rightDiffX $upDiffY $downDiffY');

      diffs.putIfAbsent(point, () => AxesDiff(leftDiffX,rightDiffX,upDiffY,downDiffY));
      double minDiff = math.min(leftDiffX.abs(),rightDiffX.abs());
      minDiff = math.min(minDiff,upDiffY.abs());
      minDiff = math.min(minDiff,downDiffY.abs());
      if(minDiff == leftDiffX.abs()){
        isLeft = true;
        maxLeft = math.max(maxLeft,minDiff);
      }
      if(minDiff == rightDiffX.abs()){
        isRight = true;
        maxRight = math.max(maxRight,minDiff);
      }
      if(minDiff == upDiffY.abs()){
        isUp = true;
        maxUp = math.max(maxUp,minDiff);
      }
      if(minDiff == downDiffY.abs()){
        isDown = true;
        maxDown = math.max(maxDown,minDiff);
      }
    }

    if(isDown && isUp && isLeft && isRight){
      print('What is??');
      return;
    }

    if(isDown && isUp){
      double maxLeft = 1000000000;
      double maxRight = 1000000000;
      for(final diff in diffs.values){
        maxLeft = math.min(maxLeft,diff.leftDiff.abs());
        maxRight = math.min(maxRight,diff.rightDiff.abs());
      }
      if(maxLeft > maxRight){
        object.position -= Vector2(maxRight,0);
      }else{
        object.position += Vector2(maxLeft,0);
      }
      return;
    }
    if(isLeft && isRight){
      double maxUp = 100000000;
      double maxDown = 100000000;
      for(final diff in diffs.values){
        maxUp = math.min(maxUp,diff.upDiff.abs());
        maxDown = math.min(maxDown,diff.downDiff.abs());
      }
      if(maxUp > maxDown){
        object.position -= Vector2(0,maxDown);
      }else{
        object.position += Vector2(0,maxUp);
      }
      return;
    }

    // print('maxs: $maxLeft $maxRight $maxUp $maxDown');

    if(isLeft){
      whereObstacle = ObstacleWhere.side;
      object.position +=  Vector2(maxLeft,0);
    }
    if(isRight){
      whereObstacle = ObstacleWhere.side;
      object.position -=  Vector2(maxRight,0);
    }
    if(isUp){
      whereObstacle = ObstacleWhere.upDown;
      object.position +=  Vector2(0,maxUp);
    }
    if(isDown){
      whereObstacle = ObstacleWhere.upDown;
      object.position -=  Vector2(0,maxDown);
    }
  }

  ObstacleWhere whereObstacle = ObstacleWhere.none;
  bool isRefresh = true;
  double health = 0;
  double armor = 0;
  int maxLoots = 0;
  int column=0;
  int row=0;
  double chanceOfLoot = 0.01; // 0 - never
  void doHurt({required double hurt, bool inArmor=true}){}
  void doMagicHurt({required double hurt,required MagicDamage magicDamage}){}
  List<Item> loots = [];
  Map<MagicDamage,int> magicDamages = {};
}