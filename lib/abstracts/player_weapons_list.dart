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
  });

  @override
  void onMount()
  {
    super.onMount();
    size = Vector2(20,50);
  }

  late double startAngle;
  double diffAngle = 0;

  @override
  Future<void> onLoad() async
  {
    damage = 1;
    activeSecs = 0.4;
    anchor = Anchor.bottomCenter;
    energyCost = 0.4;
  }

  @override
  Future<void> hit(PlayerDirectionMove direct) async
  {
    if(collisionType == CollisionType.inactive && gameRef.playerData.energy.value > energyCost) {
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