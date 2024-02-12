import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/game_worlds.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';


class Portal extends PositionComponent with HasGameRef<KyrgyzGame> {

  Vector2 targetPos;
  String toWorld;
  double _iTime = 0;

  Portal({required super.size, required super.position, required this.targetPos, required this.toWorld});

  @override
  Future<void> onLoad() async
  {
    add(ObjectHitbox(getPointsForActivs(-size / 2, size),
        collisionType: DCollisionType.active,
        isSolid: true,
        isStatic: false,
        obstacleBehavoiur: portal,
        autoTrigger: false,
        isLoop: true,
        game: gameRef));
  }

  void portal() async
  {
    gameRef.playerData.playerBigMap = getWorldFromName(toWorld);
    gameRef.playerData.startLocation = targetPos;
    await gameRef.loadNewMap();
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