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
      var firstPoint = entity.getPoint(0);
      var secondPoint = entity.getPoint(1);
      var thirdPoint = entity.getPoint(2);
      var fourthPoint = entity.getPoint(3);

      var first =  LoadedColumnRow(firstPoint.x ~/ GameConsts.lengthOfTileSquare.x, firstPoint.y ~/ GameConsts.lengthOfTileSquare.y);
      var sec =  LoadedColumnRow(secondPoint.x ~/ GameConsts.lengthOfTileSquare.x, secondPoint.y ~/ GameConsts.lengthOfTileSquare.y);
      var third =  LoadedColumnRow(thirdPoint.x ~/ GameConsts.lengthOfTileSquare.x, thirdPoint.y ~/ GameConsts.lengthOfTileSquare.y);
      var fourth =  LoadedColumnRow(fourthPoint.x ~/ GameConsts.lengthOfTileSquare.x, fourthPoint.y ~/ GameConsts.lengthOfTileSquare.y);

      int minCol = math.min(first.column, math.min(sec.column, math.min(third.column, fourth.column)));
      int maxCol = math.max(first.column, math.max(sec.column, math.max(third.column, fourth.column)));
      int minRow = math.min(first.row, math.min(sec.row, math.min(third.row, fourth.row)));
      int maxRow = math.max(first.row, math.max(sec.row, math.max(third.row, fourth.row)));
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
            // print('STATIC OBJECT POINTS: ${other.getPoints()}');
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
    Map<DCollisionEntity,DCollisionEntity> _tempPair = {};
    Map<DCollisionEntity,DCollisionEntity> _tempPair2 = {};
    for(final key in _potentialActiveEntity.keys) {
      Set<int> removeList = {};
      for(int i = 0; i < _potentialActiveEntity[key]!.length; i++){
        for(int j = 0; j < _potentialActiveEntity[key]!.length; j++){
          if(i == j || removeList.contains(j)){
            continue;
          }
          if(_tempPair.containsKey(_potentialActiveEntity[key]![i]) && _tempPair[_potentialActiveEntity[key]![i]] == _potentialActiveEntity[key]![j]){
            continue;
          }
          if(_tempPair2.containsKey(_potentialActiveEntity[key]![j]) && _tempPair2[_potentialActiveEntity[key]![j]] == _potentialActiveEntity[key]![i]){
            continue;
          }
          _tempPair.putIfAbsent(_potentialActiveEntity[key]![i], () => _potentialActiveEntity[key]![j]);
          _tempPair2.putIfAbsent(_potentialActiveEntity[key]![j], () => _potentialActiveEntity[key]![i]);
          if(_potentialActiveEntity[key]![i].collisionType == DCollisionType.passive && _potentialActiveEntity[key]![j].collisionType == DCollisionType.passive){
            continue;
          }
          if(!_potentialActiveEntity[key]![i].onComponentTypeCheck(_potentialActiveEntity[key]![j]) && !_potentialActiveEntity[key]![j].onComponentTypeCheck(_potentialActiveEntity[key]![i])){
            continue;
          }
          if(_potentialActiveEntity[key]![j] is MapObstacle){
            if(_potentialActiveEntity[key]![i].parent != null && _potentialActiveEntity[key]![i].parent is KyrgyzEnemy && _potentialActiveEntity[key]![j].onlyForPlayer){
              continue;
            }
            _calcTwoEntities(_potentialActiveEntity[key]![i], _potentialActiveEntity[key]![j],true);
            continue;
          }
          if(_potentialActiveEntity[key]![i] is MapObstacle){
            if(_potentialActiveEntity[key]![j].parent != null && _potentialActiveEntity[key]![j].parent is KyrgyzEnemy && _potentialActiveEntity[key]![i].onlyForPlayer){
              continue;
            }
            _calcTwoEntities(_potentialActiveEntity[key]![j], _potentialActiveEntity[key]![i],true);
            continue;
          }
          _calcTwoEntities(_potentialActiveEntity[key]![j], _potentialActiveEntity[key]![i],false);
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
  Set<int> insidePoints = {};
  for (int i = 0; i < other.getVerticesCount(); i++) {
    Vector2 otherFirst = other.getPoint(i);
    if (otherFirst.x <= entity
        .getPoint(3)
        .x && otherFirst.x >= entity
        .getPoint(0)
        .x
        && otherFirst.y <= entity
            .getPoint(1)
            .y && otherFirst.y >= entity
        .getPoint(0)
        .y) {
      if(isMapObstacle){
        insidePoints.add(i);
      }else {
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
  _finalInterCalc(entity, other, insidePoints, isMapObstacle);
}

void _finalInterCalc(DCollisionEntity entity, DCollisionEntity other, Set<int> insidePoints, bool isMapObstacle)
{
  for (int i = -1; i < other.getVerticesCount() - 1; i++) {
    if (!other.isLoop && i == -1) {
      continue;
    }
    int tF, tS;
    if (i == -1) {
      tF = other.getVerticesCount() - 1;
      tS = i + 1;
    } else {
      tF = i;
      tS = i + 1;
    }
    Vector2 otherFirst = other.getPoint(tF);
    Vector2 otherSecond = other.getPoint(tS);
    if (isMapObstacle) {
      List<Vector2> tempBorderLines = [];
      Vector2 point = f_pointOfIntersect(
          entity.getPoint(0), entity.getPoint(1), otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        tempBorderLines.add(point);
      }
      point = f_pointOfIntersect(
          entity.getPoint(1), entity.getPoint(2), otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        tempBorderLines.add(point);
      }
      point = f_pointOfIntersect(
          entity.getPoint(2), entity.getPoint(3), otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        tempBorderLines.add(point);
      }
      point = f_pointOfIntersect(
          entity.getPoint(3), entity.getPoint(0), otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        tempBorderLines.add(point);
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
        if(insidePoints.contains(tF)){
          absVec = tempBorderLines[0] + other.getPoint(tF);
          absVec /= 2;
        }else{
          absVec = tempBorderLines[0] + other.getPoint(tS);
          absVec /= 2;
        }
        entity.obstacleIntersects.add(absVec);
      }
    } else {
      Vector2 point = f_pointOfIntersect(
          entity.getPoint(0), entity.getPoint(1), otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        if (entity.onComponentTypeCheck(other)) {
          entity.onCollisionStart({point}, other);
        }
        if (other.onComponentTypeCheck(entity)) {
          other.onCollisionStart({point}, entity);
        }
        return;
      }
      point = f_pointOfIntersect(
          entity.getPoint(1), entity.getPoint(2), otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        if (entity.onComponentTypeCheck(other)) {
          entity.onCollisionStart({point}, other);
        }
        if (other.onComponentTypeCheck(entity)) {
          other.onCollisionStart({point}, entity);
        }
        return;
      }
      point = f_pointOfIntersect(
          entity.getPoint(2), entity.getPoint(3), otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        if (entity.onComponentTypeCheck(other)) {
          entity.onCollisionStart({point}, other);
        }
        if (other.onComponentTypeCheck(entity)) {
          other.onCollisionStart({point}, entity);
        }
        return;
      }
      point = f_pointOfIntersect(
          entity.getPoint(3), entity.getPoint(0), otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        if (entity.onComponentTypeCheck(other)) {
          entity.onCollisionStart({point}, other);
        }
        if (other.onComponentTypeCheck(entity)) {
          other.onCollisionStart({point}, entity);
        }
        return;
      }
    }
  }
}

//return point of intersects of two lines from 4 points
