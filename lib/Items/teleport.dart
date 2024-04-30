
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

  @override
  Future<void> onLoad() async
  {
    add(ObjectHitbox(getPointsForActivs(-size/2,size), collisionType: DCollisionType.active, isSolid: true, isStatic: false, obstacleBehavoiur: telep, autoTrigger: false, isLoop: true, game: gameRef));
  }

  void telep()
  {
    double dist = gameRef.gameMap.orthoPlayer?.position.distanceTo(targetPos) ?? 0;
    final effect = OpacityEffect.to(
      0.2,
      EffectController(duration: (dist / math.min(dist / 0.6, 800)) / 2),onComplete: ()
        {
          gameRef.gameMap.orthoPlayer?.position = targetPos;
          gameRef.gameMap.orthoPlayer?.add(OpacityEffect.to(1, EffectController(duration: (dist/math.min(dist / 0.6, 800)) / 2),onComplete: (){
            gameRef.playerData.isLockMove = false;
            gameRef.camera.follow(gameRef.gameMap.orthoPlayer!,
                maxSpeed: math.min(dist / 0.6, 800));
          }));
        }
    );
    gameRef.playerData.isLockMove = true;
    gameRef.camera.moveTo(targetPos);
    gameRef.gameMap.orthoPlayer?.add(effect);
  }

  @override
  void render(Canvas canvas) async
  {
    var shader = gameRef.telepShader;
    shader.setFloat(0,gameRef.gameMap.shaderTime);
    shader.setFloat(1, 1); //scalse
    shader.setFloat(2, 0); //offsetX
    shader.setFloat(3, 0);
    shader.setFloat(4,math.max(size.x,30)); //size
    shader.setFloat(5,math.max(size.y,30));
    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        math.max(size.x,30),
        math.max(size.y,30),
      ),
      paint,
    );
  }
}