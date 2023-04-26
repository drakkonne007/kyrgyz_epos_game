import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:game_flame/abstracts/obstacle.dart';
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
  }){
    id = gameRef.gameMap!.getNewId();
  }

  late int id;
  bool autoTrigger;
  Function() obstacleBehavoiur;

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, ShapeHitbox other)
  {
    if(other is PlayerHitbox) {
      if(autoTrigger) {
        obstacleBehavoiur.call();
      }else{
        gameRef.gameMap?.currentObject = this;
      }
    }else{
      print(other);
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(ShapeHitbox other)
  {
    if(other is PlayerHitbox) {
      if(gameRef.gameMap?.currentObject != null && gameRef.gameMap?.currentObject?.id == id){
        gameRef.gameMap?.currentObject = null;
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
    required this.obstacleBehavoiur
  });
  Function(Set<Vector2> intersectionPoints, ShapeHitbox other) obstacleBehavoiur;
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, ShapeHitbox other)
  {
    if(other is MapObstacle) {
      obstacleBehavoiur.call(intersectionPoints,other);
    }else{
      print(other);
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override void onCollision(Set<Vector2> intersectionPoints, ShapeHitbox other)
  {
    if(other is MapObstacle) {
      obstacleBehavoiur.call(intersectionPoints,other);
    }else{
      print(other);
    }
    super.onCollision(intersectionPoints, other);
  }
}