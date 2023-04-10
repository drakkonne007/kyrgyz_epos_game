import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/components/circle_position_component.dart';
import 'package:game_flame/components/front_player.dart';
import 'package:game_flame/components/background.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/components/helper.dart';
import 'dart:ui' as ui;
import 'package:game_flame/components/ortho_player.dart';


class KyrgyzGame extends FlameGame with HasKeyboardHandlerComponents,HasTappables,HasCollisionDetection
{
  late OrthoPlayer _player;
  late MoveArrow leftArr;
  late MoveArrow rightArr;
  late MoveArrow UpArr;
  late MoveArrow DownArr;

  @override
  Color backgroundColor() {
    return Colors.blue;
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
      // leftArr.position = Vector2(0, MediaQueryData
      //     .fromWindow(ui.window)
      //     .size
      //     .height - 50);
      // rightArr.position = Vector2(85, MediaQueryData
      //     .fromWindow(ui.window)
      //     .size
      //     .height - 50);
      // UpArr.size = Vector2(MediaQueryData
      //     .fromWindow(ui.window)
      //     .size
      //     .width / 2, MediaQueryData
      //     .fromWindow(ui.window)
      //     .size
      //     .height);
      // UpArr.position = Vector2(MediaQueryData
      //     .fromWindow(ui.window)
      //     .size
      //     .width / 2, 0);
    }
    super.onGameResize(canvasSize);
  }

  void tappableEvent(PlayerDirectionMove direct, bool isMove){
    print('sdsd');
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
    //add(Back());
    var bground = CustomTileMap();
    add(bground);
    // leftArr = MoveArrow(PlayerDirectionMove.Left, Vector2(0,MediaQueryData.fromWindow(ui.window).size.height - 50),Vector2(65,50));
    // leftArr.setColor(BasicPalette.green.color.withAlpha(20));
    // add(leftArr);
    // rightArr = MoveArrow(PlayerDirectionMove.Right, Vector2(85,MediaQueryData.fromWindow(ui.window).size.height - 50),Vector2(65,50));
    // rightArr.setColor(BasicPalette.green.color.withAlpha(20));
    // add(rightArr);
    // UpArr = MoveArrow(PlayerDirectionMove.Up, Vector2(MediaQueryData.fromWindow(ui.window).size.width/2,0),Vector2(MediaQueryData.fromWindow(ui.window).size.width/2,MediaQueryData.fromWindow(ui.window).size.height));
    // UpArr.setColor(BasicPalette.transparent.color);
    // add(UpArr);
    bground.loaded.then((value) {
      // bground.anchor = Anchor.topLeft;
      // bground.scale = Vector2.all(2);
      _player = OrthoPlayer(Vector2(0,bground.height));
      camera.followComponent(_player,worldBounds: Rect.fromLTWH(0, 0, bground.width, bground.height));
      // for(double i=100; i < bground.height - 50; i+=200){
      //   add(CustomCircle(Vector2(2,i),bground.width));
      // }
      bground.position = Vector2(0, 0);
      add(_player);
      // add(CustomJoystick(Vector2(0,MediaQueryData.fromWindow(ui.window).size.height - 60), Vector2(60,60)));
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
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: Scaffold(
        body: GameWidget(
          game: KyrgyzGame(),
          overlayBuilderMap:  {
            'OrthoJoystick': (context, KyrgyzGame game) {
              return OrthoJoystick(game,Vector2(80,80)
              );
            },
          },
          initialActiveOverlays: const ['OrthoJoystick'],
        )
      ),
    )
  );
}
