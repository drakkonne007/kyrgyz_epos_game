

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/game_widgets/joysticks.dart';
import 'package:game_flame/game_widgets/pause_button.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/game_widgets/health_bar.dart';

class GameHud extends StatelessWidget
{
  const GameHud(this._game, {Key? key}) : super(key: key);
  final KyrgyzGame _game;
  static const String id = 'GameHud';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
        fit: StackFit.passthrough,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: HealthBar(_game),
          ),
          Align(
            alignment: Alignment.topRight,
            child: PauseButton(_game),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: OrthoJoystick(120, _game),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: (){
                _game.gameMap.orthoPlayer?.startHit();
              },
              child: const Icon(Icons.password),
            ),
          )
        ]
      )
    );
  }


}