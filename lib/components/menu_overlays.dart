

import 'package:flutter/material.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/main.dart';

class DeadMenu extends StatelessWidget
{
  KyrgyzGame _game;
  DeadMenu(this._game);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
        child: Column(
          children: [
            Text('Вы погибли. Повторить?'),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: (){
                    _game.restartFromCheckpoint();
                    _game.resumeEngine();
                  },
                  child: Text('Да'),),
                FloatingActionButton(
                  onPressed: (){
                    _game.restartFromCheckpoint();
                    _game.resumeEngine();
                  },
                  child: Text('Нет'),)
              ],
            )
          ],
        )
    );
  }
}

class HealthBar extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomRight,
        child: Text('${OrthoPLayerVals.health}',
        textScaleFactor: 3,)
    );
  }
}