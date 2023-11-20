import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/tile_map_component.dart';

class DCollisionProcessor
{
  final List<DCollisionEntity> _activeCollEntity = [];
  final Map<LoadedColumnRow,List<DCollisionEntity>> _staticCollEntity = {};
  Map<DCollisionEntity,DCollisionEntity> _collisions = {};

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
    Map<LoadedColumnRow, List<DCollisionEntity>> potentialActiveEntity = {};
    for(DCollisionEntity entity in _activeCollEntity){
      entity.obstacleIntersects = {};
      if(entity.collisionType == DCollisionType.inactive) {
        continue;
      }
      PositionComponent component = entity.parent as PositionComponent;
      Set<LoadedColumnRow> contactNests = {};
      var firstPoint = component.positionOfAnchor(component.anchor) + entity.getPoint(0);
      var secondPoint = component.positionOfAnchor(component.anchor) + entity.getPoint(1);
      var thirdPoint = component.positionOfAnchor(component.anchor) + entity.getPoint(2);
      var fourthPoint = component.positionOfAnchor(component.anchor) + entity.getPoint(3);

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
          potentialActiveEntity.putIfAbsent(lcr, () => []);
          potentialActiveEntity[lcr]!.add(entity);
          contactNests.add(lcr);
        }
      }
      for(final lcr in contactNests){
        if(_staticCollEntity.containsKey(lcr)) {
          for(final other in _staticCollEntity[lcr]!){
            // print('STATIC OBJECT POINTS: ${other.getPoints()}');
            if(other.collisionType == DCollisionType.inactive){
              continue;
            }
            if(!entity.onComponentTypeCheck(other) && !other.onComponentTypeCheck(entity)) {
              continue;
            }
            if(entity.collisionType == DCollisionType.passive && other.collisionType == DCollisionType.passive){
              continue;
            }
            _calcTwoStaticEntities(entity, other);
          }
        }
      }
    }
    for(final key in potentialActiveEntity.keys) {
      Set<int> removeList = {};
      for(int i = 0; i < potentialActiveEntity[key]!.length; i++){
        for(int j = 0; j < potentialActiveEntity[key]!.length; j++){
          if(i == j || removeList.contains(j)){
            continue;
          }
          if(!potentialActiveEntity[key]![i].onComponentTypeCheck(potentialActiveEntity[key]![j])
              && !potentialActiveEntity[key]![j].onComponentTypeCheck(potentialActiveEntity[key]![i])) {
            continue;
          }
          _calcTwoActiveEntities(potentialActiveEntity[key]![i], potentialActiveEntity[key]![j]);
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
void _calcTwoStaticEntities(DCollisionEntity entity, DCollisionEntity other) {
  Set<int> insidePoints = {};
  PositionComponent component = entity.parent as PositionComponent;
  bool isMapObstacle = other is MapObstacle &&
      entity.onComponentTypeCheck(other);
  for (int i = 0; i < other.getVerticesCount(); i++) {
    Vector2 otherFirst = other.getPoint(i);
    if (otherFirst.x <= entity
        .getPoint(3)
        .x + component.positionOfAnchor(component.anchor).x && otherFirst.x >= entity
        .getPoint(0)
        .x + component.positionOfAnchor(component.anchor).x
        && otherFirst.y <= entity
            .getPoint(1)
            .y + component.positionOfAnchor(component.anchor).y && otherFirst.y >= entity
        .getPoint(0)
        .y + component.positionOfAnchor(component.anchor).y) {
      insidePoints.add(i);
      if (isMapObstacle) {
        entity.obstacleIntersects.add(otherFirst);
      } else {
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

void _calcTwoActiveEntities(DCollisionEntity entity, DCollisionEntity other)
{
  Set<int> insidePoints = {};
  Set<int> otherInsidePoints = {};
  bool isMapObstacle = other is MapObstacle &&
      entity.onComponentTypeCheck(other);
  bool isOtherMapObstacle = entity is MapObstacle &&
      other.onComponentTypeCheck(entity);
  PositionComponent componentEntity = entity.parent as PositionComponent;
  PositionComponent componentOther = other.parent as PositionComponent;

  for (int i = 0; i < other.getVerticesCount(); i++) {
    Vector2 otherFirst = other.getPoint(i) + componentOther.positionOfAnchor(componentOther.anchor);
    if (otherFirst.x <= entity
        .getPoint(3)
        .x + componentEntity.positionOfAnchor(componentEntity.anchor).x && otherFirst.x >= entity
        .getPoint(0)
        .x + componentEntity.positionOfAnchor(componentEntity.anchor).x
        && otherFirst.y <= entity
            .getPoint(1)
            .y + componentEntity.positionOfAnchor(componentEntity.anchor).y && otherFirst.y >= entity
        .getPoint(0)
        .y + componentEntity.positionOfAnchor(componentEntity.anchor).y) {
      insidePoints.add(i);
      if (isMapObstacle) {
        entity.obstacleIntersects.add(otherFirst);
      } else {
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

  for (int i = 0; i < entity.getVerticesCount(); i++) {
    Vector2 entityFirst = entity.getPoint(i) + componentEntity.positionOfAnchor(componentEntity.anchor);
    if (entityFirst.x <= other
        .getPoint(3)
        .x + componentOther.positionOfAnchor(componentOther.anchor).x && entityFirst.x >= other
        .getPoint(0)
        .x + componentOther.positionOfAnchor(componentOther.anchor).x
        && entityFirst.y <= other
            .getPoint(1)
            .y + componentOther.positionOfAnchor(componentOther.anchor).y && entityFirst.y >= other
        .getPoint(0)
        .y + componentOther.positionOfAnchor(componentOther.anchor).y) {
      otherInsidePoints.add(i);
      if (isOtherMapObstacle) {
        other.obstacleIntersects.add(entityFirst);
      } else {
        if (entity.onComponentTypeCheck(other)) {
          entity.onCollisionStart({entityFirst}, other);
        }
        if (other.onComponentTypeCheck(entity)) {
          other.onCollisionStart({entityFirst}, entity);
        }
        return;
      }
    }
  }
  _finalInterCalc(entity, other, insidePoints, isMapObstacle);
  if(isOtherMapObstacle) {
    _finalInterCalc(other, entity, otherInsidePoints, isOtherMapObstacle);
  }
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
      tS = 0;
    } else {
      tF = i;
      tS = i + 1;
    }
    // if (insidePoints.contains(tF) || insidePoints.contains(tS)) {
    //   continue;
    // }
    //FIXME Надо добавлять точки если внутри тока - то надо ешё и добавлять центры пересечения
    PositionComponent componentEntity = entity.parent as PositionComponent;
    Vector2 otherComponentVector = Vector2.zero();
    if(!other.isStatic){
      var temp = other.parent as PositionComponent;
      otherComponentVector = temp.positionOfAnchor(temp.anchor);
    }
    Vector2 otherFirst = other.getPoint(tF) + otherComponentVector;
    Vector2 otherSecond = other.getPoint(tS) + otherComponentVector;
    if (isMapObstacle) {
      List<Vector2> tempBorderLines = [];
      Vector2 point = f_pointOfIntersect(
          entity.getPoint(0) + componentEntity.positionOfAnchor(componentEntity.anchor), entity.getPoint(1)  + componentEntity.positionOfAnchor(componentEntity.anchor), otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        tempBorderLines.add(point);
      }
      point = f_pointOfIntersect(
          entity.getPoint(1) + componentEntity.positionOfAnchor(componentEntity.anchor), entity.getPoint(2) + componentEntity.positionOfAnchor(componentEntity.anchor), otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        tempBorderLines.add(point);
      }
      point = f_pointOfIntersect(
          entity.getPoint(2) + componentEntity.positionOfAnchor(componentEntity.anchor), entity.getPoint(3) + componentEntity.positionOfAnchor(componentEntity.anchor), otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        tempBorderLines.add(point);
      }
      point = f_pointOfIntersect(
          entity.getPoint(3) + componentEntity.positionOfAnchor(componentEntity.anchor), entity.getPoint(0) + componentEntity.positionOfAnchor(componentEntity.anchor), otherFirst, otherSecond);
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
          entity.getPoint(0) + componentEntity.positionOfAnchor(componentEntity.anchor), entity.getPoint(1) + componentEntity.positionOfAnchor(componentEntity.anchor), otherFirst, otherSecond);
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
          entity.getPoint(1) + componentEntity.positionOfAnchor(componentEntity.anchor), entity.getPoint(2) + componentEntity.positionOfAnchor(componentEntity.anchor), otherFirst, otherSecond);
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
          entity.getPoint(2) + componentEntity.positionOfAnchor(componentEntity.anchor), entity.getPoint(3) + componentEntity.positionOfAnchor(componentEntity.anchor), otherFirst, otherSecond);
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
          entity.getPoint(3) + componentEntity.positionOfAnchor(componentEntity.anchor), entity.getPoint(0) + componentEntity.positionOfAnchor(componentEntity.anchor), otherFirst, otherSecond);
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
