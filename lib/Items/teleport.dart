
import 'package:flame/components.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/kyrgyz_game.dart';

class Teleport extends PositionComponent with HasGameRef<KyrgyzGame>
{

  Vector2 targetPos;

  Teleport({required super.size, required super.position, required this.targetPos});

  @override
  Future<void> onLoad() async
  {
    anchor = Anchor.center;
    add(ObjectHitbox(getPointsForActivs(-size/2,size), collisionType: DCollisionType.active, isSolid: true, isStatic: false, obstacleBehavoiur: telep, autoTrigger: false, isLoop: true, game: gameRef));
  }

  void telep()
  {
    gameRef.gameMap.orthoPlayer?.position = targetPos;
  }
}