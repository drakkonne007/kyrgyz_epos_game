

import 'package:flutter/cupertino.dart';
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
        child: Stack(
            fit: StackFit.passthrough,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: HealthBar(_game),
              ),
              Align(
                alignment: Alignment.topRight,
                child: PauseButton(_game),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: OrthoJoystick(120, _game),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children:[
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                          shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                          surfaceTintColor: MaterialStateProperty.all<Color>(Colors.transparent),
                          elevation: MaterialStateProperty.all<double>(0),
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                        ),
                        onLongPress: (){
                          _game.gameMap.currentGameWorldData!.orientation == OrientatinType.orthogonal ?
                          _game.gameMap.orthoPlayer?.startHit(false) : _game.gameMap.frontPlayer?.startHit(false);
                        },
                        onPressed: (){
                          _game.gameMap.currentGameWorldData!.orientation == OrientatinType.orthogonal ?
                          _game.gameMap.orthoPlayer?.startHit(false) : _game.gameMap.frontPlayer?.startHit(false);
                        },
                        child: Image.asset('assets/images/inventar/UI-9-sliced object-209.png',width: 40,height: 40,
                        fit: BoxFit.cover,),
                      ),
                      TextButton(
                        onLongPress: (){
                          _game.gameMap.currentGameWorldData!.orientation == OrientatinType.orthogonal ?
                          _game.gameMap.orthoPlayer?.startHit(true) : _game.gameMap.frontPlayer?.startHit(true);
                        },
                        onPressed: (){
                          _game.gameMap.currentGameWorldData!.orientation == OrientatinType.orthogonal ?
                          _game.gameMap.orthoPlayer?.startHit(true) : _game.gameMap.frontPlayer?.startHit(true);
                        },
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                          shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                          surfaceTintColor: MaterialStateProperty.all<Color>(Colors.transparent),
                          elevation: MaterialStateProperty.all<double>(0),
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                        ),
                        child: Image.asset('assets/images/inventar/UI-9-sliced object-223.png',width: 40,height: 40,
                        fit: BoxFit.cover,),
                      ),
                      ValueListenableBuilder(valueListenable: _game.gameMap.currentObject, builder: (_,val,__) {
                        return val == null ? const SizedBox(width: 40,height: 44,) : ElevatedButton(
                          onPressed: (){
                            _game.gameMap.currentGameWorldData!.orientation == OrientatinType.orthogonal ?
                            _game.gameMap.orthoPlayer?.makeAction() : _game.gameMap.frontPlayer?.makeAction();
                          },
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            surfaceTintColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            elevation: MaterialStateProperty.all<double>(0),
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                          ),
                          child: Image.asset('assets/images/inventar/UI-9-sliced object-89.png',width: 40,height: 40
                            ,fit: BoxFit.cover,),
                        );
                      }),
                    ]
                ),
              ),
            ])
    );
  }
}
