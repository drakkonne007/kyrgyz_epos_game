import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:game_flame/weapon/weapon.dart';
import 'package:game_flame/kyrgyz_game.dart';

enum DCollisionType
{
  active,
  passive,
  inactive
}

List<Vector2> getPointsForActivs(Vector2 pos, Vector2 size)
{
  return [pos, pos + Vector2(0,size.y), pos + size, pos + Vector2(size.x,0)];
}

class PointCust extends PositionComponent
{
  PointCust({required super.position});
  final ShapeHitbox hitbox = CircleHitbox();

  @override
  void onLoad()
  {
      priority = 800;
      size = Vector2(5, 5);
      hitbox.paint.color = BasicPalette.green.color;
      hitbox.renderShape = true;
      add(hitbox);
      // Future.delayed(Duration(seconds: 2),(){
      //   removeFromParent();
      // });
  }
}

abstract class DCollisionEntity extends Component//Всегда против часов и ВСЕГДА с верхней левой точки
{// {



  List<Vector2> _vertices;
  DCollisionType collisionType;
  bool isSolid;
  bool isStatic;
  bool isLoop;
  late Vector2 transformPoint;
  double angle = 0;
  Vector2 size = Vector2(1,1);
  Vector2 _center = Vector2(0,0);
  Set<Vector2> obstacleIntersects = {};
  LoadedColumnRow? _myCoords;
  KyrgyzGame game;
  int? column;
  int? row;


  DCollisionEntity(this._vertices ,{required this.collisionType,required this.isSolid,required this.isStatic, required this.isLoop, required this.game,this.column, this.row})
  {
    double minX = 0;
    double minY = 0;
    double maxX = 0;
    double maxY = 0;


    transformPoint = _vertices[0];

    if(isStatic) {
      int currCol = column ?? _vertices[0].x ~/ GameConsts.lengthOfTileSquare.x;
      int currRow = row ?? _vertices[0].y ~/ GameConsts.lengthOfTileSquare.y;
      _myCoords = LoadedColumnRow(currCol, currRow);
      game.gameMap.collisionProcessor.addStaticCollEntity(LoadedColumnRow(currCol, currRow), this);
    }else{
      game.gameMap.collisionProcessor.addActiveCollEntity(this);
    }
    for(int i = 0; i < _vertices.length; i++){
      if(_vertices[i].x < minX){
        minX = _vertices[i].x;
      }
      if(_vertices[i].x > maxX){
        maxX = _vertices[i].x;
      }
      if(_vertices[i].y < minY){
        minY = _vertices[i].y;
      }
      if(_vertices[i].y > maxY){
        maxY = _vertices[i].y;
      }
    }
    _center = Vector2((minX + maxX) / 2, (minY + maxY) / 2);
  }

  @override
  void onRemove()
  {
    if(!isStatic){
      game.gameMap.collisionProcessor.removeActiveCollEntity(this);
    }else{
      game.gameMap.collisionProcessor.removeStaticCollEntity(_myCoords);
    }
  }



  bool onComponentTypeCheck(DCollisionEntity other);
  void onCollisionStart(Set<Vector2> intersectionPoints, DCollisionEntity other);
  void onCollisionEnd(DCollisionEntity other);
  void onCollision(Set<Vector2> intersectionPoints, DCollisionEntity other);

  void setVertices(List<Vector2> vertices)
  {
    _vertices = vertices;
    if(!_vertices.contains(transformPoint)){
      transformPoint = _vertices[0];
    }
  }

  Vector2 getCenter()
  {
    return _center;
  }

  int getVerticesCount()
  {
    return _vertices.length;
  }

  Vector2 getPoint(int index)
  {
    return angle == 0 ? Vector2(_vertices[index].x * size.x,_vertices[index].y * size.y) : _rotatePoint(Vector2(_vertices[index].x * size.x,_vertices[index].y * size.y));
  }

  List<Vector2> getPoints()
  {
    return List.unmodifiable(_vertices);
  }

  //rotate point around center
  Vector2 _rotatePoint(Vector2 point)
  {
    Vector2 temp = point - transformPoint;
    double radian = angle * pi / 180;
    double x = temp.x * cos(radian) - temp.y * sin(radian);
    double y = temp.x * sin(radian) + temp.y * cos(radian);
    return Vector2(x,y) + transformPoint;
  }


}

class ObjectHitbox extends DCollisionEntity
{

  ObjectHitbox(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required this.obstacleBehavoiur, required this.autoTrigger, required super.isLoop, required super.game});

  late int id = game.gameMap.getNewId();
  bool autoTrigger;

  Function() obstacleBehavoiur;

  @override
  bool onComponentTypeCheck(DCollisionEntity other) {
    if(other is PlayerHitbox) {
      return true;
    }
    return false;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, DCollisionEntity other)
  {
    if(other is PlayerHitbox) {
      if(autoTrigger) {
        obstacleBehavoiur.call();
      }else{;
        game.gameMap.currentObject = this;
      }
    }    // super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(DCollisionEntity other)
  {
    if(other is PlayerHitbox && !autoTrigger) {
      if(game.gameMap.currentObject != null){
        if(game.gameMap.currentObject?.id == id){
          game.gameMap.currentObject = null;
        }
      }
    }
    // super.onCollisionEnd(other);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, DCollisionEntity other) {
    // TODO: implement onCollision
  }
}

class PlayerHitbox extends DCollisionEntity
{
  PlayerHitbox(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required super.isLoop, required super.game});


  @override
  bool onComponentTypeCheck(DCollisionEntity other) {
    if(other is EnemyWeapon) {
      return true;
    }
    return false;
  }

  @override
  Future<void> onLoad() async
  {
    collisionType = DCollisionType.passive;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, DCollisionEntity other) {
    // TODO: implement onCollision
  }

  @override
  void onCollisionEnd(DCollisionEntity other) {
    // TODO: implement onCollisionEnd
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, DCollisionEntity other) {
    // TODO: implement onCollisionStart
  }
}

class EnemyHitbox extends DCollisionEntity
{
  EnemyHitbox(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required super.isLoop, required super.game});


  @override
  bool onComponentTypeCheck(DCollisionEntity other) {
    if(other is PlayerWeapon) {
      return true;
    }
    return false;
  }

  @override
  Future<void> onLoad() async
  {
    collisionType = DCollisionType.passive;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, DCollisionEntity other) {
    // TODO: implement onCollision
  }

  @override
  void onCollisionEnd(DCollisionEntity other) {
    // TODO: implement onCollisionEnd
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, DCollisionEntity other) {
    // TODO: implement onCollisionStart
  }
}

class GroundHitBox extends DCollisionEntity
{

  Function(Set<Vector2> intersectionPoints)? obstacleBehavoiurStart;

  GroundHitBox(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required this.obstacleBehavoiurStart, required super.isLoop, required super.game});

  @override
  bool onComponentTypeCheck(DCollisionEntity other) {
    if(other is MapObstacle) {
      return true;
    }
    return false;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, DCollisionEntity other)
  {
    obstacleBehavoiurStart?.call(intersectionPoints);
  }

  @override void onCollision(Set<Vector2> intersectionPoints, DCollisionEntity other)
  {
    obstacleBehavoiurStart?.call(intersectionPoints);
  }

  @override
  void onCollisionEnd(DCollisionEntity other) {
    // TODO: implement onCollisionEnd
  }
}