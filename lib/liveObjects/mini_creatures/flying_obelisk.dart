import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

double distToPlayer = 150;

final List<Vector2> _groundPoints = [
  Vector2(-11.4087,10.6735) * PhysicVals.physicScale
  ,Vector2(-12.7391,33.8214) *PhysicVals.physicScale
  ,Vector2(0.91903,46.9473) * PhysicVals.physicScale
  ,Vector2(14.7715,33.7444) * PhysicVals.physicScale
  ,Vector2(13.7789,10.4962) * PhysicVals.physicScale
];

class FlyingObelisk extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  FlyingObelisk(this._startPos);
  final Vector2 _startPos;
  final Vector2 _spriteSheetSize = Vector2(70,150);
  late Ground ground;

  @override
  Future onLoad() async
  {
    anchor = Anchor.center;
    position = _startPos;
    size = _spriteSheetSize;
    List<Sprite> sprites = [];
    Image img = await Flame.images.load('tiles/map/ancientLand/Props/Obelisk1-animation1-activating-70x150.png');
    for(int i=0;i<16;i++){
      sprites.add(Sprite(img,srcSize: _spriteSheetSize,srcPosition: Vector2(_spriteSheetSize.x * i,0)));
    }
    animation = SpriteAnimation.spriteList(sprites,stepTime: 0.1);
    FixtureDef fix = FixtureDef(PolygonShape()..set(_groundPoints));
    ground = Ground(
      BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
          userData: BodyUserData(isQuadOptimizaion: false)),
      gameRef.world.physicsWorld,
    );
    ground.createFixture(fix);
    gameRef.gameMap.checkPriority.addListener(checkP);
  }

  @override
  void onRemove() {
    ground.destroy();
    gameRef.gameMap.checkPriority.removeListener(checkP);
  }

  void checkP()
  {
    int pos = position.y.toInt();
    if(pos <= 0){
      pos = 1;
    }
    priority = pos;
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    position = ground.position / PhysicVals.physicScale;
  }
}
