

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game_flame/abstracts/obstacle.dart';

class Ground extends PositionComponent implements MapObstacle
{
  Ground(Vector2 size, Vector2 pos){
    this.size = size;
    position = pos;
  }
  @override
  Future<void> onLoad() async{
    // debugMode = true;
    var hitBox = RectangleHitbox();
    hitBox.collisionType = CollisionType.passive;
    add(hitBox);
  }
}