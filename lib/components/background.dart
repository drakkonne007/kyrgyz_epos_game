import 'package:flame/components.dart';

class Back extends SpriteComponent{

  @override
  Future<void> onLoad() async
  {
    position = Vector2(0,0);
    sprite = await Sprite.load('16qwe24.jpg');
    size = sprite!.originalSize;
  }
}