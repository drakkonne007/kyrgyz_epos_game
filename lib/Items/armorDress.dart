

import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/kyrgyz_game.dart';

class ArmorStart extends Item
{
  ArmorStart()
  {
    id = 'armorStart';
    source = 'images/inventar/armor/210.png';
    dressType = DressType.armor;
    hp = 10;
    cost = 10;
    armor = 0.02;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(game.playerData.armorInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game)
  {
      game.playerData.setDress(this);
  }
}