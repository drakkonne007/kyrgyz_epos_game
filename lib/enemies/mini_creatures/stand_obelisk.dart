import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/kyrgyz_game.dart';

class StandHighObelisk extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  StandHighObelisk(this._startPos);
  final Vector2 _startPos;
  final Vector2 _spriteSheetSize = Vector2(100,75);

  @override
  Future onLoad() async
  {
    anchor = const Anchor(0.5,0.8);
    position = _startPos - Vector2(0,74);
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
  StandDownObelisk(this._startPos);
  final Vector2 _startPos;
  late Ground _groundBox;
  final Vector2 _spriteSheetSize = Vector2(100,75);

  @override
  Future onLoad() async
  {
    anchor = const Anchor(0.5,0.8);
    position = _startPos;
    size = _spriteSheetSize;
    List<Sprite> sprites = [];
    Image img = await Flame.images.load('tiles/map/ancientLand/Props/Obelisk5-animation2-activated-100x150.png');
    for(int i=0;i<16;i++){
      sprites.add(Sprite(img,srcSize: _spriteSheetSize,srcPosition: Vector2(_spriteSheetSize.x * i,75)));
    }
    animation = SpriteAnimation.spriteList(sprites,stepTime: 0.09);
    Vector2 tSize = Vector2(43, 67);
    Vector2 tPos = Vector2(-24, -60);
    BodyDef bf = BodyDef(userData: BodyUserData(isQuadOptimizaion: false), position: _startPos);
    FixtureDef ft = FixtureDef(PolygonShape()..set([tPos,tPos + Vector2(0,tSize.y), tPos + tSize, tPos + Vector2(tSize.x,0)]));
    _groundBox = Ground(bf,gameRef.world.physicsWorld);
    _groundBox.createFixture(ft);
  }

  @override
  void onRemove() {
    gameRef.world.destroyBody(_groundBox);
  }
}