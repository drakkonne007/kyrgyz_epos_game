import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

enum ColorState
{
  blue,
  yellow
}

class BigFlicker extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  BigFlicker(this._startPos,this._state);
  final ColorState _state;
  final Vector2 _startPos;

  @override
  void onLoad() async
  {
    anchor = const Anchor(0.5, 0.5);
    priority = GamePriority.maxPriority;
    position = _startPos;
    String name = _state == ColorState.yellow ? 'magic flame-white-bigger.png' : 'magic flame-flickering light- bigger.png';
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load(
          'tiles/map/prisonSet/Props/$name'),
      srcSize: Vector2(160, 160),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.15, from: 0);
    size = size * 1.5;
  }
}
