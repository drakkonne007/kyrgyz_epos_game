import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/components/physic_vals.dart';

class NaturePartical extends SpriteAnimationComponent
{

  NaturePartical(this._startPos);
  final Vector2 _startPos;

  @override onLoad() async
  {
    priority = GamePriority.maxPriority;
    anchor = const Anchor(0.5,0.5);
    position = _startPos;
    String name = 'generic nature particles96x96.png';
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load('tiles/map/grassLand2/Props/Animated props/$name'),
      srcSize: Vector2(96,96),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.2,from: 0);
  }
}