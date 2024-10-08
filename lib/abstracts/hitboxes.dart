import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';
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

List<Vector2> getPointsForActivs(Vector2 pos, Vector2 size, {double? scale})
{
  scale ??= 1;
  return [pos * scale, (pos + Vector2(0,size.y)) * scale, (pos + size) * scale, (pos + Vector2(size.x,0)) * scale];
}

class PointCust extends PositionComponent
{
  PointCust({required super.position,this.color,super.priority = 99999});
  Color? color;

  @override
  void onLoad()
  {
    size = Vector2(5, 5);
    anchor = Anchor.center;
    CircleHitbox hitbox = CircleHitbox(radius: 2);
    hitbox.paint.color = color ?? BasicPalette.green.color;
    hitbox.renderShape = true;
    add(hitbox);
    Future.delayed(const Duration(milliseconds: 1000),(){
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
  KyrgyzGame game;
  int? column;
  int? row;
  double width = 0;
  double height = 0;
  bool onlyForPlayer = false;
  final Vector2 _minCoords = Vector2(0, 0);
  final Vector2 _maxCoords = Vector2(0, 0);
  Vector2? transformPoint;
  double radius = 0;
  bool isOnlyForStatic;
  bool _isTrueRect = false;

  bool get isTrueRect => _isTrueRect && angle == 0;
  List<Vector2> get vertices => _vertices;
  Vector2 get rawCenter => _center;
  bool get isCircle => radius != 0;


  DCollisionEntity(this._vertices,
      {required this.collisionType, this.isSolid = false, required this.isStatic
        ,this.isLoop = true, required this.game, this.column, this.row, this.transformPoint, this.radius = 0, this.isOnlyForStatic = false})
  {
    if (isStatic) {
      int currCol = column ?? vertices[0].x ~/ GameConsts.lengthOfTileSquare.x;
      int currRow = row ?? vertices[0].y ~/ GameConsts.lengthOfTileSquare.y;
      game.gameMap.collisionProcessor!.addStaticCollEntity(
          LoadedColumnRow(currCol, currRow), this);
    }
    calcVertices();
  }

  void changeVertices(List<Vector2> verts, {bool isLoop = false, double radius = 0, bool isSolid = false})
  {
    if(isStatic){
      throw Exception("Cannot change vertices of static entity");
    }
    this.isSolid = isSolid;
    _vertices = verts;
    this.isLoop = isLoop;
    this.radius = radius;
    calcVertices();
  }

  void calcVertices()
  {
    _minCoords.x = 99999;
    _minCoords.y = 99999;
    _maxCoords.x = -99999;
    _maxCoords.y = -99999;
    if(radius == 0) {
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
      if(vertices.length == 4 && isSolid){
        _isTrueRect = true;
      }
      width = _maxCoords.x - _minCoords.x;
      height = _maxCoords.y - _minCoords.y;
      _center = (_maxCoords + _minCoords) / 2;
    }else{
      width = radius*2;
      height = radius*2;
      _center = _vertices[0];
      _minCoords.y = _vertices[0].y - radius;
      _maxCoords.y = _vertices[0].y + radius;
      _minCoords.x = _vertices[0].x - radius;
      _maxCoords.x = _vertices[0].x + radius;
    }
    transformPoint ??= Vector2.zero();
  }

  void reInsertIntoCollisionProcessor()
  {
    game.gameMap.collisionProcessor!.addActiveCollEntity(this);
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

  doDebug({Color? color})
  {
    if(isStatic) {
      if ((game.gameMap.column() - column!).abs() > 1 || (game.gameMap.row() - row!).abs() > 1) {
        return;
      }
    }
    if(radius != 0) {
      PointCust p = PointCust(
          position: getPoint(0) - Vector2(radius,0), color: color);
      game.gameMap.container.add(p);
      p = PointCust(
          position: getPoint(0) + Vector2(radius,0), color: color);
      game.gameMap.container.add(p);
      p = PointCust(
          position: getPoint(0) - Vector2(0,radius), color: color);
      game.gameMap.container.add(p);
      p = PointCust(
          position: getPoint(0) + Vector2(0,radius), color: color);
      game.gameMap.container.add(p);
    }else {
      for (int i = 0; i < vertices.length; i++) {
        Color color;
        if (i == 0) {
          color = BasicPalette.red.color;
        } else {
          color = BasicPalette.green.color;
        }
        PointCust p = PointCust(
            position: getPoint(i), color: color);
        game.gameMap.container.add(p);
      }
    }
  }

  @override
  void onMount()
  {
    if (!isStatic) {
      game.gameMap.collisionProcessor!.addActiveCollEntity(this);
    }
  }

  @override
  void onRemove()
  {
    if (!isStatic) {
      game.gameMap.collisionProcessor!.removeActiveCollEntity(this);
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
      Vector2 point = rawPoint - transformPoint!;
      if(temp.isFlippedHorizontally){
        point.x *= -1;
      }
      point.x *= scale.x;
      point.y *= scale.y;
      point += transformPoint!;
      if(angle != 0){
        point = _rotatePoint(point,temp.isFlippedHorizontally);
      }
      if(temp.isFlippedHorizontally){
        point.x += -transformPoint!.x;
        point.x -= (temp.width/2 - temp.anchor.x*temp.width);
      }
      return point + temp.position;
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
    point -= transformPoint!;
    double radian = angle * pi / 180;
    isHorizontalFlip ? radian *= -1 : null;
    double x = point.x * cos(radian) - point.y * sin(radian);
    double y = point.x * sin(radian) + point.y * cos(radian);
    return Vector2(x,y) + transformPoint!;
  }
}

class ObjectHitbox extends DCollisionEntity
{

  ObjectHitbox(super.vertices, {required super.collisionType, super.isSolid, required super.isStatic
    , required this.obstacleBehavoiur, required this.autoTrigger, super.isLoop, required super.game, super.radius, super.isOnlyForStatic});

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
    if(_pastTime < 0.2){
      _pastTime += dt;
    }
    if(_pastTime >= 0.1 && game.gameMap.currentObject.value == this){
      game.gameMap.currentObject.value = null;
    }
    super.update(dt);
  }

  @override
  void onRemove() {
    if(game.gameMap.currentObject.value == this) {
      game.gameMap.currentObject.value = null;
    }
  }
}

class PlayerHitbox extends DCollisionEntity
{
  PlayerHitbox(super.vertices, {required super.collisionType, super.isSolid
    , required super.isStatic, super.isLoop, required super.game, super.radius, super.isOnlyForStatic, });


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
  EnemyHitbox(super.vertices, {required super.collisionType, super.isSolid
    , required super.isStatic, super.isLoop, required super.game,   super.radius, super.isOnlyForStatic, this.onStartColl});

  Function(DCollisionEntity other)? onStartColl;

  @override
  void onCollision(Set<Vector2> intersectionPoints, DCollisionEntity other) {
    // TODO: implement onCollision
  }

  @override
  bool onComponentTypeCheck(DCollisionEntity other) {
    if(other is PlayerWeapon) {
      return true;
    }
    return false;
  }

  @override
  void onCollisionEnd(DCollisionEntity other) {
    // TODO: implement onCollisionEnd
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, DCollisionEntity other) {
    onStartColl?.call(other);
  }
}