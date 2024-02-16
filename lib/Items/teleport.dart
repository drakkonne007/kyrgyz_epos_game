
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'dart:math' as math;

class Teleport extends PositionComponent with HasGameRef<KyrgyzGame>
{

  Vector2 targetPos;
  KyrgyzGame kyrGame;
  Teleport({required super.size, required super.position, required this.targetPos, required this.kyrGame});
  double _iTime = 0;

  @override
  Future<void> onLoad() async
  {
    add(ObjectHitbox(getPointsForActivs(-size/2,size), collisionType: DCollisionType.active, isSolid: true, isStatic: false, obstacleBehavoiur: telep, autoTrigger: false, isLoop: true, game: gameRef));
  }

  void telep()
  {
    double dist = gameRef.gameMap.orthoPlayer?.position.distanceTo(targetPos) ?? 0;
    gameRef.camera.speed = math.min(dist / 0.6, 800);
    final effect = OpacityEffect.to(
      0.2,
      EffectController(duration: (dist/gameRef.camera.speed) / 2),onComplete: ()
        {
          gameRef.gameMap.orthoPlayer?.position = targetPos;
          gameRef.gameMap.orthoPlayer?.add(OpacityEffect.to(1, EffectController(duration: (dist/gameRef.camera.speed) / 2),onComplete: (){
            gameRef.playerData.isLockMove = false;
            gameRef.camera.resetMovement();
            gameRef.camera.followComponent(gameRef.gameMap.orthoPlayer!, worldBounds: Rect.fromLTRB(0,0,
                game.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x*game.playerData.playerBigMap.gameConsts.maxColumn!,
                game.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y*game.playerData.playerBigMap.gameConsts.maxRow!));
          }));
        }
    );
    gameRef.playerData.isLockMove = true;
    gameRef.camera.moveTo(targetPos);
    gameRef.gameMap.orthoPlayer?.add(effect);
  }

  @override
  void update(double dt)
  {
    _iTime += dt;
  }

  @override
  void render(Canvas canvas) async
  {
    var shader = gameRef.telepShaderProgramm.fragmentShader();
    shader.setFloat(0,_iTime);
    shader.setFloat(1,max(size.x,30));
    shader.setFloat(2,max(size.y,30));
    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        max(size.x,30),
        max(size.y,30),
      ),
      paint,
    );
  }
}