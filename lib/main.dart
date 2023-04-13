import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/components/circle_position_component.dart';
import 'package:game_flame/components/front_player.dart';
import 'package:game_flame/components/background.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/components/helper.dart';
import 'dart:ui' as ui;
import 'package:game_flame/components/ortho_player.dart';
import 'package:game_flame/components/joysticks.dart';

import 'components/menu_overlays.dart';


class KyrgyzGame extends FlameGame with HasKeyboardHandlerComponents,HasTappables,HasCollisionDetection, HasTimeScale
{
  late OrthoPlayer _player;
  late CustomTileMap _bground;

  @override
  Color backgroundColor() {
    return Colors.blue;
  }

  void moveOrthoPlayer(PlayerDirectionMove direct, bool isRun){
    _player.movePlayer(direct,isRun);
  }

  void restartFromCheckpoint(){
    overlays.remove('DeadMenu');
    _bground.smallRestart();
    _player.position = _bground.playerPos;
  }

  void setTimeScale(double timeScale){
    if(timeScale == 0) {
      pauseEngine();
    }else{
      resumeEngine();
    }
  }

  void moveFrontPLayer(){}

  @override
  Future<void> onLoad() async {
    //add(Back());
    _bground = CustomTileMap();
    add(_bground);
    _bground.loaded.then((value) {
      _player = OrthoPlayer(_bground.playerPos);
      camera.followComponent(_player,worldBounds: Rect.fromLTWH(0, 0, _bground.width, _bground.height));
      _bground.position = Vector2(0, 0);
      add(_player);
      add(ScreenHitbox());
      add(FpsTextComponent());
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
              return OrthoJoystick(game,80);
            },
            'DeadMenu': (context, KyrgyzGame game) {
              return DeadMenu(game);
            },
            'HealthBar': (context, KyrgyzGame game) {
              return HealthBar();
            },
          },
          initialActiveOverlays: const ['OrthoJoystick', 'HealthBar'],
        )
      ),
    )
  );
}
