import 'package:game_flame/Quests/chestOfGlory.dart';
import 'package:game_flame/Quests/startGame.dart';
import 'package:game_flame/Quests/startGameOrc.dart';
import 'package:game_flame/kyrgyz_game.dart';

class AnswerForDialog
{
  AnswerForDialog({required this.text,required this.answers,required this.answerNumbers,required this.isEnd, this.onAnswer, required this.image, this.desc});
  String text;
  String image;
  List<String> answers;
  List<int> answerNumbers;
  bool isEnd;
  String? desc;
  Function(int answer)? onAnswer;
}


class Quest
{
  static const List<String> allQuests = [
    'buy',
    'chestOfGlory',
    'templeDungeon',
    'startGame',
    'startGameOrc',
    'startGameKuznec',
    'startGameOlder',
    'startGameValanor'
  ];

  Map<int, AnswerForDialog> dialogs = {};
  int currentState = 0;
  String id = '';
  KyrgyzGame kyrgyzGame;
  bool isDone = false;
  String name = '';
  String desc = '';
  bool needInventar = false;

  static Quest questFromName(KyrgyzGame game, String name)
  {
    switch(name){
      case 'chestOfGlory': return ChestOfGlory(game);
      case 'templeDungeon': return Quest(game);
      case 'startGame': return StartGame(game);
      case 'startGameOrc' : return StartGameOrc(game);
      case 'startGameKuznec' : return StartGameKuznec(game);
      case 'startGameOlder' : return StartGameOlder(game);
      case 'startGameValanor' : return StartGameTorgovecValanor(game);
      default: return ChestOfGlory(game);
    }
  }

  Quest(this.kyrgyzGame, {this.currentState = 0, this.isDone = false});

  AnswerForDialog getAnswer()
  {
    return dialogs[currentState]!;
  }

  void changeState(int newState)
  {
    print('changeState');
    print(newState);
    print(isDone);
    print(desc);
    print(needInventar);
    kyrgyzGame.setQuestState(id, newState, isDone, desc, needInventar);
  }
}



