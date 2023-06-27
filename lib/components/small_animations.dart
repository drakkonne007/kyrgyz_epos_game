import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class Water extends SpriteAnimationComponent
{
  Water(this.positionsAnim);
  List<Vector2> positionsAnim;
  @override
  Future<void> onLoad() async
  {
    final spriteImage = await Flame.images.load('tiles/map/ancientLand/Tilesets/Tileset-Animated Terrains-8 frames.png');
    final spriteSheet = SpriteSheet(image: spriteImage, srcSize: Vector2(32,32));
    animation = spriteSheet.createAnimation(row: 1, stepTime: 0.1, from: 0,to: 8);
    size = Vector2(33, 33);
    position = Vector2.all(0);
  }
}