import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

final List<Vector2> _lamp1 = [
  Vector2(-8.95048,17.9914) * PhysicVals.physicScale
  ,Vector2(-12.5661,36.0695) * PhysicVals.physicScale
  ,Vector2(-0.815357,40.4383) * PhysicVals.physicScale
  ,Vector2(13.1951,36.0695) * PhysicVals.physicScale
  ,Vector2(7.01847,17.3888) * PhysicVals.physicScale
  ,];

class LightConus extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  LightConus(this._startPos,this._version);
  String _version;
  late Ground _ground;
  final Vector2 _startPos;


  @override
  void onRemove()
  {
    _ground.destroy();
  }

  @override
  Future onLoad() async
  {
    anchor = Anchor.center;
    position = _startPos;
    priority = position.y.toInt() + 40;
    switch(_version){
      case 'lightConus': _version = 'shrine2-available.png'; break;
      case 'lightConusNoGrass': _version = 'shrine2-available-no grass.png'; break;
      case 'lightConusSteel': _version = 'shrine-available.png'; break;
      case 'lightConusSteelNoGrass': _version = 'shrine-available-no grass.png'; break;
      default: _version = 'shrine2-available.png';
    }
    final img = await Flame.images.load('tiles/map/grassLand/Props/$_version');
    final sheet = SpriteSheet(image: img,
        srcSize: Vector2(64,96));
    animation = sheet.createAnimation(row: 0, stepTime: 0.1, from: 0, loop: true);
    final List<Vector2> curVec;
    FixtureDef fix = FixtureDef(PolygonShape()..set(_lamp1));
    _ground = Ground(
        BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );
    _ground.createFixture(fix);
  }
}

