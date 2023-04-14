import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/components/helper.dart';
import 'package:game_flame/overlays/death_menu.dart';
import 'package:game_flame/overlays/game_pause.dart';
import 'package:game_flame/overlays/health_bar.dart';
import 'package:game_flame/overlays/joysticks.dart';
import 'package:game_flame/overlays/main_menu.dart';
import 'package:game_flame/overlays/save_dialog.dart';
import 'package:game_flame/players/ortho_player.dart';
import 'package:game_flame/components/tile_map_component.dart';

class AbstractGame extends FlameGame with HasKeyboardHandlerComponents,HasTappables,HasCollisionDetection
{
  final OrthoPlayer orthoPlayer = OrthoPlayer();
  final CustomTileMap myMap  = CustomTileMap();

  void moveOrthoPlayer(PlayerDirectionMove direct, bool isRun){
    orthoPlayer.movePlayer(direct,isRun);
  }

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

  @override
  Color backgroundColor() {
    return Colors.blue;
  }

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    camera.followComponent(orthoPlayer);
  }
}
