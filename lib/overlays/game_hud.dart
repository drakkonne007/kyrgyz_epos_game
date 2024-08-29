

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/components/game_worlds.dart';
import 'package:game_flame/game_widgets/joysticks.dart';
import 'package:game_flame/game_widgets/pause_button.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/game_widgets/health_bar.dart';
import 'package:game_flame/overlays/game_styles.dart';

class GameHud extends StatelessWidget
{
  const GameHud(this._game, {Key? key}) : super(key: key);
  final KyrgyzGame _game;
  static const String id = 'GameHud';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child:
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                      [
                        HealthBar(_game),
                        OrthoJoystick(120, _game),
                      ]
                  )
              ),
              Expanded(
                  child:
                  Stack(
                      fit: StackFit.passthrough,
                      children:
                      [
                        Positioned.fill(
                          child:
                          GestureDetector(
                              onHorizontalDragUpdate: (details) {
                                int sensitivity = 8;
                                if (details.delta.dx > sensitivity) {
                                  _game.gamePlayer().doDash(false);
                                } else if(details.delta.dx < -sensitivity){
                                  _game.gamePlayer().doDash(true);
                                }
                              },
                              onVerticalDragUpdate: (details) {
                                int sensitivity = 8;
                                if (details.delta.dy > sensitivity) {
                                  _game.gamePlayer().startMagic();
                                } else if(details.delta.dy < -sensitivity){
                                  _game.gamePlayer().doShield();
                                }
                              }
                          ),
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children:
                                [
                                  PauseButton(_game),
                                  const SizedBox(height: 15,),
                                  ValueListenableBuilder(valueListenable: _game.playerData.currentFlask1, builder: (context, value, child)
                                  {
                                    if(value != null && !_game.playerData.flaskInventar.containsKey(value)){
                                      value = null;
                                      _game.playerData.currentFlask1.value = null;
                                    }
                                    return value == null ? const SizedBox(width: 40,height: 40,) : ElevatedButton(
                                        onLongPress: (){
                                          itemFromName(value!).getEffectFromInventar(_game);
                                          _game.playerData.currentFlask1.notifyListeners();
                                        },
                                        onPressed: (){
                                          itemFromName(value!).getEffectFromInventar(_game);
                                          _game.playerData.currentFlask1.notifyListeners();
                                        },
                                        style: defaultNoneButtonStyle.copyWith(
                                            maximumSize: WidgetStateProperty.all<Size>(const Size(40,40)),
                                            backgroundBuilder: ((context, state, child){
                                              return Stack(
                                                  alignment: Alignment.bottomLeft,
                                                  fit: StackFit.passthrough,
                                                  children:
                                                  [
                                                    Image.asset('assets/${itemFromName(value!).source}'
                                                      ,width: 40,height: 40,
                                                      fit: BoxFit.contain,),
                                                    SizedBox(width: 20,height: 20,
                                                        child: AutoSizeText(_game.playerData.flaskInventar[value]!.toString(),style: defaultInventarTextStyleGood.copyWith(shadows: [const Shadow(color: Colors.black, blurRadius: 7)]))),
                                                  ]
                                              );
                                            })
                                        ),
                                        child: null
                                    );
                                  },
                                  ),
                                  const SizedBox(height: 15,),
                                  ValueListenableBuilder(valueListenable: _game.playerData.currentFlask2, builder: (context, value, child)
                                  {
                                    if(value != null && !_game.playerData.flaskInventar.containsKey(value)){
                                      _game.playerData.currentFlask2.value = null;
                                      value = null;
                                    }
                                    return value == null ? const SizedBox(width: 40,height: 40,) : ElevatedButton(
                                        onLongPress: (){
                                          itemFromName(value!).getEffectFromInventar(_game);
                                          _game.playerData.currentFlask2.notifyListeners();
                                        },
                                        onPressed: (){
                                          itemFromName(value!).getEffectFromInventar(_game);
                                          _game.playerData.currentFlask2.notifyListeners();
                                        },
                                        style: defaultNoneButtonStyle.copyWith(
                                            maximumSize: WidgetStateProperty.all<Size>(const Size(40,40)),
                                            backgroundBuilder: ((context, state, child){
                                              return Stack(
                                                  alignment: Alignment.bottomLeft,
                                                  fit: StackFit.passthrough,
                                                  children:
                                                  [
                                                    Image.asset('assets/${itemFromName(value!).source}'
                                                      ,width: 40,height: 40,
                                                      fit: BoxFit.contain,),
                                                    SizedBox(width: 20,height: 20,
                                                        child: AutoSizeText(_game.playerData.flaskInventar[value]!.toString(),style: defaultInventarTextStyleGood.copyWith(shadows: [const Shadow(color: Colors.black, blurRadius: 7)]))),
                                                  ]
                                              );
                                            })
                                        ),
                                        child: null
                                    );
                                  },
                                  ),
                                ]
                            )
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children:
                              [
                                ElevatedButton(
                                    onLongPress: (){
                                      _game.gamePlayer().startHit(false);
                                    },
                                    onPressed: (){
                                      _game.gamePlayer().startHit(false);
                                    },
                                    style: defaultNoneButtonStyle.copyWith(
                                        maximumSize: WidgetStateProperty.all<Size>(const Size(100,100)),
                                        backgroundBuilder: ((context, state, child){
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child:Image.asset('assets/images/inventar/UI-9-sliced object-209.png'
                                              ,width: 100,height: 100,
                                              fit: BoxFit.cover,),
                                          );
                                        })
                                    ),
                                    child: null
                                ),
                                const SizedBox(height: 15,),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children:
                                    [
                                      ValueListenableBuilder(valueListenable: _game.gameMap.currentObject, builder: (_,val,__) {
                                        return val == null ? Container() :
                                        ElevatedButton(
                                            onPressed: (){
                                              _game.gamePlayer().makeAction();
                                            },
                                            style: defaultNoneButtonStyle.copyWith(
                                                maximumSize: WidgetStateProperty.all<Size>(const Size(80,80)),
                                                backgroundBuilder: ((context, state, child){
                                                  return Image.asset('assets/images/inventar/UI-9-sliced object-89.png'
                                                    ,width: 80,height: 80
                                                    ,fit: BoxFit.cover,);
                                                })
                                            ),
                                            child: null
                                        );
                                      }),

                                      ElevatedButton(
                                          onLongPress: (){
                                            _game.gamePlayer().startHit(true);
                                          },
                                          onPressed: (){
                                            _game.gamePlayer().startHit(true);
                                          },
                                          style: defaultNoneButtonStyle.copyWith(
                                              maximumSize: WidgetStateProperty.all<Size>(const Size(100,100)),
                                              backgroundBuilder: ((context, state, child){
                                                return ClipRRect(
                                                  borderRadius: BorderRadius.circular(20),
                                                  clipBehavior: Clip.hardEdge,
                                                  child:Image.asset('assets/images/inventar/UI-9-sliced object-223.png'
                                                    ,width: 100,height: 100,
                                                    fit: BoxFit.cover,),
                                                );
                                              })
                                          ),
                                          child: null
                                      ),
                                    ]
                                ),
                                const SizedBox(height: 15,),
                              ]
                          ),
                        ),
                      ]
                  )
              ),
            ])
    );
  }
}
