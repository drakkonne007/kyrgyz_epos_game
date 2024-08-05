import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'dart:math' as math;
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/player_weapons_list.dart';

class ElectroBall extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  final Vector2 _sprSize = Vector2.all(96);
  final double _speed = 4;
  late DefaultPlayerWeapon _weapon;
  ElectroBall(this._angle,);
  double _angle = 0;
  final double _radius = 50;

  @override
  void onRemove()
  {
    // _ground.destroy();
  }

  @override onLoad() async
  {
    anchor = const Anchor(0.5,0.5);
    opacity = 0.2;
    priority = GamePriority.maxPriority;
    String name = 'tiles/map/mountainLand/Props/Animated props/power balls-3.png';
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load(name),
      srcSize: _sprSize,
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0);
    add(TimerComponent(period: 5.5,onTick: perfectRemove));
    _weapon = DefaultPlayerWeapon([Vector2.zero()], collisionType: DCollisionType.active, isStatic: false, onStartWeaponHit: createLightning, game: gameRef, radius: 9);
    _weapon.damage = 1;
    _weapon.coolDown = 1.5;
    add(_weapon);
    // _ground.linearVelocity = (_target) * _speed * PhysicVals.physicScale;
    add(OpacityEffect.to(1,EffectController(duration: 0.5)));
    position = gameRef.gameMap.orthoPlayer!.position + Vector2(math.cos(_angle), math.sin(_angle)) * _radius;
  }

  void createLightning()
  {
      gameRef.gameMap.container.add(Lightning(position: position));
  }

  void perfectRemove()
  {
    add(OpacityEffect.to(0.0,EffectController(duration: 0.5), onComplete: removeFromParent));
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    _angle += _speed * dt;
    position = gameRef.gameMap.orthoPlayer!.position + Vector2(math.cos(_angle), math.sin(_angle)) * _radius;
  }
}

class Lightning extends SpriteAnimationComponent
{

  Lightning({required super.position});

  @override onLoad() async
  {
    SpriteSheet temp = SpriteSheet(image: await Flame.images.load('tiles/map/mountainLand/Props/Animated props/lightning-1Tile-fading out.png'), srcSize: Vector2(96,46));
    priority = GamePriority.maxPriority;
    animation = temp.createAnimation(row: 0, stepTime: 0.08,from: 0, loop: false);
    animationTicker?.onComplete = removeFromParent;
    anchor = Anchor.center;
  }
}