import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/weapon.dart';
import 'package:game_flame/kyrgyz_game.dart';

class ObjectHitbox extends RectangleHitbox with HasGameRef<KyrgyzGame>
{
  ObjectHitbox({
    super.position,
    super.size,
    super.angle,
    super.anchor,
    super.priority,
    bool isSolid = false,
    this.autoTrigger = false,
    required this.obstacleBehavoiur,
  });

  @override
  Future<void> onLoad() async
  {
    id = gameRef.gameMap.getNewId();
  }

  late int id;
  bool autoTrigger;
  Function() obstacleBehavoiur;

  @override
  bool onComponentTypeCheck(PositionComponent other) {
    if(other is PlayerHitbox) {
      return super.onComponentTypeCheck(other);
    }
    return false;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, ShapeHitbox other)
  {
    if(other is PlayerHitbox) {
      if(autoTrigger) {
        obstacleBehavoiur.call();
      }else{;
      gameRef.gameMap.currentObject = this;
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(ShapeHitbox other)
  {
    if(other is PlayerHitbox && !autoTrigger) {
      if(gameRef.gameMap.currentObject != null){
        if(gameRef.gameMap.currentObject?.id == id){
          gameRef.gameMap.currentObject = null;
          print('currentObject = null');
        }
      }
    }
    super.onCollisionEnd(other);
  }
}

class PlayerHitbox extends RectangleHitbox
{
  PlayerHitbox({
    super.position,
    super.size,
    super.angle,
    super.anchor,
    super.priority,
    bool isSolid = false,
  });

  @override
  bool onComponentTypeCheck(PositionComponent other) {
    if(other is EnemyWeapon) {
      return super.onComponentTypeCheck(other);
    }
    return false;
  }

  @override
  Future<void> onLoad() async
  {
    collisionType = CollisionType.passive;
  }
}

class EnemyHitbox extends RectangleHitbox
{
  EnemyHitbox({
    super.position,
    super.size,
    super.angle,
    super.anchor,
    super.priority,
    bool isSolid = false,
  });

  @override
  bool onComponentTypeCheck(PositionComponent other) {
    if(other is PlayerWeapon) {
      return super.onComponentTypeCheck(other);
    }
    return false;
  }

  @override
  Future<void> onLoad() async
  {
    collisionType = CollisionType.passive;
  }
}

class GroundHitBox extends RectangleHitbox
{
  GroundHitBox({
    super.position,
    super.size,
    super.angle,
    super.anchor,
    super.priority,
    bool isSolid = false,
    this.obstacleBehavoiurStart,
    this.obstacleBehavoiurContinue,
  });
  Function(Set<Vector2> intersectionPoints, ShapeHitbox other)? obstacleBehavoiurStart;
  Function(Set<Vector2> intersectionPoints, ShapeHitbox other)? obstacleBehavoiurContinue;

  @override
  bool onComponentTypeCheck(PositionComponent other) {
    if(other is MapObstacle) {
      return super.onComponentTypeCheck(other);
    }
    return false;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, ShapeHitbox other)
  {
    if(other is MapObstacle) {
      obstacleBehavoiurStart?.call(intersectionPoints,other);
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override void onCollision(Set<Vector2> intersectionPoints, ShapeHitbox other)
  {
    if(other is MapObstacle) {
      obstacleBehavoiurContinue?.call(intersectionPoints,other);
    }
    super.onCollision(intersectionPoints, other);
  }
}