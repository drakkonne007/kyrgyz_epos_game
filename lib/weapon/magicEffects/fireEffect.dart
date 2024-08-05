

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/components/physic_vals.dart';

class FireEffect extends SpriteAnimationComponent
{
  FireEffect({required super.position});

  @override onLoad() async
  {
    opacity = 0.8;
    // SpriteSheet temp = SpriteSheet(image: await Flame.images.load('tiles/map/grassLand2/Props/Animated props/campfire1 - fire.png'), srcSize: Vector2(160,160));
    SpriteSheet temp = SpriteSheet(image: await Flame.images.load('tiles/map/mountainLand/Props/Animated props/Fire-no pot.png'), srcSize: Vector2(32,64));
    priority = GamePriority.maxPriority;
    animation = temp.createAnimation(row: 0, stepTime: 1 / temp.columns,from: 0, loop: false);
    animationTicker?.onComplete = removeFromParent;
    anchor = Anchor.center;
  }
}