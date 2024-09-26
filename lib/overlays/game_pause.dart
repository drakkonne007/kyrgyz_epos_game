

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:game_flame/kyrgyz_game.dart';

class GamePause extends StatelessWidget
{
  static const id = 'GamePause';
  final KyrgyzGame _game;
  GamePause(this._game, {super.key});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: (){
              _game.doGameHud();
            },
            child:const Text('Продолжить',softWrap: false,),
          ),
          ElevatedButton(
            onPressed: () async{
              await _game.saveGame();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Сохранено'), duration: Duration(seconds: 2),));
            },
            child: const Text('Сохранить'),
          ),
          ElevatedButton(
            onPressed: () async{
              await _game.loadGame(0);
              await _game.loadNewMap();
              _game.resumeEngine();
            },
            child: const Text('Загрузить'),
          ),
          ElevatedButton(
            onPressed: () async{
              await _game.saveFirstGame(true, 0);
              await _game.loadGame(0);
              await _game.loadNewMap();
              _game.resumeEngine();
            },
            child: const Text('Новая игра'),
          ),
          ElevatedButton(
            onPressed: (){
              _game.doBuyMenu();
            },
            child: const Text('Настройки'),
          ),
          ElevatedButton(
            onPressed: (){
              exit(0);
            },
            child: const Text('Exit'),),
        ],
      ),
    );
  }}