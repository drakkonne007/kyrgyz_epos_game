import 'package:path/path.dart';




class AnswerForDialog
{
  AnswerForDialog({required this.text,required this.answers,required this.answerNumbers,required this.isEnd});
  String text;
  List<String> answers;
  List<int> answerNumbers;
  bool isEnd;
}


abstract class Quest
{
    Map<int, AnswerForDialog> dialogs = {};
    int currentState = 0;
    String id = '';

    Quest()
    {
      currentState = 0;
    }

    AnswerForDialog getAnswer()
    {
      return dialogs[currentState]!;
    }

    void changeState(int newState)
    {
      currentState = newState;
    }
}

class ChestOfGlory extends Quest
{
  ChestOfGlory()
  {
    id = 'chestOfGlory';
    dialogs[0] = AnswerForDialog(
      text: "Путник, ты можешь взять сундук сверху, хочешь?",
      answers: ["Да", "Нет"],
      answerNumbers: [1, 0],
      isEnd: false
    );
    dialogs[2] = AnswerForDialog(
      text: "О, молодец, с правильным решением!)",
      answers: ["Ок"],
      answerNumbers: [3],
      isEnd: true
    );
    dialogs[4] = AnswerForDialog(
        text: "Ну, смотри сам",
        answers: ["Хорошо"],
        answerNumbers: [0],
        isEnd: true
    );
    dialogs[3] = AnswerForDialog(text: 'Доброй дороги', answers: ['Спасибо'], answerNumbers: [3],isEnd: true);
  }
}

