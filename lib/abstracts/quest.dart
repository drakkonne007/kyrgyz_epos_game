import 'package:game_flame/Quests/chestOfGlory.dart';
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
    'templeDungeon'
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
      default: return ChestOfGlory(game);
    }
  }



  Quest(this.kyrgyzGame, {this.currentState = 0, this.isDone = false});

  AnswerForDialog getAnswer()
  {
    return dialogs[currentState]!;
  }

  void changeState(int newState, String? desc)
  {
    kyrgyzGame.setQuestState(id, newState, isDone, desc);
  }
}



