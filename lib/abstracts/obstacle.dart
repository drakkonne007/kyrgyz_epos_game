import 'package:game_flame/abstracts/hitboxes.dart';

abstract class MapObstacle extends DCollisionEntity
{
  MapObstacle(super._vertices, {required super.collisionType, super.isSolid, required super.isStatic, super.isLoop, required super.game,super.column, super.row, super.radius, super.isOnlyForStatic, });

  @override
  bool onComponentTypeCheck(DCollisionEntity other)
  {
    if(other is GroundHitBox) {
      return true;
    }
    return false;
  }
}