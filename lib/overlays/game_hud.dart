

import 'package:flutter/material.dart';
import 'package:game_flame/components/game_worlds.dart';
import 'package:game_flame/game_widgets/joysticks.dart';
import 'package:game_flame/game_widgets/pause_button.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/game_widgets/health_bar.dart';

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
                                  _game.gameMap.orthoPlayer?.doDash(false);
                                } else if(details.delta.dx < -sensitivity){
                                  _game.gameMap.orthoPlayer?.doDash(true);
                                }
                              },
                              onVerticalDragUpdate: (details) {
                                int sensitivity = 8;
                                if (details.delta.dy > sensitivity) {
                                  _game.gameMap.orthoPlayer?.startMagic();
                                } else if(details.delta.dy < -sensitivity){
                                  _game.gameMap.orthoPlayer?.doShield();
                                }
                              }
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: PauseButton(_game),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children:
                              [
                                  TextButton(
                                    onLongPress: (){
                                      _game.gameMap.currentGameWorldData!.orientation == OrientatinType.orthogonal ?
                                      _game.gameMap.orthoPlayer?.startHit(false) : _game.gameMap.frontPlayer?.startHit(false);
                                    },
                                    onPressed: (){
                                      _game.gameMap.currentGameWorldData!.orientation == OrientatinType.orthogonal ?
                                      _game.gameMap.orthoPlayer?.startHit(false) : _game.gameMap.frontPlayer?.startHit(false);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child:Image.asset('assets/images/inventar/UI-9-sliced object-209.png'
                                      ,width: 50,height: 50,
                                      fit: BoxFit.cover,),
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children:
                                    [
                                      ValueListenableBuilder(valueListenable: _game.gameMap.currentObject, builder: (_,val,__) {
                                        return val == null ? Container() :
                                          TextButton(
                                                onPressed: (){
                                                  _game.gameMap.currentGameWorldData!.orientation == OrientatinType.orthogonal ?
                                                  _game.gameMap.orthoPlayer?.makeAction() : _game.gameMap.frontPlayer?.makeAction();
                                                },
                                                child: Image.asset('assets/images/inventar/UI-9-sliced object-89.png'
                                                  ,width: 40,height: 40
                                                  ,fit: BoxFit.cover,),
                                          );
                                      }),

                                        TextButton(
                                          onLongPress: (){
                                            _game.gameMap.currentGameWorldData!.orientation == OrientatinType.orthogonal ?
                                            _game.gameMap.orthoPlayer?.startHit(true) : _game.gameMap.frontPlayer?.startHit(true);
                                          },
                                          onPressed: (){
                                            _game.gameMap.currentGameWorldData!.orientation == OrientatinType.orthogonal ?
                                            _game.gameMap.orthoPlayer?.startHit(true) : _game.gameMap.frontPlayer?.startHit(true);
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            clipBehavior: Clip.hardEdge,
                                            child:Image.asset('assets/images/inventar/UI-9-sliced object-223.png'
                                            ,width: 50,height: 50,
                                            fit: BoxFit.cover,),
                                        ),
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
