

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/kyrgyz_game.dart';

class MainMenu extends StatelessWidget
{
  static const id = 'mainMenu';
  KyrgyzGame _game;
  MainMenu(this._game);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          FloatingActionButton(
            onPressed: (){
              _game.overlays.remove(id);
              _game.loadNewMap('tiles/map/firstMap2.tmx');
            },
            child: Text('Продолжить'),
          ),
          FloatingActionButton(
            onPressed: (){

            },
            child: Text('Новая игра'),
          ),
          FloatingActionButton(
            onPressed: (){

            },
            child: Text('Загрузить'),
          ),
          FloatingActionButton(
            onPressed: (){

            },
            child: Text('Настройки'),
          ),
          FloatingActionButton(
            onPressed: (){

            },
            child: Text('Exit'),),
        ],
      ),
    );
  }}