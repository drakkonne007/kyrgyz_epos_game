
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/main_menu.dart';

class LanguageChooser extends StatelessWidget
{
  LanguageChooser(this._game);
  static const id = 'LanguageChooser';
  KyrgyzGame _game;

  List<Widget> getFlags(double width, double height)
  {
    String source = '';
    String locale = '';
    List<Widget> list = [];
    for(int i=0;i<3;i++){
      switch(i){
        case 0: source = 'assets/images/flags/kg.png'; locale = 'kg'; break;
        case 1: source = 'assets/images/flags/ru.png'; locale = 'ru'; break;
        case 2: source = 'assets/images/flags/uk.png'; locale = 'uk'; break;
      }
      list.add(
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(min(height, width)/6)),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.asset(source,
              width: width/4,
              height: height/3,
              fit: BoxFit.cover,),
            onPressed: (){
              _game.prefs.setString('locale', locale);
              close();
            }),
      );
      if(i != 2){
        list.add(const SizedBox(width:20));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:LayoutBuilder(
        builder: (context,constraints){
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: getFlags(constraints.maxWidth, constraints.maxHeight),
          );
        }
      )
    );
  }
  void close()
  {
    _game.overlays.remove(id);
    _game.overlays.add(MainMenu.id);
  }
}