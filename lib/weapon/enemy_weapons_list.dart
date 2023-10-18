
import 'package:flame/components.dart';
import 'package:game_flame/weapon/weapon.dart';
import 'package:game_flame/components/physic_vals.dart';

class EWBody extends EnemyWeapon
{
  EWBody({
    super.position,
    super.size,
    super.angle,
    super.anchor,
    super.priority,
    bool isSolid = false,
    required super.onStartWeaponHit,
    required super.onEndWeaponHit,
  })
  {
    damage = 1;
  }

  bool _isActive = false;
  double _currentActive = 0;
  final Vector2 _startSize = Vector2(69,71);

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
    size = Vector2(size.x + dt * 5, size.y);
    if(_currentActive > activeSecs){
      size = _startSize;
      _isActive = false;
      onEndWeaponHit.call();
    }
  }
}