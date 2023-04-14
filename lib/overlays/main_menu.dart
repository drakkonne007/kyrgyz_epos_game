

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/abstract_game.dart';
import 'package:game_flame/kyrgyz_game.dart';

class MainMenu extends StatelessWidget
{
  static const id = 'mainMenu';
  AbstractGame _game;
  MainMenu(this._game);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          FloatingActionButton(
            onPressed: (){
              _game.overlays.remove(id);
              _game.add(KyrgyzGame());
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