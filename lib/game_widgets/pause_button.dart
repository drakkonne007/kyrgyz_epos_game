

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/game_pause.dart';

class PauseButton extends StatelessWidget
{
  final KyrgyzGame _game;
  const PauseButton(this._game);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: (){
          _game.pauseEngine();
          _game.startPause();
        }, icon: const Icon(Icons.pause_presentation),
    );
  }

}