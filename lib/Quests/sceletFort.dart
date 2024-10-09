

import 'package:game_flame/abstracts/quest.dart';
import 'package:game_flame/components/RenderText.dart';

class SceletFort extends Quest
{
  SceletFort(super.kyrgyzGame,{super.currentState, super.isDone})
  {
    name = 'Вождь в темнице возле форта';
    id = 'sceletFort';
    dialogs[0] = AnswerForDialog(
        text: "Ааааааргххххх, человееееееек!!!! Ну и мерзость!",
        answers: ["..."],
        answerNumbers: [1],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[1] = AnswerForDialog(
        text: "Давно тут не было таких как ты. Один только больной маг сидит у себя запертый. Но я вижу ты воин.",
        answers: ['Что это за деревня?','Как тебя зовут?','Что это за маг?'],
        answerNumbers: [2,6,10],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[10] = AnswerForDialog(
        text: "Да забрёл сюда один маг 93 года назад. Сказал что мы ничего не понимаем в магии крови и напился прямо из реки. Четыре дня лежад без сознания.",
        answers: ['Что было дальше?', '93 года назад?'],
        answerNumbers: [11,13],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[13] = AnswerForDialog(
        text: "Орким живут в два раза длинне вас. А он после этого видимо тоже стал жить намного дольше.",
        answers: ['Ясно, что было дальше?'],
        answerNumbers: [11],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[11] = AnswerForDialog(
        text: "Потом он ожил, но ещё неделю еле ходил. Мы думали, конечно, что не выживет. Потом он попросил нас обучить его как правильно использовать магию крови",
        answers: ['А что за магия крови?'],
        answerNumbers: [12],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[12] = AnswerForDialog(
        text: "Но он нам показался ненормальным и мы ему отказали. Он обиделся и ушёл. Ха-ха-ха арргггхх. Человек, что сказать",
        answers: ['Ясно. Как тебя зовут?'],
        answerNumbers: [6],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );

    dialogs[2] = AnswerForDialog(
        text: "Наши отцы шаманы поклонялись тёмной магии крови, которая родилась в стенах старого храма Ландрон. За это их выгнали в подземелья",
        answers: ['А что за магия крови?'],
        answerNumbers: [3],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[3] = AnswerForDialog(
        text: "В кровавых реках остужались выкованные рунические кольца, благодаря чему они получали возможность создавать магические сферы разрушения.",
        answers: ['Почему ваших предков выгнали за это?'],
        answerNumbers: [4],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[4] = AnswerForDialog(
        text: "Потому что орки признают лишь силу. Но для нас это устаревшая вещь. Магию не слабее копья или кулака",
        answers: ['А какие от использования побочные действия?'],
        answerNumbers: [5],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[5] = AnswerForDialog(
        text: "Никаких. Но как уже сказал орки крайне однообразный народ. Тяжело укоренить что-то новое. Поэтому мы не общаемся с орками снаружи.",
        answers: ['Как тебя зовут?'],
        answerNumbers: [6],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );

    dialogs[6] = AnswerForDialog(
        text: "Меня зовут вождь Ваарнакс. Но мне интересно твоё имя, я запомню твой запах.",
        answers: ['Как вы добываете еду для себя?', 'Что ещё есть в этих местах?'],
        answerNumbers: [7,8],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[7] = AnswerForDialog(
        text: "Иногда ловим что-то в реках крови, иногда едим залетающих сиюда птиц, но чащё спускаемся вниз, где есть всякие крысы и мелкие грызуны. Их мы жарим",
        answers: ['Что ещё есть в этом подземелье?'],
        answerNumbers: [8],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[8] = AnswerForDialog(
        text: "Да ничего, конечно. Ловушки, крысы, скелеты. Сверху был наш форт для обороны. Но его захватили скелеты.",
        answers: ['Ясно', 'Помочь вам освободить форт?'],
        answerNumbers: [9,9],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[9] = AnswerForDialog(
        text: "Если освободишь форт то я дам немного наших зелий магии крови. Но денег у нас нет",
        answers: ['Понял, всего хорошего'],
        answerNumbers: [9],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[20] = AnswerForDialog(
        text: "Ох ты, ты освободил наш форт. Спасибо! Если ты найдёшь магическое кольцо крови, принеси его нам, я научу его использовать",
        answers: ['Понял, всего хорошего'],
        answerNumbers: [21],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          kyrgyzGame.playerData.addLevel(15000);
          createText(text: 'Получено 15000 опыта', gameRef: kyrgyzGame);
        }
    );
    dialogs[21] = AnswerForDialog(
        text: "Если найдёшь кольцо крови - приходи",
        answers: ['Хорошо'],
        answerNumbers: [21],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
  }
}