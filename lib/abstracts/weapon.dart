
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
      return math.pi * 11 / 6;
    case PlayerDirectionMove.Left:
      return math.pi * 5 / 3;
    case PlayerDirectionMove.LeftDown:
      return math.pi * 4 / 3;
    case PlayerDirectionMove.Down:
      return math.pi * 7 / 6;
    case PlayerDirectionMove.RightDown:
      return math.pi * 5 / 6;
    case PlayerDirectionMove.NoMove: throw 'Error in choose weapon direction';
  }
}

abstract class EnemyWeapon extends RectangleHitbox
{
  EnemyWeapon({
    super.position,
    super.size,
    super.angle,
    super.anchor,
    super.priority,
    bool isSolid = false,
  })
  {
    collisionType = CollisionType.inactive;
    // debugColor = BasicPalette.orange.color;
    // debugMode = true;
  }
  double damage = 0;
  double permanentDamage = 0;
  double secsOfPermDamage = 0;
  bool inArmor = true;
  double activeSecs = 0;

  void hit(PlayerDirectionMove direct);

  @override
  bool onComponentTypeCheck(PositionComponent other) {
    if(other is PlayerHitbox) {
      return super.onComponentTypeCheck(other);
    }
    return false;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, ShapeHitbox other)
  {
    if(other is PlayerHitbox){
      var temp = other.parent as MainPlayer;
      temp.doHurt(hurt: damage,inArmor: inArmor, permanentDamage: permanentDamage, secsOfPermDamage: secsOfPermDamage);
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}

abstract class PlayerWeapon extends RectangleHitbox with HasGameRef<KyrgyzGame>
{
  PlayerWeapon({
    super.position,
    super.size,
    super.angle,
    super.anchor,
    super.priority,
    bool isSolid = false,
  })
  {
    debugColor = BasicPalette.orange.color;
    collisionType = CollisionType.inactive;
  }

  final double sectorInRadian = 0.383972 * 2;
  double damage = 0;
  double permanentDamage = 0;
  double secsOfPermDamage = 0;
  bool inArmor = true;
  double activeSecs = 0;
  double energyCost = 0;

  Future<void> hit(PlayerDirectionMove direct);

  @override
  bool onComponentTypeCheck(PositionComponent other) {
    if(other is EnemyHitbox) {
      return super.onComponentTypeCheck(other);
    }
    return false;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, ShapeHitbox other)
  {
    if(other is EnemyHitbox){
      print('HOhoho Enemy');
      var temp = other.parent as KyrgyzEnemy;
      temp.doHurt(hurt: damage,inArmor: inArmor, permanentDamage: permanentDamage, secsOfPermDamage: secsOfPermDamage);
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}