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
            _calcTwoStaticEntities(entity, other, component);
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
        entity.onCollisionStart(entity.obstacleIntersects, entity);
      }
    }
  }
}

//Активные entity ВСЕГДА ПРЯМОУГОЛЬНИКИ залупленные
void _calcTwoStaticEntities(DCollisionEntity entity, DCollisionEntity other, PositionComponent component, {bool isOtherActive = false}) {
  Set<int> insidePoints = {};
  bool isMapObstacle = other is MapObstacle &&
      entity.onComponentTypeCheck(other);
  Vector2 parentOtherVector = Vector2.zero();
  if(isOtherActive) {
    var temp = other.parent as PositionComponent;
    parentOtherVector = temp.position;
  }
  for (int i = 0; i < other.getVerticesCount(); i++) {
    Vector2 otherFirst = other.getPoint(i) + parentOtherVector;
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
    Vector2 otherFirst = other.getPoint(tF);
    Vector2 otherSecond = other.getPoint(tS);
    if (isMapObstacle) {
      List<Vector2> tempBorderLines = [];
      Vector2 point = _pointOfIntersect(
          entity.getPoint(0) + component.position, entity.getPoint(1)  + component.position, otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        tempBorderLines.add(point);
      }
      point = _pointOfIntersect(
          entity.getPoint(1) + component.position, entity.getPoint(2) + component.position, otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        tempBorderLines.add(point);
      }
      point = _pointOfIntersect(
          entity.getPoint(2) + component.position, entity.getPoint(3) + component.position, otherFirst, otherSecond);
      if (point != Vector2.zero()) {
        tempBorderLines.add(point);
      }
      point = _pointOfIntersect(
          entity.getPoint(3) + component.position, entity.getPoint(0) + component.position, otherFirst, otherSecond);
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
          entity.getPoint(0) + component.position, entity.getPoint(1) + component.position, otherFirst, otherSecond);
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
          entity.getPoint(1) + component.position, entity.getPoint(2) + component.position, otherFirst, otherSecond);
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
          entity.getPoint(2) + component.position, entity.getPoint(3) + component.position, otherFirst, otherSecond);
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
          entity.getPoint(3) + component.position, entity.getPoint(0) + component.position, otherFirst, otherSecond);
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

void _calcTwoActiveEntities(DCollisionEntity entity, DCollisionEntity other)
{
  PositionComponent comp1 = entity.parent as PositionComponent;
  PositionComponent comp2 = other.parent as PositionComponent;
  for(int i=-1;i<entity.getVerticesCount() - 1;i++) {
    if(!entity.isLoop && i == -1){
      continue;
    }
    Vector2 first,second;
    if(i == -1){
      first = entity.getPoint(entity.getVerticesCount() - 1) + comp1.position;
      second = entity.getPoint(0) + comp1.position;
    }else{
      first = entity.getPoint(i) + comp1.position;
      second = entity.getPoint(i+1) + comp1.position;
    }
    for(int j=-1;j<other.getVerticesCount() - 1;j++) {
      Vector2 otherFirst,otherSecond;
      if(!other.isLoop && j == -1){
        continue;
      }
      if(j == -1){
        otherFirst = other.getPoint(other.getVerticesCount() - 1) + comp2.position;
        otherSecond = other.getPoint(0) + comp2.position;
      }else{
        otherFirst = other.getPoint(j) + comp2.position;
        otherSecond = other.getPoint(j+1) + comp2.position;
      }
      Vector2 point = pointOfIntersect(first, second, otherFirst, otherSecond);
      if(point != Vector2.zero()) {
        if(other is MapObstacle){
          potentialActiveEntity[key]![i].onComponentTypeCheck(potentialActiveEntity[key]![j]) ? potentialActiveEntity[key]![i].obstacleIntersects.add(point)
              : potentialActiveEntity[key]![j].obstacleIntersects.add(point);
        }else {
          intersectionPoints.add(point);
        }
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