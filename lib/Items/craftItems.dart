

import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/kyrgyz_game.dart';

class HpSmall extends Item
{
  HpSmall()
  {
    id = 'hpSmall';
    cost = 10;
    source = 'images/inventar/flask/hpSmall.png';
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    if(game.playerData.flaskInventar.containsKey(id)){
      int curr = game.playerData.flaskInventar[id]!;
      curr++;
      game.playerData.flaskInventar[id] = curr;
    }else{
      game.playerData.flaskInventar[id] = 1;
    }
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.addHealth(10);
    if(game.playerData.flaskInventar.containsKey(id)){
      int curr = game.playerData.flaskInventar[id]!;
      curr--;
      if(curr == 0){
        game.playerData.flaskInventar.remove(id);
      }else{
        game.playerData.flaskInventar[id] = curr;
      }
    }
  }
}