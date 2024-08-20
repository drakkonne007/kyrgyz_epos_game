import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/physicWorld.dart';


class Ground extends Body
{
  Ground(super.bd, super.world, {this.isOnlyForStatic = false, this.isEnemy = false, this.isPlayer = false})
  {
    var wrld = world as WorldPhy;
    wrld.addCustomBody(this);
  }

  void destroy()
  {
    world.destroyBody(this);
  }

  bool isOnlyForStatic = false;
  bool isEnemy = false;
  bool isPlayer = false;

  @override
  Fixture createFixture(FixtureDef def)
  {
    if(isPlayer){
      def.filter = Filter();
      def.filter.categoryBits = 0x0004;
      def.filter.maskBits = 0xFFFB;
    }
    if(isEnemy){      // 0x0001;
      def.filter = Filter();
      def.filter.categoryBits = 0x0002;
      def.filter.maskBits = 0xFFFD;
    }
    if(isOnlyForStatic){
      def.filter = Filter();
      def.filter.categoryBits = 0x0001;
      def.filter.maskBits = 0x0001;
    }
    def.friction = 0.2;
    return super.createFixture(def);
  }

  @override
  bool shouldCollide(Body other)
  {
    if (bodyType != BodyType.dynamic && other.bodyType != BodyType.dynamic) {
      return false;
    }
    for (final joint in joints) {
      if (joint.containsBody(other) && !joint.collideConnected) {
        return false;
      }
    }
    if(other is Ground) {
      return true;
      if (isOnlyForStatic && other.bodyType != BodyType.static) {
        return false;
      }
      if (other.isEnemy && isEnemy) {
        return false;
      }
      if (other.isPlayer && isPlayer) {
        return false;
      }
    }
    return false;
  }
}