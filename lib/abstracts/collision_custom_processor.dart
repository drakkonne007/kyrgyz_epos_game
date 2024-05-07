import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/image_composition.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/player.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:game_flame/kyrgyz_game.dart';

class DCollisionProcessor
{
  final List<DCollisionEntity> _activeCollEntity = [];
  final Map<LoadedColumnRow,List<DCollisionEntity>> _staticCollEntity = {};
  Map<LoadedColumnRow, List<DCollisionEntity>> _potentialActiveEntity = {};
  Set<LoadedColumnRow> _contactNests = {};
  KyrgyzGame game;
  DCollisionProcessor(this.game);

  void addActiveCollEntity(DCollisionEntity entity)
  {
    _activeCollEntity.add(entity);
  }

  void removeActiveCollEntity(DCollisionEntity entity)
  {
    _activeCollEntity.remove(entity);
  }

  void addStaticCollEntity(LoadedColumnRow colRow, DCollisionEntity entity)
  {
    _staticCollEntity.putIfAbsent(colRow, () => []);
    _staticCollEntity[colRow]!.add(entity);
  }

  void removeStaticCollEntity(LoadedColumnRow? colRow)
  {
    _staticCollEntity.remove(colRow);
  }

  void clearActiveCollEntity()
  {
    _activeCollEntity.clear();
  }

  void clearStaticCollEntity()
  {
    _staticCollEntity.clear();
  }

  void updateCollisions()
  {
    _potentialActiveEntity.clear();
    for(DCollisionEntity entity in _activeCollEntity){
      entity.obstacleIntersects = {};
      if(entity.collisionType == DCollisionType.inactive) {
        continue;
      }
      if(entity.parent == null){
        continue;
      }
      _contactNests.clear();
      int minCol = 0;
      int maxCol = 0;
      int minRow = 0;
      int maxRow = 0;
      if(entity.angle == 0 && entity.scale == Vector2(1, 1)){
        minCol = entity.getMinVector().x ~/ game.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x;
        maxCol = entity.getMaxVector().x ~/ game.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x;
        minRow = entity.getMinVector().y ~/ game.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y;
        maxRow = entity.getMaxVector().y ~/ game.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y;
      }else{
        for(int i=0;i<entity.getVerticesCount();i++){
          if(i==0){
            minCol = entity.getPoint(i).x ~/ game.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x;
            maxCol = entity.getPoint(i).x ~/ game.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x;
            minRow = entity.getPoint(i).y ~/ game.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y;
            maxRow = entity.getPoint(i).y ~/ game.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y;
            continue;
          }
          minCol = math.min(minCol, entity.getPoint(i).x ~/game.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x);
          maxCol = math.max(maxCol, entity.getPoint(i).x ~/game.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x);
          minRow = math.min(minRow, entity.getPoint(i).y ~/game.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y);
          maxRow = math.max(maxRow, entity.getPoint(i).y ~/game.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y);
        }
      }
      for(int col = minCol; col <= maxCol; col++){
        for(int row = minRow; row <= maxRow; row++){
          var lcr = LoadedColumnRow(col, row);
          if(!entity.isOnlyForStatic) {
            _potentialActiveEntity.putIfAbsent(lcr, () => []);
            _potentialActiveEntity[lcr]!.add(entity);
          }
          _contactNests.add(lcr);
        }
      }
      for(final lcr in _contactNests){
        if(_staticCollEntity.containsKey(lcr)) {
          for(final other in _staticCollEntity[lcr]!){
            if(other.collisionType == DCollisionType.inactive){
              continue;
            }
            if(entity.collisionType == DCollisionType.passive && other.collisionType == DCollisionType.passive){
              continue;
            }
            if(entity.parent != null && entity.parent !is MainPlayer && other.onlyForPlayer){
              continue;
            }
            if(!entity.onComponentTypeCheck(other) && !other.onComponentTypeCheck(entity)) {
              continue;
            }
            _calcTwoEntities(entity, other, other is MapObstacle);
          }
        }
      }
    }
    final listOfList = List.unmodifiable(_potentialActiveEntity.values.toList());
    for(int key = 0; key < listOfList.length; key++){
      Set<int> removeList = {};
      for(int i = 0; i < listOfList[key].length; i++){
        for(int j = 0; j < listOfList[key].length; j++){
          if(i == j || removeList.contains(j)){
            continue;
          }
          if(listOfList[key][i].parent != null && listOfList[key][j].parent != null
              && listOfList[key][i].parent == listOfList[key][j].parent){
            continue;
          }
          if(listOfList[key][i].collisionType == DCollisionType.passive && listOfList[key][j].collisionType == DCollisionType.passive){
            continue;
          }
          if(!listOfList[key][i].onComponentTypeCheck(listOfList[key][j]) && !listOfList[key][j].onComponentTypeCheck(listOfList[key][i])){
            continue;
          }
          if(listOfList[key][j] is MapObstacle){
            if(listOfList[key][i].parent != null && listOfList[key][i].parent is KyrgyzEnemy && listOfList[key][j].onlyForPlayer){
              continue;
            }
            _calcTwoEntities(listOfList[key][i], listOfList[key][j],true);
            continue;
          }
          if(listOfList[key][i] is MapObstacle){
            if(listOfList[key][j].parent != null && listOfList[key][j].parent is KyrgyzEnemy && listOfList[key][i].onlyForPlayer){
              continue;
            }
            _calcTwoEntities(listOfList[key][j], listOfList[key][i],true);
            continue;
          }
          _calcTwoEntities(listOfList[key][j], listOfList[key][i],false);
        }
        removeList.add(i);
      }
    }
    for(DCollisionEntity entity in _activeCollEntity){
      if(entity.obstacleIntersects.isNotEmpty){
        entity.onCollisionStart(entity.obstacleIntersects, entity); ///obstacleIntersects есть только у ГроундХитбоксов, поэтому можно во втором аргументе передать лажу
        entity.obstacleIntersects.clear();
      }
    }
  }
}
//Грубая проверка - мгут ли вообще они потенциально как-то скреститься. Солид или нет - это потом
void _calcTwoEntities(DCollisionEntity entity, DCollisionEntity other, bool isMapObstacle)
{
  if(other.scale == Vector2.all(1) && other.angle == 0
      && entity.scale == Vector2.all(1) && entity.angle == 0) {
    if (other.getMaxVector().x < entity.getMinVector().x
        || other.getMinVector().x > entity.getMaxVector().x
        || other.getMaxVector().y < entity.getMinVector().y
        || other.getMinVector().y > entity.getMaxVector().y) {
      return;
    }
  }
  Set<int> insidePoints = {};
  if(isMapObstacle) { //Если у вас все обекты столкновения с препятсвием с землёй квадратные, иначе делать что ближе от центра твоего тела
    for (int i = 0; i < other.getVerticesCount(); i++) {
      Vector2 otherFirst = other.getPoint(i);
      if(otherFirst.x <= entity.getMaxVector().x
          && otherFirst.x >= entity.getMinVector().x
          && otherFirst.y <= entity.getPoint(1).y
          && otherFirst.y >= entity.getPoint(0).y){
        insidePoints.add(i);
      }
    }
  }
  _finalInterCalc(entity, other,insidePoints,isMapObstacle);
}

void _finalInterCalc(DCollisionEntity entity, DCollisionEntity obstacle,Set<int> insidePoints, bool isMapObstacle)
{
  if(entity.isCircle && obstacle.isCircle){
    bool otherTrig = false;
    bool entityTrig = false;
    if(entity.radius + obstacle.radius > math.sqrt(math.pow(entity.getPoint(0).x - obstacle.getPoint(0).x,2)
        + math.pow(entity.getPoint(0).y - obstacle.getPoint(0).y,2))){
      return;
    }

    double a = -2 * obstacle.getPoint(0).x - entity.getPoint(0).x;
    double b = -2 * obstacle.getPoint(0).y - entity.getPoint(0).y;
    double c = math.pow(obstacle.getPoint(0).x,2).toDouble() + math.pow(obstacle.getPoint(0).y,2)
        + math.pow(entity.radius,2) - math.pow(obstacle.radius,2);
    var list = f_intersectLineFunctionWithCircle(entity.radius, a, b, c, entity.getPoint(0));
    if(list.isNotEmpty){
      if(!isMapObstacle){
        if (entity.onComponentTypeCheck(obstacle) && !entityTrig) {
          entityTrig = true;
          entity.onCollisionStart({list.first}, obstacle);
        }
        if (obstacle.onComponentTypeCheck(entity) && !otherTrig) {
          otherTrig = true;
          obstacle.onCollisionStart({list.first}, entity);
        }
      }else{
        if(list.length == 1){
          var vec1 = obstacle.getCenter();
          var vec2 = entity.getCenter();
          vec1.rotate(90,center: list.first);
          vec2.rotate(90,center: list.first);
          entity.obstacleIntersects.add(Line.fromPoints(vec1, vec2));
        }else if(list.length == 2){
          entity.obstacleIntersects.add(Line.fromPoints(list.first,list.last));
        }
      }
    }
    if(entityTrig || otherTrig){
      return;
    }
    if(!isMapObstacle){
      if(obstacle.isSolid && obstacle.radius > entity.radius){
        if(obstacle.onComponentTypeCheck(entity)) {
          obstacle.onCollisionStart({Vector2.zero()}, entity);
        }
      }
      if(entity.isSolid && entity.radius > obstacle.radius){
        if(entity.onComponentTypeCheck(obstacle)) {
          entity.onCollisionStart({Vector2.zero()}, obstacle);
        }
      }
    }
    return;
  }

  bool isChangeEntityObstacle = false;
  if(!entity.isCircle && obstacle.isCircle){ //При условии, что нет круглых обстаклов)
    var temp = entity;
    entity = obstacle;
    obstacle = temp;
    isChangeEntityObstacle = true;
  }

  if(entity.isCircle){
    bool otherTrig = false;
    bool entityTrig = false;
    Set<int> insideCircles = {};
    int countOfinside = 0;
    for (int i = 0; i < obstacle.getVerticesCount(); i++) {
      if (entity.getPoint(0).distanceToSquared(obstacle.getPoint(i)) < entity.radius * entity.radius) {
        countOfinside++;
        if (!isMapObstacle) {
          if(entity.isSolid) {
            if (entity.onComponentTypeCheck(obstacle) && !entityTrig) {
              entity.onCollisionStart({obstacle.getPoint(i)}, obstacle);
              entityTrig = true;
            }
          }
        } else {
          insideCircles.add(i);
        }
      }else{
        if(!isMapObstacle && countOfinside != 0) {
          if (entity.onComponentTypeCheck(obstacle) && !entityTrig) {
            entity.onCollisionStart({obstacle.getPoint(i)}, obstacle);
            entityTrig = true;
          }
          if(obstacle.onComponentTypeCheck(entity) && !otherTrig){
            otherTrig = true;
            obstacle.onCollisionStart({entity.getPoint(0)}, entity);
          }
          return;
        }
      }
    }
    if(countOfinside == obstacle.getVerticesCount()){
      return;
    }
    for (int i = -1; i < obstacle.getVerticesCount() - 1; i++) {
      if (!obstacle.isLoop && i == -1) {
        continue;
      }
      int tFirst, tSecond;
      if (i == -1) {
        tFirst = obstacle.getVerticesCount() - 1;
      } else {
        tFirst = i;
      }
      tSecond = i + 1;
      Vector2 otherFirst = obstacle.getPoint(tFirst);
      Vector2 otherSecond = obstacle.getPoint(tSecond);
      var list = f_intersectLineWithCircle(
          [otherFirst, otherSecond], entity.getPoint(0), entity.radius);
      if(list.isNotEmpty){
        if(!isMapObstacle){
          if (entity.onComponentTypeCheck(obstacle) && !entityTrig) {
            entity.onCollisionStart({list.first}, obstacle);
            entityTrig = true;
          }
          if (obstacle.onComponentTypeCheck(entity) && !otherTrig) {
            obstacle.onCollisionStart({list.first}, entity);
            otherTrig = true;
          }
          return;
        }else{
          if (list.length == 1) {
            if(isChangeEntityObstacle){
            }else{
              if(insideCircles.contains(tFirst)){
                entity.obstacleIntersects.add(Line.fromPoints(obstacle.getPoint(tFirst), list.first));
              }
              if(insideCircles.contains(tSecond)){
                entity.obstacleIntersects.add(Line.fromPoints(obstacle.getPoint(tSecond), list.first));
              }
              Vector2 absVec;
              if (insideCircles.contains(tFirst)) {
                absVec = list[0] + otherFirst;
              } else {
                absVec = list[0] + otherSecond;
              }
              absVec /= 2;
              entity.obstacleIntersects.add(absVec);
            }

          } else if (list.length == 2) {
            entity.obstacleIntersects.add(Line.fromPoints(list.first,list.last));
          }
        }
      }
    }
    if(!isMapObstacle){
      if(obstacle.isSolid){
        if(obstacle.onComponentTypeCheck(entity) && !otherTrig){
          obstacle.onCollisionStart({Vector2.zero()}, entity);
          otherTrig = true;
        }
      }
    }
    return;
  }

  //Если тупо два квадрата

  for (int i = -1; i < obstacle.getVerticesCount() - 1; i++) {
    if (!obstacle.isLoop && i == -1) {
      continue;
    }
    int tFirst, tSecond;
    if (i == -1) {
      tFirst = obstacle.getVerticesCount() - 1;
    } else {
      tFirst = i;
    }
    tSecond = i + 1;
    Vector2 obstacleFirst = obstacle.getPoint(tFirst);
    Vector2 obstacleSecond = obstacle.getPoint(tSecond);
    if (isMapObstacle) {
      if(insidePoints.contains(tFirst) && insidePoints.contains(tSecond)) {
        entity.obstacleIntersects.add(Line.fromPoints(obstacleFirst, obstacleSecond));
        continue;
      }
      List<Vector2> tempBorderLines = [];
      LoadedColumnRow ld = LoadedColumnRow(0, 0);
      for(int i = - 1; i<entity.getVerticesCount() - 1; i++){
        if (!entity.isLoop && i == -1) {
          continue;
        }
        int tF, tS;
        if (i == -1) {
          tF = entity.getVerticesCount() - 1;
        } else {
          tF = i;
        }
        tS = i + 1;
        Vector2 point = f_pointOfIntersect(entity.getPoint(tF), entity.getPoint(tS)
            , obstacleFirst, obstacleSecond);

        if (point != Vector2.zero()) {
          ld.column = tF;
          ld.row = tS;
          tempBorderLines.add(point);
        }
      }
      if (tempBorderLines.length == 2) {
        entity.obstacleIntersects.add(Line.fromPoints(obstacleFirst, obstacleSecond));
      }else if(tempBorderLines.length == 1){
        entity.obstacleIntersects.add(Line.fromPoints(entity.getPoint(ld.column), entity.getPoint(ld.row)));
      }
    } else {
      for(int i=-1; i<entity.getVerticesCount() - 1; i++){
        if (!entity.isLoop && i == -1) {
          continue;
        }
        int tF, tS;
        if (i == -1) {
          tF = entity.getVerticesCount() - 1;
          tS = i + 1;
        }else{
          tF = i;
          tS = i + 1;
        }
        Vector2 tempPos = f_pointOfIntersect(entity.getPoint(tF), entity.getPoint(tS), obstacleFirst, obstacleSecond);
        if(tempPos != Vector2.zero()){
          if (entity.onComponentTypeCheck(obstacle)) {
            entity.onCollisionStart({obstacleFirst}, obstacle);
          }
          if (obstacle.onComponentTypeCheck(entity)) {
            obstacle.onCollisionStart({obstacleFirst}, entity);
          }
          return;
        }
      }
    }
  }
  if(!isMapObstacle){
    if(entity.isSolid && obstacle.isTrueRect){
      if(entity.getMinVector().x < obstacle.getMinVector().x){
        if (entity.onComponentTypeCheck(obstacle)) {
          entity.onCollisionStart({Vector2.zero()}, obstacle);
        }
      }
    }
    if(obstacle.isSolid && entity.isTrueRect){
      if(obstacle.getMinVector().x < entity.getMinVector().x){
        if (obstacle.onComponentTypeCheck(entity)) {
          obstacle.onCollisionStart({Vector2.zero()}, entity);
        }
      }
    }
  }
}

//return point of intersects of two lines from 4 points
