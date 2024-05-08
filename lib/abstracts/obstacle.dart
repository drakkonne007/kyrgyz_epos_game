import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:game_flame/kyrgyz_game.dart';


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

    // Does a joint prevent collision?
    for (final joint in joints) {
      if (joint.containsBody(other) && !joint.collideConnected) {
        return false;
      }
    }
    var ground = other as Ground;
    if(isOnlyForStatic && ground.bodyType != BodyType.static){
      return false;
    }
    if(ground.isEnemy && isEnemy){
      return false;
    }
    return true;
  }
}