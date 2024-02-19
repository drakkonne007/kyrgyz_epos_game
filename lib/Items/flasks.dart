

import 'package:flame/components.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/kyrgyz_game.dart';

class HpSmall extends Item
{
  HpSmall(super.id)
  {
    gold = 10;
    enabled = true;
    source = 'images/inventar/flask/hpSmall.png';
    srcSize = Vector2.all(24);
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
  void gerEffectFromInventar(KyrgyzGame game)
  {
    game.playerData.health.value += 10;
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

class HpMedium extends Item
{
  HpMedium(super.id)
  {
    gold = 25;
    enabled = true;
    source = 'images/inventar/flask/hpMedium.png';
    srcSize = Vector2.all(24);
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
  void gerEffectFromInventar(KyrgyzGame game)
  {
    game.playerData.health.value += 25;
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

class HpBig extends Item
{
  HpBig(super.id)
  {
    gold = 50;
    enabled = true;
    source = 'images/inventar/flask/hpBig.png';
    srcSize = Vector2.all(24);
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
  void gerEffectFromInventar(KyrgyzGame game)
  {
    game.playerData.health.value += 50;
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

class HpFull extends Item
{
  HpFull(super.id)
  {
    gold = 90;
    enabled = true;
    source = 'images/inventar/flask/hpBig.png';
    srcSize = Vector2.all(24);
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
  void gerEffectFromInventar(KyrgyzGame game)
  {
    game.playerData.health.value = game.playerData.maxHealth.value;
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