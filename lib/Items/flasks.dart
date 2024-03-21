
import 'package:flame/components.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/components/CountTimer.dart';
import 'package:game_flame/kyrgyz_game.dart';

class HpSmall extends Item
{
  HpSmall()
  {
    id = 'hpSmall';
    cost = 10;
    enabled = true;
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
  void getEffectFromInventar(KyrgyzGame game)
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

class HpMedium extends Item
{
  HpMedium()
  {
    id = 'hpMedium';
    cost = 25;
    enabled = true;
    source = 'images/inventar/flask/hpMedium.png';
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
  void getEffectFromInventar(KyrgyzGame game)
  {
    var timer = CountTimer(period: 1,repeat: true,onTick: () => game.playerData.addHealth(2), count: 10, onEndCount: (){game.playerData.effectTimer.remove(this);});
    game.gameMap.add(timer);
    game.playerData.effectTimer.add(timer);
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
  HpBig()
  {
    id = 'hpBig';
    cost = 50;
    enabled = true;
    source = 'images/inventar/flask/hpBig.png';
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
  void getEffectFromInventar(KyrgyzGame game)
  {
    var timer = CountTimer(period: 0.5,repeat: true,onTick: () => game.playerData.addHealth(2.5), count: 30, onEndCount: (){game.playerData.effectTimer.remove(this);});
    game.gameMap.add(timer);
    game.playerData.effectTimer.add(timer);
    // game.playerData.addHealth(50);
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
  HpFull()
  {
    id = 'hpFull';
    cost = 90;
    enabled = true;
    source = 'images/inventar/flask/hpFull.png';
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
  void getEffectFromInventar(KyrgyzGame game)
  {
    game.playerData.addHealth(0,full: true);
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


class EnergySmall extends Item
{
  EnergySmall()
  {
    id = 'energySmall';
    cost = 10;
    enabled = true;
    source = 'images/inventar/flask/energySmall.png';
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
  void getEffectFromInventar(KyrgyzGame game)
  {
    game.playerData.addEnergy(5);
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

class EnergyMedium extends Item
{
  EnergyMedium()
  {
    id = 'energyMedium';
    cost = 25;
    enabled = true;
    source = 'images/inventar/flask/energyMedium.png';
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
  void getEffectFromInventar(KyrgyzGame game)
  {
    var timer = CountTimer(period: 1,repeat: true,onTick: () => game.playerData.addEnergy(1.5), count: 10, onEndCount: (){game.playerData.effectTimer.remove(this);});
    game.gameMap.add(timer);
    game.playerData.effectTimer.add(timer);
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

class EnergyBig extends Item
{
  EnergyBig()
  {
    id = 'energyBig';
    cost = 50;
    enabled = true;
    source = 'images/inventar/flask/energyBig.png';
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
  void getEffectFromInventar(KyrgyzGame game)
  {
    var timer = CountTimer(period: 0.5,repeat: true,onTick: () => game.playerData.addEnergy(2), count: 30, onEndCount: (){game.playerData.effectTimer.remove(this);});
    game.gameMap.add(timer);
    game.playerData.effectTimer.add(timer);
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

class EnergyFull extends Item
{
  EnergyFull()
  {
    id = 'energyFull';
    cost = 90;
    enabled = true;
    source = 'images/inventar/flask/energyFull.png';
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
  void getEffectFromInventar(KyrgyzGame game)
  {
    game.playerData.addEnergy(0, full: true);
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