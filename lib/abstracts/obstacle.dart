import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/players/ortho_player.dart';

abstract class MapObstacle extends DCollisionEntity
{
  MapObstacle(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required super.isLoop, required super.game,super.column, super.row, super.radius});

  @override
  bool onComponentTypeCheck(DCollisionEntity other)
  {
    if(other is GroundHitBox) {
      return true;
    }
    return false;
  }
}

abstract class MapObstacleForPlayer extends DCollisionEntity
{
  MapObstacleForPlayer(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required super.isLoop, required super.game,super.column, super.row, super.radius});

  @override
  bool onComponentTypeCheck(DCollisionEntity other)
  {
    if(other is GroundHitBox) {
      return true;
    }
    return false;
  }
}