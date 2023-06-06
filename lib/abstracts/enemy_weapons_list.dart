
import 'package:game_flame/abstracts/weapon.dart';
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
  })
  {
    damage = 1;
  }

  @override
  void hit(PlayerDirectionMove direct)
  {
    // TODO: implement hit
  }

  
}