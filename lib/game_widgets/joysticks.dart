import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:game_flame/components/game_worlds.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

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
  const OrthoJoystick(this._size,this.game,{Key? key}) : super(key: key);
  final double _size;
  final KyrgyzGame game;
  @override
  State<OrthoJoystick> createState() => _OrthoJoystickState();
}

class _OrthoJoystickState extends State<OrthoJoystick> {
  late double _size;
  final ValueNotifier<double> _left = ValueNotifier<double>(0), _top = ValueNotifier<double>(0);
  final double right1 = math.pi/3;
  final double right2 = math.pi * 2/3;
  final double rightUp1 = 5 * math.pi/6;
  final double up1 = -5 * math.pi/6;
  final double left1 = math.pi / 6;

  @override
  void initState() {
    _size = widget._size;
    _left.value = _size/2 - _size/8;
    _top.value = _size/2 - _size/8;
    super.initState();
  }

  void doMove(double dx, double dy){
    bool isRun = false;
    var ugol = math.atan2(dx - _size/2, dy - _size / 2);
    if(math.sqrt(math.pow(dx- _size / 2,2) + math.pow(dy- _size / 2, 2)) >= _size / 2 - _size/8){
      _left.value = math.sin(ugol) * (_size / 2 - _size/8) - _size/8 + _size/2;
      _top.value = math.cos(ugol) * (_size / 2 - _size/8) - _size/8 + _size/2;
      isRun = true;
    }else {
      _left.value = dx - _size/8;
      _top.value = dy - _size/8;
    }
    PlayerDirectionMove dir = PlayerDirectionMove.NoMove;
    if(ugol >= right1 && ugol < right2){
      dir = PlayerDirectionMove.Right;
    }else if(ugol < rightUp1 && ugol >= right2){
      dir = PlayerDirectionMove.RightUp;
    }else if(ugol < -rightUp1 || ugol >= rightUp1){
      dir = PlayerDirectionMove.Up;
    }else if(ugol >= -rightUp1 && ugol < -right2){
      dir = PlayerDirectionMove.LeftUp;
    }else if(ugol >= -right2 && ugol < -right1){
      dir = PlayerDirectionMove.Left;
    }else if(ugol >= -right1 && ugol < -left1){
      dir = PlayerDirectionMove.LeftDown;
    }else if(ugol >= -left1 && ugol < left1){
      dir = PlayerDirectionMove.Down;
    }else if(ugol > left1 && ugol < right1){
      dir = PlayerDirectionMove.RightDown;
    }
    widget.game.gameMap.currentGameWorldData!.orientation == OrientatinType.orthogonal ?
    widget.game.gameMap.orthoPlayer?.movePlayer(dir,isRun):
    widget.game.gameMap.frontPlayer?.movePlayer(dir,isRun);
  }

  void stopMove(){
    widget.game.gameMap.currentGameWorldData!.orientation == OrientatinType.orthogonal ?
    widget.game.gameMap.orthoPlayer?.movePlayer(PlayerDirectionMove.NoMove,false):
    widget.game.gameMap.frontPlayer?.movePlayer(PlayerDirectionMove.NoMove,false);
    _left.value = _size/2 - _size/8;
    _top.value = _size/2 - _size/8;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Container(
        width: _size,
        height: _size,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(color: Colors.blue.withAlpha(100), shape: BoxShape.circle),
        child:  Stack(
            fit: StackFit.passthrough,
            children:<Widget>[
              ValueListenableBuilder(
                valueListenable: _left,
                builder: (_,val,__) => Positioned(
                    width: _size/4,
                    height: _size/4,
                    left: val,
                    top: _top.value,
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(_size)),color: Colors.red.withAlpha(220)),
                    )),),
              GestureDetector(
                onLongPressStart: (details){
                  doMove(details.localPosition.dx, details.localPosition.dy);
                },
                onLongPressMoveUpdate: (details){
                  doMove(details.localPosition.dx, details.localPosition.dy);
                },
                onLongPressEnd: (details){
                  stopMove();
                },
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
    );
  }
}