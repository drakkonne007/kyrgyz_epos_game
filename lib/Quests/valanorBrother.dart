import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/abstracts/quest.dart';
import 'package:game_flame/components/RenderText.dart';

class ValanorBrother extends Quest //Разговор с кузнецом
    {
  ValanorBrother(super.kyrgyzGame, {super.currentState, super.isDone}) {
    name = 'Брат Валанора';
    id = 'valanorBrother';
    dialogs[1] = AnswerForDialog(
        text: "О, приветсвую вас, я вам очень рад. Валанор, тебе удалось найти инструменты для тележки?",
        answers: [
          "Валанор: да, удалось",
        ],
        answerNumbers: [2],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[2] = AnswerForDialog(
        text: "Это очень радует. Тебя сопровождал воин на всякий случай?",
        answers: [
          'Валанор: да, на него напали бандиты. Я подумал что лучше пойти вдвоём.'
        ],
        answerNumbers: [3],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[3] = AnswerForDialog(
        text: "Согласен с тобой. Воин, возьми себе эти 200 золотых и несколько зелий на силу",
        answers: [
          'Спасибо.'
        ],
        answerNumbers: [4],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer) {
          itemFromName('gold200').getEffect(kyrgyzGame);
          itemFromName('hpBig').getEffect(kyrgyzGame);
          itemFromName('hpBig').getEffect(kyrgyzGame);
          itemFromName('energyBig').getEffect(kyrgyzGame);
          itemFromName('energyBig').getEffect(kyrgyzGame);
        }
    );
    dialogs[4] = AnswerForDialog(
        text: "Здесь слева есть несколько поселений. Советую зайти к вождю орков. Его деревня сверху от дороги.",
        answers: [
          'Почему именно к нему?'
        ],
        answerNumbers: [5],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );

    dialogs[5] = AnswerForDialog(
        text: "Он очень любит воинов и даёт им щедрые награды за выполения боевых задач. Так же он поможет тебе с боевыми навыками, расскажет про древние обелиски, которые дадут тебе дополнительный опыт",
        answers: [
          '...'
        ],
        answerNumbers: [6],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[6] = AnswerForDialog(
        text: "Научит пользоваться колодцами крови для сильной регенерации. Да и денег тоже даст.",
        answers: [
          'Куда ещё можно пойти?',
          'Спасибо'
        ],
        answerNumbers: [7,10],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[7] = AnswerForDialog(
        text: "Сверху есть старый храм, должно быть там есть что-то интересное. Слева много других маленьких поселений. Люди там богатые",
        answers: [
          'Спасибо за информацию'
        ],
        answerNumbers: [10],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          kyrgyzGame.playerData.addLevel(3000);
          createText(text: 'Получено 3000 опыта', gameRef: kyrgyzGame);
          isDone = true;
          kyrgyzGame.setQuestState(name:  'startGameValanor',state:  16,isDone: true,desc: null,needInventar:  false);
          kyrgyzGame.setQuestState(name:  'startGameOrc',state:  1,isDone: false,desc: 'Узнать что может рассказать нам вождь орков',needInventar:  true);
          kyrgyzGame.gameMap.companionEnemy?.setCompanion(false);
        }
    );
    dialogs[10] = AnswerForDialog(
        text: "Всегда пожалуйста",
        answers: [
          '...'
        ],
        answerNumbers: [11],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          kyrgyzGame.playerData.addLevel(3000);
          createText(text: 'Получено 3000 опыта', gameRef: kyrgyzGame);
          isDone = true;
          kyrgyzGame.setQuestState(name: 'startGameValanor',state:  16,isDone:  true,desc:  null,needInventar:  false);
          kyrgyzGame.setQuestState(name: 'startGameOrc',state:  1,isDone:  false
              ,desc: 'Узнать что может рассказать нам вождь орков',needInventar:  true);
          kyrgyzGame.gameMap.companionEnemy?.setCompanion(false);
        }
    );
    dialogs[11] = AnswerForDialog(
        text: "Доброго пути",
        answers: [
          'Спасибо'
        ],
        answerNumbers: [11],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
  }
}