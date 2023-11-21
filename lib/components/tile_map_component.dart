import 'dart:convert';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/abstracts/collision_custom_processor.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/MapNode.dart';
import 'package:game_flame/components/cached_utils.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/main.dart';
import 'package:game_flame/overlays/health_bar.dart';
import 'package:game_flame/overlays/joysticks.dart';
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

  ObjectHitbox? currentObject;
  static int countId = 0;
  OrthoPlayer? orthoPlayer;
  late FrontPlayer frontPlayer = FrontPlayer(Vector2.all(1));
  int _column=0, _row=0;
  MapNode? _mapNode;
  bool isFirstLoad = false;
  Set<Vector2> loadedLivesObjs = {};
  Map<LoadedColumnRow,List<Component>> allEls = {};
  final DCollisionProcessor collisionProcessor = DCollisionProcessor();

  @override
  Future<void> onLoad() async
  {
    _mapNode = MapNode(this);
  }

  Future preloadAnimAndObj() async
  {
    var timer = Stopwatch();
    isMapCached.value = false;
    KyrgyzGame.cachedObjXmls.clear();
    KyrgyzGame.cachedAnims.clear();
    KyrgyzGame.cachedImgs.clear();
    KyrgyzGame.cachedMapPngs.clear();
    // await firstCachedIntoInternal();
    timer.start();
    loadObjs().ignore();
    loadAnimsHigh().ignore();
    loadAnimsDown().ignore();
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final manifestMap = json.decode(manifestContent) as Map<String, dynamic>;
    final imagePaths = manifestMap.keys.where((path) {
      return path.startsWith('assets/metaData/') && path.toLowerCase().endsWith('.png');
    }).map((path) => path.replaceFirst('assets/metaData/', ''));
    for(final path in imagePaths) {
      KyrgyzGame.cachedMapPngs.add(path);
    }
    timer.stop();
    print('all map load time: ${timer.elapsedMilliseconds}');
    print('end preload');
    isMapCached.value = true;
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

  Future<void> reloadWorld(int newColumn, int newRow) async
  {
    var tempColumn = _column;
    var tempRow = _row;
    _column = newColumn;
    _row = newRow;
    print('loadNewMap $newColumn $newRow');
    List<LoadedColumnRow> toRemove = [];
    Set<LoadedColumnRow> allEllsSet = allEls.keys.toSet();
    if(newColumn < tempColumn){
      for(final node in allEllsSet) {
        if (node.column == newColumn + 2) {
          toRemove.add(node);
        }
      }
      for(int i=0;i<3;i++) {
        _mapNode?.generateMap(LoadedColumnRow(newColumn - 1, newRow + i - 1));
      }
    }
    if(newColumn > tempColumn){
      for(final node in allEllsSet) {
        if (node.column == newColumn - 2) {
          toRemove.add(node);
        }
      }
      for(int i=0;i<3;i++) {
        _mapNode?.generateMap(LoadedColumnRow(newColumn + 1, newRow + i - 1));
      }
    }
    if(newRow < tempRow){
      for(final node in allEllsSet) {
        if (node.row == newRow + 2) {
          toRemove.add(node);
        }
      }
      for(int i=0;i<3;i++) {
        _mapNode?.generateMap(LoadedColumnRow(newColumn + i - 1, newRow - 1));
      }
    }
    if(newRow > tempRow){
      for(final node in allEllsSet) {
        if (node.row == newRow - 2) {
          toRemove.add(node);
        }
      }
      for(int i=0;i<3;i++) {
        _mapNode?.generateMap(LoadedColumnRow(newColumn + i - 1, newRow + 1));
      }
    }
    for(final node in toRemove) {
      if(allEls.containsKey(node)){
        for(final dd in allEls[node]!){
          dd.removeFromParent();
        }
      }
      allEls.remove(node);
    }
    orthoPlayer?.priority = GamePriority.player-1;
    orthoPlayer?.priority = GamePriority.player;
  }

  clearGameMap()
  {
    removeWhere((component) => component is! OrthoPlayer || component is! FrontPlayer);
  }

  Future<void> loadNewMap(Vector2 playerPos) async
  {
    _mapNode?.myGame = gameRef;
    if(isMapCompile){
      await _mapNode?.generateMap(LoadedColumnRow(0,0));
    }
    _column = playerPos.x ~/ (GameConsts.lengthOfTileSquare.x);
    _row = playerPos.y ~/ (GameConsts.lengthOfTileSquare.y);
    for(int i=0;i<3;i++) {
      for(int j=0;j<3;j++) {
        _mapNode?.generateMap(LoadedColumnRow(_column + j - 1, _row + i - 1));
      }
    }
    orthoPlayer = null;
    orthoPlayer = OrthoPlayer();
    orthoPlayer?.position = playerPos;
    orthoPlayer?.priority = GamePriority.player;
    await add(orthoPlayer!);
    gameRef.showOverlay(overlayName: OrthoJoystick.id,isHideOther: true);
    gameRef.showOverlay(overlayName: HealthBar.id);
    gameRef.camera.followComponent(orthoPlayer!, worldBounds: Rect.fromLTRB(0,0,GameConsts.lengthOfTileSquare.x*GameConsts.maxColumn,GameConsts.lengthOfTileSquare.y*GameConsts.maxRow));
    gameRef.camera.zoom = 1.4;
    isFirstLoad = true;
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
    // _tickUpdateCollision += dt;
    // if(_tickUpdateCollision > 0.1) {
    //   _tickUpdateCollision = 0;
    // }
    collisionProcessor.updateCollisions();
    if(orthoPlayer != null && isFirstLoad) {
      int col = orthoPlayer!.position.x ~/ (GameConsts.lengthOfTileSquare.x);
      int row = orthoPlayer!.position.y ~/ (GameConsts.lengthOfTileSquare.y);
      if (col != _column || row != _row) {
        reloadWorld(col, row);
      }
    }
  }
}