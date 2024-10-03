

import 'package:game_flame/abstracts/quest.dart';

class StartGameOrc extends Quest {
  StartGameOrc(super.kyrgyzGame, {super.currentState, super.isDone}) {
    name = 'Вождь орков';
    needInventar = true;
    id = 'startGameOrc';
    desc = 'Интересно, насколько силён этот вождь и что сможет мне рассказать';
    dialogs[0] = AnswerForDialog(
        text: "Привет, я видел здесь тебя много раз, и ты всегда был радостным, что случилось?",
        answers: ["На меня напали по пути сюда и отобрали все мои вещи"],
        answerNumbers: [1],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
  }
}