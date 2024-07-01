

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:game_flame/gen/strings.g.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/main.dart';
import 'package:game_flame/abstracts/compiller.dart';

TextStyle textStyle = const TextStyle(fontSize: 20, color: Colors.amber);
ButtonStyle bStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    padding: EdgeInsets.zero,
    shadowColor: Colors.brown,
    backgroundColor: Colors.transparent
);



class MainMenu extends StatelessWidget
{
  const MainMenu(this._game, {super.key});
  static const id = 'MainMenu';
  final KyrgyzGame _game;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints) {
      return Stack(
          fit: StackFit.passthrough,
          alignment: Alignment.center,
          children: [
            Image(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              image: const AssetImage('assets/images/mountain.webp'),
              fit: BoxFit.cover,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,),
                  Expanded(
                    child:ElevatedButton(
                        clipBehavior: Clip.antiAlias,
                        onPressed: ()async {
                          isNeedCopyInternal = true;
                          _game.overlays.remove(id);
                          await _game.loadNewMap();
                        },
                        style: bStyle,
                        child:
                        Stack(
                          fit: StackFit.passthrough,
                          alignment: Alignment.center,
                          children: [
                            const Image(
                              image: AssetImage('assets/images/gui/wood_button.png'),
                              fit: BoxFit.fill,
                            ),
                            Text('С ПРЕЛОАДОМ',softWrap: false,style: textStyle),
                          ],
                        )
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Expanded(
                    child:
                    ElevatedButton(
                        clipBehavior: Clip.antiAlias,
                        onPressed: () async{
                            _game.overlays.remove(id);
                            await _game.loadNewMap();
                        },
                        style: bStyle,
                        child:
                        Stack(
                          fit: StackFit.passthrough,
                          alignment: Alignment.center,
                          children: [
                            const Image(
                              image: AssetImage('assets/images/gui/wood_button.png'),
                              fit: BoxFit.fill,
                            ),
                            Text('БЕЗ ПРЕЛОАДА',style: textStyle),
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
                        style: bStyle,
                        child:
                        Stack(
                          fit: StackFit.passthrough,
                          alignment: Alignment.center,
                          children: [
                            const Image(
                              image: AssetImage('assets/images/gui/wood_button.png'),
                              fit: BoxFit.fill,
                            ),
                            Text(context.t.loadGame,style: textStyle),
                          ],
                        )
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Expanded(
                      child:
                      ElevatedButton(
                          clipBehavior: Clip.antiAlias,
                          onPressed: () async{
                            await precompileAll();
                            print('PRECOMPILE DONE!!!');
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Прекомпил сделан!!!'), duration: Duration(seconds: 2),));
                          },
                          style: bStyle,
                          child:
                          Stack(
                            fit: StackFit.passthrough,
                            alignment: Alignment.center,
                            children: [
                              const Image(
                                image: AssetImage('assets/images/gui/wood_button.png'),
                                fit: BoxFit.fill,
                              ),
                              Text('Запустить прекомпил',style: textStyle),
                            ],
                          )
                      )
                  ),
                  const SizedBox(height: 10,),
                  Expanded(
                      child:
                      ElevatedButton(
                          clipBehavior: Clip.antiAlias,
                          onPressed: () async{
                            await _game.dbHandler.createTable();
                            print('Обновили предметы в БД!!!');
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Обновили предметы в БД!!!'), duration: Duration(seconds: 2),));
                          },
                          style: bStyle,
                          child:
                          Stack(
                            fit: StackFit.passthrough,
                            alignment: Alignment.center,
                            children: [
                              const Image(
                                image: AssetImage('assets/images/gui/wood_button.png'),
                                fit: BoxFit.fill,
                              ),
                              Text('Рефреш предметов в БД',style: textStyle),
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
                        style: bStyle,
                        child:
                        Stack(
                          fit: StackFit.passthrough,
                          alignment: Alignment.center,
                          children: [
                            const Image(
                              image: AssetImage('assets/images/gui/wood_button.png'),
                              fit: BoxFit.fill,
                            ),
                            Text('Exit',style: textStyle),
                          ],
                        )
                    ),
                  ),
                  const SizedBox(height: 20,),
                  ValueListenableBuilder(
                    valueListenable: isMapCached,
                    builder: (BuildContext context, int value, Widget? child) {
                      return value >= 4 ? const SizedBox.shrink() : Row(children: [const CircularProgressIndicator(), Text('$value')]);
                    },
                  )
                ]
            )
          ]
      );
    });
  }
}