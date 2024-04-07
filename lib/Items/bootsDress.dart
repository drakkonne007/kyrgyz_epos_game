import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/kyrgyz_game.dart';

class Boots1 extends Item
{
  Boots1()
  {
    id = 'boots1';
    source = 'images/inventar/boots/5.png';
    dressType = DressType.boots;
    cost = 10;
    armor = 1;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(game.playerData.armorInventar, this);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game)
  {
    game.playerData.setDress(this);
  }
}



