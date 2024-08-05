

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/components/physic_vals.dart';

class LightningEffect extends SpriteAnimationComponent
{
  LightningEffect({required super.position});

  @override onLoad() async
  {
    opacity = 0.8;
    SpriteSheet temp = SpriteSheet(image: await Flame.images.load('tiles/map/mountainLand/Props/Animated props/lightning-1Tile-fading out.png'), srcSize: Vector2(96,46));
    priority = GamePriority.maxPriority;
    animation = temp.createAnimation(row: 0, stepTime: 1 / temp.columns,from: 0, loop: false);
    animationTicker?.onComplete = removeFromParent;
    anchor = Anchor.center;
  }
}