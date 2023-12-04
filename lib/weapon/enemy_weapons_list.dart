
import 'package:flame/components.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/weapon/weapon.dart';
import 'package:game_flame/components/physic_vals.dart';

class EWBody extends EnemyWeapon
{
  bool _isActive = false;
  double _currentActive = 0;
  final Vector2 _startSize = Vector2(1,1);

  EWBody(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required super.onStartWeaponHit, required super.onEndWeaponHit, required super.isLoop, required super.game});

  @override
  Future onLoad() async
  {
    damage = 1;
  }

  @override
  void hit(PlayerDirectionMove direct)
  {
    onStartWeaponHit.call();
    _currentActive = 0;
    _isActive = true;
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    if(!_isActive){
      return;
    }
    _currentActive += dt;
    // size = Vector2(size.x + dt * 5, size.y);
    if(_currentActive > activeSecs){
      size = _startSize;
      _isActive = false;
      onEndWeaponHit.call();
    }
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