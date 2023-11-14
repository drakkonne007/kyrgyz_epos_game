import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
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

abstract class DCollisionEntity extends Component with HasGameRef<KyrgyzGame> //Всегда против часов и ВСЕГДА с верхней левой точки
{
  DCollisionEntity(this._vertices ,{required this.collisionType,required this.isSolid,required this.isStatic, required this.isLoop})
  {
    double minX = 0;
    double minY = 0;
    double maxX = 0;
    double maxY = 0;
    transformPoint = _vertices[0];
    int column = _vertices[0].x ~/ GameConsts.lengthOfTileSquare.x;
    int row    = _vertices[0].y ~/ GameConsts.lengthOfTileSquare.y;
    _myCoords = LoadedColumnRow(column, row);
     if(isStatic) {
        gameRef.gameMap.collisionProcessor.addStaticCollEntity(LoadedColumnRow(column, row), this);
     }else{
        gameRef.gameMap.collisionProcessor.addActiveCollEntity(this);
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
        gameRef.gameMap.collisionProcessor.removeActiveCollEntity(this);
      }else{
        gameRef.gameMap.collisionProcessor.removeStaticCollEntity(_myCoords!);
      }
  }

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

  ObjectHitbox(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required this.obstacleBehavoiur, required this.autoTrigger, required super.isLoop});

  late int id = gameRef.gameMap.getNewId();
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
        gameRef.gameMap.currentObject = this;
      }
    }    // super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(DCollisionEntity other)
  {
    if(other is PlayerHitbox && !autoTrigger) {
      if(gameRef.gameMap.currentObject != null){
        if(gameRef.gameMap.currentObject?.id == id){
          gameRef.gameMap.currentObject = null;
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
  PlayerHitbox(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required super.isLoop});


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
  EnemyHitbox(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required super.isLoop});


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

  GroundHitBox(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required this.obstacleBehavoiurStart, required super.isLoop});

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