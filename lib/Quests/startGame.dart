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
    game.setQuestState(name: 'chestOfGlory',state: 4,isDone: true,needInventar: false);
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
          changeState(answer);
        }
    );
    dialogs[4] = AnswerForDialog(
        text: "Ну смотри, не факт, что он тебе поможет. Но к кузнецу тоже зайди обязательно",
        answers: ["Спасибо"],
        answerNumbers: [6],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          isDone = true;
          needInventar = false;
          kyrgyzGame.setQuestState(name: 'startGameOlder',state: 1,isDone:  false,needInventar:  true);
          kyrgyzGame.setQuestState(name: 'startGameKuznec',state: 1,isDone:  false,needInventar:  true);
          changeState(answer);
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
          needInventar = false;
          kyrgyzGame.setQuestState(name: 'startGameOlder',state: 1,isDone: false,needInventar: true);
          kyrgyzGame.setQuestState(name: 'startGameKuznec',state: 1,isDone: false,needInventar: true);
          changeState(answer);
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
        answerNumbers: [3],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    // dialogs[2] = AnswerForDialog( //Охранник в деревне
    //     text: "Кто тебе сказал придти ко мне?",
    //     answers: ["Часовой"],
    //     answerNumbers: [3],
    //     isEnd: false,
    //     image: 'assets/tiles/sprites/dialogIcons/azura.png'
    // );
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
          kyrgyzGame.setQuestState(name: 'startGameKuznec',state: 20,isDone: false, needInventar: true);
          changeState(answer);
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
          changeState(answer);
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
        onAnswer: (answer){
          kyrgyzGame.playerData.addLevel(2000);
          createText(text: 'Получено 2000 опыта', gameRef: kyrgyzGame);
          itemFromName('sword2').getEffect(kyrgyzGame);
          itemFromName('manaMedium').getEffect(kyrgyzGame);
          itemFromName('manaMedium').getEffect(kyrgyzGame);
          itemFromName('manaMedium').getEffect(kyrgyzGame);
          itemFromName('energyMedium').getEffect(kyrgyzGame);
          itemFromName('energyMedium').getEffect(kyrgyzGame);
          itemFromName('energyMedium').getEffect(kyrgyzGame);
          itemFromName('hpMedium').getEffect(kyrgyzGame);
          itemFromName('hpMedium').getEffect(kyrgyzGame);
          itemFromName('hpMedium').getEffect(kyrgyzGame);
        }
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
        answerNumbers: [27],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (int answer) {
          kyrgyzGame.setQuestState(name: 'startGameValanor',state: 1,isDone: false,needInventar:  false);
          desc = 'Принести молот кузнецу в деревне';
          kyrgyzGame.playerData.addLevel(1000);
          createText(text: 'Квест выполнен. Приключения начинаются. Добавлено 1000 опыта', gameRef: kyrgyzGame);
          changeState(answer);
        }
    );
    dialogs[27] = AnswerForDialog(
      text: "Вход в старые развалины будет снизу. Осторожно, быки довольно сильны.",
      answers: ["Понял, принесу молот"],
      answerNumbers: [27],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );

    //Это про получение умения делать дэш
    dialogs[35] = AnswerForDialog(
      text: "Привет, воин. Я думал тебя убили давно или ты сбежал в страхе перед быками.",
      answers: ["Они и вправду оказались сильными противниками. Но я нашёл в битвах этот амулет"],
      answerNumbers: [36],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[36] = AnswerForDialog(
        text: "Хммммм, выглядит знакомо. Погуляй немного, я пороюсь в записях. Должно что-то найтись",
        answers: ["Хорошо"],
        answerNumbers: [37],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          itemFromName('timerThinkAboutMedalion').getEffectFromInventar(kyrgyzGame);
        }
    );
    dialogs[37] = AnswerForDialog(
      text: "Хммммм, выглядит знакомо. Погуляй немного, я пороюсь в записях. Должно что-то найтись",
      answers: ["Хорошо"],
      answerNumbers: [37],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[38] = AnswerForDialog(
        text: "Таааак, ну я нашёл записи про этот амулет. Это амулет древних людей. Они тоже любили магию.",
        answers: ["Что он делает?"],
        answerNumbers: [39],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          desc = 'Сделать себе амулет в доспехах';
          changeState(answer);
        }
    );
    dialogs[39] = AnswerForDialog(
        text: "Он вставляется в доспехи и позволяет уворачиваться от атак противников. Я бы мог тебе поставить такое за 2000 золота в твой доспех",
        answers: ["Да это же грабёж чистой воды!", 'Согласен'],
        answerNumbers: [40,44],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
            isDone = false;
            needInventar = true;
            changeState(answer);
        }
    );

    dialogs[44] = AnswerForDialog(
        text: "Сделать тебе амулет?",
        answers: ["Да", 'Нет'],
        answerNumbers: [42,44],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer) {
          if (answer == 44) {
            kyrgyzGame.doGameHud();
          } else {
            if (kyrgyzGame.playerData.money.value >= 2000) {
              kyrgyzGame.playerData.canDash = true;
              createText(text: 'Теперь я могу уворачиваться от ударов свайпом влево и вправо', gameRef: kyrgyzGame);
              itemFromName('dashAmulet').getEffectFromInventar(kyrgyzGame);
              kyrgyzGame.playerData.money.value -= 2000;
            }else{
              kyrgyzGame.setQuestState(name: id, state: 45, isDone: false, needInventar: true);
            }
          }
        }
    );

    dialogs[45] = AnswerForDialog(
      text: "У тебя недостаточно денег",
      answers: ["..."],
      answerNumbers: [44],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );

    dialogs[40] = AnswerForDialog(
      text: "Ладно, за 1900. Больше скинуть не могу",
      answers: ["Ладно, пойдёт"],
      answerNumbers: [41],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );

    // onAnswer: (answer){
    //   if(kyrgyzGame.playerData.money.value >= 1900){
    //
    //   }
    // }
    dialogs[41] = AnswerForDialog(
        text: "Сделать тебе амулет?",
        answers: ["Да", 'Нет'],
        answerNumbers: [42,41],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer) {
          if (answer == 41) {
            kyrgyzGame.doGameHud();
          } else {
            if (kyrgyzGame.playerData.money.value >= 1900) {
              kyrgyzGame.playerData.canDash = true;
              createText(text: 'Теперь я могу уворачиваться от ударов свайпом влево и вправо', gameRef: kyrgyzGame);
              itemFromName('dashAmulet').getEffectFromInventar(kyrgyzGame);
              kyrgyzGame.playerData.money.value -= 1900;
            }else{
              kyrgyzGame.setQuestState(name: id, state: 43, isDone: false, needInventar: true);
            }
          }
        }
    );
    dialogs[42] = AnswerForDialog(
        text: "Вот теперь другое дело. Сделай свайп вправо и влево, чтобы делать уворот. Это тратит ману",
        answers: ['Спасибо'],
        answerNumbers: [42],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
      onAnswer: (answer){
          needInventar = true;
          desc = 'Принести молот из подземелий';
          isDone = false;
          changeState(answer);
      }
    );
    dialogs[43] = AnswerForDialog(
      text: "У тебя недостаточно денег",
      answers: ["..."],
      answerNumbers: [41],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
  }
}

class StartGameValanor extends Quest //Разговор с кузнецом
    {
  StartGameValanor(super.kyrgyzGame, {super.currentState, super.isDone}) {
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
        text: "Я бы предложил сопроводить меня к моему брату. У нас сломалась телега и купил инструменты. Я дам тебе за это денег и зелья",
        answers: [
          'Похоже, у меня нет особо выбора'
        ],
        answerNumbers: [15],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[15] = AnswerForDialog(
        text: "Ну, надо с чего-то начинать. Брат находится слева возле дороги через горы. Это самый край этого района",
        answers: [
          'Хорошо, пошли'
        ],
        answerNumbers: [15],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          kyrgyzGame.playerData.companion = 'humanValinor'; //2637
          kyrgyzGame.gameMap.allEnemies[2637]!.setCompanion(true);
          needInventar = true;
          isDone = false;
          desc = 'Отвести Валанора к его брату';
          kyrgyzGame.setQuestState(name: 'valanorBrother',state: 1,isDone: false,needInventar: false);
        }
    );
    dialogs[16] = AnswerForDialog(
      text: "Спасибо, что отвёл меня. Удачи в битвах.",
      answers: [
        'Спасибо'
      ],
      answerNumbers: [16],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
  }
}

// dialogs[15] = AnswerForDialog(
// text: "Он очень любит воинов и даёт им щедрые награды за выполения боевых задач. Так же он поможет тебе с боевыми навыками, расскажет про древние обелиски, которые дадут тебе дополнительный опыт",
// answers: [
// '...'
// ],
// answerNumbers: [16],
// isEnd: false,
// image: 'assets/tiles/sprites/dialogIcons/azura.png'
// );
// dialogs[16] = AnswerForDialog(
// text: "Научит пользоваться колодцами крови для сильной регенерации. Да и денег тоже даст. Иди сначала к нему",
// answers: [
// 'Звучит неплохо. Получается лучше идти к нему?'
// ],
// answerNumbers: [17],
// isEnd: false,
// image: 'assets/tiles/sprites/dialogIcons/azura.png'
// );
// dialogs[17] = AnswerForDialog(
// text: "Да, лучше иди к нему. Кузнец живёт нормально и без своего молота, так что подождёт ещё. А ты хотя бы не умрёшь таким молодым)",
// answers: [
// 'Ну что ж, ладно, спасибо за советы!'
// ],
// answerNumbers: [18],
// isEnd: true,
// image: 'assets/tiles/sprites/dialogIcons/azura.png',
// onAnswer: (answer){
// needInventar = false;
// kyrgyzGame.setQuestState('startGameOrc', 1, false, null,true);
// }
// );
// dialogs[18] = AnswerForDialog(
// text: "Давай, ты много путешествуешь, поэтому мне нравишься. Удачи в пути!",
// answers: [
// 'Спасибо'
// ],
// answerNumbers: [18],
// isEnd: true,
// image: 'assets/tiles/sprites/dialogIcons/azura.png'
// );
