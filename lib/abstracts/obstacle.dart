import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/players/ortho_player.dart';

abstract class MapObstacle extends DCollisionEntity
{
  bool _isFirst = true;

  MapObstacle(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required super.isLoop});

  @override
  bool onComponentTypeCheck(DCollisionEntity other)
  {
    if(other is GroundHitBox) {
      return true;
    }
    return false;
  }

  @override
  void updateTree(double dt)
  {
    if(_isFirst) {
      _isFirst = false;
      super.updateTree(dt);
    }
  }
}

class MapWarp extends DCollisionEntity
{
  String to;

  MapWarp(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required this.to, required super.isLoop});

  @override
  bool onComponentTypeCheck(DCollisionEntity other) {
    if(other is GroundHitBox && other.parent is OrthoPlayer) {
      return true;
    }
    return false;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, DCollisionEntity other) {
    if(other is GroundHitBox && other.parent is OrthoPlayer){
      // other.position = Vector2.all(-150);
      gameRef.loadNewMap(to);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, DCollisionEntity other) {
    // TODO: implement onCollision
  }

  @override
  void onCollisionEnd(DCollisionEntity other) {
    // TODO: implement onCollisionEnd
  }
}