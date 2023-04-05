import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/components/circlePositionComponent.dart';
import 'package:game_flame/components/player.dart';
import 'package:game_flame/components/background.dart';
import 'package:game_flame/components/tileMapComponent.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/components/helper.dart';
import 'dart:ui' as ui;


class CustomGame extends FlameGame with HasKeyboardHandlerComponents,HasTappables,HasCollisionDetection
{
  late PlayerSpriteSheetComponent _player;
  late MoveArrow leftArr;
  late MoveArrow rightArr;
  late MoveArrow UpArr;

  @override
  Color backgroundColor() {
    return Colors.purple;
  }
  //
  // CustomGame(){
  //   SystemChrome.setEnabledSystemUIOverlays([]);
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeRight,
  //     DeviceOrientation.landscapeLeft,
  //   ]);
  // }

  @override
  void onGameResize(Vector2 canvasSize) {
    if(isLoaded) {
      leftArr.position = Vector2(0, MediaQueryData
          .fromWindow(ui.window)
          .size
          .height - 50);
      rightArr.position = Vector2(85, MediaQueryData
          .fromWindow(ui.window)
          .size
          .height - 50);
      UpArr.size = Vector2(MediaQueryData
          .fromWindow(ui.window)
          .size
          .width / 2, MediaQueryData
          .fromWindow(ui.window)
          .size
          .height);
      UpArr.position = Vector2(MediaQueryData
          .fromWindow(ui.window)
          .size
          .width / 2, 0);
    }
    super.onGameResize(canvasSize);
  }

  void tappableEvent(PlayerDirectionMove direct, bool isMove){
    if(direct == PlayerDirectionMove.Left){
      _player.moveLeft(isMove);
    }else if(direct == PlayerDirectionMove.Right){
      _player.moveRight(isMove);
    }else if(direct == PlayerDirectionMove.Up){
      _player.moveUp(isMove);
    }
  }

  @override
  Future<void> onLoad() async {
    add(Back());
    var bground = CustomTileMap();
    add(bground);
    leftArr = MoveArrow(PlayerDirectionMove.Left, Vector2(0,MediaQueryData.fromWindow(ui.window).size.height - 50),Vector2(65,50));
    leftArr.setColor(BasicPalette.green.color.withAlpha(20));
    add(leftArr);
    rightArr = MoveArrow(PlayerDirectionMove.Right, Vector2(85,MediaQueryData.fromWindow(ui.window).size.height - 50),Vector2(65,50));
    rightArr.setColor(BasicPalette.green.color.withAlpha(20));
    add(rightArr);
    UpArr = MoveArrow(PlayerDirectionMove.Up, Vector2(MediaQueryData.fromWindow(ui.window).size.width/2,0),Vector2(MediaQueryData.fromWindow(ui.window).size.width/2,MediaQueryData.fromWindow(ui.window).size.height));
    UpArr.setColor(BasicPalette.transparent.color);
    add(UpArr);
    bground.loaded.then((value) {
      _player = PlayerSpriteSheetComponent();
      camera.followComponent(_player,worldBounds: Rect.fromLTWH(0, 0, bground.width, bground.height));
      for(double i=100; i < bground.height - 50; i+=200){
        add(CustomCircle(Vector2(2,i),bground.width));
      }
      bground.position = Vector2(0, 0);
      add(_player);
      add(ScreenHitbox());
    }
    );
  }
}


main()
{
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget(
          game: CustomGame()
        )
      ),
    )
  );
}
