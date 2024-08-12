
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/abstracts/player.dart';
import 'package:game_flame/components/CountTimer.dart';
import 'dart:math' as math;
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/weapon/magicEffects/lightningEffect.dart';

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
  EnemyWeapon(super._vertices, {this.onObstacle, required super.collisionType, super.isSolid, required super.isStatic,this.onStartWeaponHit,
    this.onEndWeaponHit, super.isLoop, required super.game, super.radius, super.isOnlyForStatic});

  Function()? onStartWeaponHit;
  Function()? onObstacle;
  final double sectorInRadian = 0.383972 * 2;
  Function()? onEndWeaponHit;
  double damage = 1;
  double permanentDamage = 0;
  double secsOfPermDamage = 0;
  bool inArmor = true;
  double _coolDown = 1;
  double currentCoolDown = 1;
  double latencyBefore = 0;

  set coolDown(double val)
  {
    _coolDown = val;
    currentCoolDown = _coolDown;
  }
  double get coolDown => _coolDown;

  Future<void> hit();

  @override
  void onLoad()
  {
    currentCoolDown = _coolDown;
  }


  @override
  bool onComponentTypeCheck(DCollisionEntity other) {
    if(other is PlayerHitbox) {
      return true;
    }
    return false;
  }

  @mustCallSuper
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, DCollisionEntity other)
  {
    if(other is PlayerHitbox){
      if(currentCoolDown < _coolDown){
        return;
      }
      onObstacle?.call();
      currentCoolDown = 0;
      var temp = other.parent as MainPlayer;
      temp.doHurt(hurt: damage,inArmor: inArmor, permanentDamage: permanentDamage, secsOfPermDamage: secsOfPermDamage);
    }
  }

  @mustCallSuper
  @override
  void update(double dt)
  {
    // doDebug();
    if(currentCoolDown < _coolDown){
      currentCoolDown += dt;
    }
    // super.update(dt);
  }
}

abstract class PlayerWeapon extends DCollisionEntity
{
  PlayerWeapon(super._vertices, {required super.collisionType, super.isSolid, required super.isStatic,this.onStartWeaponHit,
    this.onEndWeaponHit, super.isLoop, required super.game, super.radius, super.isOnlyForStatic});

  Function()? onStartWeaponHit;
  Function()? onEndWeaponHit;
  final double sectorInRadian = 0.383972 * 2;
  MagicDamage? magicDamage;
  double? damage;
  double permanentDamage = 0;
  double secsOfPermDamage = 0;
  bool inArmor = true;
  double energyCost = 0;
  double _coolDown = 1;
  double currentCoolDown = 0;
  double latencyBefore = 0;
  final Map<EnemyHitbox,int> _myHitboxes= {};

  set coolDown(double val)
  {
    _coolDown = val;
    currentCoolDown = _coolDown;
  }
  double get coolDown => _coolDown;

  void hit();

  @override
  void onLoad()
  {
    TimerComponent timer = TimerComponent(period: 60, repeat: true,onTick: cleanHash);
    add(timer);
    currentCoolDown = coolDown;
  }

  void cleanHash()
  {
    var listKeys = _myHitboxes.keys.toList(growable: false);
    var listValues = _myHitboxes.values.toList(growable: false);
    for(int i = 0; i < listValues.length; i++){
      if(listValues[i] - DateTime.now().millisecondsSinceEpoch < - -30 * 1000){
        _myHitboxes.remove(listKeys[i]);
      }
    }
  }

  @override
  bool onComponentTypeCheck(DCollisionEntity other) {
    if(other is EnemyHitbox) {
      return true;
    }
    return false;
  }

  void cleanHashes()
  {
    _myHitboxes.clear();
  }

  void stopHit()
  {
    collisionType = DCollisionType.inactive;
  }

  Vector2 randomVector2() => (Vector2.random() - Vector2.random()) * 100;

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, DCollisionEntity other) {

    if (other is EnemyHitbox) {
      if (_myHitboxes.containsKey(other)) {
        if (DateTime.now().millisecondsSinceEpoch - _myHitboxes[other]! < coolDown * 1000) {
          return;
        } else {
          _myHitboxes[other] = DateTime.now().millisecondsSinceEpoch;
        }
      } else {
        _myHitboxes[other] = DateTime.now().millisecondsSinceEpoch;
      }
      hit();
      if (other.parent is KyrgyzEnemy) {
        var temp = other.parent as KyrgyzEnemy;
        bool isPlayer = parent is MainPlayer;
        if(damage != null){
          if((damage! == 0 && magicDamage == null) || damage! > 0){
            temp.doHurt(hurt: damage!, inArmor: inArmor, isPlayer: isPlayer);
          }
        }
        // temp.doHurt(hurt: damage ?? 0, inArmor: inArmor, isPlayer: isPlayer);
        if (magicDamage != null) {
          // if (temp.magicDamages.containsKey(magicDamage)) {
          //   int curr = temp.magicDamages[magicDamage]!;
          //   curr++;
          //   temp.magicDamages[magicDamage!] = curr;
          // } else {
          //   temp.magicDamages[magicDamage!] = 1;
          // }
          var tempComponent = other.parent as Component;
          double damage = permanentDamage;
          MagicDamage magic = magicDamage!;
          temp.doMagicHurt(hurt: damage, magicDamage: magic);
          if(secsOfPermDamage.toInt() > 0) {
            tempComponent.add(CountTimer(
                period: 1,
                count: secsOfPermDamage.toInt(),
                onTick: () {
                  temp.doMagicHurt(hurt: damage, magicDamage: magic);
                }));
          }
        }
      }
    }
  }

  @mustCallSuper
  @override
  void update(double dt)
  {
    // doDebug();
    if(currentCoolDown < coolDown){
      currentCoolDown += dt;
    }
    super.update(dt);
  }
}