

import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/gen/strings.g.dart';
import 'package:game_flame/kyrgyz_game.dart';

class MainMenu extends StatelessWidget
{
  static const id = 'MainMenu';
  KyrgyzGame _game;
  MainMenu(this._game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child:
        Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child:ElevatedButton(
                    clipBehavior: Clip.antiAlias,
                    onPressed: (){
                      _game.overlays.remove(id);
                      _game.loadNewMap('test.tmx');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                    ),
                    child:
                    const Stack(
                      fit: StackFit.passthrough,
                      alignment: Alignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/gui/wood_button.png'),
                          fit: BoxFit.fill,
                        ),
                        Text('Продолжить',softWrap: false,),
                      ],
                    )
                ),
              ),
              const SizedBox(height: 10,),
              Expanded(
                child:
                ElevatedButton(
                    clipBehavior: Clip.antiAlias,
                    onPressed: (){
                      _game.overlays.remove(id);
                      _game.loadNewMap('test.tmx');
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                    ),
                    child:
                    Stack(
                      fit: StackFit.passthrough,
                      alignment: Alignment.center,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/gui/wood_button.png'),
                          fit: BoxFit.fill,
                        ),
                        Text(context.t.newGame),
                      ],
                    )
                ),
              ),
              const SizedBox(height: 10,),
              Expanded(
                child:
                ElevatedButton(
                    clipBehavior: Clip.antiAlias,
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                    ),
                    child:
                    Stack(
                      fit: StackFit.passthrough,
                      alignment: Alignment.center,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/gui/wood_button.png'),
                          fit: BoxFit.fill,
                        ),
                        Text(context.t.loadGame),
                      ],
                    )
                ),
              ),
              const SizedBox(height: 10,),
              Expanded(
                  child:
                  ElevatedButton(
                      clipBehavior: Clip.antiAlias,
                      onPressed: (){
                        if(LocaleSettings.currentLocale != AppLocale.ru) {
                          LocaleSettings.setLocale(AppLocale.ru);
                        }else{
                          LocaleSettings.setLocale(AppLocale.kg);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                      ),
                      child:
                      const Stack(
                        fit: StackFit.passthrough,
                        alignment: Alignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/images/gui/wood_button.png'),
                            fit: BoxFit.fill,
                          ),
                          Text('Настройки'),
                        ],
                      )
                  )
              ),
              const SizedBox(height: 10,),
              Expanded(
                child:
                ElevatedButton(
                    clipBehavior: Clip.antiAlias,
                    onPressed: (){
                      exit(0);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                    ),
                    child:
                    const Stack(
                      fit: StackFit.passthrough,
                      alignment: Alignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/gui/wood_button.png'),
                          fit: BoxFit.fill,
                        ),
                        Text('Exit')
                      ],
                    )
                ),
              )
            ]
        )
    );
  }
}