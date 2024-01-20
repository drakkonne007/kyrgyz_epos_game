// Obelisk4-animation2-activated-110x180

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class BigFlyingObelisk extends SpriteAnimationComponent
{

  BigFlyingObelisk(this._startPos, {super.priority});
  Vector2 _startPos;

  @override onLoad() async
  {
    anchor = const Anchor(0.5,0.5);
    position = _startPos;
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load('tiles/map/ancientLand/Props/Obelisk4-animation2-activated-110x180.png'),
      srcSize: Vector2(110,180),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0);
  }
}