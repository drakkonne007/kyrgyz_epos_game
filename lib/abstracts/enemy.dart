import 'package:game_flame/abstracts/item.dart';

abstract class KyrgyzEnemy
{
  double health = 0;
  double armor = 0;
  int maxLoots = 0;
  int column=0;
  int row=0;
  double chanceOfLoot = 1; // 1 - never (Random().nextDouble(); // Value is >= 0.0 and < 1.0)
  void doHurt({required double hurt, bool inArmor=true, double permanentDamage = 0, double secsOfPermDamage=0})async{}
  List<Item> loots = [];
}