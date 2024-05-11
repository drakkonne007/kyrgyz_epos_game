

import 'package:flutter/material.dart';
import 'package:game_flame/kyrgyz_game.dart';

class PauseButton extends StatelessWidget
{
  final KyrgyzGame _game;
  const PauseButton(this._game, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: (){
          _game.startPause();
        }, icon: const Icon(Icons.pause_presentation),
    );
  }

}