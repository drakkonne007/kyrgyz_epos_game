

import 'dart:math';

import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/components/CountTimer.dart';
import 'package:game_flame/components/RenderText.dart';
import 'package:game_flame/kyrgyz_game.dart';

class TimerInvisibleFlask extends Item
{
  TimerInvisibleFlask()
  {
    id = 'timerInvisibleFlask';
    secsOfPermDamage = 60 * 10;
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    var timer = TempEffect(parentId: id ,period: duration ?? secsOfPermDamage,
        onEndEffect: (){
          game.setQuestState(name: 'villageGrow', state: 24, isDone: false, needInventar: true, desc: 'Забрать зелья у крестьянина в деревне');
          createText(text: 'Наверное моё зелье невидимости уже готово', gameRef: game);
        });
    game.gameMap.effectComponent.add(timer);
  }
}//bullSkin


class TimerGonecForSornyakPoison extends Item
{
  TimerGonecForSornyakPoison()
  {
    id = 'timerGonecForSornyakPoison';
    secsOfPermDamage = 60 * 10;
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    var timer = TempEffect(parentId: id ,period: duration ?? secsOfPermDamage,
        onEndEffect: (){
          game.setQuestState(name: 'villageGrow', state: 8, isDone: true, needInventar: false);
        });
    game.gameMap.effectComponent.add(timer);
  }
}//bullSkin

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
}//bullSkin

class SornyakPoison extends Item
{
  SornyakPoison()
  {
    id = 'sornyakPoison';
    dressType = InventarType.item;
    enabled = false;
    source = 'images/inventar/item/175.png';
    description = 'Яд от сорняков';
  }

  @override
  void getEffect(KyrgyzGame game) {
    plusToInventar(game);
  }
}

class BullSkin extends Item
{
  BullSkin()
  {
    id = 'bullSkin';
    dressType = InventarType.item;
    enabled = false;
    source = 'images/inventar/item/297.png';
    description = 'Кожа быка. Из такой кожи частично делают юрты';
  }

  @override
  void getEffect(KyrgyzGame game) {
    plusToInventar(game);
  }
}

class VillageFish extends Item
{
  VillageFish()
  {
    id = 'villageFish';
    dressType = InventarType.item;
    enabled = false;
    int rand = Random().nextInt(5);
    source = 'images/inventar/item/${276 + rand}.png';
    description = 'Сырая рыба. Сырую есть я её боюсь';
  }

  @override
  void getEffect(KyrgyzGame game) {
    plusToInventar(game);
  }
}

class VillageApple extends Item
{
  VillageApple()
  {
    id = 'villageApple';
    dressType = InventarType.item;
    enabled = false;
    source = 'images/inventar/item/241.png';
    description = 'Урожай, который просил собрать крестьянин';
  }

  @override
  void getEffect(KyrgyzGame game) {
    plusToInventar(game);
  }
}

class KeyForBigDungeon extends Item
{
  KeyForBigDungeon()
  {
    id = 'keyForBigDungeon';
    dressType = InventarType.item;
    enabled = false;
    source = 'images/inventar/keys/key2.png';
    description = 'Ключ от шахты орков';
  }

  @override
  void getEffect(KyrgyzGame game) {
    plusToInventar(game);
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
    source = 'images/inventar/keys/key1.gif';
    description = 'Ключ от сундука в деревне Алькима';
  }

  @override
  void getEffect(KyrgyzGame game) {
    plusToInventar(game);
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