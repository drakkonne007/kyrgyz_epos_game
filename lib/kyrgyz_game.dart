import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/components/physic_vals.dart';
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
  CustomTileMap? gameMap;
  late PlayerData playerData;

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,)
  {
    super.onKeyEvent(event, keysPressed);
    if(keysPressed.contains(LogicalKeyboardKey.escape)){
      pauseEngine();
      showOverlay(overlayName: GamePause.id,isHideOther: true);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void showOverlay({required String overlayName, bool isHideOther = false})
  {
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

  Future<void> loadNewMap(String filePath) async
  {
    gameMap?.removeFromParent();
    gameMap = CustomTileMap(filePath);
    await add(gameMap!);
  }

  @override
  Color backgroundColor()
  {
    return Colors.orange;
  }

  @override
  Future<void> onLoad() async
  {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
  }
}
