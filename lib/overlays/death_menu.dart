

import 'package:flutter/material.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/overlays/health_bar.dart';
import 'package:game_flame/overlays/joysticks.dart';

class DeathMenu extends StatelessWidget
{
  static const id = 'DeathMenu';
  KyrgyzGame _game;
  DeathMenu(this._game);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Вы погибли. Повторить?'),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    _game.loadNewMap('tiles/map/firstMap2.tmx');
                    _game.showOverlay(overlayName: OrthoJoystick.id,isHideOther: true);
                    _game.showOverlay(overlayName: HealthBar.id);
                    _game.resumeEngine();
                    OrthoPLayerVals.doNewGame();
                  },
                  child: Text('Да'),),
                ElevatedButton(
                  onPressed: (){
                    _game.gameMap?.smallRestart();
                    _game.showOverlay(overlayName: OrthoJoystick.id,isHideOther: true);
                    _game.showOverlay(overlayName: HealthBar.id);
                    _game.resumeEngine();
                    OrthoPLayerVals.doNewGame();
                  },
                  child: Text('Нет'),)
              ],
            )
          ],
        )
    );
  }
}
