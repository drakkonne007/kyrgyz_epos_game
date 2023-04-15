import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/overlays/death_menu.dart';
import 'package:game_flame/overlays/game_pause.dart';
import 'package:game_flame/overlays/health_bar.dart';
import 'package:game_flame/overlays/joysticks.dart';
import 'package:game_flame/overlays/main_menu.dart';
import 'package:game_flame/overlays/save_dialog.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:game_flame/players/ortho_player.dart';

class KyrgyzGame extends FlameGame with HasKeyboardHandlerComponents,HasTappables,HasCollisionDetection
{
  CustomTileMap? gameMap = null;

  void showOverlay({required String overlayName, bool isHideOther = false}){
    if(isHideOther){
      overlays.removeAll( <String>[DeathMenu.id,
        GamePause.id,
        HealthBar.id,
        OrthoJoystick.id,
        MainMenu.id,
        SaveDialog.id,]);
    }
    overlays.add(overlayName);
  }

  void loadNewMap(String filePath){
    gameMap?.removeFromParent();
    gameMap = CustomTileMap(filePath);
    add(gameMap!);
    camera.followComponent(OrthoPlayer(),worldBounds: Rect.fromLTWH(0,0, gameMap!.width, gameMap!.height));
  }
  //
  // @override
  // Color backgroundColor() {
  //   return Colors.blue;
  // }

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
  }
}
