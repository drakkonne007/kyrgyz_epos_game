import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/abstracts/quest.dart';
import 'package:game_flame/components/RenderText.dart';
//villageGrow

class VillageGrow extends Quest
{
  VillageGrow(super.kyrgyzGame, {super.currentState, super.isDone})
  {
    name = 'Помощь с посадкой';
    id = 'villageGrow';
    dialogs[0] = AnswerForDialog(
        text: 'О, тебе интересен огород. Не бросай меня здесь одного! Мне надо срочно полить землю от сорняков, а зелье кончилось',
        answers: ['Ну уж нет. Это не мои проблемы','И где мне его найти?'],
        answerNumbers: [1,5],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[1] = AnswerForDialog(
        text: 'О нет, мне придётся самому тогда идти за ним к торговцу у реки. А пока я буду ходить пройдёт день и тут надо ещё вскопать. Дай тогда мне хотя бы 200 золотых, чтобы я послал кого-нибудь',
        answers: ['Ты издеваешься?', 'Ладно, вот 200 золотых', 'Я сам схожу'],
        answerNumbers: [2,6,20],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          if(answer == 6){
            if(kyrgyzGame.playerData.money.value >= 200){
              kyrgyzGame.playerData.money.value -= 200;
              currentState = 7;
              itemFromName('timerGonecForSornyakPoison').getEffectFromInventar(kyrgyzGame);
              isDone = true;
              needInventar = false;
              changeState(currentState);
            }
          }
        }
    );
    dialogs[2] = AnswerForDialog(
      text: 'Нет, но всем надо кушать. Ну как хочешь. Если сходишь - я приготовлю для тебя 10 слабых зелий. И зелье невидимости',
      answers: ['Нет времени', 'Уговорил'],
      answerNumbers: [3,20],
      isEnd: false,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[5] = AnswerForDialog(
        text: 'Оно уже купленное лежит в лавке на реке. Рядом ещё большая нога стоит. Люди говорят - это наш бог Крипитис её там поставил',
        answers: ['Нет времени', 'Уговорил'],
        answerNumbers: [1,20],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          if(answer == 1){
            kyrgyzGame.doGameHud();
          }
        }
    );
    dialogs[7] = AnswerForDialog(
      text: 'Благодарю тебя! Ты правда очень помог. Отправлю за зельем кого-нибудь из села.',
      answers: ['Да не за что'],
      answerNumbers: [7],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[8] = AnswerForDialog(
      text: 'Мне принесли зелье. Теперь наконец можно работать спокойно! Ещё раз спасибо!',
      answers: ['Всегда рад помочь!'],
      answerNumbers: [8],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[6] = AnswerForDialog(
        text: 'У тебя же нет 200 золотых. Может сходишь сам?',
        answers: ['Нет времени', 'Уговорил'],
        answerNumbers: [3,20],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );

    dialogs[3] = AnswerForDialog(
      text: 'Ох уж времена настали. Чтоб тебя съели орки на ужин в пещере. Тьфу.',
      answers: ['...'],
      answerNumbers: [4],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[4] = AnswerForDialog(
        text: 'Может всё-таки сходишь?',
        answers: ['Да', 'Нет'],
        answerNumbers: [20,4],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          if(answer == 4){
            kyrgyzGame.doGameHud();
          }
        }
    );
    dialogs[20] = AnswerForDialog(
      text: 'Хвала Крипитису! Принеси зелье, у лавки, что возле реки. А потом приходи через пару дней за своими зельями',
      answers: ['Хорошо'],
      answerNumbers: [21],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[21] = AnswerForDialog(
        text: 'Ты принёс зелье от сорняков?',
        answers: ['Сейчас, проверю сумку'],
        answerNumbers: [22],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          if(kyrgyzGame.playerData.itemInventar.containsKey('sornyakPoison')){
            kyrgyzGame.playerData.itemInventar.remove('sornyakPoison');
            itemFromName('timerInvisibleFlask').getEffectFromInventar(kyrgyzGame);
            isDone = false;
            needInventar = true;
            currentState = 23;
            desc = 'Дожаться готовности зелий';
            changeState(currentState);
          }
        }
    );
    dialogs[22] = AnswerForDialog(
      text: 'Я уже вижу, что не принёс. Ну ладно, я пока здесь всё копаю и пересаживаю. Поторопись, если можешь',
      answers: ['Удачи в работе!'],
      answerNumbers: [21],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[23] = AnswerForDialog(
      text: 'Как замечательно. Буду поливать. Четыре руки всегда лучше, чем две! За зельями приходи позже.',
      answers: ['Удачи в работе!'],
      answerNumbers: [23],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
    dialogs[24] = AnswerForDialog(
      text: 'Привет. Твои зелья готовы!',
      answers: ['Спасибо'],
      answerNumbers: [25],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
      onAnswer: (answer){
        itemFromName('hpBig').getEffect(kyrgyzGame);
        itemFromName('hpBig').getEffect(kyrgyzGame);
        itemFromName('hpBig').getEffect(kyrgyzGame);
        itemFromName('hpBig').getEffect(kyrgyzGame);
        itemFromName('hpBig').getEffect(kyrgyzGame);
        itemFromName('hpBig').getEffect(kyrgyzGame);
      }
    );
    dialogs[25] = AnswerForDialog(
      text: 'Люблю когда всё цветёт',
      answers: ['Крипитис в помощь!'],
      answerNumbers: [25],
      isEnd: true,
      image: 'assets/tiles/sprites/dialogIcons/azura.png',
    );
  }
}

class SkinTrader extends Quest
{
  SkinTrader(super.kyrgyzGame, {super.currentState, super.isDone})
  {
    name = 'Сбор урожая';
    id = 'skinTrader';
    dialogs[0] = AnswerForDialog(
        text: 'Здравствуй, воин!',
        answers: ['Здравствуй. Как тебя зовут?'],
        answerNumbers: [1],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[1] = AnswerForDialog(
        text: 'Меня зовут Нордвиг',
        answers: ['А меня зовут ${kyrgyzGame.playerData.playerName}'],
        answerNumbers: [2],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[2] = AnswerForDialog(
        text: 'Приятно познакомиться!',
        answers: ['Что ты делаешь в деревне?', 'Много ли человек в деревне?'],
        answerNumbers: [3,7],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[7] = AnswerForDialog(
        text: 'В деревне не очень много людей, но хватает. Кто-то следит за садом, кто-то выращивает овощи. Кто-то ловит рыбу.',
        answers: ['...'],
        answerNumbers: [8],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[8] = AnswerForDialog(
        text: 'Я делаю юрты из шкур животных. Так что если ты хочешь обменять шкуры диких быков - я куплю их все по 50 золотых за штуку.',
        answers: ['Понятно.'],
        answerNumbers: [4],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[3] = AnswerForDialog(
        text: 'Я делаю юрты из шкур животных. Так что если ты хочешь обменять шкуры диких быков - я куплю их все по 50 золотых за штуку.',
        answers: ['Понятно.','Много ли людей в деревне?'],
        answerNumbers: [4,6],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[6] = AnswerForDialog(
        text: 'В деревне не очень много людей, но хватает. Кто-то следит за садом, кто-то выращивает овощи. Кто-то ловит рыбу.',
        answers: ['Понятно.'],
        answerNumbers: [4],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[4] = AnswerForDialog(
        text: 'Хочешь обменять шкуры на деньги?',
        answers: ['Да', 'Нет'],
        answerNumbers: [5,4],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          if(answer == 5){
            if(kyrgyzGame.playerData.itemInventar.containsKey('bullSkin')){
              int count = kyrgyzGame.playerData.itemInventar['bullSkin']!;
              kyrgyzGame.playerData.money.value += count * 50;
              kyrgyzGame.playerData.itemInventar.remove('bullSkin');
              currentState = 4;
              changeState(currentState);
              createText(text: 'Получено ${count * 50} золотых', gameRef: kyrgyzGame);
              kyrgyzGame.doGameHud();
            }
          }else{
            kyrgyzGame.doGameHud();
          }
        }
    );
    dialogs[5] = AnswerForDialog(
        text: 'Приходи когда будут шкуры',
        answers: ['Хорошо'],
        answerNumbers: [4],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
  }
}

class GiveApple extends Quest
{
  GiveApple(super.kyrgyzGame,{super.currentState, super.isDone})
  {
    name = 'Сбор урожая';
    id = 'giveApple';
    dialogs[0] = AnswerForDialog(
        text: 'Здравствуй путник! Как поживаешь? Погода замечательная!',
        answers: ['Да, погода отличная! Такие деньки масое то для путешествий.'],
        answerNumbers: [1],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[1] = AnswerForDialog(
        text: 'Поможешь мне собрать урожай. Это будет не сложно. А я дам тебе 200 золотых. Сроки немного поджимают, надо скорее всё продавать на рынке пока спелое',
        answers: ['Да','Нет'],
        answerNumbers: [20,7],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          if(answer == 7){
            kyrgyzGame.doGameHud();
          }
        }
    );
    dialogs[7] = AnswerForDialog(
        text: 'Может всё-такие поможешь? Пока погода хорошая.',
        answers: ['Да','Нет'],
        answerNumbers: [20,7],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          if(answer == 7){
            kyrgyzGame.doGameHud();
          }
        }
    );
    dialogs[20] = AnswerForDialog(
        text: 'Отлично. В нашем саду растут яблоки. Сад вниз и справа от деревни. Принеси мне 30 яблок',
        answers: ['Хорошо'],
        answerNumbers: [30],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          desc = 'Собрать 30 яблок в саду';
          isDone = false;
          needInventar = true;
          changeState(answer);
        }
    );
    dialogs[30] = AnswerForDialog(
        text: 'Принёс яблоки?',
        answers: ['Как сказать...'],
        answerNumbers: [30],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          if(kyrgyzGame.playerData.itemInventar.containsKey('villageApple') && kyrgyzGame.playerData.itemInventar['villageApple']! >= 30){
            kyrgyzGame.playerData.itemInventar.remove('villageApple');
            itemFromName('gold200').getEffect(kyrgyzGame);
            createText(text: '200 золотых получено', gameRef: kyrgyzGame);
            currentState = 40;
            changeState(currentState);
          }else{
            currentState = 60;
            changeState(currentState);
          }
        }
    );
    dialogs[40] = AnswerForDialog(
        text: 'Отлично. Торговля пойдёт ещё лучше!',
        answers: ['Рад помочь!'],
        answerNumbers: [50],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          isDone = true;
          needInventar = false;
          changeState(answer);
        }
    );
    dialogs[50] = AnswerForDialog(
        text: 'Удачи в пути, друг!',
        answers: ['И тебе!'],
        answerNumbers: [50],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[60] = AnswerForDialog(
        text: 'Недостаточно яблок ты собрал, мой друг',
        answers: ['Приду попозже'],
        answerNumbers: [30],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
  }
}

class GiveFish extends Quest
{
  GiveFish(super.kyrgyzGame, {super.currentState, super.isDone})
  {
    name = 'Ловля рыбы';
    id = 'giveFish';
    dialogs[0] = AnswerForDialog(
        text: 'Привествую тебя! Отгадаешь загадку?',
        answers: ['Да', 'Нет'],
        answerNumbers: [1,6],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[1] = AnswerForDialog(
        text: 'Без окон без дверей, полна горница людей',
        answers: ['Огурец', 'Капуста', 'Персик'],
        answerNumbers: [2,3,3],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[2] = AnswerForDialog(
        text: 'Огооо, правильно! Я обожаю загадки, и когда их кто-то отгадывает',
        answers: ['...'],
        answerNumbers: [5],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[3] = AnswerForDialog(
        text: 'Нет, это неправильный ответ. Правильный ответ - это ОГУРЕЦ',
        answers: ['Эх'],
        answerNumbers: [4],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[4] = AnswerForDialog(
        text: 'Да, я бы дал тебе 50 золотых. Ну да ладно. Поможешь мне собрать рыбу? Я дам 100 золотых',
        answers: ['Да', 'Нет'],
        answerNumbers: [20,5],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          if(answer == 5){
            kyrgyzGame.doGameHud();
          }
        }
    );
    dialogs[6] = AnswerForDialog(
        text: 'Как знаешь, я бы дал тебе 50 золотых. Я обожаю загадки. Ну да ладно. Поможешь мне собрать рыбу? Я дам 100 золотых',
        answers: ['Да', 'Нет'],
        answerNumbers: [20,5],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          if(answer == 5){
            kyrgyzGame.doGameHud();
          }
        }
    );
    dialogs[5] = AnswerForDialog(
        text: 'Поможешь мне собрать рыбу? Я дам 100 золотых',
        answers: ['Да', 'Нет'],
        answerNumbers: [20,5],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          if(answer == 5){
            kyrgyzGame.doGameHud();
          }
        }
    );
    dialogs[20] = AnswerForDialog(
        text: 'Отлично, вниз по дороге от деревне ты найдёшь реку. Сегодня утром был сильный шторм. Должно быть много рыбы выбросилось на берег. Собери 7 штук, пока она свежая',
        answers: ['Хорошо'],
        answerNumbers: [21],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          desc = 'Собрать рыбу на берегу реки';
          isDone = false;
          needInventar = true;
          changeState(answer);
        }
    );
    dialogs[21] = AnswerForDialog(
        text: 'Собрал?',
        answers: ['Щас посмотрю'],
        answerNumbers: [21],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          if(kyrgyzGame.playerData.itemInventar.containsKey('villageFish') && kyrgyzGame.playerData.itemInventar['villageFish']! >= 7){
            kyrgyzGame.playerData.itemInventar.remove('villageFish');
            itemFromName('gold100').getEffect(kyrgyzGame);
            currentState = 22;
            isDone = true;
            needInventar = false;
            changeState(answer);
          }else{
            currentState = 29;
            changeState(currentState);
          }
        }
    );
    dialogs[29] = AnswerForDialog(
        text: 'Эх, не СОБ-РАЛ... Буду ждать, а то помру от голода',
        answers: ['Рад помочь'],
        answerNumbers: [21],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[22] = AnswerForDialog(
        text: 'Хохо, молодец! Теперь я два дня буду объедаться вкусной рыбой. Вот твои 100 золотых',
        answers: ['Рад помочь'],
        answerNumbers: [23],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          isDone = true;
          needInventar = false;
          changeState(answer);
        }
    );
    dialogs[23] = AnswerForDialog(
        text: 'Загадки-загадки, люблю я загадки',
        answers: ['Я заметил'],
        answerNumbers: [23],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );

    dialogs[24] = AnswerForDialog(
        text: 'Я нашёл ещё одну загадку',
        answers: ['Не интересно', 'Рассказывай'],
        answerNumbers: [24,25],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer) {
          if (answer == 24) {
            kyrgyzGame.doGameHud();
          }
        }
    );
    dialogs[25] = AnswerForDialog(
        text: 'В лесу без огня котел кипит.',
        answers: ['Солнечный зайчик', 'Муравейник', 'Дупло с совой'],
        answerNumbers: [26,27,26],
        isEnd: false,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
    dialogs[27] = AnswerForDialog(
        text: 'Как догадался. Ха-ха. Вот тебе 100 золотых',
        answers: ['В следующий раз повезёт больше.'],
        answerNumbers: [28],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          itemFromName('gold100').getEffect(kyrgyzGame);
          isDone = true;
          needInventar = false;
          changeState(answer);
        }
    );
    dialogs[26] = AnswerForDialog(
        text: 'Не правильно. Это - муравейник. Вот так дела. Ха-ха.',
        answers: ['В следующий раз повезёт больше.'],
        answerNumbers: [28],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png',
        onAnswer: (answer){
          isDone = true;
          needInventar = false;
          changeState(answer);
        }
    );
    dialogs[28] = AnswerForDialog(
        text: 'Пчёлы гудут\nВ поле идут\nС поля идут\nМедок несут',
        answers: ['...'],
        answerNumbers: [28],
        isEnd: true,
        image: 'assets/tiles/sprites/dialogIcons/azura.png'
    );
  }
}