import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game_flame/abstracts/weapon.dart';
import 'package:game_flame/components/physic_vals.dart';

class WDubina extends PlayerWeapon
{
  WDubina({
    super.position,
    super.size,
    super.angle,
    super.anchor,
    super.priority,
    bool isSolid = false,
    required super.onStartWeaponHit,
    required super.onEndWeaponHit,
  });

  @override
  void onMount()
  {
    super.onMount();
    size = Vector2(20,50);
  }

  late double startAngle;
  late double activeSecs;
  double diffAngle = 0;

  @override
  Future<void> onLoad() async
  {
    damage = 10;
    anchor = Anchor.bottomCenter;
    energyCost = 0.4;
  }

  @override
  Future<void> hit(PlayerDirectionMove direct, double long) async
  {
    activeSecs = long;
    if(collisionType == CollisionType.inactive) {
      print(long);
      onStartWeaponHit.call();
      gameRef.playerData.energy.value -= energyCost;
      gameRef.playerData.isLockEnergy = true;
      startAngle = radiansOfPlayerDirect(direct);
      diffAngle = 0;
      angle = startAngle;
      debugMode = true;
      collisionType = CollisionType.active;
      // print('start hit');
      await Future.delayed(Duration(milliseconds: (activeSecs * 1000).toInt()),(){
          collisionType = CollisionType.inactive;
          debugMode = false;
          gameRef.playerData.isLockEnergy = false;
          onEndWeaponHit.call();
          // print('end hit');
      });
    }
  }

  @override
  void update(double dt)
  {
    if(collisionType == CollisionType.active){
      diffAngle -= dt/activeSecs * sectorInRadian;
      angle = startAngle + diffAngle;
    }
    super.update(dt);
  }
}