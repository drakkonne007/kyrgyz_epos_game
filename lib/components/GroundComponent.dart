

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Ground extends PositionComponent
{
  Ground(Vector2 size, Vector2 pos){
    this.size = size;
    position = pos;
  }

  @override
  Future<void> onLoad() async{
    var hitBox = RectangleHitbox(isSolid: true);
    hitBox.collisionType = CollisionType.passive;
    add(hitBox);
  }
}