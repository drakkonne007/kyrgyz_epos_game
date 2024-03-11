import 'dart:math' as math;

import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/abstracts/item.dart';

abstract class KyrgyzEnemy
{
  KyrgyzEnemy()
  {
    math.Random rand = math.Random(DateTime.now().microsecondsSinceEpoch);
    for(int i=0;i<maxLoots;i++){
      double chance = rand.nextDouble();
      if(chance <= chanceOfLoot){
        var item = Gold();
        loots.add(item);
      }
    }
  }

  double health = 0;
  double armor = 0;
  int maxLoots = 0;
  int column=0;
  int row=0;
  double chanceOfLoot = 0.01; // 0 - never
  void doHurt({required double hurt, bool inArmor=true}){}
  void doMagicHurt({required double hurt,required MagicDamage magicDamage}){}
  List<Item> loots = [];
  Map<MagicDamage,int> magicDamages = {};
}