import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';
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
  PointCust({required super.position,this.color});
  final ShapeHitbox hitbox = CircleHitbox();
  Color? color;

  @override
  void onLoad()
  {
    priority = 800;
    size = Vector2(5, 5);
    hitbox.paint.color = color ?? BasicPalette.green.color;
    hitbox.renderShape = true;
    add(hitbox);

    Future.delayed(const Duration(milliseconds: 30),(){
      removeFromParent();
    });
  }
}

abstract class DCollisionEntity extends Component
    {
  List<Vector2> _vertices;
  DCollisionType collisionType;
  bool isSolid;
  bool isStatic;
  bool isLoop;
  double angle = 0;
  Vector2 scale = Vector2(1, 1);
  Vector2 _center = Vector2(0, 0);
  Set<Vector2> obstacleIntersects = {};
  LoadedColumnRow? _myCoords;
  KyrgyzGame game;
  int? column;
  int? row;
  bool onlyForPlayer = false;
  double width = 0;
  double height = 0;
  final Vector2 _minCoords = Vector2(0, 0);
  final Vector2 _maxCoords = Vector2(0, 0);
  Vector2? transformPoint;

  List<Vector2> get vertices => _vertices;


  DCollisionEntity(this._vertices,
      {required this.collisionType, required this.isSolid, required this.isStatic
        , required this.isLoop, required this.game, this.column, this.row, this.transformPoint})
  {
    if (isStatic) {
      int currCol = column ?? vertices[0].x ~/ GameConsts.lengthOfTileSquare.x;
      int currRow = row ?? vertices[0].y ~/ GameConsts.lengthOfTileSquare.y;
      _myCoords = LoadedColumnRow(currCol, currRow);
      game.gameMap.collisionProcessor.addStaticCollEntity(
          LoadedColumnRow(currCol, currRow), this);
    } else {
      game.gameMap.collisionProcessor.addActiveCollEntity(this);
    }
    for (int i = 0; i < vertices.length; i++) {
      if (vertices[i].x < _minCoords.x) {
        _minCoords.x = vertices[i].x;
      }
      if (vertices[i].x > _maxCoords.x) {
        _maxCoords.x = vertices[i].x;
      }
      if (vertices[i].y < _minCoords.y) {
        _minCoords.y = vertices[i].y;
      }
      if (vertices[i].y > _maxCoords.y) {
        _maxCoords.y = vertices[i].y;
      }
    }
    _center = (_maxCoords + _minCoords) / 2;
    transformPoint??= _center;
  }

  Vector2 getMinVector()
  {
    if(isStatic){
      return _minCoords;
    }
    var par = parent as PositionComponent;
    if(par.isFlippedHorizontally){
      return _getPointFromRawPoint(_maxCoords);
    }else{
      return _getPointFromRawPoint(_minCoords);
    }
  }

  Vector2 getMaxVector()
  {
    if(isStatic){
      return _maxCoords;
    }
    var par = parent as PositionComponent;
    if(par.isFlippedHorizontally){
      return _getPointFromRawPoint(_minCoords);
    }else{
      return _getPointFromRawPoint(_maxCoords);
    }
  }

  doDebug() {
    for (int i = 0; i < vertices.length; i++) {
      if(parent == null){
        return;
      }
      PointCust p = PointCust(
          position: getPoint(i));
      game.gameMap.add(p);
    }
  }

  @override
  void onRemove() {
    if (!isStatic) {
      game.gameMap.collisionProcessor.removeActiveCollEntity(this);
    } else {
      game.gameMap.collisionProcessor.removeStaticCollEntity(_myCoords);
    }
  }

  bool onComponentTypeCheck(DCollisionEntity other);

  void onCollisionStart(Set<Vector2> intersectionPoints,
      DCollisionEntity other);

  void onCollisionEnd(DCollisionEntity other);

  void onCollision(Set<Vector2> intersectionPoints, DCollisionEntity other);

  Vector2 _getPointFromRawPoint(Vector2 rawPoint)
  {
    if(isStatic){
      return rawPoint;
    }else {
      var temp = parent as PositionComponent;
      Vector2 posAnchor = temp.positionOfAnchor(temp.anchor);
      Vector2 point = rawPoint - transformPoint!;
      if(temp.isFlippedHorizontally){
        point.x *= -1;
      }
      point.x *= scale.x;
      point.y *= scale.y;
      if(angle != 0){
        point = _rotatePoint(point,temp.isFlippedHorizontally);
      }
      point += transformPoint!;
      return point + posAnchor;
    }
  }

  Vector2 getCenter() {
    return _getPointFromRawPoint(_center);
  }

  int getVerticesCount() {
    return vertices.length;
  }

  Vector2 getPoint(int index) {
    return _getPointFromRawPoint(vertices[index]);
    // if(!isStatic){
    //   Vector2 temp;
    //   Vector2 posAnchor = Vector2.zero();
    //   if(parent != null){
    //     var temp = parent as PositionComponent;
    //     posAnchor = temp.positionOfAnchor(temp.anchor);
    //   }
    //   if (isHorizontalFlip) {
    //     if (index == 0) {
    //       angle == 0 ? temp = Vector2(
    //           _vertices[index].x * scale.x, _vertices[index].y * scale.y)
    //           : temp = _rotatePoint(
    //           Vector2(
    //               _vertices[index].x * scale.x, _vertices[index].y * scale.y));
    //       return temp + posAnchor;
    //     }
    //     if (index == 1) {
    //       angle == 0 ? temp = Vector2(
    //           _vertices[index].x * scale.x, _vertices[index].y * scale.y)
    //           : temp = _rotatePoint(
    //           Vector2(
    //               _vertices[index].x * scale.x, _vertices[index].y * scale.y));
    //       return temp + posAnchor;
    //     }
    //     if (index == 2) {
    //       angle == 0
    //           ? temp = Vector2(
    //           _vertices[index].x , _vertices[index].y * scale.y)
    //           : temp = _rotatePoint(
    //           Vector2(
    //               _vertices[index].x, _vertices[index].y * scale.y));
    //       return temp + posAnchor;
    //     }
    //     if (index == 3) {
    //       angle == 0
    //           ? temp = Vector2(
    //           _vertices[index].x, _vertices[index].y * scale.y)
    //           : temp = _rotatePoint(
    //           Vector2(
    //               _vertices[index].x, _vertices[index].y * scale.y));
    //       return temp + posAnchor;
    //     }
    //   } else {
    //     if (index == 0) {
    //       angle == 0
    //           ? temp = Vector2(
    //           _vertices[index].x, _vertices[index].y * scale.y)
    //           : temp = _rotatePoint(
    //           Vector2(
    //               _vertices[index].x, _vertices[index].y * scale.y));
    //       return temp + posAnchor;
    //     }
    //     if (index == 1) {
    //       angle == 0
    //           ? temp = Vector2(
    //           _vertices[index].x, _vertices[index].y * scale.y)
    //           : temp = _rotatePoint(
    //           Vector2(
    //               _vertices[index].x , _vertices[index].y * scale.y));
    //       return temp + posAnchor;
    //     }
    //     if (index == 2) {
    //       angle == 0
    //           ? temp = Vector2(
    //           _vertices[index].x * scale.x, _vertices[index].y * scale.y)
    //           : temp = _rotatePoint(
    //           Vector2(
    //               _vertices[index].x * scale.x, _vertices[index].y * scale.y));
    //       return temp + posAnchor;
    //     }
    //     if (index == 3) {
    //       angle == 0
    //           ? temp = Vector2(
    //           _vertices[index].x * scale.x, _vertices[index].y * scale.y)
    //           : temp = _rotatePoint(
    //           Vector2(
    //               _vertices[index].x * scale.x, _vertices[index].y * scale.y));
    //       return temp + posAnchor;
    //     }
    //   }
    // }
    // return _vertices[index];
  }

  Vector2 _rotatePoint(Vector2 point, bool isHorizontalFlip) {
    double radian = angle * pi / 180;
    isHorizontalFlip ? radian *= -1 : radian;
    point.x = point.x * cos(radian) - point.y * sin(radian);
    point.y = point.x * sin(radian) + point.y * cos(radian);
    return point;
  }

  @override
  void update(double dt) {
    // doDebug();
    super.update(dt);
  }

}

class ObjectHitbox extends DCollisionEntity
{

  ObjectHitbox(super.vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required this.obstacleBehavoiur, required this.autoTrigger, required super.isLoop, required super.game});

  late int id = game.gameMap.getNewId();
  bool autoTrigger;
  double _pastTime = 0.5;

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
      }else{
        _pastTime = 0;
        game.gameMap.currentObject.value = this;
      }
    }    // super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(DCollisionEntity other)
  {
    if(other is PlayerHitbox && !autoTrigger) {
      if(game.gameMap.currentObject.value != null){
        if(game.gameMap.currentObject.value?.id == id){
          game.gameMap.currentObject.value = null;
        }
      }
    }
    // super.onCollisionEnd(other);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, DCollisionEntity other) {
    // TODO: implement onCollision
  }

  @override
  void update(double dt) {
    if(_pastTime < 0.6) {
      _pastTime += dt;
    }
    if(_pastTime > 0.5 && game.gameMap.currentObject.value == this){
      game.gameMap.currentObject.value = null;
    }
    super.update(dt);
  }
}

class PlayerHitbox extends DCollisionEntity
{
  PlayerHitbox(super.vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required super.isLoop, required super.game});


  @override
  bool onComponentTypeCheck(DCollisionEntity other) {
    if(other is EnemyWeapon) {
      return true;
    }
    return false;
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
  EnemyHitbox(super.vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required super.isLoop, required super.game});


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

  Function(Set<Vector2> intersectionPoints, DCollisionEntity other)? obstacleBehavoiurStart;

  GroundHitBox(super.vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required this.obstacleBehavoiurStart, required super.isLoop, required super.game});

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
    obstacleBehavoiurStart?.call(intersectionPoints,other);
  }

  @override void onCollision(Set<Vector2> intersectionPoints, DCollisionEntity other)
  {
    obstacleBehavoiurStart?.call(intersectionPoints,other);
  }

  @override
  void onCollisionEnd(DCollisionEntity other) {
    // TODO: implement onCollisionEnd
  }
}