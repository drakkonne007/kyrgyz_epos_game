
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/player.dart';

abstract class EnemyWeapon extends RectangleHitbox
{
  double damage = 0;
  double permanentDamage = 0;
  double secsOfPermDamage = 0;
  bool inArmor = true;
  double activeSecs = 1;

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, ShapeHitbox other) {
    if(other is PlayerHitbox){
      print("MainPlayer hurt");
      var temp = other.parent as MainPlayer;
      temp.doHurt(hurt: damage,inArmor: inArmor, permanentDamage: permanentDamage, secsOfPermDamage: secsOfPermDamage);
    }
  }
}

abstract class PlayerWeapon extends RectangleHitbox
{
  double damage = 0;
  double permanentDamage = 0;
  double secsOfPermDamage = 0;
  bool inArmor = true;
  double activeSecs = 1;

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, ShapeHitbox other) {
    if(other is EnemyHitbox){
      print("KyrgyzEnemy hurt");
      var temp = other.parent as KyrgyzEnemy;
      temp.doHurt(hurt: damage,inArmor: inArmor, permanentDamage: permanentDamage, secsOfPermDamage: secsOfPermDamage);
    }
  }
}