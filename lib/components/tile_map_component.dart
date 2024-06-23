import 'dart:convert';
import 'dart:math';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart' as forge2d;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/ForgeOverrides/broadphase.dart';
import 'package:game_flame/ForgeOverrides/physicWorld.dart';
import 'package:game_flame/abstracts/collision_custom_processor.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/MapNode.dart';
import 'package:game_flame/components/cached_utils.dart';
import 'package:game_flame/components/game_worlds.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/main.dart';
import 'package:game_flame/players/front_player.dart';
import 'package:game_flame/players/ortho_player.dart';

class LoadedColumnRow
{
  LoadedColumnRow(this.column, this.row);
  int column;
  int row;

  @override
  bool operator ==(Object other) {
    return other is LoadedColumnRow && other.column == column && other.row == row;
  }

  @override
  int get hashCode => column.hashCode ^ row.hashCode;
}


class CustomTileMap extends World with HasGameRef<KyrgyzGame>, HasDecorator
{
  ValueNotifier<ObjectHitbox?> currentObject = ValueNotifier(null);
  static int countId = 0;
  OrthoPlayer? orthoPlayer;
  FrontPlayer? frontPlayer;
  int _column=0, _row=0;
  MapNode? mapNode;
  Set<Vector2> loadedLivesObjs = {};
  Map<LoadedColumnRow,List<Component>> allEls = {};
  DCollisionProcessor? collisionProcessor;
  GameWorldData? currentGameWorldData;
  bool _isLoad = false;
  double shaderTime = 0;
  Component container = Component();
  // final Component priorityHigh = Component(priority: GamePriority.high);
  // final Component priorityHighMinus1 = Component(priority: GamePriority.high - 1);
  // final Component priorityGroundPlus1 = Component(priority: GamePriority.ground + 1);
  // final Component enemyComponent = Component(priority: GamePriority.player - 2);
  // final Component playerLayout = Component(priority: GamePriority.player);
  // final Component enemyOnPlayer = Component(priority: GamePriority.player +2);


  @override
  Future onLoad() async
  {
    await add(container);
    // gameRef.camera = CameraComponent.withFixedResolution(width: 600, height: 350, world: this);
    // await add(playerLayout);
    // await add(enemyComponent);
    // await add(enemyOnPlayer);
    // await add(priorityGroundPlus1);
    // await add(priorityHighMinus1);
    // await add(priorityHigh);
  }


  int column()
  {
    return _column;
  }

  int row()
  {
    return _row;
  }

  int getNewId(){
    return countId++;
  }

  clearGameMap()
  {
    removeWhere((component) => component is! OrthoPlayer || component is! FrontPlayer);
  }

  Future<void> loadNewMap() async
  {

    game.world = UpWorld();
    var dworld = game.world.physicsWorld as WorldPhy;
    dworld.resetWorld();
    game.doLoadingMapHud();
    _isLoad = false;
    _column = -100;
    _row = -100;
    Flame.assets.clearCache();
    Flame.images.clearCache();
    if(orthoPlayer != null){
      container.remove(orthoPlayer!);
      orthoPlayer = null;
    }
    if(frontPlayer != null){
      container.remove(frontPlayer!);
      frontPlayer = null;
    }
    collisionProcessor ??= DCollisionProcessor(gameRef);
    collisionProcessor?.clearActiveCollEntity();
    collisionProcessor?.clearStaticCollEntity();
    mapNode ??= MapNode(gameRef);
    var tempList = allEls.values.toList(growable: false);
    for(final temp in tempList){
      for(final el in temp){
        el.removeFromParent();
      }
    }
    container.removeAll(container.children);


    allEls.clear();
    loadedLivesObjs.clear();
    currentObject.value = null;

    currentGameWorldData = gameRef.playerData.playerBigMap;
    if(currentGameWorldData == null) return;
    if(currentGameWorldData!.orientation == OrientatinType.front){
      game.world.gravity = Vector2(0,100);
    }else{
      game.world.gravity = Vector2(0,0);
    }
    var dd =  gameRef.world.physicsWorld.contactManager.broadPhase as MyBroadPhase;
    dd.initBroadPhase(currentGameWorldData!);
    isMapCached.value = 0;
    await _preloadAnimAndObj();
    while(isMapCached.value < 4){
      await Future.delayed(const Duration(milliseconds: 100));
    }

    for(int i=0;i<currentGameWorldData!.gameConsts.maxColumn!;i++){
      for(int j=0;j<currentGameWorldData!.gameConsts.maxRow!;j++){
        if (KyrgyzGame.cachedGround.containsKey('$i-$j.objXml')) {
          var objects = KyrgyzGame.cachedGround['$i-$j.objXml']!;
          for(final obj in objects){
            var points = obj.getAttribute('p')!;
            var pointsList = points.split(' ');
            List<Vector2> temp = [];
            for (final sources in pointsList) {
              if (sources == '') {
                continue;
              }
              temp.add(Vector2(double.parse(sources.split(',')[0]),
                  double.parse(sources.split(',')[1])));
            }
            if (temp.length > 1) {
              for( int i = 0; i < temp.length - 1; i++) {
                final shape = forge2d.EdgeShape()..set(temp[i] * PhysicVals.physicScale, temp[i + 1] * PhysicVals.physicScale);
                final fixtureDef = forge2d.FixtureDef(shape);
                var tt = Ground(forge2d.BodyDef(userData: BodyUserData(isQuadOptimizaion: true, loadedColumnRow: LoadedColumnRow(i, j))),gameRef.world.physicsWorld);
                tt.createFixture(fixtureDef);
              }
              if(obj.getAttribute('lp')! == '1'){
                final shape = forge2d.EdgeShape()..set(temp.last * PhysicVals.physicScale, temp.first * PhysicVals.physicScale);
                final fixtureDef = forge2d.FixtureDef(shape);
                var tt = Ground(forge2d.BodyDef(userData: BodyUserData(isQuadOptimizaion: true, loadedColumnRow: LoadedColumnRow(i, j))),gameRef.world.physicsWorld);
                tt.createFixture(fixtureDef);
              }
            }
          }
        }
      }
    }
    if(currentGameWorldData!.orientation == OrientatinType.orthogonal){
      if(orthoPlayer == null){
        orthoPlayer = OrthoPlayer(startPos: gameRef.playerData.startLocation);
        await container.add(orthoPlayer!);
        await orthoPlayer!.loaded;
      }
    }else{
      if(frontPlayer == null){
        frontPlayer = FrontPlayer(startPos: gameRef.playerData.startLocation);
        await container.add(frontPlayer!);
        await frontPlayer!.loaded;
      }
    }
    gameRef.camera.world = this;
    gameRef.camera.setBounds(Rectangle.fromLTRB(0,0,
        game.playerData.playerBigMap.gameConsts.visibleBounds!.x * 32,
        game.playerData.playerBigMap.gameConsts.visibleBounds!.y * 32), considerViewport: true);
    gameRef.camera.follow(frontPlayer ?? orthoPlayer!, snap: true);
    gameRef.doGameHud();
    _isLoad = true;
  }

  Future _preloadAnimAndObj() async
  {
    isMapCached.value = 0;
    KyrgyzGame.cachedObjects.clear();
    KyrgyzGame.cachedGround.clear();
    KyrgyzGame.cachedAnims.clear();
    KyrgyzGame.cachedImgs.clear();
    KyrgyzGame.cachedMapPngs.clear();
    if(isNeedCopyInternal) {
      isNeedCopyInternal = false;
      await firstCachedIntoInternal();
    }
    loadObjs(currentGameWorldData!);
    loadAnimsHigh(currentGameWorldData!);
    loadAnimsDown(currentGameWorldData!);
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final manifestMap = json.decode(manifestContent) as Map<String, dynamic>;
    final imagePaths = manifestMap.keys.where((path) {
      return path.startsWith('assets/metaData/${currentGameWorldData!.nameForGame}/') && path.toLowerCase().endsWith('.png');
    }).map((path) => path.replaceFirst('assets/metaData/${currentGameWorldData!.nameForGame}/', ''));
    await mutex.protect(() async  {
      for(final path in imagePaths) {
        KyrgyzGame.cachedMapPngs.add(path);
      }
    });
    isMapCached.value++;
  }

  Future<void> smallRestart() async
  {
    // removeWhere((component) => component is KyrgyzEnemy);
    // final enemySpawn = tiledMap.tileMap.getLayer<ObjectGroup>("objects");
    // for(final obj in enemySpawn!.objects){
    //   if(obj.name == 'enemy') {
    //     bground.add(SwordEnemy(Vector2(
    //         obj.x, obj.y)));
    //   }
    // }
  }

  @override
  void update(double dt)
  {
    shaderTime += dt;
    if(!_isLoad){
      return;
    }
    collisionProcessor?.updateCollisions();
    int col = gameRef.camera.visibleWorldRect.center.dx ~/ (currentGameWorldData!.gameConsts.lengthOfTileSquare.x);
    int row = gameRef.camera.visibleWorldRect.center.dy ~/ (currentGameWorldData!.gameConsts.lengthOfTileSquare.y);
    if (col != _column || row != _row) {
      repaintWorld(col, row);
    }
    // return;
    // int col = 0;
    // int row = 0;
    // if(orthoPlayer != null && !orthoPlayer!.gameHide){
    //   col = (orthoPlayer!.hitBox!.getCenter().x - 10) ~/ (currentGameWorldData!.gameConsts.lengthOfTileSquare.x);
    //   row = (orthoPlayer!.hitBox!.getCenter().y - 10) ~/ (currentGameWorldData!.gameConsts.lengthOfTileSquare.y);
    // }else if(frontPlayer != null && !frontPlayer!.gameHide){
    //   col = (frontPlayer!.hitBox!.getCenter().x - 10) ~/ (currentGameWorldData!.gameConsts.lengthOfTileSquare.x);
    //   row = (frontPlayer!.hitBox!.getCenter().y - 10) ~/ (currentGameWorldData!.gameConsts.lengthOfTileSquare.y);
    // }
    // print('col: $col, row: $row');
    // col = min(col, currentGameWorldData!.gameConsts.maxColumn! - 1);
    // row = min(row, currentGameWorldData!.gameConsts.maxRow! - 1);
  }

  void repaintWorld(int newColumn, int newRow)
  {
    _column = newColumn;
    _row = newRow;
    var dworld = game.world.physicsWorld as WorldPhy;
    dworld.changeActiveBodies(LoadedColumnRow(_column, _row));
    Set<LoadedColumnRow> allEllsSet = allEls.keys.toSet();
    for(final els in allEllsSet){
      if((els.row - _row).abs() >= 2 || (els.column - _column).abs() >= 2){
        if(allEls.containsKey(els)){
          for(final dd in allEls[els]!){
            dd.removeFromParent();
          }
        }
        allEls.remove(els);
      }
    }
    for(int i=-1;i<2;i++) {
      for(int j=-1;j<2;j++) {
        if(allEls.containsKey(LoadedColumnRow(_column + i, _row + j))){
          continue;
        }
        mapNode?.generateMap(LoadedColumnRow(_column + i, _row + j));
      }
    }
  }
}