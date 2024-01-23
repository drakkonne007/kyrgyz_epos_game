import 'dart:math' as math;

import 'package:game_flame/abstracts/item.dart';

abstract class KyrgyzEnemy
{
  KyrgyzEnemy()
  {
    math.Random rand = math.Random(DateTime.now().microsecondsSinceEpoch);
    for(int i=0;i<maxLoots;i++){
      double chance = rand.nextDouble();
      if(chance >= chanceOfLoot){
        var item = itemFromId(2);
        loots.add(item);
      }
    }
  }
  double health = 0;
  double armor = 0;
  int maxLoots = 0;
  int column=0;
  int row=0;
  double chanceOfLoot = 1; // 1 - never (Random().nextDouble(); // Value is >= 0.0 and < 1.0)
  void doHurt({required double hurt, bool inArmor=true, double permanentDamage = 0, double secsOfPermDamage=0}){}
  List<Item> loots = [];
}