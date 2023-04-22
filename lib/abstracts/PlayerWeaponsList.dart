
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game_flame/abstracts/weapon.dart';

class WDubina extends PlayerWeapon
{
  @override
  Future<void> onLoad() async{
    debugMode = true;
    damage = 1;
    activeSecs = 1;
    size = Vector2(20,70);
    anchor = Anchor.topCenter;
  }
}