import 'package:game_flame/Quests/chestOfGlory.dart';
import 'package:game_flame/kyrgyz_game.dart';

class AnswerForDialog
{
  AnswerForDialog({required this.text,required this.answers,required this.answerNumbers,required this.isEnd, this.onAnswer, required this.image});
  String text;
  String image;
  List<String> answers;
  List<int> answerNumbers;
  bool isEnd;
  Function(int answer)? onAnswer;
}


abstract class Quest
{
    Map<int, AnswerForDialog> dialogs = {};
    int currentState = 0;
    String id = '';
    KyrgyzGame kyrgyzGame;
    bool isDone = false;

    static Quest questFromName(KyrgyzGame game, String name)
    {
      switch(name){
        case 'chestOfGlory': return ChestOfGlory(game);
        default: return ChestOfGlory(game);
      }
    }

    static const List<String> allQuests = [
      'chestOfGlory',
    ];

    Quest(this.kyrgyzGame, {this.currentState = 0, this.isDone = false});

    AnswerForDialog getAnswer()
    {
      return dialogs[currentState]!;
    }

    void changeState(int newState)
    {
      currentState = newState;
      kyrgyzGame.dbHandler.setQuestState(id, currentState, isDone);
    }
}



