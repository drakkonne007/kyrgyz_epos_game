import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';


enum PlayerDirectionMove{
  NoMove,
  Left,
  Right,
  Up,
  Down,
  LeftUp,
  LeftDown,
  RightUp,
  RightDown,
}


class GameConsts
{
  static const double gameScale = 1.3;
}

class OrthoPlayerVals
{
  static var health = ValueNotifier<double>(maxHealth);
  static var energy = ValueNotifier<double>(maxEnergy);
  static var armor = ValueNotifier<double>(maxArmor);

  static bool isLockEnergy = false;

  static double maxHealth = 10;
  static double maxEnergy = 5;
  static double maxArmor = 0;

  static const double maxSpeed = 130 * GameConsts.gameScale;
  static const double startSpeed = 400 * GameConsts.gameScale;
  static double runCoef = 1.3;
  static double runMinimum = 0.2;
  static double playerScale = 1.4;

  static double gravity = 20 * GameConsts.gameScale;
  static double rigidy = 0.5;
  static double stopSpeed = 800 * GameConsts.gameScale;

  static void doNewGame(){
    health.value = maxHealth;
    energy.value = maxEnergy;
    armor.value  = maxArmor;
    isLockEnergy = false;
  }
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

