

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
                      ElevatedButton(
                        onLongPress: (){
                          _game.gameMap.currentGameWorldData!.orientation == OrientatinType.orthogonal ?
                          _game.gameMap.orthoPlayer?.startHit(true) : _game.gameMap.frontPlayer?.startHit(true);
                        },
                        onPressed: (){
                          // _game.doInventoryHud();
                          _game.gameMap.currentGameWorldData!.orientation == OrientatinType.orthogonal ?
                          _game.gameMap.orthoPlayer?.startHit(false) : _game.gameMap.frontPlayer?.startHit(false);
                        },
                        child: const Icon(Icons.sports_handball_outlined),
                      ),

                      ValueListenableBuilder(valueListenable: _game.gameMap.currentObject, builder: (_,val,__) {
                        return val == null ? const SizedBox(width: 30,height: 30,) : ElevatedButton(
                          onPressed: (){
                            _game.gameMap.currentGameWorldData!.orientation == OrientatinType.orthogonal ?
                            _game.gameMap.orthoPlayer?.makeAction() : _game.gameMap.frontPlayer?.makeAction();
                          },
                          child: const Icon(Icons.waving_hand),
                        );
                      }),
                    ]
                ),
              ),
            ])
    );
  }
}
