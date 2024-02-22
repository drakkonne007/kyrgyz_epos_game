import 'package:game_flame/abstracts/item.dart';
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
  Gold()
  {
    id = 'gold';
    cost = 10;
    enabled = true;
    source = 'images/inventar/item/61.png';
  }

  @override
  void getEffect(KyrgyzGame game)
  {
      game.playerData.money.value += cost;
  }

}

