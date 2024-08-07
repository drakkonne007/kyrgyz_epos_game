

import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

class ArmorStart extends Item
{
  ArmorStart()
  {
    id = 'armorStart';
    source = 'images/inventar/armor/3.png';
    dressType = DressType.armor;
    hp = 10;
    cost = 10;
    armor = 0.02;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
      game.playerData.setDress(this);
  }
}