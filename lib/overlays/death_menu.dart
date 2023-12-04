import 'package:flutter/material.dart';
import 'package:game_flame/kyrgyz_game.dart';

class DeathMenu extends StatelessWidget
{
  static const id = 'DeathMenu';
  final KyrgyzGame _game;
  const DeathMenu(this._game);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Вы погибли. Повторить?'),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    _game.loadNewMap('tiles/map/firstMap2.tmx');
                    // _game.showOverlay(overlayName: OrthoJoystick.id,isHideOther: true);
                    // _game.showOverlay(overlayName: HealthBar.id);
                    _game.resumeEngine();
                  },
                  child: const Text('Да'),),
                ElevatedButton(
                  onPressed: (){
                    _game.gameMap.smallRestart();
                    _game.doGameHud();
                    // _game.showOverlay(overlayName: HealthBar.id);
                    _game.resumeEngine();
                  },
                  child: const Text('Нет'),)
              ],
            )
          ],
        )
    );
  }
}
