import 'package:flame/collisions.dart';
import 'package:flame/components.dart';


void groundCalcLines(){

}

class PlayerHitbox extends RectangleHitbox {
  @override
  Future<void> onLoad() async{
    collisionType = CollisionType.passive;
  }
}
class EnemyHitbox extends RectangleHitbox {
  @override
  Future<void> onLoad() async{
    collisionType = CollisionType.passive;
  }
}

class OrthoPlayerGroundHitbox extends RectangleHitbox {

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, ShapeHitbox other) {
    if(other.parent is MapObstacle) {
      groundCalcLines(points,other);
    }else if(other.parent is EnemyWeapon){
      var temp = other as EnemyWeapon;
      doHurt(hurt: temp.damage,inArmor: temp.inArmor, permanentDamage: temp.permanentDamage, secsOfPermDamage: temp.secsOfPermDamage);
    }else if(other is ScreenHitbox){
      if(x < 0){
        position.x = 1;
      }
      if(y < 0){
        position.y = 1;
      }
      if(x > gameRef.gameMap!.size.x){
        position.x = gameRef.size.x - 1;
      }
      if(y > gameRef.gameMap!.size.y){
        position.y = gameRef.size.y - 1;
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override void onCollision(Set<Vector2> intersectionPoints, ShapeHitbox other) {
    if(other.parent is MapObstacle) {
      groundCalcLines(points,other);
    }
    super.onCollision(points, other);
    super.onCollision(intersectionPoints, other);
  }
}

class OrthoEnemyGroundHitbox extends RectangleHitbox {

}