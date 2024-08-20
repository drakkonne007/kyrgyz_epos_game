
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'dart:math' as math;

class Teleport extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{

  Vector2 targetPos;
  KyrgyzGame kyrGame;
  Teleport({required super.position, required this.targetPos, required this.kyrGame});

  @override
  Future<void> onLoad() async
  {
    anchor = Anchor.center;
    size = Vector2(40,30);
    add(ObjectHitbox(getPointsForActivs(-size/2,size), collisionType: DCollisionType.active, isSolid: true, isStatic: false, obstacleBehavoiur: telep, autoTrigger: false, isLoop: true, game: gameRef));
    final img = await Flame.images.load('images/portalAnim.png');
    final spriteSheet = SpriteSheet(image: img, srcSize: Vector2(img.width / 6, img.height / 5));
    List<Sprite> sprs = [];
    List<double> times = [];
    for(int row = 0; row < 5; row++){
      for(int column = 0; column < 6; column++){
        sprs.add(spriteSheet.getSprite(row, column));
        times.add(0.08);
      }
    }
    animation = SpriteAnimation.variableSpriteList(sprs, stepTimes: times);
  }

  void telep()
  {
    double dist = gameRef.gameMap.orthoPlayer?.position.distanceTo(targetPos) ?? 0;
    final effect = OpacityEffect.to(
        0.05,
        EffectController(duration: 0.5),onComplete: (){
      gameRef.camera.moveTo(targetPos,speed: math.min(dist / 0.6, 850));
      gameRef.gameMap.orthoPlayer?.add(TimerComponent(period: (dist/math.min(dist / 0.6, 850)),removeOnFinish: true,onTick: (){
        gameRef.gameMap.orthoPlayer?.setGroundBody(targetPos: targetPos);
        gameRef.gameMap.orthoPlayer?.add(OpacityEffect.to(1, EffectController(duration: 0.5),onComplete: (){
          gameRef.playerData.isLockMove = false;
          gameRef.camera.follow(gameRef.gameMap.orthoPlayer!,snap: true);
        }));
      }));
    }
    );
    gameRef.playerData.isLockMove = true;
    gameRef.gameMap.orthoPlayer?.add(effect);
  }
}