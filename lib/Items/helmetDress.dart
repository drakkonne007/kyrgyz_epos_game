import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/kyrgyz_game.dart';

class StartHelmet extends Item
{
  StartHelmet()
  {
    id = 'startHelmet';
    source = 'images/inventar/helmet/53.png';
    hp = 10;
    cost = 10;
    armor = 0.02;
    dressType = DressType.helmet;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(game.playerData.armorInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game)
  {
    game.playerData.helmetDress.value = this;
  }
}
