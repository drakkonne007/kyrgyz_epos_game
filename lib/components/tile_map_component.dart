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
import 'package:game_flame/players/sword_enemy.dart';

class CustomTileMap extends Component with HasGameRef<KyrgyzGame>
{
  final _lengthOfTileSquare = 32*30 * GameConsts.gameScale;
  ImageBatchCompiler _imageBatchCompiler = ImageBatchCompiler();
  late Vector2 _playerPos;
  ObjectHitbox? currentObject;
  int countId=0;
  late PositionComponent bground;
  late PositionComponent upperPlayer;
  OrthoPlayer? orthoPlayer;
  late FrontPlayer frontPlayer = FrontPlayer(Vector2.all(1));
  int _column=0,_row=0;
  List<MapNode> _mapNodes = []; //Ноды по столбикам
  bool isFirstLoad = false;

  int getNewId(){
    return countId++;
  }

  Future<void> reloadWorld(int newColumn, int newRow) async
  {
    print('start dynamic reload, column: $newColumn, row: $newRow');
    var toRemove = [];
    if(newColumn < _column){
      for(final node in _mapNodes) {
        if (node.column == newColumn + 2) {
          toRemove.add(node);
          node.removeFromParent();
        }
      }
      for(int i=0;i<3;i++) {
        var node = MapNode(newColumn - 1, newRow + i - 1,_imageBatchCompiler);
        await add(node);
        _mapNodes.add(node);
      }
    }
    if(newColumn > _column){
      for(final node in _mapNodes) {
        if (node.column == newColumn - 2) {
          toRemove.add(node);
          node.removeFromParent();
        }
      }
      for(int i=0;i<3;i++) {
        var node = MapNode(newColumn + 1, newRow + i - 1,_imageBatchCompiler);
        await add(node);
        _mapNodes.add(node);
      }
    }
    if(newRow < _row){
      for(final node in _mapNodes) {
        if (node.row == newRow + 2) {
          toRemove.add(node);
          node.removeFromParent();
        }
      }
      for(int i=0;i<3;i++) {
        var node = MapNode(newColumn + i - 1, newRow - 1,_imageBatchCompiler);
        await add(node);
        _mapNodes.add(node);
      }
    }
    if(newRow > _row){
      for(final node in _mapNodes) {
        if (node.row == newRow - 2) {
          toRemove.add(node);
          node.removeFromParent();
        }
      }
      for(int i=0;i<3;i++) {
        var node = MapNode(newColumn + i - 1, newRow + 1,_imageBatchCompiler);
        await add(node);
        _mapNodes.add(node);
      }
    }
    _mapNodes.removeWhere((element) => toRemove.contains(element));
    _column = newColumn;
    _row = newRow;
  }

  clearGameMap()
  {
    removeWhere((component) => component is! OrthoPlayer || component is! FrontPlayer);
  }

  Future<void> loadNewMap(Vector2 playerPos) async
  {
    _playerPos = playerPos;
    _column = _playerPos.x ~/ _lengthOfTileSquare;
    _row = _playerPos.y ~/ _lengthOfTileSquare;
    print('load new map');
    print('column: $_column, row: $_row');
    for(int i=0;i<3;i++) {
      for(int j=0;j<3;j++) {
        var node = MapNode(_column + j - 1, _row + i - 1,_imageBatchCompiler);
        await node.generateMap();
        await add(node);
        _mapNodes.add(node);
      }
    }
    orthoPlayer = null;
    orthoPlayer = OrthoPlayer();
    await add(orthoPlayer!);
    orthoPlayer?.priority = GamePriority.player;
    orthoPlayer?.position = _playerPos;
    // await add(ScreenHitbox());
    gameRef.showOverlay(overlayName: OrthoJoystick.id,isHideOther: true);
    gameRef.showOverlay(overlayName: HealthBar.id);
    gameRef.camera.followComponent(orthoPlayer!);
    print('end load new map');
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
      int col = orthoPlayer!.position.x ~/ _lengthOfTileSquare;
      int row = orthoPlayer!.position.y ~/ _lengthOfTileSquare;
      if (col != _column || row != _row) {
        await reloadWorld(col, row);
      }
    }
  }
}