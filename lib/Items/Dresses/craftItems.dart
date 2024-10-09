

import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/components/CountTimer.dart';
import 'package:game_flame/components/RenderText.dart';
import 'package:game_flame/kyrgyz_game.dart';

class TimerThinkAboutMedalion extends Item
{
  TimerThinkAboutMedalion()
  {
    id = 'timerThinkAboutMedalion';
    secsOfPermDamage = 90;
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    var timer = TempEffect(parentId: id ,period: duration ?? secsOfPermDamage,
    onEndEffect: (){
      game.setQuestState(name: 'startGameKuznec', state: 38, isDone: false, needInventar: true, desc: 'Скорее всего кузнец нашёл записи');
      createText(text: 'Скорее всего кузнец уже закончил искать записи', gameRef: game);
    });
    game.gameMap.effectComponent.add(timer);
  }
}

class KeyForChestOfGlory extends Item
{
  String success = 'Квест выполнен';
  KeyForChestOfGlory()
  {
    id = 'keyForChestOfGlory';
    dressType = InventarType.item;
    enabled = false;
    source = 'images/inventar/Key1_cr.png';
    description = 'Ключ от сундука в деревне с садом';
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration}) async{
    minusInInventar(game);
    game.setQuestState(name: 'chestOfGlory',state: 14,isDone: true,needInventar: false);
    createText(text: success, gameRef: game);
  }
}

class DashAmulet extends Item
{
  DashAmulet()
  {
    id = 'dashAmulet';
    source = 'images/inventar/gem_07.png';
    enabled = false;
    dressType = InventarType.item;
    description = 'Странный древний амулет';
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    plusToInventar(game);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    minusInInventar(game);
  }
}