
import 'package:flame/components.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/weapon/weapon.dart';
import 'dart:math' as math;

class EWBody extends EnemyWeapon
{
  bool _isActive = false;
  bool _isGrow = true;
  final double _maxLength = 3;

  EWBody(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required super.onStartWeaponHit, required super.onEndWeaponHit, required super.isLoop, required super.game});

  @override
  Future onLoad() async
  {
    damage = 1;
    transformPoint = vertices[0];
  }

  @override
  Future<void> hit() async
  {
    currentCoolDown = coolDown;
    onStartWeaponHit.call();
    _isActive = true;
    latencyBefore = -activeSecs/3;
    scale = Vector2(1,1);
    await Future.delayed(Duration(milliseconds: (activeSecs * 1000).toInt()),(){
      _isGrow = true;
      onEndWeaponHit.call();
      _isActive = false;
      scale = Vector2(1,1);
    });
  }

  @override
  void update(double dt)
  {
    if(latencyBefore < 0){
      latencyBefore += dt;
    }
    if(latencyBefore >= 0 && _isActive){
      if(_isGrow && scale.x > _maxLength/3){
        _isGrow = false;
      }
      _isGrow ? scale = Vector2(math.max(1,(scale.x + dt/activeSecs * _maxLength)), scale.y) : scale = Vector2(math.max(1, scale.x - dt/activeSecs * _maxLength), scale.y);
    }else{
      scale = Vector2(1,1);
    }
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, DCollisionEntity other) {
    // TODO: implement onCollision
  }

  @override
  void onCollisionEnd(DCollisionEntity other) {
    // TODO: implement onCollisionEnd
  }
}