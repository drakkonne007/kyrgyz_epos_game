import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/kyrgyz_game.dart';

class FlyingHighObelisk extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  FlyingHighObelisk(this._startPos, this._column, this._row,{super.priority});
  final Vector2 _startPos;
  final Vector2 _spriteSheetSize = Vector2(70,70);
  int _column;
  int _row;
  bool _isHigh = false;

  @override
  Future onLoad() async
  {
    position = _startPos;
    size = _spriteSheetSize;
    List<Sprite> sprites = [];
    Image img = await Flame.images.load('tiles/map/ancientLand/Props/Obelisk1-animation1-activating-70x150.png');
    for(int i=0;i<16;i++){
      sprites.add(Sprite(img,srcSize: _spriteSheetSize,srcPosition: Vector2(_spriteSheetSize.x * i,0)));
    }
    animation = SpriteAnimation.spriteList(sprites,stepTime: 0.1);
  }

  @override
  void update(double dt)
  {
    int diffCol = (_column - gameRef.gameMap.column()).abs();
    int diffRow = (_row - gameRef.gameMap.row()).abs();
    if((diffCol > 0 || diffRow > 0) && _isHigh){
      _isHigh = false;
      position += Vector2(0,50);
    }
    if(diffCol == 0 && diffRow == 0 && !_isHigh){
      _isHigh = true;
      position += Vector2(0,-50);
    }
    super.update(dt);
  }
}

class FlyingDownObelisk extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  FlyingDownObelisk(this._startPos, this._column, this._row,{super.priority});
  final Vector2 _startPos;
  late Ground _groundBox;
  final Vector2 _spriteSheetSize = Vector2(70,80);
  int _column;
  int _row;
  bool _isHigh = false;

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
    _groundBox = Ground([tPos,tPos + Vector2(0,tSize.y), tPos + tSize, tPos + Vector2(tSize.x,0)],collisionType: DCollisionType.passive,isStatic: false, isSolid: false, isLoop: true, game: gameRef);
    add(_groundBox);
  }

  @override
  void update(double dt)
  {
    int diffCol = (_column - gameRef.gameMap.column()).abs();
    int diffRow = (_row - gameRef.gameMap.row()).abs();
    if((diffCol > 0 || diffRow > 0) && _isHigh){
      _isHigh = false;
      position += Vector2(0,50);
    }
    if(diffCol == 0 && diffRow == 0 && !_isHigh){
      _isHigh = true;
      position += Vector2(0,-50);
    }
    super.update(dt);
  }
}