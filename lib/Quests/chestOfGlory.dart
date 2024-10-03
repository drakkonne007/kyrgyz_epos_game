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
    minusInInventar(game);
    game.setQuestState('chestOfGlory',14,true, '', false);
    createText(text: success, gameRef: game);
  }
}


class ChestOfGlory extends Quest
{
  ChestOfGlory(super.kyrgyzGame,{super.currentState, super.isDone})
  {
    name = 'Сундук старика';
    needInventar = true;
    id = 'chestOfGlory';
    dialogs[0] = AnswerForDialog(
        text: "Привет, я видел здесь тебя много раз, и ты всегда был радостным, что случилось?",
        answers: ["На меня напали по пути сюда и отобрали все мои вещи"],
        answerNumbers: [1],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[1] = AnswerForDialog(
        text: "Какой ужас. Давно у нас такого не было. Спасибо, что рассказал. Я могу тебе немного помочь.",
        answers: ["..."],
        answerNumbers: [2],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[2] = AnswerForDialog(
        text: "Я давно уже живу в деревне и занимаюсь промыслом, но у меня остались прошлые ненужные пожитки. Зелья и прочее",
        answers: ["..."],
        answerNumbers: [10],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );

    dialogs[10] = AnswerForDialog(
      text: "Ты можешь взять сундук возле верхней стены, хочешь?",
      answers: ["Да", "Нет"],
      answerNumbers: [12, 11],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
      onAnswer: (answer){
        desc = 'Можно взять зелья из сундука ремесленника';
      },
    );
    dialogs[11] = AnswerForDialog(
        text: "Ну, смотри сам...",
        answers: ["..."],
        answerNumbers: [10],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[12] = AnswerForDialog(
        text: "Хорошо, вот тебе ключ от него. Мне то добро уже не надо. Я уже давно живу в деревне и занимаюсь промыслом",
        answers: ["Спасибо!"],
        answerNumbers: [13],
        isEnd: true,
        onAnswer: (answer){
          if(answer == 13){
            kyrgyzGame.playerData.addToInventar(InventarType.item, 'keyForChestOfGlory');
            createText(text: 'Получен ключ', gameRef: kyrgyzGame);
          }
          desc = 'Я получил ключ от старика в деревне. Надо найти сундук где-то вверху возле юрты';
        },
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[13] = AnswerForDialog(text: 'Доброй дороги', answers: ['Спасибо'], answerNumbers: [13],isEnd: true,image: 'assets/tiles/sprites/dialogIcons/azura.png');
    dialogs[14] = AnswerForDialog(text: 'Молодец, что забрал мои вещи', answers: ['...'], answerNumbers: [14],isEnd: true,image: 'assets/tiles/sprites/dialogIcons/azura.png');
  }
}