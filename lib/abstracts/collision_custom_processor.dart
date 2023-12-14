import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/player.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/tile_map_component.dart';

class DCollisionProcessor
{
  final List<DCollisionEntity> _activeCollEntity = [];
  final Map<LoadedColumnRow,List<DCollisionEntity>> _staticCollEntity = {};
  Map<LoadedColumnRow, List<DCollisionEntity>> _potentialActiveEntity = {};
  Set<LoadedColumnRow> _contactNests = {};


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
      _contactNests.clear();
      int minCol = 0;
      int maxCol = 0;
      int minRow = 0;
      int maxRow = 0;
      for(int i=0;i<entity.getVerticesCount();i++){
        if(i==0){
          minCol = entity.getPoint(i).x ~/ GameConsts.lengthOfTileSquare.x;
          maxCol = entity.getPoint(i).x ~/ GameConsts.lengthOfTileSquare.x;
          minRow = entity.getPoint(i).y ~/ GameConsts.lengthOfTileSquare.y;
          maxRow = entity.getPoint(i).y ~/ GameConsts.lengthOfTileSquare.y;
          continue;
        }
        minCol = math.min(minCol, entity.getPoint(i).x ~/ GameConsts.lengthOfTileSquare.x);
        maxCol = math.max(maxCol, entity.getPoint(i).x ~/ GameConsts.lengthOfTileSquare.x);
        minRow = math.min(minRow, entity.getPoint(i).y ~/ GameConsts.lengthOfTileSquare.y);
        maxRow = math.max(maxRow, entity.getPoint(i).y ~/ GameConsts.lengthOfTileSquare.y);
      }

      for(int col = minCol; col <= maxCol; col++){
        for(int row = minRow; row <= maxRow; row++){
          var lcr = LoadedColumnRow(col, row);
          _potentialActiveEntity.putIfAbsent(lcr, () => []);
          _potentialActiveEntity[lcr]!.add(entity);
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

//Активные entity ВСЕГДА ПРЯМОУГОЛЬНИКИ залупленные
void _calcTwoEntities(DCollisionEntity entity, DCollisionEntity other, bool isMapObstacle)
{
  _finalInterCalc(entity, other,isMapObstacle);
}

void _finalInterCalc(DCollisionEntity entity, DCollisionEntity other, bool isMapObstacle)
{
  Set<int> insidePoints = {};
  for (int i = -1; i < other.getVerticesCount() - 1; i++) {
    if (!other.isLoop && i == -1) {
      continue;
    }
    int tFirst, tSecond;
    if (i == -1) {
      tFirst = other.getVerticesCount() - 1;
      tSecond = i + 1;
    } else {
      tFirst = i;
      tSecond = i + 1;
    }
    Vector2 otherFirst = other.getPoint(tFirst);
    Vector2 otherSecond = other.getPoint(tSecond);
    if (isMapObstacle) {
      List<Vector2> tempBorderLines = [];
      for(int i=0; i<entity.getVerticesCount() - 1; i++){
        if (!entity.isLoop && i == -1) {
          continue;
        }
        int tF, tS;
        if (i == -1) {
          tF = entity.getVerticesCount() - 1;
          tS = i + 1;
        } else {
          tF = i;
          tS = i + 1;
        }
        Vector2 point = f_pointOfIntersect(
            entity.getPoint(tF), entity.getPoint(tS), otherFirst, otherSecond);
        if (point != Vector2.zero()) {
          tempBorderLines.add(point);
        }
      }
      if (tempBorderLines.length == 2) {
        Vector2 absLength = Vector2(tempBorderLines[0].x - tempBorderLines[1].x,
            tempBorderLines[0].y - tempBorderLines[1].y);
        absLength = Vector2(absLength.x.abs(), absLength.y.abs()) / 2;
        entity.obstacleIntersects.add(Vector2(
            absLength.x + math.min(tempBorderLines[0].x, tempBorderLines[1].x),
            absLength.y + math.min(tempBorderLines[0].y, tempBorderLines[1].y)));
      }else if(tempBorderLines.length == 1){
        Vector2 absVec;
        if(insidePoints.contains(tFirst)){
          absVec = tempBorderLines[0] + otherFirst;
        }else if(insidePoints.contains(tSecond)){
          absVec = tempBorderLines[0] + otherSecond;
        }else{
            if (otherFirst.x <= entity
                .getMaxVector()
                .x && otherFirst.x >= entity
                .getMinVector()
                .x
                && otherFirst.y <= entity
                    .getMaxVector()
                    .y && otherFirst.y >= entity
                .getMinVector()
                .y) {
              insidePoints.add(tFirst);
              absVec = tempBorderLines[0] + otherFirst;
            }else{
              insidePoints.add(tSecond);
              absVec = tempBorderLines[0] + otherSecond;
            }
        }
        absVec /= 2;
        entity.obstacleIntersects.add(absVec);
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
}

//return point of intersects of two lines from 4 points
