// Obelisk4-animation2-activated-110x180

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

final List<Vector2> _groundPoints = [
  Vector2(-22.0281,6.35966) * PhysicVals.physicScale
  ,Vector2(-22.7949,38.3092) * PhysicVals.physicScale
  ,Vector2(0.20872,66.9359) * PhysicVals.physicScale
  ,Vector2(21.4232,36.7756) * PhysicVals.physicScale
  ,Vector2(19.1228,6.10407) * PhysicVals.physicScale
  ,];

class BigFlyingObelisk extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{

  late Ground _ground;
  BigFlyingObelisk(this._startPos, {super.priority});
  final Vector2 _startPos;

  @override
  void onRemove()
  {
    gameRef.world.destroyBody(_ground);
  }

  @override onLoad() async
  {
    anchor = const Anchor(0.5,0.5);
    position = _startPos;
    priority = position.y.toInt() + 55;
    FixtureDef fix = FixtureDef(PolygonShape()..set(_groundPoints));
    _ground = Ground(
        BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );
    _ground.createFixture(fix);
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load('tiles/map/ancientLand/Props/Obelisk4-animation2-activated-110x180.png'),
      srcSize: Vector2(110,180),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0);
  }
}