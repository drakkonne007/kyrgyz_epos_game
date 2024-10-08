

import 'package:game_flame/abstracts/quest.dart';

class StartGameOrc extends Quest {
  StartGameOrc(super.kyrgyzGame, {super.currentState, super.isDone}) {
    name = 'Вождь орков Забранок';
    needInventar = true;
    id = 'startGameOrc';
    desc = 'Интересно, насколько силён этот вождь и что сможет мне рассказать';
    dialogs[1] = AnswerForDialog(
        text: 'Привет, воин. Как тебя зовут?',
        answers: ['Меня зовут ${kyrgyzGame.playerData.playerName}'],
        answerNumbers: [2],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[2] = AnswerForDialog(
        text: 'Хорошее имя! Я орк, а значит не люблю много разговаривать.',
        answers: ['Чем вы занимаетесь в деревне?',''],
        answerNumbers: [2],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
  }
}