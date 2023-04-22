import 'package:flame/collisions.dart';

abstract class MapObstacle extends RectangleHitbox
{
  @override
  Future<void> onLoad() async{
    collisionType = CollisionType.passive;
  }
}