import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/MapNode.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/overlays/health_bar.dart';
import 'package:game_flame/overlays/joysticks.dart';
import 'package:game_flame/players/front_player.dart';
import 'package:game_flame/players/ortho_player.dart';

class LoadedColumnRow
{
  LoadedColumnRow(this.column, this.row);
  int column;
  int row;
}

class CustomTileMap extends PositionComponent with HasGameRef<KyrgyzGame>
{
  final _imageBatchCompiler = ImageBatchCompiler();
  ObjectHitbox? currentObject;
  int countId=0;
  OrthoPlayer? orthoPlayer;
  late FrontPlayer frontPlayer = FrontPlayer(Vector2.all(1));
  int _column=0,_row=0;
  final List<MapNode> _mapNodes = [];
  bool isFirstLoad = false;
  Set<int> loadedColumns = {};
  Set<int> loadedRows = {};

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
    loadedColumns.removeWhere((element) => (element - newColumn).abs() > 2);
    loadedRows.removeWhere((element) => (element - newRow).abs() > 2);
    var toRemove = [];
    if(newColumn < tempColumn){
      for(final node in _mapNodes) {
        if (node.column == newColumn + 2) {
          toRemove.add(node);
          node.removeFromParent();
        }
      }
      for(int i=0;i<3;i++) {
        var node = MapNode(newColumn - 1, newRow + i - 1,_imageBatchCompiler);
        await add(node);
        await node.generateMap();
        _mapNodes.add(node);
      }
    }
    if(newColumn > tempColumn){
      for(final node in _mapNodes) {
        if (node.column == newColumn - 2) {
          toRemove.add(node);
          node.removeFromParent();
        }
      }
      for(int i=0;i<3;i++) {
        var node = MapNode(newColumn + 1, newRow + i - 1,_imageBatchCompiler);
        await add(node);
        await node.generateMap();
        _mapNodes.add(node);
      }
    }
    if(newRow < tempRow){
      for(final node in _mapNodes) {
        if (node.row == newRow + 2) {
          toRemove.add(node);
          node.removeFromParent();
        }
      }
      for(int i=0;i<3;i++) {
        var node = MapNode(newColumn + i - 1, newRow - 1,_imageBatchCompiler);
        await add(node);
        await node.generateMap();
        _mapNodes.add(node);
      }
    }
    if(newRow > tempRow){
      for(final node in _mapNodes) {
        if (node.row == newRow - 2) {
          toRemove.add(node);
          node.removeFromParent();
        }
      }
      for(int i=0;i<3;i++) {
        var node = MapNode(newColumn + i - 1, newRow + 1,_imageBatchCompiler);
        await add(node);
        await node.generateMap();
        _mapNodes.add(node);
      }
    }
    loadedColumns.addAll({_column,_column - 1, _column + 1});
    loadedRows.addAll({_row,_row - 1, _row + 1});
    _mapNodes.removeWhere((element) => toRemove.contains(element));
  }

  clearGameMap()
  {
    removeWhere((component) => component is! OrthoPlayer || component is! FrontPlayer);
  }

  Future<void> loadNewMap(Vector2 playerPos) async
  {
    _column = playerPos.x ~/ GameConsts.lengthOfTileSquare;
    _row = playerPos.y ~/ GameConsts.lengthOfTileSquare;
    for(int i=0;i<3;i++) {
      for(int j=0;j<3;j++) {
        var node = MapNode(_column + j - 1, _row + i - 1,_imageBatchCompiler);
        await add(node);
        await node.generateMap();
        _mapNodes.add(node);
      }
    }
    loadedColumns.addAll({_column,_column - 1, _column + 1});
    loadedRows.addAll({_row,_row - 1, _row + 1});
    orthoPlayer = null;
    orthoPlayer = OrthoPlayer();
    await add(orthoPlayer!);
    orthoPlayer?.priority = GamePriority.player;
    orthoPlayer?.position = playerPos;
    // await add(ScreenHitbox());
    gameRef.showOverlay(overlayName: OrthoJoystick.id,isHideOther: true);
    gameRef.showOverlay(overlayName: HealthBar.id);
    gameRef.camera.followComponent(orthoPlayer!);
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
    if(orthoPlayer != null && isFirstLoad) {
      int col = orthoPlayer!.position.x ~/ GameConsts.lengthOfTileSquare;
      int row = orthoPlayer!.position.y ~/ GameConsts.lengthOfTileSquare;
      if (col != _column || row != _row) {
        reloadWorld(col, row);
      }
    }
  }
}