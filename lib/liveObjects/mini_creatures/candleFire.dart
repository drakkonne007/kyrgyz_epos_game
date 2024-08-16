import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/components/physic_vals.dart';

class CandleFire extends SpriteAnimationComponent
{
  CandleFire(this._startPos);
  final Vector2 _startPos;

  @override
  void onLoad() async
  {
    anchor = Anchor.center;
    priority = GamePriority.maxPriority;
    position = _startPos;
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load(
          'tiles/map/mountainLand/Props/Animated props/Fire-no pot.png'),
      srcSize: Vector2(32, 64),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0);
    size = size * 1.2;
  }
}
