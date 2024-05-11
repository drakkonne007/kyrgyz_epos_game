import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';


class Ground extends Body with ContactCallbacks
{
  Ground(super.bd, super.world, {this.onGroundCollision, this.isOnlyForStatic = false, this.isEnemy = false})
  {
    onBeginContact = onGroundCollision;
    var wrld = world as DWorld;
    wrld.addCustomBody(this);
  }

  bool isOnlyForStatic = false;
  bool isEnemy = false;
  Function(Object other, Contact contact)? onGroundCollision;

  @override
  bool shouldCollide(Body other) {
    if (bodyType != BodyType.dynamic && other.bodyType != BodyType.dynamic) {
      return false;
    }
    for (final joint in joints) {
      if (joint.containsBody(other) && !joint.collideConnected) {
        return false;
      }
    }
    if(other is Ground) {
      if (isOnlyForStatic && other.bodyType != BodyType.static) {
        return false;
      }
      if (other.isEnemy && isEnemy) {
        return false;
      }
      return true;
    }
    return false;
  }
}