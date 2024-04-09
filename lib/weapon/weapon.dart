
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_flame/abstracts/dVector2.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/abstracts/player.dart';
import 'package:game_flame/components/CountTimer.dart';
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
  double activeSecs = 0;
  double coolDown = 1;
  double currentCoolDown = 0;
  double latencyBefore = 0;


  Future<void> hit();


  @override
  bool onComponentTypeCheck(DCollisionEntity other) {
    if(other is PlayerHitbox) {
      return true;
    }
    return false;
  }

  @mustCallSuper
  @override
  void onCollisionStart(Set<dVector2> intersectionPoints, DCollisionEntity other)
  {
    if(other is PlayerHitbox){
      if(currentCoolDown < coolDown){
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
    if(currentCoolDown < coolDown){
      currentCoolDown += dt;
    }
    // super.update(dt);
  }
}

abstract class PlayerWeapon extends DCollisionEntity
{
  PlayerWeapon(super._vertices, {required super.collisionType, super.isSolid, required super.isStatic,required this.onStartWeaponHit,
    required this.onEndWeaponHit, super.isLoop, required super.game, super.radius, super.isOnlyForStatic});

  Function()? onStartWeaponHit;
  Function()? onEndWeaponHit;
  final double sectorInRadian = 0.383972 * 2;
  MagicDamage? magicDamage;
  double? damage;
  double permanentDamage = 0;
  double secsOfPermDamage = 0;
  bool inArmor = true;
  double energyCost = 0;
  double coolDown = 1;
  double currentCoolDown = 0;
  double latencyBefore = 0;
  Map<EnemyHitbox,int> _myHitboxes= {};

  Future<void> hit();

  @override
  void onLoad()
  {
    TimerComponent timer = TimerComponent(period: 60, repeat: true,onTick: cleanHash);
    add(timer);
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
  void onCollisionStart(Set<dVector2> intersectionPoints, DCollisionEntity other)
  {
    if(other is EnemyHitbox){
      if(_myHitboxes.containsKey(other)){
        if(DateTime.now().millisecondsSinceEpoch - _myHitboxes[other]! < coolDown * 1000){
          return;
        } else{
          _myHitboxes[other] = DateTime.now().millisecondsSinceEpoch;
        }
      }else{
        _myHitboxes[other] = DateTime.now().millisecondsSinceEpoch;
      }
      // if(currentCoolDown < coolDown){
      //   return;
      // }
      // currentCoolDown = 0;
      var temp = other.parent as KyrgyzEnemy;
      temp.doHurt(hurt: damage ?? 0,inArmor: inArmor);
      game.add(
        ParticleSystemComponent(
          position: other.getCenter().toVector2(),
          size: Vector2(5,5),
          particle: Particle.generate(
            count: 15,
            generator: (i) => AcceleratedParticle(
              lifespan: 0.3,
              acceleration: randomVector2(),
              child: CircleParticle(
                radius: 0.7,
                paint: Paint()..color = Colors.red[900]!,
              ),
            ),
          ),
        ),
      );
      if(secsOfPermDamage > 0
          && permanentDamage > 0
          && magicDamage != null){
        if(temp.magicDamages.containsKey(magicDamage)){
          int curr = temp.magicDamages[magicDamage]!;
          curr++;
          temp.magicDamages[magicDamage!] = curr;
        }else{
          temp.magicDamages[magicDamage!] = 1;
        }
        var tempComponent = other.parent as Component;
        double damage = permanentDamage/2;
        MagicDamage magic = magicDamage!;
        tempComponent.add(TempEffect(period: secsOfPermDamage,onUpdate: (dt){
          temp.doMagicHurt(hurt: damage * dt, magicDamage: magic);},onEndEffect: (){
          int curr = temp.magicDamages[magic]!;
          curr--;
          if(curr == 0){
            temp.magicDamages.remove(magic);
          }else{
            temp.magicDamages[magic] = curr;
          }
        }));
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