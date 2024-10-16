import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/kyrgyz_game.dart';

class CampfireSmoke extends SpriteAnimationComponent with HasGameRef<KyrgyzGame> {
  CampfireSmoke(this._startPos);

  Vector2 _startPos;

  @override
  void onLoad() async
  {
    anchor = const Anchor(0.5, 0.5);
    position = _startPos;
    String name = 'campfire smoke.png';
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load(
          'tiles/map/grassLand2/Props/Animated props/$name'),
      srcSize: Vector2(64, 64),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0);
  }
}