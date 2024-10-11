import 'package:game_flame/Quests/chestOfGlory.dart';
import 'package:game_flame/Quests/mageInDungeon.dart';
import 'package:game_flame/Quests/nezarykVillage.dart';
import 'package:game_flame/Quests/smallVillageQuests.dart';
import 'package:game_flame/Quests/startGame.dart';
import 'package:game_flame/Quests/startGameOrc.dart';
import 'package:game_flame/Quests/valanorBrother.dart';
import 'package:game_flame/Quests/sceletFort.dart';
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
    'startGameValanor',
    'valanorBrother',
    'parlamentusBoss',
    'sceletFort',
    'mageInDungeon'
    ,'giveApple'
    ,'giveFish'
    ,'skinTrader'
    ,'villageGrow'
    ,'brevnoOrc'
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
      case 'dragonKiller' : return DragonKiller(game);
      case 'brevnoOrc'    :   return BrevnoOrc(game);
      case 'villageGrow'  : return VillageGrow(game);
      case 'skinTrader'  :   return SkinTrader(game);
      case 'giveFish'   : return GiveFish(game);
      case 'giveApple' : return GiveApple(game);
      case 'chestOfGlory': return ChestOfGlory(game);
      case 'startGame': return StartGame(game);
      case 'startGameOrc' : return StartGameOrc(game);
      case 'startGameKuznec' : return StartGameKuznec(game);
      case 'startGameOlder' : return StartGameOlder(game);
      case 'startGameValanor' : return StartGameValanor(game);
      case 'valanorBrother' : return ValanorBrother(game);
      case 'mageInDungeon'  : return MageInDungeon(game);
      case 'sceletFort'     : return SceletFort(game);
      default: return Quest(game);
    }
  }

  Quest(this.kyrgyzGame, {this.currentState = 0, this.isDone = false});

  AnswerForDialog getAnswer()
  {
    return dialogs[currentState]!;
  }

  void changeState(int newState)
  {
    kyrgyzGame.setQuestState(name:id,state: newState,isDone: isDone,desc: desc,needInventar: needInventar);
  }
}



