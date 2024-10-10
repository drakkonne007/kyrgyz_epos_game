

import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/abstracts/quest.dart';
import 'package:game_flame/components/RenderText.dart';

class StartGameOrc extends Quest {
  StartGameOrc(super.kyrgyzGame, {super.currentState, super.isDone}) {
    name = 'Вождь орков Забранок';
    needInventar = true;
    id = 'startGameOrc';
    desc = 'Интересно, насколько силён этот вождь и что сможет мне рассказать';
    dialogs[1] = AnswerForDialog(
        text: 'Привет, воин. Я вождь Забранок. Как тебя зовут?',
        answers: ['Меня зовут ${kyrgyzGame.playerData.playerName}'],
        answerNumbers: [2],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[2] = AnswerForDialog(
        text: 'Хорошее имя! Я орк, а значит не люблю много разговаривать.',
        answers: ['Чем вы занимаетесь в деревне?','Вы все воины?'],
        answerNumbers: [3,4],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[3] = AnswerForDialog(
        text: 'В деревне мы как правило занимаемся охотой. Мы любим охоту.',
        answers: ['Вы все воины?'],
        answerNumbers: [4],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[4] = AnswerForDialog(
        text: 'Есть и маги. Магия течёт в наших жилах давно. Некоторые могут её использовать',
        answers: ['Вы можете научить меня ей?'],
        answerNumbers: [5],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[5] = AnswerForDialog(
        text: 'Ты не можешь её выучить - ты человек. Но можешь торговать у нас в деревне',
        answers: ['Спасибо, я пойду', 'А есть ли какие-нибудь задания для воина по типу меня?'],
        answerNumbers: [6,8],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[7] = AnswerForDialog(
        text: 'Привествую снова тебя, воин!',
        answers: ['Спасибо, я пойду', 'А есть ли какие-нибудь задания для воина по типу меня?'],
        answerNumbers: [6,8],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[6] = AnswerForDialog(
        text: 'Да будет следовать Солнце с тобой по пути',
        answers: ['...'],
        answerNumbers: [7],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[8] = AnswerForDialog(
        text: 'Да, тут рядом с нами никак не хочет уходить толпа гоблинов. Мы их можем убить. Но хотели бы потешиться и посмотреть как это сделаешь ты',
        answers: ['Звучит не очень'],
        answerNumbers: [9],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[9] = AnswerForDialog(
        text: 'Да нет, нам нравится смотреть на кровь врагов. Нам понравится твоё представление. Но чтобы ты точно не думал, что я тебя обманываю - я научу тебя использовать наши колодцы жизни',
        answers: ['Что это за колодцы?','Как они выглядят?','Как их использовать?'],
        answerNumbers: [16,16,17],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[16] = AnswerForDialog(
        text: 'Это чаши с красным или белым соком. Красный сок даёт небывалую регенерацию жизненных сил, а серебрянный сок пополняет твои физические и магические силы',
        answers: ['Как их использовать?'],
        answerNumbers: [17],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[17] = AnswerForDialog(
        text: 'Подойти и сказать аррргхунОа. Ударение на О!',
        answers: ['Понял. Спасибо! Это мне сильно поможет!'],
        answerNumbers: [10],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          desc = 'Надо убить всех гоблинов справа от орков';
          kyrgyzGame.playerData.canShrines = true;
          createText(text: 'Теперь ты можешь использовать древние колодцы орков', gameRef: kyrgyzGame);
          needInventar = true;
          isDone = false;
          changeState(answer);
        }
    );
    dialogs[10] = AnswerForDialog(
        text: 'Что там с мерзкими гоблинами?',
        answers: ['Пока ещё живы', 'Я всех убил'],
        answerNumbers: [10,12],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer)async {
          if(answer == 10){
            kyrgyzGame.doGameHud();
          }
          if(answer == 12){
            for(final cur in [2855,2862,2863,2856,2859,2864,2856,2858,2861]){
              var answ = await kyrgyzGame.dbHandler.getItemStateFromDb(cur,kyrgyzGame.gameMap.currentGameWorldData!.nameForGame);
              if(!answ.used){
                kyrgyzGame.setQuestState(name: id,state: 13,isDone:  false,desc:  desc,needInventar:  false);
                return;
              }
            }
            kyrgyzGame.setQuestState(name:id,state: 14,isDone:  false,desc:  desc,needInventar:  false);
          }
        }
    );
    dialogs[13] = AnswerForDialog(
        text: 'Да вот же они прям видны, бегают живые. Приходи когда убьёшь',
        answers: ['Хорошо'],
        answerNumbers: [10],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[14] = AnswerForDialog(
        text: 'Даааа, мы видели. Это было зрелищно, их было много. Классно. Держи всякие зелья и мои старые перчатки. Они всё равно лучше чем у тебя',
        answers: ['Спасибо!'],
        answerNumbers: [15],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          desc = 'Дела с орками идут неплохо';
          kyrgyzGame.playerData.addLevel(6000);
          createText(text: 'Получено 6000 опыта', gameRef: kyrgyzGame);
          itemFromName('gold200').getEffect(kyrgyzGame);
          itemFromName('hpFull').getEffect(kyrgyzGame);
          itemFromName('hpBig').getEffect(kyrgyzGame);
          itemFromName('hpFull').getEffect(kyrgyzGame);
          itemFromName('hpBig').getEffect(kyrgyzGame);
          itemFromName('hpFull').getEffect(kyrgyzGame);
          itemFromName('hpBig').getEffect(kyrgyzGame);
          itemFromName('gloves20').getEffect(kyrgyzGame);
          changeState(answer);
        }
    );
    dialogs[15] = AnswerForDialog(
      text: 'Ты стал нашим другом. Это большая ответственность. Ты не должен будешь предавать нас, иначе ты заплатишь за это кровью.',
      answers: ['Хорошо'],
      answerNumbers: [18],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[18] = AnswerForDialog(
        text: 'Ты стал нашим другом. Это большая ответственность. Ты не должен будешь предавать нас, иначе ты заплатишь за это кровью.',
        answers: ['Хорошо','Есть ли ещё задания?'],
        answerNumbers: [18,19],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          if(answer == 18){
            kyrgyzGame.doGameHud();
          }
        }
    );
    dialogs[19] = AnswerForDialog(
      text: 'Справа подальше есть одна заброшенная бывшая наша шахта. Называем мы её Радок. Пора бы её заново восстановить',
      answers: ['В чём сложность?'],
      answerNumbers: [20],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[20] = AnswerForDialog(
      text: 'Там появились сильные огры пока нас не было. Их не очень много, но было бы неплохо, если бы ты их убил.',
      answers: ['Почему именно я?'],
      answerNumbers: [21],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[21] = AnswerForDialog(
        text: 'Почему бы нет. Ты всегда будешь получать награды за выполнение заданий. Таким образом я расширяю свою армию. Хотя бы даже на несколько дней',
        answers: ['Разумно, и вроде не очень сложно'],
        answerNumbers: [22],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          desc = 'Разобраться с горами в заброшенных копях';
          changeState(answer);
        }
    );
    dialogs[22] = AnswerForDialog(
        text: 'Тогда в добрый путь! Аргххх!',
        answers: ['аррргхунОа','Я уже разобрался с ограми'],
        answerNumbers: [22, 24],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer) async{
          if (answer == 22) {
            kyrgyzGame.doGameHud();
          }else{
            var answ = await kyrgyzGame.dbHandler.getItemStateFromDb(2889,kyrgyzGame.gameMap.currentGameWorldData!.nameForGame);
            if(!answ.used){
              kyrgyzGame.setQuestState(name: id,state:  23,isDone:  false,desc:  desc,needInventar:  false);
              return;
            }
          }
        }
    );
    dialogs[23] = AnswerForDialog(
      text: 'Как минимум один ещё остался. Я чую его запах.',
      answers: ['Проверю'],
      answerNumbers: [22],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[24] = AnswerForDialog(
      text: 'Я в тебе не сомневался. Там же есть ещё и колоец красного сока. Надеюсь ты им воспользовался',
      answers: ['Да', 'Нет'],
      answerNumbers: [25,26],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[25] = AnswerForDialog(
      text: 'Я рад. Приятно видеть, что твои слова понимают',
      answers: ['Я нашёл странный амулет синего цвета'],
      answerNumbers: [27],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[26] = AnswerForDialog(
      text: 'Зря. Не забывай про такие колодцы.',
      answers: ['Я нашёл странный амулет синего цвета'],
      answerNumbers: [27],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[27] = AnswerForDialog(
        text: 'Ага... Это не из нашего мира, это людское. Отнеси опытному мастеру, может он что-то умеет. Я в первый раз такое вижу',
        answers: ['Хорошо, спасибо'],
        answerNumbers: [28],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          kyrgyzGame.playerData.addLevel(2000);
          createText(text: 'Получено 2000 опыта', gameRef: kyrgyzGame);
          kyrgyzGame.setQuestState(name: 'startGameKuznec',state: 35, isDone:  false,desc: 'Поговорить с кузнецом насчёт амулета',needInventar:  true);
          needInventar = false;
          isDone = false;
          changeState(answer);
        }
    );
    dialogs[28] = AnswerForDialog(
      text: 'Удачи тебе в пути, воин. Мне понадобится твоя помощь, но дальше',
      answers: ['Хорошо, спасибо'],
      answerNumbers: [28],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[29] = AnswerForDialog(
      text: 'Узнал, что за амулет?',
      answers: ['Да, оказывается его вставляют в доспех для уклонения'],
      answerNumbers: [29],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
      onAnswer: (answer){
        if(!kyrgyzGame.playerData.canDash){
          if(kyrgyzGame.playerData.money.value < 2000){
            currentState = 30;
          }else{
            currentState = 31;
          }
        }else{
          currentState = 35;
        }
        changeState(currentState);
      }
    );
    dialogs[30] = AnswerForDialog(
      text: 'Почему ещё не поставил себе?',
      answers: ['Не хватает денег'],
      answerNumbers: [32],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[32] = AnswerForDialog(
      text: 'Вот, возьми тогда 200 золотых. Немного помогу тебе. Приходи когда улучшишь доспехи - я дам тебе ключ от шахты. Там много всего интересного',
      answers: ['Спасибо! Я этого не забуду!'],
      answerNumbers: [33],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
      onAnswer: (answer){
        itemFromName('gold200').getEffect(kyrgyzGame);
      }
    );
    dialogs[33] = AnswerForDialog(
      text: 'Приходи когда сделаешь амулет',
      answers: ['Хорошо'],
      answerNumbers: [33],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[31] = AnswerForDialog(
      text: 'Почему ещё не поставил себе?',
      answers: ['Пока не хочу'],
      answerNumbers: [34],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[34] = AnswerForDialog(
      text: 'Зря, ты станешь намного сильнее. Приходи когда улучшишь доспехи - я дам тебе ключ от шахты. Там много всего интересного',
      answers: ['Хорошо'],
      answerNumbers: [33],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[35] = AnswerForDialog(
      text: 'Ого, я вижу тот синий амулет у тебя в доспехах. Значит ты стал сильнее. Теперь можно отправить тебя в более сложные места.',
      answers: ['Наверное да'],
      answerNumbers: [36],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[36] = AnswerForDialog(
      text: 'В общем-то у меня сейчас нет особых заданий, но тебе будет интересно осмотреть нашу старую шахту. Мы через месяц сами туда пойдём, но там можно славно подраться. Держи ключ от неё',
      answers: ['Спасибо за помощь! Я этого не забуду!'],
      answerNumbers: [37],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
      onAnswer: (answer){
        itemFromName('keyForBigDungeon').getEffect(kyrgyzGame);
      }
    );
    dialogs[37] = AnswerForDialog(
      text: 'Ты мой друг, я твой друг. Аргххххар!',
      answers: ['Аргххххар!'],
      answerNumbers: [37],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
  }
}