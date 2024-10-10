import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/kyrgyz_game.dart';

class NullItem extends Item
{
  NullItem()
  {
    id = 'nullItem';
    source = 'images/inventar/nullImage.png';
  }
}

class Gold extends Item
{
  Gold(int newCost)
  {
    id = 'gold';
    cost = newCost;
    enabled = true;
    source = 'images/inventar/item/292.png';
  }

  @override
  void getEffect(KyrgyzGame game)
  {
      game.playerData.money.value += cost;
  }
}

