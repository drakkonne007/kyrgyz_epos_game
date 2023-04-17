

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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: (){
              _game.overlays.remove(id);
              _game.loadNewMap('tiles/map/firstMap2.tmx');
            },
            child:Text('Продолжить',softWrap: false,),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: (){
              _game.overlays.remove(id);
              _game.loadNewMap('tiles/map/firstMap3.tmx');
            },
            child: Text('Новая игра'),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: (){

            },
            child: Text('Загрузить'),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: (){

            },
            child: Text('Настройки'),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: (){

            },
            child: Text('Exit'),),
        ],
      ),
    );
  }}