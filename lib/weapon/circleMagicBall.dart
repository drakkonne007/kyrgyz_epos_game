import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'dart:math' as math;
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/player_weapons_list.dart';

class CircleMagicBall extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  CircleMagicBall({ required this.source, required this.damage, required this.secs,
    required this.magicDamage,required this.angle});
  final Vector2 _sprSize = Vector2.all(96);
  final double _speed = 4;
  late DefaultPlayerWeapon _weapon;
  final String source;
  final double damage;
  final double secs;
  final MagicDamage magicDamage;
  double angle;
  final double _radius = 50;

  @override onLoad() async
  {
    anchor = const Anchor(0.5,0.5);
    opacity = 0.2;
    priority = GamePriority.maxPriority;
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load(source),
      srcSize: _sprSize,
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0);
    add(TimerComponent(period: 5.5,onTick: perfectRemove));
    _weapon = DefaultPlayerWeapon([Vector2.zero()], collisionType: DCollisionType.active, isStatic: false, game: gameRef, radius: 9);
    _weapon.permanentDamage = damage;
    _weapon.coolDown = 1;
    _weapon.secsOfPermDamage = secs;
    _weapon.magicDamage = magicDamage;
    add(_weapon);
    add(OpacityEffect.to(1,EffectController(duration: 0.5)));
    position = gameRef.gameMap.orthoPlayer!.position + Vector2(math.cos(angle), math.sin(angle)) * _radius;
  }

  void perfectRemove()
  {
    add(OpacityEffect.to(0.0,EffectController(duration: 0.5), onComplete: removeFromParent));
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    angle += _speed * dt;
    position = gameRef.gameMap.orthoPlayer!.position + Vector2(math.cos(angle), math.sin(angle)) * _radius;
  }
}
