import 'dart:ffi';

import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'package:flutter/animation.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/components/CountTimer.dart';
import 'package:game_flame/kyrgyz_game.dart';

class BloodShrine extends Item
{
  BloodShrine()
  {
    id = 'bloodShrine';
    secsOfPermDamage = 90;
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.addHealth(game.playerData.maxHealth.value);
    var timer = TempEffect(parentId: id, period: duration ?? secsOfPermDamage,
        onStartEffect: (){
          game.playerData.plusHealthMainPlayerChanger.value++;
        },
        onUpdate: (dt){
          game.playerData.addHealth(game.playerData.maxHealth.value * 0.5 * dt);
        }, onEndEffect: (){
          game.playerData.plusHealthMainPlayerChanger.value--;
        });
    game.gameMap.effectComponent.add(timer);
  }
}

class SilverShrine extends Item
{
  SilverShrine()
  {
    id = 'silverShrine';
    secsOfPermDamage = 90;
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.addEnergy(game.playerData.maxEnergy.value);
    game.playerData.addMana(game.playerData.maxMana.value);
    var timer = TempEffect(parentId: id, period: duration ?? secsOfPermDamage, onUpdate: (dt){
      game.playerData.addEnergy(game.playerData.maxEnergy.value * 0.5 * dt);
      game.playerData.addMana(game.playerData.maxMana.value * 0.5 * dt);
    },
        onStartEffect: (){
          game.playerData.plusManaMainPlayerChanger.value++;
          game.playerData.plusStaminaMainPlayerChanger.value++;
        },
        onEndEffect: (){
          game.playerData.plusManaMainPlayerChanger.value--;
          game.playerData.plusStaminaMainPlayerChanger.value--;
        });
    game.gameMap.effectComponent.add(timer);
  }
}

class HpSmall extends Item
{
  HpSmall()
  {
    id = 'hpSmall';
    cost = 100;
    source = 'images/inventar/flask/hpSmall.png';
    hp = 10;
    dressType = InventarType.flask;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    plusToInventar(game);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.addHealth(hp);
    minusInInventar(game);
  }
}

class HpMedium extends Item
{
  HpMedium()
  {
    id = 'hpMedium';
    cost = 250;
    enabled = true;
    source = 'images/inventar/flask/hpMedium.png';
    hp = 2;
    secsOfPermDamage = 10;
    dressType = InventarType.flask;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    plusToInventar(game);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    var timer = TempEffect(parentId: id, period: duration ?? secsOfPermDamage, onUpdate: (dt){
      game.playerData.addHealth(hp * dt);
    },
        onStartEffect: (){
          game.playerData.plusHealthMainPlayerChanger.value++;
        },
        onEndEffect: (){
          game.playerData.plusHealthMainPlayerChanger.value--;
        });
    game.gameMap.effectComponent.add(timer);
    minusInInventar(game);
  }
}

class HpBig extends Item
{
  HpBig()
  {
    id = 'hpBig';
    cost = 500;
    enabled = true;
    source = 'images/inventar/flask/hpBig.png';
    hp = 2.5;
    secsOfPermDamage = 15;
    dressType = InventarType.flask;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    plusToInventar(game);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    var timer = TempEffect(parentId: id, period: duration ?? secsOfPermDamage, onUpdate: (dt){
      game.playerData.addHealth(hp * dt);
    },
        onStartEffect: (){
          game.playerData.plusHealthMainPlayerChanger.value++;
        },
        onEndEffect: (){
          game.playerData.plusHealthMainPlayerChanger.value--;
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
    cost = 900;
    enabled = true;
    source = 'images/inventar/flask/hpFull.png';
    hp = 99999999;
    dressType = InventarType.flask;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    plusToInventar(game);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.addHealth(0,full: true);
    minusInInventar(game);
  }
}


class EnergySmall extends Item
{
  EnergySmall()
  {
    id = 'energySmall';
    cost = 100;
    enabled = true;
    source = 'images/inventar/flask/energySmall.png';
    energy = 5;
    dressType = InventarType.flask;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    plusToInventar(game);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.addEnergy(energy);
    minusInInventar(game);
  }
}

class EnergyMedium extends Item
{
  EnergyMedium()
  {
    id = 'energyMedium';
    cost = 250;
    enabled = true;
    source = 'images/inventar/flask/energyMedium.png';
    secsOfPermDamage = 10;
    energy = 1.5;
    dressType = InventarType.flask;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    plusToInventar(game);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    var timer = TempEffect(parentId: 'energyMedium' ,period: duration ?? secsOfPermDamage, onUpdate: (dt){
      game.playerData.addEnergy(energy * dt);
    });
    game.gameMap.effectComponent.add(timer);
    minusInInventar(game);
  }
}

class EnergyBig extends Item
{
  EnergyBig()
  {
    id = 'energyBig';
    cost = 500;
    enabled = true;
    source = 'images/inventar/flask/energyBig.png';
    energy = 2;
    secsOfPermDamage = 15;
    dressType = InventarType.flask;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    plusToInventar(game);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    var timer = TempEffect(parentId: id,period: duration ?? secsOfPermDamage, onUpdate: (dt){
      game.playerData.addEnergy(energy * dt);
    });
    game.gameMap.effectComponent.add(timer);
    minusInInventar(game);
  }
}

class EnergyFull extends Item
{
  EnergyFull()
  {
    id = 'energyFull';
    cost = 900;
    enabled = true;
    source = 'images/inventar/flask/energyFull.png';
    energy = 9999999;
    dressType = InventarType.flask;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    plusToInventar(game);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.addEnergy(0, full: true);
    minusInInventar(game);
  }
}

class ManaSmall extends Item
{
  ManaSmall()
  {
    id = 'manaSmall';
    cost = 100;
    enabled = true;
    source = 'images/inventar/flask/manaSmall.png';
    mana = 10;
    dressType = InventarType.flask;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    plusToInventar(game);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.addMana(mana);
    minusInInventar(game);
  }
}

class ManaMedium extends Item
{
  ManaMedium()
  {
    id = 'manaMedium';
    cost = 250;
    enabled = true;
    source = 'images/inventar/flask/manaMedium.png';
    secsOfPermDamage = 10;
    mana = 1.5;
    dressType = InventarType.flask;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    plusToInventar(game);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    var timer = TempEffect(parentId: 'manaMedium' ,period: duration ?? secsOfPermDamage, onUpdate: (dt){
      game.playerData.addMana(mana * dt);
    });
    game.gameMap.effectComponent.add(timer);
    minusInInventar(game);
  }
}

class ManaBig extends Item
{
  ManaBig()
  {
    id = 'manaBig';
    cost = 500;
    enabled = true;
    source = 'images/inventar/flask/manaBig.png';
    mana = 2;
    secsOfPermDamage = 15;
    dressType = InventarType.flask;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    plusToInventar(game);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    var timer = TempEffect(parentId: id,period: duration ?? secsOfPermDamage, onUpdate: (dt){
      game.playerData.addMana(mana * dt);
    });
    game.gameMap.effectComponent.add(timer);
    minusInInventar(game);
  }
}

class ManaFull extends Item
{
  ManaFull()
  {
    id = 'manaFull';
    cost = 900;
    enabled = true;
    source = 'images/inventar/flask/manaFull.png';
    mana = 9999999;
    dressType = InventarType.flask;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    plusToInventar(game);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.addMana(0, full: true);
    minusInInventar(game);
  }
}