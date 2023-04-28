

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:game_flame/gen/strings.g.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/gen/strings.g.dart';

class MainMenu extends StatelessWidget
{
  static const id = 'mainMenu';
  KyrgyzGame _game;
  MainMenu(this._game, {super.key});

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
            child: Text(context.t.newGame),
          ),
          const SizedBox(height: 10,),
          ElevatedButton(
            onPressed: (){

            },
            child: Text(context.t.loadGame),
          ),
          const SizedBox(height: 10,),
          ElevatedButton(
            onPressed: (){
              if(LocaleSettings.currentLocale != AppLocale.ru) {
                LocaleSettings.setLocale(AppLocale.ru);
              }else{
                LocaleSettings.setLocale(AppLocale.kg);
              }
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