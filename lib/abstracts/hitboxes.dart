import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:game_flame/abstracts/obstacle.dart';

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
  Future<void> onLoad() async{
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
  Future<void> onLoad() async{
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
  void onCollisionStart(Set<Vector2> intersectionPoints, ShapeHitbox other) {
    if(other is MapObstacle) {
      obstacleBehavoiur.call(intersectionPoints,other);
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override void onCollision(Set<Vector2> intersectionPoints, ShapeHitbox other) {
    if(other is MapObstacle) {
      obstacleBehavoiur.call(intersectionPoints,other);
    }
    super.onCollision(intersectionPoints, other);
  }
}