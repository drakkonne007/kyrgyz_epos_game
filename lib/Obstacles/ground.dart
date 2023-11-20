import 'package:flame/src/components/position_component.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:vector_math/vector_math_64.dart';

class Ground extends MapObstacle
{
  Ground(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required super.isLoop, required super.game, super.column, super.row});


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