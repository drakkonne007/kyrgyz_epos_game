import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/extensions.dart' as ext;
import 'package:flutter/services.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/gen/strings.g.dart';
import 'package:game_flame/main.dart';
import 'package:game_flame/overlays/death_menu.dart';
import 'package:game_flame/overlays/dialog_overlay.dart';
import 'package:game_flame/overlays/game_hud.dart';
import 'package:game_flame/overlays/game_pause.dart';
import 'package:game_flame/overlays/language.dart';
import 'package:game_flame/overlays/main_menu.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart';

ValueNotifier<bool> isMapCached = ValueNotifier(false);

class KyrgyzGame extends FlameGame with HasKeyboardHandlerComponents,HasTappables, WidgetsBindingObserver
{
  final CustomTileMap gameMap = CustomTileMap();
  final PlayerData playerData = PlayerData();
  late final SharedPreferences prefs;
  static Map<String,Iterable<XmlElement>> cachedObjXmls = {};
  static Map<String,Iterable<XmlElement>> cachedAnims = {};
  static Map<String,ext.Image> cachedImgs = {};
  static Set<String> cachedMapPngs = {};
  Database? database;

  @override
  Future onLoad() async
  {
    // database = await openDatabase('kyrgyz.db');
    // await database?.rawQuery('select is_cached_into_internal from kyrgyz_game.settings');
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
    WidgetsBinding.instance.addObserver(this);
    playerData.setStartValues();
    add(gameMap);
    await gameMap.loaded;
    if(!isMapCompile) {
      gameMap.preloadAnimAndObj();
    }
  }

  void doGameHud()
  {
    resumeEngine();
    _showOverlay(overlayName: GameHud.id,isHideOther: true);
  }

  void doDialogHud()
  {
    pauseEngine();
    _showOverlay(overlayName: DialogOverlay.id,isHideOther: true);
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,)
  {
    super.onKeyEvent(event, keysPressed);
    if(keysPressed.contains(LogicalKeyboardKey.escape)){
      pauseEngine();
      _showOverlay(overlayName: GamePause.id,isHideOther: true);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void startDeathMenu()
  {
    _showOverlay(overlayName: DeathMenu.id,isHideOther: true);
  }

  void _showOverlay({required String overlayName, bool isHideOther = false})
  {
    if(isHideOther){
      var temp = overlays.activeOverlays.toList();
      overlays.removeAll(temp);
    }
    overlays.add(overlayName);
  }

  void startPause()
  {
    pauseEngine();
    _showOverlay(overlayName: GamePause.id,isHideOther: true);
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

  Future loadNewMap(String filePath) async
  {
    gameMap.removeAll(gameMap.children);
    gameMap.loadNewMap(Vector2(2000,2000));
  }

  @override
  Color backgroundColor()
  {
    return Colors.black;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // super.didChangeAppLifecycleState(state);
    if(state != AppLifecycleState.resumed) {
      if(overlays.activeOverlays.contains(GameHud.id)){
        pauseEngine();
        startPause();
      }
    }
  }
}
