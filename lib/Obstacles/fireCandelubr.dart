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
  Vector2(-2.77853,12.2594) * PhysicVals.physicScale
  ,Vector2(-3.11755,23.1078) * PhysicVals.physicScale
  ,Vector2(-6.84668,26.1589) * PhysicVals.physicScale
  ,Vector2(-6.84668,30.8203) * PhysicVals.physicScale
  ,Vector2(5.01874,30.9898) * PhysicVals.physicScale
  ,Vector2(5.10349,26.0741) * PhysicVals.physicScale
  ,Vector2(1.1201,22.8535) * PhysicVals.physicScale
  ,Vector2(0.865844,12.1746) * PhysicVals.physicScale
  ,];

class FireCandelubr extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  FireCandelubr(this._startPos);
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
    priority = position.y.toInt() + 31;
    final img = await Flame.images.load('tiles/map/mountainLand/Props/Animated props/Fire-candelabrum.png');
    final sheet = SpriteSheet(image: img,
        srcSize: Vector2(img.width / 8,img.height * 1.0));
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

