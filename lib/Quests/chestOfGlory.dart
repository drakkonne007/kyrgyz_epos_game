import 'package:flame/components.dart';
import 'package:game_flame/Items/Dresses/item.dart';
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
    dressType = InventarType.item;
    enabled = false;
    source = 'images/inventar/gloves/6.png';
    description = 'Ключ от сундука в деревне с садом';
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration}) async{
    minusInInventar(game, InventarType.item);
    game.setQuestState('chestOfGlory',4,true);
    createText(text: success, gameRef: game);
  }
}


class ChestOfGlory extends Quest
{
  ChestOfGlory(super.kyrgyzGame,{super.currentState, super.isDone})
  {
    id = 'chestOfGlory';
    dialogs[0] = AnswerForDialog(
        text: "Путник, ты можешь взять сундук возле верхней стены, хочешь?",
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
            kyrgyzGame.playerData.addToInventar(InventarType.item, 'keyForChestOfGlory');
            createText(text: 'Получен ключ', gameRef: kyrgyzGame);
          }
        },
       image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[3] = AnswerForDialog(text: 'Доброй дороги', answers: ['Спасибо'], answerNumbers: [3],isEnd: true,image: 'assets/tiles/sprites/dialogIcons/azura.png');
    dialogs[4] = AnswerForDialog(text: 'Молодец, что забрал мои вещи', answers: ['...'], answerNumbers: [4],isEnd: true,image: 'assets/tiles/sprites/dialogIcons/azura.png');
  }
}