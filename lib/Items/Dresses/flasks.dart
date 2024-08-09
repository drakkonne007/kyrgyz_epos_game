
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/components/CountTimer.dart';
import 'package:game_flame/kyrgyz_game.dart';

class HpSmall extends Item
{
  HpSmall()
  {
    id = 'hpSmall';
    cost = 10;
    source = 'images/inventar/flask/hpSmall.png';
    hp = 10;
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
    game.playerData.addHealth(hp);
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
    hp = 2;
    secsOfPermDamage = 10;
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
    var timer = TempEffect(parentId: id, period: duration ?? secsOfPermDamage, onUpdate: (dt){
      game.playerData.addHealth(hp * dt);
    });
    game.gameMap.effectComponent.add(timer);
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
    hp = 2.5;
    secsOfPermDamage = 15;
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
    var timer = TempEffect(parentId: id, period: duration ?? secsOfPermDamage, onUpdate: (dt){
      game.playerData.addHealth(hp * dt);
    });
    game.gameMap.effectComponent.add(timer);
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
    hp = 99999999;
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
    energy = 5;
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
    game.playerData.addEnergy(energy);
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
    secsOfPermDamage = 10;
    energy = 1.5;
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
    var timer = TempEffect(parentId: 'energyMedium' ,period: duration ?? secsOfPermDamage, onUpdate: (dt){
      game.playerData.addEnergy(energy * dt);
    });
    game.gameMap.effectComponent.add(timer);
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
    energy = 2;
    secsOfPermDamage = 15;
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
    var timer = TempEffect(parentId: id,period: duration ?? secsOfPermDamage, onUpdate: (dt){
      game.playerData.addEnergy(energy * dt);
    });
    game.gameMap.effectComponent.add(timer);
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
    energy = 9999999;
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