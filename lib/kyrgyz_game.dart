import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flame/extensions.dart' as ext;
import 'package:flutter/services.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/ForgeOverrides/broadphase.dart';
import 'package:game_flame/Items/armorDress.dart';
import 'package:game_flame/Items/helmetDress.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/Items/swordDress.dart';
import 'package:game_flame/abstracts/compiller.dart';
import 'package:game_flame/components/CountTimer.dart';
import 'package:game_flame/components/DBHandler.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/quests.dart';
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
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

ValueNotifier<int> isMapCached = ValueNotifier(0);
const double aspect = 750.0 / 430.0;


class KyrgyzGame extends Forge2DGame with HasKeyboardHandlerComponents, WidgetsBindingObserver, SingleGameInstance
{
  KyrgyzGame() : super(
    world: UpWorld()
  );

  final DbHandler dbHandler = DbHandler();
  final CustomTileMap gameMap = CustomTileMap();
  late PlayerData playerData;
  late final SharedPreferences prefs;
  static Map<String,Iterable<XmlElement>> cachedGround = {};
  static Map<String,Iterable<XmlElement>> cachedObjects = {};
  static Map<String,Iterable<XmlElement>> cachedAnims = {};
  static Map<String,ext.Image> cachedImgs = {};
  static Set<String> cachedMapPngs = {};
  Database? database;
  late FragmentProgram _telepShaderProgramm;
  late FragmentProgram _fireShaderProgramm;
  late FragmentProgram _iceShaderProgramm;
  late FragmentProgram _poisonShaderProgramm;
  late FragmentProgram _lightningShaderProgramm;
  late FragmentShader telepShader;
  late FragmentShader fireShader;
  late FragmentShader iceShader;
  late FragmentShader poisonShader;
  late FragmentShader lightningShader;

  Future saveGame() async
  {
    await dbHandler.saveGame(0, gameMap.orthoPlayer?.x ?? gameMap.frontPlayer!.x, gameMap.orthoPlayer?.y ?? gameMap.frontPlayer!.y
        , gameMap.currentGameWorldData!.nameForGame, playerData.health.value,  playerData.energy.value,  playerData.playerLevel.value
        , playerData.money.value, playerData.helmetDress.value, playerData.armorDress.value, playerData.glovesDress.value, playerData.swordDress.value
        , playerData.ringDress.value, playerData.bootsDress.value, playerData.weaponInventar, playerData.armorInventar, playerData.flaskInventar, playerData.itemInventar
    ,gameMap.effectComponent.children.toList(growable: false).cast());
  }

  @override
  Future onLoad() async
  {
    FlameAudio.bgm.initialize();
    // FlameAudio.bgm.play('background.mp3');
    playerData = PlayerData(this);
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    await dbHandler.openDb();
    // database = await openDatabase('kyrgyz.db');
    // await database?.rawQuery('select is_cached_into_internal from kyrgyz_game.settings');
    maxPolygonVertices = 20;
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    Flame.images.prefix = 'assets/';
    _telepShaderProgramm = await FragmentProgram.fromAsset('assets/shaders/portalShader.frag');
    _fireShaderProgramm = await FragmentProgram.fromAsset('assets/shaders/portalShader.frag');
    _iceShaderProgramm = await FragmentProgram.fromAsset('assets/shaders/ice.frag');
    _poisonShaderProgramm = await FragmentProgram.fromAsset('assets/shaders/poison.frag');
    _lightningShaderProgramm = await FragmentProgram.fromAsset('assets/shaders/lightning.frag');
    telepShader = _telepShaderProgramm.fragmentShader();
    fireShader = _fireShaderProgramm.fragmentShader();
    iceShader = _iceShaderProgramm.fragmentShader();
    poisonShader = _poisonShaderProgramm.fragmentShader();
    lightningShader = _lightningShaderProgramm.fragmentShader();
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
    if(!await dbHandler.checkSaved(0)) {
      await dbHandler.saveGame(
          0,
          4772,
          9433,
          'topLeftTempleDungeon',
          30,
          15,
          1,
          100,
          StartHelmet(),
          ArmorStart(),
          NullItem(),
          SwordStart(),
          NullItem(),
          NullItem(),
          {'swordStart': 1, 'sword36': 1, 'sword19': 1},
          {'armorStart': 1, 'startHelmet': 1},
          {'hpSmall': 10,
            'hpMedium': 10,
            'hpBig': 10,
            'hpFull': 10,
            'energySmall': 10,
            'energyMedium': 10,
            'energyBig': 10,
            'energyFull': 10}
          ,
          {},
          []);
    }

    await loadGame(0);
    
    // playerData.setStartValues(
    //   helmet: StartHelmet(),
    //   armor: ArmorStart(),
    //   sword: SwordStart(),
    //   weaponInventar: {'swordStart': 1, 'sword36' : 1, 'sword19' : 1},
    //   armorInventar: {'armorStart': 1, 'startHelmet': 1},
    //   flaskInventar: {
    //     'hpSmall':10,
    //     'hpMedium':10,
    //     'hpBig':10,
    //     'hpFull':10,
    //     'energySmall':10,
    //     'energyMedium':10,
    //     'energyBig':10,
    //     'energyFull':10},
    // );
    add(gameMap);
    await gameMap.loaded;
    //TODO добавить сохранённые бутылочки в gameMap;
  }

  Future loadGame(int saveId) async
  {
    playerData.loadGame(await dbHandler.loadGame(saveId));
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    double xZoom = size.x / 768;
    double yZoom = size.y / 448;
    camera.viewfinder.zoom = max(xZoom, yZoom) + 0.04;
    if(gameMap.isMounted) {
      gameMap.setCameraBounds();
    }
  }

  void doGameHud()
  {
    FlameAudio.bgm.stop();
    resumeEngine();
    _showOverlay(overlayName: GameHud.id,isHideOther: true);
  }

  void doDialogHud(Quest quest)
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
  KeyEventResult onKeyEvent(KeyEvent event,
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
    // FlameAudio.bgm.play('background.mp3');
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
}
