import 'dart:math' as math;

import 'package:flame/components.dart';
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
        entity.onCollisionStart({}, entity); ///obstacleIntersects есть только у ГроундХитбоксов, поэтому можно во втором аргументе передать лажу
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

void _finalInterCalc(DCollisionEntity entity, DCollisionEntity other,Set<int> insidePoints, bool isMapObstacle)
{
  if(entity.isCircle && other.isCircle){
    bool otherTrig = false;
    bool entityTrig = false;
    if(entity.radius + other.radius > math.sqrt(math.pow(entity.getPoint(0).x - other.getPoint(0).x,2)
        + math.pow(entity.getPoint(0).y - other.getPoint(0).y,2))){
      return;
    }

    double a = -2 * other.getPoint(0).x - entity.getPoint(0).x;
    double b = -2 * other.getPoint(0).y - entity.getPoint(0).y;
    double c = math.pow(other.getPoint(0).x,2).toDouble() + math.pow(other.getPoint(0).y,2)
        + math.pow(entity.radius,2) - math.pow(other.radius,2);
    var list = f_intersectLineFunctionWithCircle(entity.radius, a, b, c, entity.getPoint(0));
    if(list.isNotEmpty){
      if(!isMapObstacle){
        if (entity.onComponentTypeCheck(other) && !entityTrig) {
          entityTrig = true;
          entity.onCollisionStart({list.first}, other);
        }
        if (other.onComponentTypeCheck(entity) && !otherTrig) {
          otherTrig = true;
          other.onCollisionStart({list.first}, entity);
        }
      }else{
        // if(list.length == 1){
        //   entity.obstacleIntersects.add(list.first);
        // }else if(list.length == 2){
        //   entity.obstacleIntersects.add((list.first + list.last) / 2);
        // }
      }
    }
    if(entityTrig || otherTrig){
      return;
    }
    if(!isMapObstacle){
      if(other.isSolid && other.radius > entity.radius){
        if(other.onComponentTypeCheck(entity)) {
          other.onCollisionStart({Vector2.zero()}, entity);
        }
      }
      if(entity.isSolid && entity.radius > other.radius){
        if(entity.onComponentTypeCheck(other)) {
          entity.onCollisionStart({Vector2.zero()}, other);
        }
      }
    }
    return;
  }

  if(!entity.isCircle && other.isCircle){ //При условии, что нет круглых обстаклов)
    var temp = entity;
    entity = other;
    other = temp;
  }

  if(entity.isCircle) {
    bool otherTrig = false;
    bool entityTrig = false;
    Set<int> insideCircles = {};
    int countOfinside = 0;
    for (int i = 0; i < other.getVerticesCount(); i++) {
      if (entity.getPoint(0).distanceToSquared(other.getPoint(i)) < entity.radius * entity.radius) {
        countOfinside++;
        if (!isMapObstacle) {
          if(entity.isSolid) {
            if (entity.onComponentTypeCheck(other) && !entityTrig) {
              entity.onCollisionStart({other.getPoint(i)}, other);
              entityTrig = true;
            }
          }
        } else {
          insideCircles.add(i);
        }
      }else{
        if(!isMapObstacle && countOfinside != 0) {
          if (entity.onComponentTypeCheck(other) && !entityTrig) {
            entity.onCollisionStart({other.getPoint(i)}, other);
            entityTrig = true;
          }
          if(other.onComponentTypeCheck(entity) && !otherTrig){
            otherTrig = true;
            other.onCollisionStart({entity.getPoint(0)}, entity);
          }
          return;
        }
      }
    }
    if(countOfinside == other.getVerticesCount()){
      return;
    }
    for (int i = -1; i < other.getVerticesCount() - 1; i++) {
      if (!other.isLoop && i == -1) {
        continue;
      }
      int tFirst, tSecond;
      if (i == -1) {
        tFirst = other.getVerticesCount() - 1;
      } else {
        tFirst = i;
      }
      tSecond = i + 1;
      Vector2 otherFirst = other.getPoint(tFirst);
      Vector2 otherSecond = other.getPoint(tSecond);
      var list = f_intersectLineWithCircle(
          [otherFirst, otherSecond], entity.getPoint(0), entity.radius);
      if (list.isNotEmpty) {
        if (!isMapObstacle) {
          if (entity.onComponentTypeCheck(other) && !entityTrig) {
            entity.onCollisionStart({list.first}, other);
            entityTrig = true;
          }
          if (other.onComponentTypeCheck(entity) && !otherTrig) {
            other.onCollisionStart({list.first}, entity);
            otherTrig = true;
          }
          return;
        } else {
          // if (list.length == 1) {
          //   Vector2 absVec;
          //   if (insideCircles.contains(tFirst)) {
          //     absVec = list[0] + otherFirst;
          //   } else {
          //     absVec = list[0] + otherSecond;
          //   }
          //   absVec /= 2;
          //   entity.obstacleIntersects.add(absVec);
          // } else if (list.length == 2) {
          //   entity.obstacleIntersects.add((list.first + list.last) / 2);
          // }
        }
      }
    }
    if(!isMapObstacle){
      if(other.isSolid){
        if(other.onComponentTypeCheck(entity) && !otherTrig){
          other.onCollisionStart({Vector2.zero()}, entity);
          otherTrig = true;
        }
      }
    }
    return;
  }

  //Если тупо два квадрата

  for (int i = -1; i < other.getVerticesCount() - 1; i++) {
    if (!other.isLoop && i == -1) {
      continue;
    }
    int tFirst, tSecond;
    if (i == -1) {
      tFirst = other.getVerticesCount() - 1;
    } else {
      tFirst = i;
    }
    tSecond = i + 1;
    Vector2 otherFirst = other.getPoint(tFirst);
    Vector2 otherSecond = other.getPoint(tSecond);
    if (isMapObstacle) {
      if(insidePoints.contains(tFirst) && insidePoints.contains(tSecond)) {
        CollideInfo cinf = CollideInfo();
        cinf.collideDepth = (otherFirst + otherSecond) / 2;
        cinf.lineWhichCollide = [otherFirst, otherSecond];
        entity.obstacleIntersects.add(cinf);
        continue;
      }
      List<Vector2> tempBorderLines = [];
      List<Vector2> entityFrames = [];
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
            , otherFirst, otherSecond);
        if (point != Vector2.zero()) {
          tempBorderLines.add(point);
          entityFrames.add(entity.getPoint(tF));
          entityFrames.add(entity.getPoint(tS));
        }
      }
      if (tempBorderLines.length == 2) {
        CollideInfo cinf = CollideInfo();
        cinf.collideDepth = (tempBorderLines[0] + tempBorderLines[1]) / 2;
        cinf.lineWhichCollide = [tempBorderLines[0], tempBorderLines[1]];
        entity.obstacleIntersects.add(cinf);
      }else if(tempBorderLines.length == 1){
        CollideInfo cinf = CollideInfo();
        if(insidePoints.contains(tFirst)){
          cinf.collideDepth = otherFirst;
        }else{
          cinf.collideDepth = otherSecond;
        }
        cinf.lineWhichCollide = [entityFrames[0], entityFrames[1]];
        entity.obstacleIntersects.add(cinf);
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
        Vector2 tempPos = f_pointOfIntersect(entity.getPoint(tF), entity.getPoint(tS), otherFirst, otherSecond);
        if(tempPos != Vector2.zero()){
          if (entity.onComponentTypeCheck(other)) {
            entity.onCollisionStart({otherFirst}, other);
          }
          if (other.onComponentTypeCheck(entity)) {
            other.onCollisionStart({otherFirst}, entity);
          }
          return;
        }
      }
    }
  }
  if(!isMapObstacle){
    if(entity.isSolid && other.isTrueRect){
      if(entity.getMinVector().x < other.getMinVector().x){
        if (entity.onComponentTypeCheck(other)) {
          entity.onCollisionStart({Vector2.zero()}, other);
        }
      }
    }
    if(other.isSolid && entity.isTrueRect){
      if(other.getMinVector().x < entity.getMinVector().x){
        if (other.onComponentTypeCheck(entity)) {
          other.onCollisionStart({Vector2.zero()}, entity);
        }
      }
    }
  }
}

//return point of intersects of two lines from 4 points
