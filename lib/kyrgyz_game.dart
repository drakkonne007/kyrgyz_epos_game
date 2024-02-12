import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/extensions.dart' as ext;
import 'package:flutter/services.dart';
import 'package:game_flame/abstracts/compiller.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/gen/strings.g.dart';
import 'package:game_flame/main.dart';
import 'package:game_flame/overlays/death_menu.dart';
import 'package:game_flame/overlays/dialog_overlay.dart';
import 'package:game_flame/overlays/game_hud.dart';
import 'package:game_flame/overlays/game_pause.dart';
import 'package:game_flame/overlays/inventar_overlay.dart';
import 'package:game_flame/overlays/language.dart';
import 'package:game_flame/overlays/main_menu.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart';

ValueNotifier<int> isMapCached = ValueNotifier(0);

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
  late FragmentProgram telepShaderProgramm;

  @override
  Future onLoad() async
  {
    // database = await openDatabase('kyrgyz.db');
    // await database?.rawQuery('select is_cached_into_internal from kyrgyz_game.settings');
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    Flame.images.prefix = 'assets/';
    telepShaderProgramm = await FragmentProgram.fromAsset('assets/shaders/portalShader.frag');
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
    if(isMapCompile){
      await precompileAll();
      exit(0);
    }
  }

  @override
  void onGameResize(Vector2 size) {
    double xZoom = size.x / 768;
    double yZoom = size.y / 448;
    camera.zoom = max(xZoom, yZoom);
    // print(size);
    super.onGameResize(size);
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

  void doInventoryHud()
  {
    pauseEngine();
    _showOverlay(overlayName: InventoryOverlay.id,isHideOther: true);
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
    pauseEngine();
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

  void doLoadingMapHud()
  {
    pauseEngine();
    var temp = overlays.activeOverlays.toList();
    overlays.removeAll(temp);
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

  Future loadNewMap() async
  {
    await gameMap.loadNewMap();
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

  @override
  void update(double dt)
  {
    if(dt > 0.041){
      return;
    }
    super.update(dt);
  }
}
