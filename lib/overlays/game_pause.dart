

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
              _game.resumeEngine();
            },
            child:const Text('Продолжить',softWrap: false,),
          ),
          ElevatedButton(
            onPressed: () async{
              _game.resumeEngine();
              await _game.loadNewMap();
              // await _game.loadNewMap();
            },
            child: const Text('Загрузить'),
          ),
          SizedBox(
            width: 300,
            child: TextFormField(
              maxLines: 1,
              controller: _controller,
            ),
          ),
          ElevatedButton(
            onPressed: (){
              _game.gameMap.mapNode!.createLiveObj(null,null,null,cheatName: _controller.text);
            },
            child: const Text('Создать'),
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