import 'dart:convert';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/abstracts/collision_custom_processor.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
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

class CustomTileMap extends PositionComponent with HasGameRef<KyrgyzGame>
{
  ValueNotifier<ObjectHitbox?> currentObject = ValueNotifier(null);
  static int countId = 0;
  OrthoPlayer? orthoPlayer;
  late FrontPlayer frontPlayer = FrontPlayer(Vector2.all(1));
  int _column=0, _row=0;
  MapNode? mapNode;
  Set<Vector2> loadedLivesObjs = {};
  Map<LoadedColumnRow,List<Component>> allEls = {};
  final List<Ground> grounds = [];
  DCollisionProcessor? collisionProcessor;
  GameWorldData? _currentGameWorldData;
  bool _isLoad = false;



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
    _isLoad = false;
    collisionProcessor ??= DCollisionProcessor(gameRef);
    collisionProcessor?.clearActiveCollEntity();
    collisionProcessor?.clearStaticCollEntity();
    orthoPlayer?.reInsertFullActiveHitBoxes();
    mapNode ??= MapNode(gameRef);
    var tempList = allEls.values.toList(growable: false);
    for(final temp in tempList){
      for(final el in temp){
        el.removeFromParent();
      }
    }
    allEls.clear();
    grounds.clear();
    loadedLivesObjs.clear();
    currentObject.value = null;
    // if(_currentGameWorldData != null && _currentGameWorldData!.nameForGame == gameRef.playerData.playerBigMap.nameForGame){
    //   smallRestart();
    //   return;
    // }
    _currentGameWorldData = gameRef.playerData.playerBigMap;
    print(_currentGameWorldData?.nameForGame);
    await _preloadAnimAndObj();
    while(isMapCached.value < 4){
      await Future.delayed(const Duration(milliseconds: 100));
    }
    print(isMapCached.value);
    _column = gameRef.playerData.startLocation.x ~/ (_currentGameWorldData!.gameConsts.lengthOfTileSquare.x);
    _row = gameRef.playerData.startLocation.y ~/ (_currentGameWorldData!.gameConsts.lengthOfTileSquare.y);
    for(int i=0;i<3;i++) {
      for(int j=0;j<3;j++) {
        mapNode?.generateMap(LoadedColumnRow(_column + j - 1, _row + i - 1));
      }
    }
    grounds.clear();
    for(int i=0;i<_currentGameWorldData!.gameConsts.maxColumn!;i++){
      for(int j=0;j<_currentGameWorldData!.gameConsts.maxRow!;j++){
        if (KyrgyzGame.cachedObjXmls.containsKey('$i-$j.objXml')) {
          var objects = KyrgyzGame.cachedObjXmls['$i-$j.objXml']!;
          for(final obj in objects){
            String? name = obj.getAttribute('nm');
            if(name == ''){
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
              if (temp.isNotEmpty) {
                var ground = Ground(temp, collisionType: DCollisionType.passive,
                    isSolid: false,
                    isStatic: true,
                    isLoop: obj.getAttribute('lp')! == '1',
                    game: gameRef,
                    column: i,
                    row: j);
                grounds.add(ground);
              }
            }
          }
        }
      }
    }
    print('total ground ${grounds.length}');
    if(orthoPlayer == null){
      orthoPlayer= OrthoPlayer();
      await add(orthoPlayer!);
    }
    orthoPlayer?.priority = GamePriority.player;
    gameRef.playerData.health.value = gameRef.playerData.maxHealth.value;
    orthoPlayer?.position = gameRef.playerData.startLocation;
    gameRef.doGameHud();
    gameRef.camera.followComponent(orthoPlayer!, worldBounds: Rect.fromLTRB(0,0,_currentGameWorldData!.gameConsts.lengthOfTileSquare.x
        *_currentGameWorldData!.gameConsts.maxColumn!,
        _currentGameWorldData!.gameConsts.lengthOfTileSquare.y
            *_currentGameWorldData!.gameConsts.maxRow!));
    gameRef.camera.zoom = 1.35;
    _isLoad = true;
  }

  Future _preloadAnimAndObj() async
  {
    isMapCached.value = 0;
    KyrgyzGame.cachedObjXmls.clear();
    KyrgyzGame.cachedAnims.clear();
    KyrgyzGame.cachedImgs.clear();
    KyrgyzGame.cachedMapPngs.clear();
    // await firstCachedIntoInternal();
    loadObjs(_currentGameWorldData!);
    loadAnimsHigh(_currentGameWorldData!);
    loadAnimsDown(_currentGameWorldData!);
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final manifestMap = json.decode(manifestContent) as Map<String, dynamic>;
    final imagePaths = manifestMap.keys.where((path) {
      return path.startsWith('assets/metaData/${_currentGameWorldData!.nameForGame}/') && path.toLowerCase().endsWith('.png');
    }).map((path) => path.replaceFirst('assets/metaData/${_currentGameWorldData!.nameForGame}/', ''));
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
  Future<void> update(double dt) async
  {
    if(!_isLoad){
      return;
    }
    collisionProcessor?.updateCollisions();
    if(orthoPlayer != null) {
      int col = orthoPlayer!.position.x ~/ (_currentGameWorldData!.gameConsts.lengthOfTileSquare.x);
      int row = orthoPlayer!.position.y ~/ (_currentGameWorldData!.gameConsts.lengthOfTileSquare.y);
      if (col != _column || row != _row) {
        reloadWorld(col, row);
      }
    }
  }

  Future<void> reloadWorld(int newColumn, int newRow) async
  {
    var tempColumn = _column;
    var tempRow = _row;
    _column = newColumn;
    _row = newRow;
    List<LoadedColumnRow> toRemove = [];
    Set<LoadedColumnRow> allEllsSet = allEls.keys.toSet();
    if(newColumn < tempColumn){
      for(final node in allEllsSet) {
        if (node.column == newColumn + 2) {
          toRemove.add(node);
        }
      }
      for(int i=0;i<3;i++) {
        mapNode?.generateMap(LoadedColumnRow(newColumn - 1, newRow + i - 1));
      }
    }
    if(newColumn > tempColumn){
      for(final node in allEllsSet) {
        if (node.column == newColumn - 2) {
          toRemove.add(node);
        }
      }
      for(int i=0;i<3;i++) {
        mapNode?.generateMap(LoadedColumnRow(newColumn + 1, newRow + i - 1));
      }
    }
    if(newRow < tempRow){
      for(final node in allEllsSet) {
        if (node.row == newRow + 2) {
          toRemove.add(node);
        }
      }
      for(int i=0;i<3;i++) {
        mapNode?.generateMap(LoadedColumnRow(newColumn + i - 1, newRow - 1));
      }
    }
    if(newRow > tempRow){
      for(final node in allEllsSet) {
        if (node.row == newRow - 2) {
          toRemove.add(node);
        }
      }
      for(int i=0;i<3;i++) {
        mapNode?.generateMap(LoadedColumnRow(newColumn + i - 1, newRow + 1));
      }
    }
    for(final node in toRemove) {
      if(allEls.containsKey(node)){
        for(final dd in allEls[node]!){
          dd.removeFromParent();
        }
      }
      // collisionProcessor.removeStaticCollEntity(node);
      allEls.remove(node);
    }
    orthoPlayer?.priority = GamePriority.player-1;
    orthoPlayer?.priority = GamePriority.player;
  }
}