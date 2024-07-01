
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
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    var timer = TempEffect(parentId: id, period: duration ?? 10, onUpdate: (dt){
      game.playerData.addHealth(2.0 * dt);
    });
    game.gameMap.add(timer);
    game.playerData.tempEffects.add(timer);
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
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    var timer = TempEffect(parentId: id, period: duration ?? 15, onUpdate: (dt){
      game.playerData.addHealth(2.5 * dt);
    });
    game.gameMap.add(timer);
    game.playerData.tempEffects.add(timer);
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
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
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
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
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
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    var timer = TempEffect(parentId: 'energyMedium' ,period: duration ?? 10, onUpdate: (dt){
      game.playerData.addEnergy(1.5 * dt);
    });
    game.gameMap.add(timer);
    game.playerData.tempEffects.add(timer);
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
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    var timer = TempEffect(parentId: id,period: duration ?? 15, onUpdate: (dt){
      game.playerData.addEnergy(2 * dt);
    });
    game.gameMap.add(timer);
    game.playerData.tempEffects.add(timer);
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
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
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