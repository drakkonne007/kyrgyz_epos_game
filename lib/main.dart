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
import 'package:game_flame/components/joysticks.dart';


class KyrgyzGame extends FlameGame with HasKeyboardHandlerComponents,HasTappables,HasCollisionDetection
{
  late OrthoPlayer _player;

  @override
  Color backgroundColor() {
    return Colors.blue;
  }

  void moveOrthoPlayer(PlayerDirectionMove direct, bool isRun){
    _player.movePlayer(direct,isRun);
  }

  void moveFrontPLayer(){}

  @override
  Future<void> onLoad() async {
    //add(Back());
    var bground = CustomTileMap();
    add(bground);
    bground.loaded.then((value) {
      _player = OrthoPlayer(Vector2(0,bground.height));
      camera.followComponent(_player,worldBounds: Rect.fromLTWH(0, 0, bground.width, bground.height));
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
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: Scaffold(
        body: GameWidget(
          game: KyrgyzGame(),
          overlayBuilderMap:  {
            'OrthoJoystick': (context, KyrgyzGame game) {
              return OrthoJoystick(game,80);
            },
          },
          initialActiveOverlays: const ['OrthoJoystick'],
        )
      ),
    )
  );
}
