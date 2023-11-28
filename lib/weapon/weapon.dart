
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/player.dart';
import 'dart:math' as math;
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

double radiansOfPlayerDirect(PlayerDirectionMove direct)
{
  switch (direct) {
    case PlayerDirectionMove.Right:
      return math.pi * 2 / 3;
    case PlayerDirectionMove.RightUp:
      return math.pi / 3;
    case PlayerDirectionMove.Up:
      return 2*math.pi + math.pi / 6;
    case PlayerDirectionMove.LeftUp:
      return math.pi / 3;
    case PlayerDirectionMove.Left:
      return math.pi * 2 / 3;
    case PlayerDirectionMove.LeftDown:
      return math.pi * 5 / 6;
    case PlayerDirectionMove.Down:
      return math.pi * 7 / 6;
    case PlayerDirectionMove.RightDown:
      return math.pi * 5 / 6;
    case PlayerDirectionMove.NoMove: throw 'Error in choose weapon direction';
  }
}

abstract class EnemyWeapon extends DCollisionEntity
{
  EnemyWeapon(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic,required this.onStartWeaponHit,
    required this.onEndWeaponHit, required super.isLoop, required super.game});

  Function() onStartWeaponHit;
  Function() onEndWeaponHit;
  double damage = 0;
  double permanentDamage = 0;
  double secsOfPermDamage = 0;
  bool inArmor = true;
  double activeSecs = 0;
  double coolDown = 1000;
  double currentCoolDown = 0;
  double latencyBefore = 0;


  void hit(PlayerDirectionMove direct);

  @override
  bool onComponentTypeCheck(DCollisionEntity other) {
    if(other is PlayerHitbox) {
      return true;
    }
    return false;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, DCollisionEntity other)
  {
    if(other is PlayerHitbox){
      if(currentCoolDown < coolDown){
        return;
      }
      currentCoolDown = 0;
      var temp = other.parent as MainPlayer;
      temp.doHurt(hurt: damage,inArmor: inArmor, permanentDamage: permanentDamage, secsOfPermDamage: secsOfPermDamage);
    }
  }

  @override
  void update(double dt)
  {
    if(currentCoolDown < coolDown){
      currentCoolDown += dt;
    }
  }
}

abstract class PlayerWeapon extends DCollisionEntity
{

  PlayerWeapon(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic,required this.onStartWeaponHit,
    required this.onEndWeaponHit, required super.isLoop, required super.game});

  Function() onStartWeaponHit;
  Function() onEndWeaponHit;
  final double sectorInRadian = 0.383972 * 2;
  double damage = 0;
  double permanentDamage = 0;
  double secsOfPermDamage = 0;
  bool inArmor = true;
  double energyCost = 0;
  double coolDown = 1000;
  double currentCoolDown = 0;
  double latencyBefore = 0;

  Future<void> hit();

  @override
  bool onComponentTypeCheck(DCollisionEntity other) {
    if(other is EnemyHitbox) {
      return true;
    }
    return false;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, DCollisionEntity other)
  {
    if(other is EnemyHitbox){
      if(currentCoolDown < coolDown){
        return;
      }
      currentCoolDown = 0;
      var temp = other.parent as KyrgyzEnemy;
      temp.doHurt(hurt: damage,inArmor: inArmor, permanentDamage: permanentDamage, secsOfPermDamage: secsOfPermDamage);
    }
  }

  @override
  void update(double dt)
  {
    if(currentCoolDown < coolDown){
      currentCoolDown += dt;
    }
  }
}