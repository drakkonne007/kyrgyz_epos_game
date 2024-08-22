import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/weapon/weapon.dart';
import 'dart:math' as math;

class DefaultPlayerWeapon extends PlayerWeapon
{
  DefaultPlayerWeapon(super._vertices, {required super.collisionType,super.isSolid,required super.isStatic,
     super.onStartWeaponHit, super.onEndWeaponHit,super.isLoop,required super.game,super.radius, super.isOnlyForStatic, });

  @override
  void hit() {
    onStartWeaponHit?.call();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, DCollisionEntity other) {}

  @override
  void onCollisionEnd(DCollisionEntity other){}

}