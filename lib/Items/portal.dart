import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/game_worlds.dart';
import 'package:game_flame/kyrgyz_game.dart';


class Portal extends SpriteAnimationComponent with HasGameRef<KyrgyzGame> {

  Vector2 targetPos;
  String toWorld;

  Portal({required super.position, required this.targetPos, required this.toWorld});

  @override
  Future<void> onLoad() async
  {
    anchor = Anchor.center;
    size = Vector2(40,30);
    add(ObjectHitbox(getPointsForActivs(-size / 2, size),
        collisionType: DCollisionType.active,
        isSolid: true,
        isStatic: false,
        obstacleBehavoiur: portal,
        autoTrigger: false,
        isLoop: true,
        game: gameRef));
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

  void portal() async
  {
    gameRef.playerData.playerBigMap = getWorldFromName(toWorld);
    gameRef.playerData.startLocation = targetPos;
    await gameRef.loadNewMap();
  }


  // @override
  // void render(Canvas canvas) async
  // {
  //   var shader = gameRef.telepShader;
  //   shader.setFloat(0,gameRef.gameMap.shaderTime);
  //   shader.setFloat(1, 1); //scalse
  //   shader.setFloat(2, 0); //offsetX
  //   shader.setFloat(3, 0);
  //   shader.setFloat(4,math.max(size.x,30)); //size
  //   shader.setFloat(5,math.max(size.y,30));
  //   final paint = Paint()..shader = shader;
  //   canvas.drawRect(
  //     Rect.fromLTWH(
  //       0,
  //       0,
  //       math.max(size.x,30),
  //       math.max(size.y,30),
  //     ),
  //     paint,
  //   );
  // }
}