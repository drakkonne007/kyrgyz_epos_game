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
  double width = 0;
  double height = 0;
  bool onlyForPlayer = false;
  final Vector2 _minCoords = Vector2(0, 0);
  final Vector2 _maxCoords = Vector2(0, 0);
  Vector2? transformPoint;

  List<Vector2> get vertices => _vertices;
  Vector2 get rawCenter => _center;


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
    width = _maxCoords.x - _minCoords.x;
    height = _maxCoords.y - _minCoords.y;
    _center = (_maxCoords + _minCoords) / 2;
    transformPoint ??= _center;
  }

  Vector2 getMinVector()
  {
    if(isStatic){
      return _minCoords;
    }
    var par = parent as PositionComponent;
    if(par.isFlippedHorizontally){
      return Vector2(_getPointFromRawPoint(_maxCoords).x, _getPointFromRawPoint(_minCoords).y);
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
      return Vector2(_getPointFromRawPoint(_minCoords).x, _getPointFromRawPoint(_maxCoords).y);
    }else{
      return _getPointFromRawPoint(_maxCoords);
    }
  }

  doDebug({Color? color}) {
    for (int i = 0; i < vertices.length; i++) {
      if(parent == null){
        return;
      }
      Color color;
      if(i == 0){
        color = BasicPalette.red.color;
      }else{
        color = BasicPalette.green.color;
      }
      PointCust p = PointCust(
          position: getPoint(i), color: color);
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
      // return temp.isFlippedHorizontally ? Vector2(-rawPoint.x,rawPoint.y) + posAnchor : rawPoint + posAnchor;
      Vector2 point = rawPoint;
      if(temp.isFlippedHorizontally){
        // point = rawPoint - Vector2(-transformPoint!.x,transformPoint!.y);
        point = Vector2(-rawPoint.x + transformPoint!.x,rawPoint.y - transformPoint!.y);
        point.x *= scale.x;
        point.y *= scale.y;
        point += Vector2(-transformPoint!.x,transformPoint!.y);
        if(angle != 0){
          point = _rotatePoint(point,temp.isFlippedHorizontally);
        }
      }else{
        print('false');
        point = rawPoint - transformPoint!;
        point.x *= scale.x;
        point.y *= scale.y;
        point += transformPoint!;
        if(angle != 0){
          point = _rotatePoint(point,temp.isFlippedHorizontally);
        }
      }
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
  }

  Vector2 _rotatePoint(Vector2 point, bool isHorizontalFlip) {
    if(isHorizontalFlip){
      point = Vector2(-point.x + transformPoint!.x,point.y - transformPoint!.y);
    }else{
      point = point - transformPoint!;
    }
    // point -= transformPoint!;

    double radian = angle * pi / 180;
    if(isHorizontalFlip){
      radian += -radian;
    }
    double x,y;
    if(isHorizontalFlip){
      x = point.x * cos(radian) - point.y * sin(radian);
      y = point.x * sin(radian) + point.y * cos(radian);
    }else{
      x = point.x * cos(radian) - point.y * sin(radian);
      y = point.x * sin(radian) + point.y * cos(radian);
    }
    if(isHorizontalFlip){
      point = Vector2(x,y) + Vector2(-transformPoint!.x,transformPoint!.y);
    }else{
      point = Vector2(x,y) + transformPoint!;
    }
    return point;//Vector2(x,y) + transformPoint!;
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