import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class PhysicsVals
{
  PhysicsVals(){}
  static double gravity = 20;
  static double rigidy = 0.5;
  static double athmosphereResistance = 0.5;
}

class TimePoint extends CircleComponent
{

  TimePoint(Vector2 pos){
    position = pos;
  }
  double _lifeTime = 0;

  @override
  Future <void> onLoad() async{
    anchor = Anchor.center;
    radius = 3;
    size = Vector2(10, 10);
    setColor(ColorExtension.random());
    renderShape = true;
    super.onLoad();
  }

  @override
  void update(double dt){
    _lifeTime += dt;
    if(_lifeTime > 3){
      removeFromParent();
    }
  }

}