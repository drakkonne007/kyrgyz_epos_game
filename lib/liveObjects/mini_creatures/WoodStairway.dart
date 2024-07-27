import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';


class WoodStairway extends SpriteComponent with HasGameRef<KyrgyzGame>
{
  WoodStairway(this._startPos);
  final Vector2 _startPos;

  @override
  void onLoad() async
  {
    anchor = const Anchor(0.5, 0.5);
    position = _startPos;
    sprite = Sprite(await Flame.images.load('tiles/map/grassLand2/Props/Animated props/woodStairway.png'));
    priority = position.y.toInt() + height ~/ 2;
  }
}
