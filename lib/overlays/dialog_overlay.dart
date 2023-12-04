

import 'package:flutter/material.dart';
import 'package:game_flame/kyrgyz_game.dart';

class GameDialog extends StatefulWidget
{
  const GameDialog(this._game, {Key? key}) : super(key: key);
  final KyrgyzGame _game;
  static const String id = 'GameDialog';

  @override
  State<GameDialog> createState() => _GameDialogState();
}

class _GameDialogState extends State<GameDialog> {

  int currentDialogState = 0;

  @override
  void initState() {
    currentDialogState = widget._game.playerData.currentDialog;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Container();
  }
}











class AnswerChooser extends StatelessWidget 
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  
}

