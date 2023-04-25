

import 'dart:io';

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
            child:const Text('Продолжить',softWrap: false,),
          ),
          const SizedBox(height: 10,),
          ElevatedButton(
            onPressed: (){
              _game.overlays.remove(id);
              _game.loadNewMap('tiles/map/firstMap2.tmx');
            },
            child: const Text('Новая игра'),
          ),
          const SizedBox(height: 10,),
          ElevatedButton(
            onPressed: (){

            },
            child: const Text('Загрузить'),
          ),
          const SizedBox(height: 10,),
          ElevatedButton(
            onPressed: (){

            },
            child: const Text('Настройки'),
          ),
          const SizedBox(height: 10,),
          ElevatedButton(
            onPressed: (){
                exit(0);
            },
            child: const Text('Exit'),),
        ],
      ),
    );
  }}