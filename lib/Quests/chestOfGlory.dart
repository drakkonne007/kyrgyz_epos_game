import 'package:flame/components.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/abstracts/quest.dart';
import 'package:game_flame/components/RenderText.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

class KeyForChestOfGlory extends Item
{
  String success = 'Квест выполнен';
  KeyForChestOfGlory()
  {
    id = 'keyForChestOfGlory';
    enabled = false;
    source = 'images/inventar/gloves/6.png';
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration}) async{
    minusInInventar(game, InventarType.item);
    game.dbHandler.setQuestState('chestOfGlory',3,true);
    var player = game.gameMap.orthoPlayer ?? game.gameMap.frontPlayer!;
    var renderText = RenderText(player.position, Vector2(150,75), success);
    renderText.priority = GamePriority.maxPriority;
    game.gameMap.container.add(renderText);
    game.gameMap.openSmallDialogs.add(success);
    TimerComponent timer1 = TimerComponent(
      period: success.length * 0.05 + 2,
      removeOnFinish: true,
      onTick: () {
        renderText.removeFromParent();
        game.gameMap.openSmallDialogs.remove(success);
      },
    );
    game.gameMap.add(timer1);
  }
}


class ChestOfGlory extends Quest
{
  ChestOfGlory(super.kyrgyzGame,{super.currentState, super.isDone})
  {
    id = 'chestOfGlory';
    dialogs[0] = AnswerForDialog(
        text: "Путник, ты можешь взять сундук сверху, хочешь?",
        answers: ["Да", "Нет"],
        answerNumbers: [2, 1],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[1] = AnswerForDialog(
        text: "Ну, смотри сам...",
        answers: ["..."],
        answerNumbers: [0],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[2] = AnswerForDialog(
        text: "Хорошо, вот тебе ключ от него. Мне то добро уже не надо. Я уже давно живу в деревне и занимаюсь промыслом",
        answers: ["Спасибо!"],
        answerNumbers: [3],
        isEnd: true,
        onAnswer: (answer){
          if(answer == 3){
            kyrgyzGame.playerData.addToInventar(InventarType.item, KeyForChestOfGlory());
            print('hoho');
          }
        },
       image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[3] = AnswerForDialog(text: 'Доброй дороги', answers: ['Спасибо'], answerNumbers: [3],isEnd: true,image: 'assets/tiles/sprites/dialogIcons/azura.png');
  }
}