import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';
import 'package:game_flame/abstracts/dVector2.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:game_flame/weapon/weapon.dart';
import 'package:game_flame/kyrgyz_game.dart';

enum DCollisionType
{
  active,
  passive,
  inactive
}

List<dVector2> getPointsForActivs(dVector2 pos, dVector2 size)
{
  return [pos, pos + dVector2(0,size.y), pos + size, pos + dVector2(size.x,0)];
}

class PointCust extends PositionComponent
{
  PointCust({required super.position,this.color});
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
    Future.delayed(const Duration(milliseconds: 30),(){
      removeFromParent();
    });
  }
}

abstract class DCollisionEntity extends Component
{
  List<dVector2> _vertices;
  DCollisionType collisionType;
  bool isSolid;
  bool isStatic;
  bool isLoop;
  double angle = 0;
  dVector2 scale = dVector2(1, 1);
  dVector2 _center = dVector2(0, 0);
  Set<dVector2> obstacleIntersects = {};
  KyrgyzGame game;
  int? column;
  int? row;
  double width = 0;
  double height = 0;
  bool onlyForPlayer = false;
  final dVector2 _minCoords = dVector2(0, 0);
  final dVector2 _maxCoords = dVector2(0, 0);
  dVector2? transformPoint;
  double radius = 0;
  bool isOnlyForStatic;
  bool _isTrueRect = false;

  bool get isTrueRect => _isTrueRect && angle == 0;
  List<dVector2> get vertices => _vertices;
  dVector2 get rawCenter => _center;
  bool get isCircle => radius != 0;


  DCollisionEntity(this._vertices,
      {required this.collisionType, this.isSolid = false, required this.isStatic
        ,this.isLoop = true, required this.game, this.column, this.row, this.transformPoint, this.radius = 0, this.isOnlyForStatic = false})
  {
    if (isStatic) {
      int currCol = column ?? vertices[0].x ~/ game.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x;
      int currRow = row ?? vertices[0].y ~/ game.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y;
      game.gameMap.collisionProcessor!.addStaticCollEntity(
          LoadedColumnRow(currCol, currRow), this);
    }
    calcVertices();
  }

  void changeVertices(List<dVector2> verts, {bool isLoop = false, double radius = 0, bool isSolid = false})
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
      Set<double>? check;
      if(vertices.length == 4 && !isStatic && isLoop){
        check = {};
      }
      for (int i = 0; i < vertices.length; i++) {
        check?.add(vertices[i].x);
        check?.add(vertices[i].y);
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
      if(check != null && check.length == 4){
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
    transformPoint ??= dVector2.zero();
  }

  void reInsertIntoCollisionProcessor()
  {
    game.gameMap.collisionProcessor!.addActiveCollEntity(this);
  }

  dVector2 getMinVector()
  {
    if(isStatic){
      return _minCoords;
    }
    var par = parent as PositionComponent;
    if(par.isFlippedHorizontally){
      return dVector2(_getPointFromRawPoint(_maxCoords).x, _getPointFromRawPoint(_minCoords).y);
    }else{
      return _getPointFromRawPoint(_minCoords);
    }
  }

  dVector2 getMaxVector()
  {
    if(isStatic){
      return _maxCoords;
    }
    var par = parent as PositionComponent;
    if(par.isFlippedHorizontally){
      return dVector2(_getPointFromRawPoint(_minCoords).x, _getPointFromRawPoint(_maxCoords).y);
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
          position: (getPoint(0) - dVector2(radius,0)).toVector2(), color: color);
      game.gameMap.priorityHigh.add(p);
      p = PointCust(
          position: (getPoint(0) + dVector2(radius,0)).toVector2(), color: color);
      game.gameMap.priorityHigh.add(p);
      p = PointCust(
          position: (getPoint(0) - dVector2(0,radius)).toVector2(), color: color);
      game.gameMap.priorityHigh.add(p);
      p = PointCust(
          position: (getPoint(0) + dVector2(0,radius)).toVector2(), color: color);
      game.gameMap.priorityHigh.add(p);
    }else {
      for (int i = 0; i < vertices.length; i++) {
        Color color;
        if (i == 0) {
          color = BasicPalette.red.color;
        } else {
          color = BasicPalette.green.color;
        }
        PointCust p = PointCust(
            position: getPoint(i).toVector2(), color: color);
        game.gameMap.priorityHigh.add(p);
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

  void onCollisionStart(Set<dVector2> intersectionPoints,
      DCollisionEntity other);

  void onCollisionEnd(DCollisionEntity other);

  void onCollision(Set<dVector2> intersectionPoints, DCollisionEntity other);

  dVector2 _getPointFromRawPoint(dVector2 rawPoint)
  {
    if(isStatic){
      return rawPoint;
    }else {
      var temp = parent as PositionComponent;
      dVector2 point = rawPoint - transformPoint!;
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

  dVector2 getCenter() {
    return _getPointFromRawPoint(_center);
  }

  int getVerticesCount() {
    return vertices.length;
  }

  dVector2 getPoint(int index) {
    return _getPointFromRawPoint(vertices[index]);
  }

  dVector2 _rotatePoint(dVector2 point, bool isHorizontalFlip) {
    point -= transformPoint!;
    double radian = angle * pi / 180;
    isHorizontalFlip ? radian *= -1 : null;
    double x = point.x * cos(radian) - point.y * sin(radian);
    double y = point.x * sin(radian) + point.y * cos(radian);
    return dVector2(x,y) + transformPoint!;
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
  void onCollisionStart(Set<dVector2> intersectionPoints, DCollisionEntity other)
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
  void onCollision(Set<dVector2> intersectionPoints, DCollisionEntity other) {
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
  void onCollision(Set<dVector2> intersectionPoints, DCollisionEntity other) {
    // TODO: implement onCollision
  }

  @override
  void onCollisionEnd(DCollisionEntity other) {
    // TODO: implement onCollisionEnd
  }

  @override
  void onCollisionStart(Set<dVector2> intersectionPoints, DCollisionEntity other) {
    // TODO: implement onCollisionStart
  }
}

class EnemyHitbox extends DCollisionEntity
{
  EnemyHitbox(super.vertices, {required super.collisionType, super.isSolid
    , required super.isStatic, super.isLoop, required super.game,   super.radius, super.isOnlyForStatic, });


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
  void onCollision(Set<dVector2> intersectionPoints, DCollisionEntity other) {
    // TODO: implement onCollision
  }

  @override
  void onCollisionEnd(DCollisionEntity other) {
    // TODO: implement onCollisionEnd
  }

  @override
  void onCollisionStart(Set<dVector2> intersectionPoints, DCollisionEntity other) {
    // TODO: implement onCollisionStart
  }
}

class GroundHitBox extends DCollisionEntity
{

  Function(Set<dVector2> intersectionPoints, DCollisionEntity other)? obstacleBehavoiurStart;

  GroundHitBox(super.vertices, {required super.collisionType, super.isSolid
    , required super.isStatic, required this.obstacleBehavoiurStart, super.isLoop, required super.game
    ,  super.radius, super.isOnlyForStatic, });

  @override
  bool onComponentTypeCheck(DCollisionEntity other) {
    if(other is MapObstacle) {
      return true;
    }
    return false;
  }

  @override
  void onCollisionStart(Set<dVector2> intersectionPoints, DCollisionEntity other)
  {
    obstacleBehavoiurStart?.call(intersectionPoints,other);
  }

  @override void onCollision(Set<dVector2> intersectionPoints, DCollisionEntity other)
  {
    obstacleBehavoiurStart?.call(intersectionPoints,other);
  }

  @override
  void onCollisionEnd(DCollisionEntity other) {
    // TODO: implement onCollisionEnd
  }
}