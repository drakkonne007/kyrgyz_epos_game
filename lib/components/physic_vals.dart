import 'package:flame/components.dart';
import 'package:flame/extensions.dart';


class GameConsts
{
  static const gameScale = 1.5;
  static const maxSpeed = 3;
}

class OrthoPLayerVals
{
  static int health = 5;
  static double energy = 10;
  static int armor = 0;

  static void doNewGame(){
    health = 5;
    energy = 10;
    armor = 0;
  }
}

class PhysicsVals
{
  static double gravity = 20;
  static double rigidy = 0.5;
  static double athmosphereResistance = 150;
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
    if(_lifeTime > 2){
      removeFromParent();
    }
  }
}

