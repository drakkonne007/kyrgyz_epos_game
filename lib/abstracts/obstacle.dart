import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game_flame/abstracts/hitboxes.dart';

abstract class MapObstacle extends RectangleHitbox
{
  MapObstacle({
    super.position,
    super.size,
    super.angle,
    super.anchor,
    super.priority,
    bool isSolid = false,
  });

  @override
  bool onComponentTypeCheck(PositionComponent other) {
    if(other is GroundHitBox) {
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