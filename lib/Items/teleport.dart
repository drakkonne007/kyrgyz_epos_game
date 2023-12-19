
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/physic_vals.dart';
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
    double dist = gameRef.gameMap.orthoPlayer?.position.distanceTo(targetPos) ?? 0;
    final effect = OpacityEffect.to(
      0.2,
      EffectController(duration: 0.35),onComplete: ()
        {
          gameRef.gameMap.orthoPlayer?.position = targetPos;
          gameRef.gameMap.orthoPlayer?.add(OpacityEffect.to(1, EffectController(duration: 0.35),onComplete: (){
            gameRef.playerData.isLockMove = false;
            gameRef.camera.resetMovement();
            gameRef.camera.followComponent(gameRef.gameMap.orthoPlayer!, worldBounds: Rect.fromLTRB(0,0,GameConsts.lengthOfTileSquare.x*GameConsts.maxColumn,GameConsts.lengthOfTileSquare.y*GameConsts.maxRow));
          }));
        }
    );
    gameRef.playerData.isLockMove = true;
    gameRef.camera.speed = dist / 0.6;
    gameRef.camera.moveTo(targetPos);
    gameRef.gameMap.orthoPlayer?.add(effect);
  }
}