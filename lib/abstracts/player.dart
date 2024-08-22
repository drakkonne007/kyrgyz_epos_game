

import 'package:flame/components.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/players/ortho_player.dart';

mixin class MainPlayer
{

  void doHurt({required double hurt, bool inArmor=true, double permanentDamage = 0, double secsOfPermDamage=0}){}
  SpriteAnimation? animMove, animIdle, animHurt, animDeath, animShort,animLong, animShield, animSlide;
  final Vector2 maxSpeeds = Vector2.all(0);
  final Vector2 sprSize = Vector2(144,96);
  PlayerHitbox? hitBox;
  bool gameHide = false;
  bool isLongAttack = false;
  bool isMinusEnergy = false;
  bool isRun = false;
  Ground? groundRigidBody;
  AnimationState animState = AnimationState.idle;
  bool canMagicSpell = true;
  bool enableShieldLock = true;
  bool wasMagicSwordHit = false;
  void startHit(bool isLong){}
  void doDash(bool left){}
  void doShield(){}
  void startMagic(){}
  void makeAction(){}
}
