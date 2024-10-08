import 'package:game_flame/abstracts/quest.dart';

class MageInDungeon extends Quest
{
  MageInDungeon(super.kyrgyzGame, {super.currentState, super.isDone})
  {
    name = 'Двинутый маг в подземелье';
    id = 'mageInDungeon';
    dialogs[0] = AnswerForDialog(
        text: 'А-ля ля ля ля. Привет, воин ${kyrgyzGame.playerData.playerName}. Как дела?',
        answers: [
          'Откуда ты знаешь моё имя?'
        ],
        answerNumbers: [1],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[1] = AnswerForDialog(
        text: 'О-хо-хо, я много чего знаю, а может тебе кажется, что я это знаю, а на самом деле я не знаю',
        answers: [
          'Ты кто?',
          'Что это за место?'
        ],
        answerNumbers: [2,7],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[2] = AnswerForDialog(
        text: 'Я маг отшельник. Я изучаю древнюю магию крови. Для этого вырыл источник крови у себя в комнате.',
        answers: [
          'Что такое магия крови?'
        ],
        answerNumbers: [3],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[3] = AnswerForDialog(
        text: 'Это древняя и очень могущественная магия. Но я полностью не знаю, как ей управлять.',
        answers: [
          'Что это за место?'
        ],
        answerNumbers: [4],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[4] = AnswerForDialog(
        text: 'Это моя обитель. На входы я поставил руны стены, для того чтобы порождения скелетов сюда не зашли. Но друзья проходить могут.',
        answers: [
          'Я же пока не твой друг!'
        ],
        answerNumbers: [5],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[5] = AnswerForDialog(
        text: 'Да, но и не враг ведь. Ладно, не мешай мне.',
        answers: [
          'Хорошо'
        ],
        answerNumbers: [6],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[6] = AnswerForDialog(
        text: 'Не мешай мне работать',
        answers: [
          'Хорошо'
        ],
        answerNumbers: [6],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[7] = AnswerForDialog(
        text: 'Это моя обитель. На входы я поставил руны стены, для того чтобы порождения скелетов сюда не зашли. Но друзья проходить могут',
        answers: [
          'Ты наверное сильный маг, раз живёшь в таком месте?'
        ],
        answerNumbers: [8],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[8] = AnswerForDialog(
        text: 'Я маг отшельник. Я изучаю древнюю магию крови. Для этого вырыл источник крови у себя в комнате.',
        answers: [
          'Что такое магия крови?'
        ],
        answerNumbers: [9],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[9] = AnswerForDialog(
        text: 'Это древняя и очень могущественная магия. Но я полностью не знаю, как ей управлять. А теперь не мешай работать. Тром-бом-бом.',
        answers: [
          'Хорошо'
        ],
        answerNumbers: [6],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
  }
}