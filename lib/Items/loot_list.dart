import 'package:flame/components.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/kyrgyz_game.dart';

class Gold extends Item
{
  Gold(super.id)
  {
    gold = 10;
    enabled = true;
    source = 'tiles/map/loot/loot.png';
    srcSize = Vector2.all(24);
  }

  @override
  void getEffect(KyrgyzGame game)
  {
      game.playerData.money.value += gold;
  }

  @override
  void gerEffectFromInventar(KyrgyzGame game)
  {
    game.playerData.health.value += 1;
    game.playerData.money.value += 1;
    if(game.playerData.itemInventar.containsKey(id)){
      int curr = game.playerData.itemInventar[id]!;
      curr--;
      if(curr == 0){
        game.playerData.itemInventar.remove(id);
      }else{
        game.playerData.itemInventar[id] = curr;
      }
    }
  }
}

class PureHat extends Item
{
  PureHat(super.id)
  {
    source = 'tiles/map/loot/loot.png';
    armor = 1;
    cost = 100;
    isDress = true;
    countOfUses = 100;
  }

  @override
  void getEffect(KyrgyzGame game)
  {

  }
}

class StrongHat extends Item
{
  StrongHat(super.id)
  {
    srcSize = Vector2.all(24);
    source = 'tiles/map/loot/loot.png';
    armor = 1.5;
    cost = 100;
    isDress = true;
    countOfUses = 200;
  }

  @override
  void getEffect(KyrgyzGame game)
  {

  }
}