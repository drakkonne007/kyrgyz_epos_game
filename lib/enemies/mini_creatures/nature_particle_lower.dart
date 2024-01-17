import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class NatureParticalLower extends SpriteAnimationComponent
{
  NatureParticalLower(this._startPos, {super.priority});
  Vector2 _startPos;

  @override onLoad() async
  {
    anchor = const Anchor(0.5,0.5);
    position = _startPos;
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load('tiles/map/ancientLand/Props/atmospheric nature particles.png'),
      srcSize: Vector2(64,64),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.2,from: 0);
  }
}