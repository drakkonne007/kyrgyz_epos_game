import 'dart:math' as math;
import 'package:game_flame/components/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/players/ortho_player.dart';
import 'dart:ui' as ui;

// class MoveArrow extends RectangleComponent with Tappable, ParentIsA<KyrgyzGame>
// {
//   PlayerDirectionMove _direction;
//   MoveArrow(this._direction, Vector2 pos, Vector2 size){
//     position = pos;
//     this.size = size;
//     positionType = PositionType.widget;
//   }
//
//   @override
//   Future<void> onLoad() async{
//     setColor(BasicPalette.red.color);
//   }
//
//   @override
//   bool onTapDown(TapDownInfo info) {
//     parent.moveFrontPLayer();
//     return true;
//   }
//
//   @override
//   bool onLongTapDown(TapDownInfo info) {
//     gameRef.moveFrontPLayer();
//     return true;
//   }
//
//   @override
//   bool onTapCancel() {
//     gameRef.moveFrontPLayer();
//     return true;
//   }
//
//   @override
//   bool onTapUp(TapUpInfo info) {
//     gameRef.moveFrontPLayer();
//     return true;
//   }
// }

class OrthoJoystick extends StatefulWidget
{
  static const id = 'OrthoJoystick';
  KyrgyzGame _game;
  double _size;
  OrthoJoystick(this._game, this._size);

  @override
  State<OrthoJoystick> createState() => _OrthoJoystickState(_size);
}

class _OrthoJoystickState extends State<OrthoJoystick> {
  double _size;
  late double _left,_top;
  _OrthoJoystickState(this._size){
    _left = _size/2 - _size/8;
    _top = _size/2 - _size/8;
  }

  void doMove(double dx, double dy){
    bool isRun = false;
    var ugol = math.atan2(dx - _size/2, dy - _size / 2);
    if(math.sqrt(math.pow(dx- _size / 2,2) + math.pow(dy- _size / 2, 2)) >= _size / 2 - _size/8){
      _left = math.sin(ugol) * (_size / 2 - _size/8) - _size/8 + _size/2;
      _top = math.cos(ugol) * (_size / 2 - _size/8) - _size/8 + _size/2;
      isRun = true;
    }else {
      _left = dx - _size/8;
      _top = dy - _size/8;
    }
    setState(() {
      if(ugol >= math.pi/3 && ugol < math.pi * 2/3){
        OrthoPlayer().movePlayer(PlayerDirectionMove.Right,isRun);
      }else if(ugol < 5 * math.pi/6 && ugol >= math.pi * 2/3){
        OrthoPlayer().movePlayer(PlayerDirectionMove.RightUp,isRun);
      }else if(ugol < -5 * math.pi/6 || ugol >= 5 * math.pi/6){
        OrthoPlayer().movePlayer(PlayerDirectionMove.Up,isRun);
      }else if(ugol >= -5 * math.pi/6 && ugol < math.pi * -2 / 3){
        OrthoPlayer().movePlayer(PlayerDirectionMove.LeftUp,isRun);
      }else if(ugol >= -2 * math.pi/3 && ugol < -math.pi / 3){
        OrthoPlayer().movePlayer(PlayerDirectionMove.Left,isRun);
      }else if(ugol >= -math.pi/3 && ugol < -math.pi / 6){
        OrthoPlayer().movePlayer(PlayerDirectionMove.LeftDown,isRun);
      }else if(ugol >= -math.pi/6 && ugol < math.pi / 6){
        OrthoPlayer().movePlayer(PlayerDirectionMove.Down,isRun);
      }else if(ugol > math.pi/6 && ugol < math.pi / 3){
        OrthoPlayer().movePlayer(PlayerDirectionMove.RightDown,isRun);
      }
    });
  }

  void stopMove(){
    OrthoPlayer().movePlayer(PlayerDirectionMove.NoMove,false);
    setState(() {
      _left = _size/2 - _size/8;
      _top = _size/2 - _size/8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        children:[
          Expanded(
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: Container(
                    width: _size,
                    height: _size,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(color: Colors.blue.withAlpha(100), shape: BoxShape.circle),
                    child:  Stack(
                        fit: StackFit.passthrough,
                        children:<Widget>[
                          Positioned(
                              width: _size/4,
                              height: _size/4,
                              left: _left,
                              top: _top,
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(_size)),color: Colors.red.withAlpha(220)),
                              )),
                          GestureDetector(
                            onTapUp: (details){
                              stopMove();
                            },
                            onLongPressDown: (details){
                              doMove(details.localPosition.dx, details.localPosition.dy);
                            },
                            onTapDown: (details){
                              doMove(details.localPosition.dx, details.localPosition.dy);
                            },
                            onPanStart: (details){
                              doMove(details.localPosition.dx, details.localPosition.dy);
                            },
                            onPanUpdate: (details){
                              doMove(details.localPosition.dx, details.localPosition.dy);
                            },
                            onPanCancel: (){
                              stopMove();
                            },
                            onTapCancel: (){
                              stopMove();
                            },
                            onLongPressCancel: () {
                              stopMove();
                            },
                            onPanEnd: (details){
                              stopMove();
                            },
                          ),
                        ]
                    ),
                  ),
                )
            ),
          ),
          Expanded(
              child:
              GestureDetector(
                onTap: (){
                  OrthoPlayer().startHit();
                  },
              ))
        ]
    );
  }
}