import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:game_flame/weapon/weapon.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'dart:math' as math;

class WSword extends PlayerWeapon
{
  WSword({
    super.position,
    super.size,
    super.angle,
    super.anchor,
    super.priority,
    bool isSolid = false,
    required super.onStartWeaponHit,
    required super.onEndWeaponHit,
  });

  @override
  void onMount()
  {
    super.onMount();
    size = Vector2(20,50);
  }

  late double _startAngle;
  late double _activeSecs;
  late int _hitVariant;
  double _diffAngle = 0;

  @override
  Future<void> onLoad() async
  {
    damage = 1;
    anchor = Anchor.bottomCenter;
    energyCost = 1;
  }

  @override
  Future<void> hit(PlayerDirectionMove direct, double long, int hitAnimation) async
  {
    if(gameRef.playerData.energy.value < energyCost) {
      return;
    }
    if(collisionType == CollisionType.inactive) {
      onStartWeaponHit.call();
      gameRef.playerData.energy.value -= energyCost;
      _activeSecs = long;
      _hitVariant = hitAnimation;
      gameRef.playerData.isLockEnergy = true;
      _startAngle = tau / 3;
      _diffAngle = 0;
      angle = _startAngle;
      debugMode = true;
      collisionType = CollisionType.active;
      // print('start hit');
      await Future.delayed(Duration(milliseconds: (_activeSecs * 1000).toInt()),(){
        collisionType = CollisionType.inactive;
        debugMode = false;
        gameRef.playerData.isLockEnergy = false;
        onEndWeaponHit.call();
        // print('end hit');
      });
    }
  }

  @override
  void update(double dt)
  {
    if(collisionType == CollisionType.active){
      _diffAngle -= dt/_activeSecs * sectorInRadian;
      angle = _startAngle + _diffAngle;
    }
    super.update(dt);
  }
}