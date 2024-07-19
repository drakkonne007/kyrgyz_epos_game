import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

//[
// Vector2(-3.60963,-3.13516)
// ,Vector2(-20.9279,-2.89792)
// ,];

class GroundFire extends SpriteAnimationComponent with HasGameRef<KyrgyzGame> {
  GroundFire(this._startPos);

  late Ground _ground;
  final Vector2 _startPos;

  @override
  void onRemove()
  {
    _ground.destroy();
  }

  @override
  void onLoad() async
  {
    anchor = const Anchor(0.5, 0.5);
    position = _startPos;
    priority = position.y.toInt() + 3;
    String name = 'campfire1 - fire.png';
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load(
          'tiles/map/grassLand2/Props/Animated props/$name'),
      srcSize: Vector2(1280 / 8, 160),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0);
    var sh = CircleShape();
    sh.radius = 17 * PhysicVals.physicScale;
    FixtureDef fix = FixtureDef(sh);
    _ground = Ground(
        BodyDef(type: BodyType.static, position: (position + Vector2(-3.60963,-3.13516)) * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );
    _ground.createFixture(fix);
  }
}