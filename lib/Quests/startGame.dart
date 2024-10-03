import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/abstracts/quest.dart';
import 'package:game_flame/components/RenderText.dart';
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
    game.setQuestState('chestOfGlory',4,true, '', false);
    createText(text: success, gameRef: game);
  }
}


class StartGame extends Quest //Разговор с охранником
    {
  StartGame(super.kyrgyzGame,{super.currentState, super.isDone})
  {
    name = 'Моя судьба';
    needInventar = true;
    id = 'startGame';
    desc = 'Боже, как меня только угораздило попасть к этим бандитам. Первый случай за много лет. Надо скорее в деревню пока бандиты не решили вернуться';
    dialogs[0] = AnswerForDialog( //Охранник в деревне
        text: "Охохооо, что случилось, ты попал на дикого орка, или упал об ветки? Ахах",
        answers: ["Упал об ветки", "На меня напали бандиты"],
        answerNumbers: [1, 2],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[1] = AnswerForDialog(
        text: "Ахахах, ну да, конечно. Я же вижу что тебя побили. Кто это был?",
        answers: ["На меня напали бандиты"],
        answerNumbers: [2],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[2] = AnswerForDialog(
        text: "Огоо, сколько лет никто не нападал на путников на этом пути. Мда.",
        answers: ["..."],
        answerNumbers: [3],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[3] = AnswerForDialog(
        text: "Ну у тебя есть два варианта. Пойти к старейшине, или к кузнецу. Старейшина может соберёт людей тебе помочь вернуть награбленное. А кузнец раньше был воином",
        answers: ["Пойду к старейшине","Пойду к кузнецу"],
        answerNumbers: [4,5],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          desc = 'Найти помощь и оповестить деревню что опять появились бандиты';
        }
    );
    dialogs[4] = AnswerForDialog(
        text: "Ну смотри, не факт, что он тебе поможет. Но к кузнецу тоже зайди обязательно",
        answers: ["Спасибо"],
        answerNumbers: [6],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          kyrgyzGame.setQuestState('startGameOlder', 1, false, null,true);
          kyrgyzGame.setQuestState('startGameKuznec', 1, false,null,true);
        }
    );
    dialogs[5] = AnswerForDialog(
        text: "Ну смотри, не факт, что он тебе поможет. Но к старейшине тоже зайди обязательно",
        answers: ["Спасибо"],
        answerNumbers: [6],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          isDone = true;
          kyrgyzGame.setQuestState('startGameOlder', 1, false, null,true);
          kyrgyzGame.setQuestState('startGameKuznec', 1, false, null,true);
        }
    );
    dialogs[6] = AnswerForDialog(
        text: "Давай, иди лечись",
        answers: ["..."],
        answerNumbers: [6],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
  }
}

class StartGameOlder extends Quest //Разговор со старейшиной
    {
  StartGameOlder(super.kyrgyzGame,{super.currentState, super.isDone})
  {
    name = 'Поговорить со старейшиной';
    needInventar = true;
    id = 'startGameOlder';
    desc = 'Надо рассказать, что здесь появились бандиты';
    dialogs[1] = AnswerForDialog( //Охранник в деревне
        text: "Приветствую тебя, путник. Выглядишь не очень хорошо",
        answers: ["..."],
        answerNumbers: [2],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[2] = AnswerForDialog( //Охранник в деревне
        text: "Кто тебе сказал придти ко мне?",
        answers: ["Часовой"],
        answerNumbers: [3],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[3] = AnswerForDialog( //Охранник в деревне
        text: "Кто тебе сказал придти ко мне?",
        answers: ["Часовой. На меня напали бандиты на вашей дороги"],
        answerNumbers: [4],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[4] = AnswerForDialog( //Охранник в деревне
        text: "...",
        answers: ["..."],
        answerNumbers: [5],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[5] = AnswerForDialog( //Охранник в деревне
        text: "Ясно, не очень конечно хорошие новости. Это первый случай на этой дороге?",
        answers: ["Да"],
        answerNumbers: [6],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[6] = AnswerForDialog( //Охранник в деревне
        text: "Понятно. Не очень приятно, мы будем предупреждать об этом торговцев, но один случай это не показатель.",
        answers: ["Может прямо сейчас пойти за бандитами толпой и наказать их?"],
        answerNumbers: [7],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[7] = AnswerForDialog( //Охранник в деревне
        text: "Идея конечно интересная, но мы очень давно перешли на осёдлую жизнь, поэтому я не хочу рисковать своими людьми. Они давно не держали оружие.",
        answers: ["..."],
        answerNumbers: [8],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[8] = AnswerForDialog( //Охранник в деревне
        text: "Я скажу кузнецу, чтобы он помог тебе в этом деле. Сам он останется здесь, но даст тебе хороший меч и поможет первое время встать на ноги",
        answers: ["Спасибо"],
        answerNumbers: [9],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          isDone = true;
          kyrgyzGame.setQuestState('startGameKuznec', 20, false, null,true);
        }
    );
    dialogs[9] = AnswerForDialog( //Охранник в деревне
        text: "Доброй дороги",
        answers: ["Спасибо"],
        answerNumbers: [9],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
  }
}

class StartGameKuznec extends Quest //Разговор с кузнецом
    {
  StartGameKuznec(super.kyrgyzGame, {super.currentState, super.isDone}) {
    name = 'Поговорить с кузнецом';
    needInventar = true;
    id = 'startGameKuznec';
    desc = 'Надо попросить помощи. Как бывший воин он должен помочь';
    dialogs[1] = AnswerForDialog(
        text: "Здравствуй, путник. Что хотел купить?",
        answers: ["Пока ничего, на меня напали бандиты и отобрали все мои деньги и вещи."],
        answerNumbers: [2],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[2] = AnswerForDialog(
        text: "Ого, скверно. Но я просто кузнец и торговец. Так что если ты ничего купить не хочешь, то я не могу помочь тебе",
        answers: ["Но ты же в прошлом был воином, я думал воины помогают таким же как они"],
        answerNumbers: [3],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[3] = AnswerForDialog(
        text: "Так-то оно так, конечно. Но у меня уже и жена, и дети. Я уже не воин. Так что - извини. Если что-то захочешь купить - подходи к моей лавке",
        answers: ["Понял, спасибо"],
        answerNumbers: [4],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          desc = 'Видимо надо найти к кузнецу другой подход';
        }
    );
    dialogs[4] = AnswerForDialog(
      text: "Если что-то хочешь купить - подходи к прилавку",
      answers: ["Ага"],
      answerNumbers: [4],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );

    dialogs[20] = AnswerForDialog(
      text: "Таааак, мне передали просьбу старейшины помочь тебе. Я вижу у тебя сломанный меч, вот, держи меч получше и пару зелей, тоже пригодятся",
      answers: ["Спасибо"],
      answerNumbers: [21],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[21] = AnswerForDialog(
      text: "Предлагаю тебе работать на меня какое-то время, потому что бандиты бандитами, а вокруг вообще начинают происходить странные вещи.",
      answers: ["..."],
      answerNumbers: [22],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[22] = AnswerForDialog(
      text: "Тут говорят появились какие-то ожившие скелеты, которых не было 500 лет. Ещё говорят о каком-то талисмане, который даёт возможность мгновенно перемещаться. В общем это так. Просто вспомнил",
      answers: ["..."],
      answerNumbers: [23],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[23] = AnswerForDialog(
      text: "Для начала было бы классно тебе принести мне мои вещи, которые остались на прошлом нашем поселении. Мы тогда жили в старых развалинах. Там было легко охранять нашу деревню",
      answers: ["..."],
      answerNumbers: [24],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[24] = AnswerForDialog(
      text: "Но потом случилось землетрясение и из трещин в земле начали вылазить сверепые быки с молотами. Мы в испуге всё побросали и ушли с того места. А ведь там осталось много нашего добра",
      answers: ["Ага, я понял к чему ты клонишь"],
      answerNumbers: [25],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[25] = AnswerForDialog(
      text: "Да да да. Вот надо бы принести мой родовой молот обратно ко мне. Место ты сразу узнаешь, как выйдешь из деревни иди налево. Мы оградили то место деревянным забором",
      answers: ["..."],
      answerNumbers: [26],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[26] = AnswerForDialog(
        text: "Вход в старые развалины будет снизу. Осторожно, быки довольно сильны.",
        answers: ["Понял, принесу молот"],
        answerNumbers: [26],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (int answer) {
          kyrgyzGame.setQuestState('startGameValanor', 1, false, null,false);
          desc = 'Принести молот кузнецу в деревне';
        }
    );
  }
}

class StartGameTorgovecValanor extends Quest //Разговор с кузнецом
    {
  StartGameTorgovecValanor(super.kyrgyzGame, {super.currentState, super.isDone}) {
    name = 'Странник Валанор';
    id = 'startGameValanor';
    dialogs[1] = AnswerForDialog(
        text: "Стой, тебя послали принести молот из старых развалин. Но я там только что был. Я опытный следопыт. Меня зовут Валанор",
        answers: [
          "Ага, а меня зовут ${kyrgyzGame.playerData.playerName}",
        ],
        answerNumbers: [2],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[2] = AnswerForDialog(
        text: "Молот забрали скелеты далеко в трещины вниз. А вход запечатали душами быков. Тебе придётся убить всех быков, чтобы пройти вниз.",
        answers: [
          'Чёрт, плохо дело',
          'Насколько сильны скелеты?',
          'Насколько сильны быки?'
        ],
        answerNumbers: [6,3,4],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[6] = AnswerForDialog(
        text: "И не говори.",
        answers: [
          'Насколько сильны скелеты?',
          'Насколько сильны быки?'
        ],
        answerNumbers: [3,4],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );

    dialogs[3] = AnswerForDialog(
        text: "Скелеты не очень сильные. Но внизу их довольно много. Встречаются так же маги. Ты можешь с ними справиться, но вот быки...",
        answers: [
          'А что быки?',
          'Что ты предлагаешь делать?'
        ],
        answerNumbers: [4,5],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[4] = AnswerForDialog(
        text: "Быки очень сильны. У них толстая кожа, из-за чего довольно высокая броня и очень большой боевой болот.",
        answers: [
          'Что ты предлагаешь делать?',
          'А что скелеты?'
        ],
        answerNumbers: [5,3],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[5] = AnswerForDialog(
        text: "Я бы придумал пока пойти к вождю племени орков",
        answers: [
          'Почему к нему?'
        ],
        answerNumbers: [15],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[15] = AnswerForDialog(
        text: "Он очень любит воинов и даёт им щедрые награды за выполения боевых задач. Так же он поможет тебе с боевыми навыками, расскажет про древние обелиски, которые дадут тебе дополнительный опыт",
        answers: [
          '...'
        ],
        answerNumbers: [16],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[16] = AnswerForDialog(
        text: "Научит пользоваться колодцами крови для сильной регенерации. Да и денег тоже даст. Иди сначала к нему",
        answers: [
          'Звучит неплохо. Получается лучше идти к нему?'
        ],
        answerNumbers: [17],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[17] = AnswerForDialog(
        text: "Да, лучше иди к нему. Кузнец живёт нормально и без своего молота, так что подождёт ещё. А ты хотя бы не умрёшь таким молодым)",
        answers: [
          'Ну что ж, ладно, спасибо за советы!'
        ],
        answerNumbers: [18],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          needInventar = false;
          kyrgyzGame.setQuestState('startGameOrc', 1, false, null,true);
        }
    );
    dialogs[18] = AnswerForDialog(
        text: "Давай, ты много путешествуешь, поэтому мне нравишься. Удачи в пути!",
        answers: [
          'Спасибо'
        ],
        answerNumbers: [18],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
  }
}