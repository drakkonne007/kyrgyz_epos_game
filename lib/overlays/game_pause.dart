

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/health_bar.dart';
import 'package:game_flame/overlays/joysticks.dart';

class GamePause extends StatelessWidget
{
  static const id = 'GamePause';
  KyrgyzGame _game;
  GamePause(this._game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: (){
              _game.showOverlay(overlayName: OrthoJoystick.id,isHideOther: true);
              _game.showOverlay(overlayName: HealthBar.id);
              _game.resumeEngine();
            },
            child:const Text('Продолжить',softWrap: false,),
          ),
          ElevatedButton(
              onPressed: (){
                _game.overlays.remove(id);
                _game.loadNewMap('tiles/map/firstMap2.tmx');
                _game.resumeEngine();
              },
            child: const Text('Загрузить'),
          ),
          ElevatedButton(
            onPressed: (){

            },
            child: const Text('Настройки'),
          ),
          ElevatedButton(
            onPressed: (){

            },
            child: const Text('Exit'),),
        ],
      ),
    );
  }}