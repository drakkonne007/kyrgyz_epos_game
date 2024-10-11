import 'package:game_flame/abstracts/quest.dart';

class DragonKiller extends Quest
{
  DragonKiller(super.kyrgyzGame, {super.currentState, super.isDone})
  {
    name = 'Драконоборец';
    id = 'dragonKiller';
    dialogs[0] = AnswerForDialog(
        text: 'Чмок-чмок. Хрх. Превет, потник!',
        answers: ['Я не потник!', 'Привет'],
        answerNumbers: [1, 3],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
  }
}

class BrevnoOrc extends Quest
{
  BrevnoOrc(super.kyrgyzGame,{super.currentState, super.isDone})
  {
    name = 'Обмен брёвен на деньги';
    id = 'brevnoOrc';
    dialogs[0] = AnswerForDialog(
        text: 'Чмок-чмок. Хрх. Превет, потник!',
        answers: ['Я не потник!','Привет'],
        answerNumbers: [1,3],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[1] = AnswerForDialog(
      text: 'Я плохо говорить по человек',
      answers: ['Понял, извини'],
      answerNumbers: [3],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[3] = AnswerForDialog(
        text: 'Ты сдесь гулять. Я чинить телеги и деревянные ящики. Строить вёдра. Если будет дерево - приноси, я дам тебе за это 10 золотых.',
        answers: ['Хорошо'],
        answerNumbers: [4],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[4] = AnswerForDialog(
        text: 'Особеннно много брёвен на лесопилках. Одна находится внизу и слева. Далеко, но там много дерева.',
        answers: ['Хорошо'],
        answerNumbers: [5],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          if(!kyrgyzGame.playerData.itemInventar.containsKey('brevno')){
            kyrgyzGame.doGameHud();
          }
        }
    );
    dialogs[5] = AnswerForDialog(
        text: 'Хочешь менять бревно золото?',
        answers: ['Да', 'Нет'],
        answerNumbers: [6,5],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          if(answer == 6){
            if(kyrgyzGame.playerData.itemInventar.containsKey('brevno')){
              int count = kyrgyzGame.playerData.itemInventar['brevno'] ?? 0;
              kyrgyzGame.playerData.money.value += count * 10;
              kyrgyzGame.playerData.itemInventar.remove('brevno');
              currentState = 5;
              kyrgyzGame.doGameHud();
            }
          }else{
            kyrgyzGame.doGameHud();
          }
        }
    );
    dialogs[6] = AnswerForDialog(
        text: 'Нет брёвен - нет золота. Хрф. Я любить дерево. Дерево красивый',
        answers: ['Приду позже'],
        answerNumbers: [5],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
  }
}