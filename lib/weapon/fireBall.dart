import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/player_weapons_list.dart';

enum FireBallType
{
  blue, //слабее
  red //сильнее
}

class FireBall extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  final Vector2 _sprSize = Vector2.all(96);
  final double _speed = 150;
  late Ground _ground;
  final Vector2 _target;
  late DefaultPlayerWeapon _weapon;
  FireBallType _type;
  FireBall(this._type,this._target,{required super.position});

  @override
  void onRemove()
  {
    _ground.destroy();
  }

  @override onLoad() async
  {
    anchor = const Anchor(0.5,0.5);
    opacity = 0.2;
    priority = GamePriority.foregroundTile - 1;
    String name;
    if(_type == FireBallType.blue){
      name = 'tiles/map/mountainLand/Props/Animated props/power balls-1.png';
    }else{
      name = 'tiles/map/mountainLand/Props/Animated props/power balls-2.png';
    }
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load(name),
      srcSize: _sprSize,
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0);
    BodyDef bodyDef = BodyDef(position:position * PhysicVals.physicScale, type: BodyType.dynamic,userData: BodyUserData(isQuadOptimizaion: false),fixedRotation: true);
    _ground = Ground(bodyDef, gameRef.world.physicsWorld, isOnlyForStatic: true);
    _ground.createFixture(FixtureDef(CircleShape()..radius = 9 * PhysicVals.physicScale, restitution: 0.7));
    add(TimerComponent(period: 3.5,onTick: perfectRemove));
    _weapon = DefaultPlayerWeapon([Vector2.zero()], collisionType: DCollisionType.active, isStatic: false, onStartWeaponHit: perfectRemove, game: gameRef, radius: 8);
    _weapon.damage = _type == FireBallType.blue ? 4 : 8;
    if(_type == FireBallType.blue){
      _weapon.secsOfPermDamage = 2;
      _weapon.permanentDamage = 0;
      _weapon.magicDamage = MagicDamage.ice;
    }
    add(_weapon);
    _ground.linearVelocity = (_target) * _speed * PhysicVals.physicScale;
    add(OpacityEffect.to(1,EffectController(duration: 0.5)));
  }

  void perfectRemove()
  {
    add(OpacityEffect.to(0.0,EffectController(duration: 0.5), onComplete: removeFromParent));
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    position = _ground.position / PhysicVals.physicScale;
  }
}