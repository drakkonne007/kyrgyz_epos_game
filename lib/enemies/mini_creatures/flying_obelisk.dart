import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/player.dart';
import 'package:game_flame/kyrgyz_game.dart';

double distToPlayer = 150;

class FlyingHighObelisk extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  FlyingHighObelisk(this._startPosSource);
  Vector2 _startPosSource;
  late Vector2 _startPos;
  final Vector2 _spriteSheetSize = Vector2(70,70);

  @override
  Future onLoad() async
  {
    _startPos = Vector2(_startPosSource.x, _startPosSource.y - 69);
    position = _startPos;
    size = _spriteSheetSize;
    List<Sprite> sprites = [];
    Image img = await Flame.images.load('tiles/map/ancientLand/Props/Obelisk1-animation1-activating-70x150.png');
    for(int i=0;i<16;i++){
      sprites.add(Sprite(img,srcSize: _spriteSheetSize,srcPosition: Vector2(_spriteSheetSize.x * i,0)));
    }
    animation = SpriteAnimation.spriteList(sprites,stepTime: 0.1);
  }
}

class FlyingDownObelisk extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  FlyingDownObelisk(this._startPos, this._highObelisk);
  final Vector2 _startPos;
  late Ground _groundBox;
  final Vector2 _spriteSheetSize = Vector2(70,80);
  late SpriteAnimationComponent _player;
  final Vector2 _speed = Vector2(0,0);
  FlyingHighObelisk _highObelisk;

  @override
  Future onLoad() async
  {
    position = _startPos;
    size = _spriteSheetSize;
    List<Sprite> sprites = [];
    Image img = await Flame.images.load('tiles/map/ancientLand/Props/Obelisk1-animation1-activating-70x150.png');
    for(int i=0;i<16;i++){
      sprites.add(Sprite(img,srcSize: _spriteSheetSize,srcPosition: Vector2(_spriteSheetSize.x * i,70)));
    }
    animation = SpriteAnimation.spriteList(sprites,stepTime: 0.1);
    Vector2 tSize = Vector2(28, 52);
    Vector2 tPos = Vector2(22, 0);
    _groundBox = Ground([tPos,tPos + Vector2(0,tSize.y), tPos + tSize, tPos + Vector2(tSize.x,0)],collisionType: DCollisionType.passive,isStatic: false, isSolid: false, isLoop: true, gameKyrgyz: gameRef);
    add(_groundBox);
    _player = gameRef.gameMap.orthoPlayer?? gameRef.gameMap.frontPlayer!;
  }

  @override
  void update(double dt)
  {
    if(_player.distance(this) < distToPlayer && position.y > _startPos.y - 20){
      _speed.y = -30;
    }else if(_player.distance(this) > distToPlayer && position.y < _startPos.y){
      _speed.y = 30;
    }else{
      _speed.y = 0;
    }
    position += _speed * dt;
    _highObelisk.position += _speed * dt;
    super.update(dt);
  }
}