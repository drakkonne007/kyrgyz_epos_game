
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class SwordEnemy extends SpriteAnimationComponent
{


  @override
  Future<void> onLoad() async{
    debugMode = true;
    final spriteImage = await Flame.images.load(
        'tiles/sprites/players/arrowman.png');
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: Vector2(_spriteSheetWidth, _spriteSheetHeight));
    _leftMove =
        spriteSheet.createAnimation(row: 0, stepTime: 0.3, from: 0, to: 4);
    _rightMove =
        spriteSheet.createAnimation(row: 4, stepTime: 0.3, from: 0, to: 4);
    _upMove =
        spriteSheet.createAnimation(row: 2, stepTime: 0.3, from: 0, to: 4);
    _downMove =
        spriteSheet.createAnimation(row: 6, stepTime: 0.3, from: 0, to: 4);
    _rightUpMove =
        spriteSheet.createAnimation(row: 3, stepTime: 0.3, from: 0, to: 4);
    _rightDownMove =
        spriteSheet.createAnimation(row: 5, stepTime: 0.3, from: 0, to: 4);
    _leftUpMove =
        spriteSheet.createAnimation(row: 1, stepTime: 0.3, from: 0, to: 4);
    _leftDownMove =
        spriteSheet.createAnimation(row: 7, stepTime: 0.3, from: 0, to: 4);
    _idleAnimation =
        spriteSheet.createAnimation(row: 6, stepTime: 0.3, from: 6, to: 7);
    animation = _idleAnimation;
    size = Vector2(_spriteSheetWidth, _spriteSheetHeight);
    topLeftPosition = _startPos - Vector2(0, height);
    _groundBox = RectangleHitbox(position: Vector2(width / 4, 15),
        size: Vector2(width / 2, height * 0.6));
    anchor = Anchor(_groundBox.center.x / width, _groundBox.center.y / height);
    //_groundBox.anchor = Anchor.center;
    add(_groundBox);
  }

}