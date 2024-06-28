import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/components/physic_vals.dart';

class AuraLightning extends SpriteAnimationComponent
{
  AuraLightning(this.pos);

  Vector2 pos;

  @override
  Future<void> onLoad() async
  {
    position = pos;
    priority = GamePriority.high;
    anchor = Anchor.center;
    final spriteImage = await Flame.images.load('tiles/map/ancientLand/Props/altar-lightning fx.png');
    final spriteSheet = SpriteSheet(image: spriteImage, srcSize: Vector2(spriteImage.width / 20,spriteImage.height.toDouble()));
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0);
  }
}