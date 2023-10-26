import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/kyrgyz_game.dart';

class StandHighObelisk extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  StandHighObelisk(this._startPos,{super.priority});
  final Vector2 _startPos;
  final Vector2 _spriteSheetSize = Vector2(100,75);

  @override
  Future onLoad() async
  {
    position = _startPos;
    size = _spriteSheetSize;
    List<Sprite> sprites = [];
    Image img = await Flame.images.load('tiles/map/ancientLand/Props/Obelisk5-animation2-activated-100x150.png');
    for(int i=0;i<16;i++){
      sprites.add(Sprite(img,srcSize: _spriteSheetSize,srcPosition: Vector2(_spriteSheetSize.x * i,0)));
    }
    animation = SpriteAnimation.spriteList(sprites,stepTime: 0.09);
  }
}

class StandDownObelisk extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  StandDownObelisk(this._startPos,{super.priority});
  final Vector2 _startPos;
  late GroundHitBox _groundBox;
  final Vector2 _spriteSheetSize = Vector2(100,75);

  @override
  Future onLoad() async
  {
    position = _startPos;
    size = _spriteSheetSize;
    List<Sprite> sprites = [];
    Image img = await Flame.images.load('tiles/map/ancientLand/Props/Obelisk5-animation2-activated-100x150.png');
    for(int i=0;i<16;i++){
      sprites.add(Sprite(img,srcSize: _spriteSheetSize,srcPosition: Vector2(_spriteSheetSize.x * i,75)));
    }
    animation = SpriteAnimation.spriteList(sprites,stepTime: 0.09);
    _groundBox = GroundHitBox(size: Vector2(43, 67), position: Vector2(26, 0));
    add(_groundBox);
  }
}