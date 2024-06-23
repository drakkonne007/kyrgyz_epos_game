import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/kyrgyz_game.dart';

class GroundFire extends SpriteAnimationComponent with HasGameRef<KyrgyzGame> {
  GroundFire(this._startPos);

  final Vector2 _startPos;

  @override
  void onLoad() async
  {
    anchor = const Anchor(0.5, 0.5);
    position = _startPos;
    priority = position.y.toInt();
    String name = 'campfire1 - fire.png';
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load(
          'tiles/map/grassLand2/Props/Animated props/$name'),
      srcSize: Vector2(1280 / 8, 160),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0);
  }
}