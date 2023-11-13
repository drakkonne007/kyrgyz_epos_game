import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/tile_map_component.dart';

class DCollisionProcessor
{
  final List<DCollisionEntity> _activeCollEntity = [];
  final Map<LoadedColumnRow,List<DCollisionEntity>> _staticCollEntity = {};

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

  void removeStaticCollEntity(LoadedColumnRow colRow)
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
    for(DCollisionEntity entity in _activeCollEntity)
    {
      entity.obstacleIntersects = {};
      if(entity.collisionType == DCollisionType.inactive) {
        continue;
      }
      PositionComponent component = entity.parent as PositionComponent;
      Set<LoadedColumnRow> contactNests = {};
      var first =  LoadedColumnRow(component.x ~/ GameConsts.lengthOfTileSquare.x, component.y ~/ GameConsts.lengthOfTileSquare.y);
      var sec =  LoadedColumnRow((component.x + component.size.x) ~/ GameConsts.lengthOfTileSquare.x, component.y ~/ GameConsts.lengthOfTileSquare.y);
      var third =  LoadedColumnRow((component.x + component.size.x) ~/ GameConsts.lengthOfTileSquare.x, (component.y + component.size.y) ~/ GameConsts.lengthOfTileSquare.y);
      var fourth =  LoadedColumnRow(component.x ~/ GameConsts.lengthOfTileSquare.x, (component.y + component.size.y) ~/ GameConsts.lengthOfTileSquare.y);
      contactNests.add(first);
      contactNests.add(sec);
      contactNests.add(third);
      contactNests.add(fourth);
      for(final lcr in contactNests){
        potentialActiveEntity.putIfAbsent(lcr, () => []);
        potentialActiveEntity[lcr]!.add(entity);
      }
      for(final lcr in contactNests){
        if(_staticCollEntity.containsKey(lcr)) {
          for(final other in _staticCollEntity[lcr]!){
            if(other.collisionType == DCollisionType.inactive){
              continue;
            }
            if(!entity.onComponentTypeCheck(other) && !other.onComponentTypeCheck(entity)) {
              continue;
            }
            _calcTwoStaticEntities(entity, other);
          }
        }
      }
    }
    Set<int> removeList = {};
    for(final key in potentialActiveEntity.keys) {
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
    if (otherFirst.x < entity
        .getPoint(3)
        .x + component.x && otherFirst.x > entity
        .getPoint(0)
        .x + component.x
        && otherFirst.y < entity
            .getPoint(1)
            .y + component.y && otherFirst.y > entity
        .getPoint(0)
        .y + component.y) {
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
    Vector2 otherFirst = other.getPoint(i) + componentOther.position;
    if (otherFirst.x < entity
        .getPoint(3)
        .x + componentEntity.x && otherFirst.x > entity
        .getPoint(0)
        .x + componentEntity.x
        && otherFirst.y < entity
            .getPoint(1)
            .y + componentEntity.y && otherFirst.y > entity
        .getPoint(0)
        .y + componentEntity.y) {
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
    Vector2 entityFirst = entity.getPoint(i) + componentEntity.position;
    if (entityFirst.x < other
        .getPoint(3)
        .x + componentOther.x && entityFirst.x > other
        .getPoint(0)
        .x + componentOther.x
        && entityFirst.y < other
            .getPoint(1)
            .y + componentOther.y && entityFirst.y > other
        .getPoint(0)
        .y + componentOther.y) {
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
    if (insidePoints.contains(i)) {
      continue;
    }
    int tF, tS;
    if (i == -1) {
      tF = 0;
      tS = other.getVerticesCount() - 1;
    } else {
      tF = i;
      tS = i + 1;
    }
    if (insidePoints.contains(tF) || insidePoints.contains(tS)) {
      continue;
    }
    PositionComponent componentEntity = entity.parent as PositionComponent;
    Vector2 otherComponentVector = Vector2.zero();
    if(!other.isStatic){
      var temp = other.parent as PositionComponent;
      otherComponentVector = temp.position;
    }
    Vector2 otherFirst = other.getPoint(tF) + otherComponentVector;
    Vector2 otherSecond = other.getPoint(tS) + otherComponentVector;
    if (isMapObstacle) {
      List<Vector2> tempBorderLines = [];
      Vector2 point = _pointOfIntersect(
          entity.getPoint(0) + componentEntity.position, entity.getPoint(1)  + componentEntity.position, otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        tempBorderLines.add(point);
      }
      point = _pointOfIntersect(
          entity.getPoint(1) + componentEntity.position, entity.getPoint(2) + componentEntity.position, otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        tempBorderLines.add(point);
      }
      point = _pointOfIntersect(
          entity.getPoint(2) + componentEntity.position, entity.getPoint(3) + componentEntity.position, otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        tempBorderLines.add(point);
      }
      point = _pointOfIntersect(
          entity.getPoint(3) + componentEntity.position, entity.getPoint(0) + componentEntity.position, otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        tempBorderLines.add(point);
      }
      if (tempBorderLines.length == 2) {
        Vector2 absLength = Vector2(tempBorderLines[0].x - tempBorderLines[1].x,
            tempBorderLines[0].y - tempBorderLines[1].y);
        absLength = Vector2(absLength.x.abs(), absLength.y.abs()) / 2;
        entity.obstacleIntersects.add(Vector2(
            absLength.x + min(tempBorderLines[0].x, tempBorderLines[1].x),
            absLength.y + min(tempBorderLines[0].y, tempBorderLines[1].y)));
      }
    } else {
      Vector2 point = _pointOfIntersect(
          entity.getPoint(0) + componentEntity.position, entity.getPoint(1) + componentEntity.position, otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        if (entity.onComponentTypeCheck(other)) {
          entity.onCollisionStart({point}, other);
        }
        if (other.onComponentTypeCheck(entity)) {
          other.onCollisionStart({point}, entity);
        }
        return;
      }
      point = _pointOfIntersect(
          entity.getPoint(1) + componentEntity.position, entity.getPoint(2) + componentEntity.position, otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        if (entity.onComponentTypeCheck(other)) {
          entity.onCollisionStart({point}, other);
        }
        if (other.onComponentTypeCheck(entity)) {
          other.onCollisionStart({point}, entity);
        }
        return;
      }
      point = _pointOfIntersect(
          entity.getPoint(2) + componentEntity.position, entity.getPoint(3) + componentEntity.position, otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        if (entity.onComponentTypeCheck(other)) {
          entity.onCollisionStart({point}, other);
        }
        if (other.onComponentTypeCheck(entity)) {
          other.onCollisionStart({point}, entity);
        }
        return;
      }
      point = _pointOfIntersect(
          entity.getPoint(3) + componentEntity.position, entity.getPoint(0) + componentEntity.position, otherFirst, otherSecond);
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
Vector2 _pointOfIntersect(Vector2 a1, Vector2 a2, Vector2 b1, Vector2 b2)
{
  double s1_x, s1_y, s2_x, s2_y;
  s1_x = a2.x - a1.x;
  s1_y = a2.y - a1.y;
  s2_x = b2.x - b1.x;
  s2_y = b2.y - b1.y;

  double s, t;
  s = (-s1_y * (a1.x - b1.x) + s1_x * (a1.y - b1.y)) /
      (-s2_x * s1_y + s1_x * s2_y);
  t = (s2_x * (a1.y - b1.y) - s2_y * (a1.x - b1.x)) /
      (-s2_x * s1_y + s1_x * s2_y);

  if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
    return Vector2(a1.x + (t * s1_x), a1.y + (t * s1_y));
  }
  return Vector2.zero();
}