import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/gen/strings.g.dart';
import 'package:game_flame/overlays/death_menu.dart';
import 'package:game_flame/overlays/game_pause.dart';
import 'package:game_flame/overlays/health_bar.dart';
import 'package:game_flame/overlays/joysticks.dart';
import 'package:game_flame/overlays/language.dart';
import 'package:game_flame/overlays/main_menu.dart';
import 'package:game_flame/overlays/save_dialog.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KyrgyzGame extends FlameGame with HasKeyboardHandlerComponents,HasTappables,HasCollisionDetection
{
  CustomTileMap? gameMap;
  PlayerData playerData = PlayerData();
  late final SharedPreferences prefs;

  @override
  Future<void> onLoad() async
  {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    prefs = await SharedPreferences.getInstance();
    prefs.remove('locale');
    var loc = prefs.getString('locale');
    if(loc == null){
      overlays.add(LanguageChooser.id);
    }else{
      LocaleSettings.setLocaleRaw(loc);
      overlays.add(MainMenu.id);
    }
  }

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

  void createNewGame(int saveId)
  {
    prefs.remove('${saveId}_maxHp');
    prefs.remove('${saveId}_curHp');
    prefs.remove('${saveId}_maxEnergy');
    prefs.remove('${saveId}_curEnergy');
    prefs.remove('${saveId}_bosses');
    prefs.remove('${saveId}_items');
    prefs.remove('${saveId}_gold');
    prefs.remove('${saveId}_curWeapon');
    prefs.remove('${saveId}_curDress');
    prefs.remove('${saveId}_location');
    prefs.remove('${saveId}_position');
    prefs.remove('${saveId}_gameTime');
    prefs.remove('${saveId}_secsInGame');

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
}
