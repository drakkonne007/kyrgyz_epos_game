import 'package:flame/collisions.dart';

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
  Future<void> onLoad() async{
    collisionType = CollisionType.passive;
  }
}