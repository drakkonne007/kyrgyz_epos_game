import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/Items/Dresses/ringDress.dart';
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
import 'package:game_flame/Items/Dresses/armorDress.dart';
import 'package:game_flame/Items/Dresses/helmetDress.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/Items/Dresses/swordDress.dart';
import 'package:game_flame/abstracts/player.dart';
import 'package:game_flame/components/DBHandler.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/abstracts/quest.dart';
import 'package:game_flame/gen/strings.g.dart';
import 'package:game_flame/main.dart';
import 'package:game_flame/overlays/PrettySplash.dart';
import 'package:game_flame/overlays/buy_overlay.dart';
import 'package:game_flame/overlays/death_menu.dart';
import 'package:game_flame/overlays/dialog_overlay.dart';
import 'package:game_flame/overlays/game_hud.dart';
import 'package:game_flame/overlays/game_pause.dart';
import 'package:game_flame/overlays/inventar_overlay.dart';
import 'package:game_flame/overlays/language.dart';
import 'package:game_flame/overlays/main_menu.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:game_flame/overlays/mapOverlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

ValueNotifier<int> isMapCached = ValueNotifier(0);
const double aspect = 750.0 / 430.0;

enum InventarOverlayType
{
  helmet,
  armor,
  gloves,
  boots,
  sword,
  ring,
  flask,
  item,
  quests,
  map
}

enum PlayerState
{
  armor,
  damage,
  magicDamage,
  lengthMagicDamage,
  attackSpeed,
  uvorot,
}


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
  Map<String, int> currentShopItems = {'helmet1': 1,'helmet5': 1,'helmet10': 1,'helmet45': 1,
    'armor10': 1, 'armor50': 1, 'armor25': 1,'armor30': 1,
    'gloves10': 1, 'gloves50': 1, 'gloves25': 1,'gloves30': 1,
    'boots1': 1,'boots4': 1,'boots2': 1,'boots3': 1,'boots20': 1,'boots30': 1,'hpSmall': 10,'hpMedium': 10,
    'hpBig': 10,'hpFull': 10,'energySmall': 10,
    'energyMedium': 10,'energyBig': 10,'energyFull': 10,'manaSmall': 10,'manaMedium': 10,'manaBig': 10,'manaFull': 10,
    'sword1': 1, 'sword2': 1, 'sword3': 1,'sword4': 1,'sword5': 1,'sword6': 1,'sword7': 1,'sword8': 1,'sword9': 1,
    'ring1' : 1, 'ring2' : 1, 'ring3' : 1, 'ring4' : 1, 'ring5' : 1};


  ValueNotifier<Item?> currentItemInInventar = ValueNotifier<Item?>(null);
  Image? imageForMap;
  Quest? currentQuest;
  Map<String,Quest> quests = {};
  ValueNotifier<InventarOverlayType> currentStateInventar = ValueNotifier<InventarOverlayType>(InventarOverlayType.helmet);

  Future saveGame() async
  {
    await dbHandler.saveGame(
        saveId: 0,
        x: playerPosition().x,
        y: playerPosition().y,
        world: gameMap.currentGameWorldData!.nameForGame,
        health: playerData.health.value,
        mana: playerData.mana.value,
        energy: playerData.energy.value,
        level: playerData.experience.value,
        gold: playerData.money.value,
        helmetDress: playerData.helmetDress.value,
        armorDress: playerData.armorDress.value,
        glovesDress: playerData.glovesDress.value,
        swordDress: playerData.swordDress.value,
        ringDress: playerData.ringDress.value,
        bootsDress: playerData.bootsDress.value,
        helmetInventar: playerData.helmetInventar,
        bodyArmorInventar: playerData.bodyArmorInventar,
        glovesInventar: playerData.glovesInventar,
        bootsInventar: playerData.bootsInventar,
        flaskInventar: playerData.flaskInventar,
        itemInventar: playerData.itemInventar,
        swordInventar: playerData.swordInventar,
        ringInventar: playerData.ringInventar,
        currentFlask1: playerData.currentFlask1.value,
        currentFlask2: playerData.currentFlask2.value,
        tempEffects:  gameMap.effectComponent.children.toList(growable: false).cast());
  }

  Future setQuestState(String name, int state, bool isDone)async
  {
    quests[name]?.isDone = isDone;
    quests[name]?.currentState = state;
    dbHandler.setQuestState(name, state, isDone);
  }

  Vector2 playerPosition()
  {
    return gameMap.orthoPlayer?.position ?? gameMap.frontPlayer!.position;
  }

  MainPlayer gamePlayer()
  {
    var temp = gameMap.orthoPlayer == null ? gameMap.frontPlayer! : gameMap.orthoPlayer!;
    return temp as MainPlayer;
  }

  bool isPlayerFlipped()
  {
    return gameMap.orthoPlayer?.isFlippedHorizontally ?? gameMap.frontPlayer!.isFlippedHorizontally;
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
    // await dbHandler.dropAllTables();
    await dbHandler.createTable(); //TODO создаёт, но если удалишь кэш с телефона
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
      overlays.add(SplashScreenGame.id);
    }
    WidgetsBinding.instance.addObserver(this);
    await setQuestState('chestOfGlory', 0, false);
    await setQuestState('templeDungeon', 0, false);
    for(final name in Quest.allQuests){
      quests[name] = Quest.questFromName(this, name);
      final state = await dbHandler.getQuestState(name);
      quests[name]!.isDone = state.isDone;
      quests[name]!.currentState = state.currentState;
    }
    add(gameMap);
    await gameMap.loaded;
    //TODO добавить сохранённые бутылочки в gameMap;
  }

  Future loadGame(int saveId) async
  {
    playerData.loadGame(await dbHandler.loadGame(saveId));
  }

  Future saveFirstGame(bool hard, int saveId) async
  {
    if(!await dbHandler.checkSaved(saveId) || hard) {
      if(hard){
        await dbHandler.fillGameObjects(true);
        await dbHandler.refreshQuests();
      }
      await dbHandler.saveGame(
        saveId: saveId,
        x: 1750,
        y: 3000,
        world: 'topLeftVillage',
        health: 100,
        mana: 50,
        energy: 50,
        level: 0,
        gold: 2000,
        helmetDress: Helmet1(),
        armorDress: Armor10(),
        glovesDress: NullItem(),
        swordDress: Sword1(),
        ringDress: Ring1(),
        bootsDress: NullItem(),
        helmetInventar: {'helmet1': 1,'helmet5': 1,'helmet10': 1,'helmet45': 1},
        bodyArmorInventar: {'armor10': 1, 'armor50': 1, 'armor25': 1,'armor30': 1},
        glovesInventar: {'gloves10': 1, 'gloves50': 1, 'gloves25': 1,'gloves30': 1},
        bootsInventar: {'boots1': 1,'boots4': 1,'boots2': 1,'boots3': 1,'boots20': 1,'boots30': 1},
        flaskInventar: {
          'hpSmall': 10,
          'hpMedium': 10,
          'hpBig': 10,
          'hpFull': 10,
          'energySmall': 10,
          'energyMedium': 10,
          'energyBig': 10,
          'energyFull': 10,
          'manaSmall': 10,
          'manaMedium': 10,
          'manaBig': 10,
          'manaFull': 10},
        itemInventar: {},
        swordInventar: {'sword1': 1, 'sword2': 1, 'sword3': 1,'sword4': 1,'sword5': 1,'sword6': 1,'sword7': 1,'sword8': 1,'sword9': 1},
        ringInventar: {'ring1' : 1, 'ring2' : 1, 'ring3' : 1, 'ring4' : 1, 'ring5' : 1},
        tempEffects: [],
      );
    }
    await loadGame(saveId);
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

  void doBuyMenu()
  {
    pauseEngine();
    _showOverlay(overlayName: BuyOverlay.id,isHideOther: true);
  }

  void doMapHud() async
  {
    FlameAudio.bgm.stop();
    pauseEngine();
    final composition = ImageCompositionExt();
    var img = await Flame.images.load('metaData/${gameMap.currentGameWorldData?.nameForGame}/fullMap.png');
    composition.add(img, Vector2.zero());
    Set<LoadedColumnRow> temp = {};
    Set<LoadedColumnRow> clearMap = await dbHandler.getClearMap(0, gameMap.currentGameWorldData!.nameForGame);
    for(final loadCol in clearMap){
      int col = loadCol.column;
      int row = loadCol.row;
      for(int i=-1;i<2;i++) {
        for(int j=-1;j<2;j++) {
          temp.add(LoadedColumnRow(col + i, row + j));
        }
      }
    }
    for (int cols = 0; cols < gameMap.currentGameWorldData!.gameConsts.maxColumn; cols++) {
      for (int rows = 0; rows < gameMap.currentGameWorldData!.gameConsts.maxRow; rows++) {
        LoadedColumnRow loadedColumnRow = LoadedColumnRow(cols, rows);
        if(temp.contains(loadedColumnRow)){
          continue;
        }
        composition.add(await Flame.images.load('nullDarkQuarter.png'), Vector2(cols * GameConsts.lengthOfTileSquare.x / 4, rows * GameConsts.lengthOfTileSquare.y / 4));
      }
    }
    var player = await Flame.images.load('images/inventar/warrior.png');
    composition.add(player, playerPosition() / 4 - Vector2(player.width / 2, player.height / 2));
    final newImg = composition.compose();
    // newImg = await newImg.resize(Vector2(newImg.width / 4, newImg.height / 4));
    var bytes = await newImg.toByteData(format: ImageByteFormat.png);
    imageForMap = Image.memory(bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    _showOverlay(overlayName: MapOverlay.id, isHideOther: true);
  }

  void doDialogHud(String id)async
  {
    if(!quests.containsKey(id)){
      throw 'wrong quest!!! $id';
    }
    currentQuest = quests[id]!;
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

  Future startGame(int saveId) async
  {
    await saveFirstGame(isNeedCopyInternal,saveId);
    await loadNewMap();
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
