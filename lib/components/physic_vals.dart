import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:game_flame/components/helper.dart';


class GameConsts
{
  static const gameScale = 1.5;
  static const maxSpeed = 3;
}

class OrthoPlayerVals
{
  static var health = ValueNotifier<double>(10);
  static var energy = ValueNotifier<double>(5);
  static var armor = ValueNotifier<double>(0);

  static double maxHealth = 10;
  static double maxEnergy = 5;
  static double maxArmor = 0;

  static void doNewGame(){
    health.value = 10;
    energy.value = 5;
    armor.value  = 0;
  }
}

class PhysicsVals
{
  static double gravity = 20;
  static double rigidy = 0.5;
  static double athmosphereResistance = 450;
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

