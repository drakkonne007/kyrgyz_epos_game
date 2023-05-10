import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/players/ortho_player.dart';

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

class MapWarp extends RectangleHitbox with HasGameRef<KyrgyzGame>
{
  MapWarp({
    super.position,
    super.size,
    super.angle,
    super.anchor,
    super.priority,
    bool isSolid = false,
    required this.to
  }){
    collisionType = CollisionType.passive;
  }
  String to;

  @override
  bool onComponentTypeCheck(PositionComponent other) {
    if(other is GroundHitBox && other.parent is OrthoPlayer) {
      return super.onComponentTypeCheck(other);
    }
    return false;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, ShapeHitbox other) {
    if(other is GroundHitBox && other.parent is OrthoPlayer){
      other.position = Vector2.all(-150);
      gameRef.loadNewMap(to);
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}