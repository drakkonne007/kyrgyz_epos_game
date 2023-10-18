import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/MapNode.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/main.dart';
import 'package:game_flame/overlays/health_bar.dart';
import 'package:game_flame/overlays/joysticks.dart';
import 'package:game_flame/players/front_player.dart';
import 'package:game_flame/players/ortho_player.dart';
import 'package:xml/xml.dart';

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
  bool isCached = false;
  ObjectHitbox? currentObject;
  int countId=0;
  OrthoPlayer? orthoPlayer;
  late FrontPlayer frontPlayer = FrontPlayer(Vector2.all(1));
  int _column=0,_row=0;
  final List<MapNode> _mapNodes = [];
  bool isFirstLoad = false;
  Map<RectangleHitbox,int> rectHitboxes = {};
  Map<LoadedColumnRow,List<PositionComponent>> allEls = {};
  Set<Vector2> loadedLivesObjs = {};

  void preloadAnimAndObj() async
  {
    // KyrgyzGame.anims.clear();
    // KyrgyzGame.objXmls.clear();
    // KyrgyzGame.tiledPngs.clear();
    for(int cl = 0; cl < GameConsts.maxColumn; cl++){
      for(int rw = 0; rw < GameConsts.maxRow; rw++){
        // try{
        //   var temp = await Flame.assets.readFile('metaData/$cl-$rw.objXml');
        //   KyrgyzGame.objXmls['metaData/$cl-$rw.objXml'] = temp;
        // }catch(e){
        //   print(e);
        // }
        try{
          var animsDown = await Flame.assets.readFile(
              'metaData/$cl-${rw}_high.anim');
          var objects =
          XmlDocument.parse(animsDown.toString()).findAllElements('an');
          for (final obj in objects) {
            await Flame.images.load(obj.getAttribute('src')!);
          }
        }catch(e){
          e;
        }
        try{
          var animsHigh = await Flame.assets.readFile(
              'metaData/$cl-${rw}_down.anim');
          var objects
          = XmlDocument.parse(animsHigh.toString()).findAllElements('an');
          for (final obj in objects) {
            await Flame.images.load(obj.getAttribute('src')!);
          }
        }catch(e){
          print(e);
        }
        try{
          await Flame.images.load('metaData/$cl-${rw}_high.png');
        }catch(e){
          print(e);
        }
        try{
          await Flame.images.load('metaData/$cl-${rw}_down.png');
        }catch(e){
          print(e);
        }
      }
    }
    // gameRef.prefs.setStringList('tileds', KyrgyzGame.tiledPngs.keys.toList());
    // gameRef.prefs.setStringList('objs', KyrgyzGame.objXmls.keys.toList());
    // gameRef.prefs.setStringList('objs', KyrgyzGame.objXmls.keys.toList());
    isCached = true;
    print('stop cached map');
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
    List<MapNode> toRemove = [];
    if(newColumn < tempColumn){
      for(final node in _mapNodes) {
        if (node.column == newColumn + 2) {
          toRemove.add(node);
        }
      }
      for(int i=0;i<3;i++) {
        var node = MapNode(newColumn - 1, newRow + i - 1,this);
        node.generateMap();
        _mapNodes.add(node);
      }
    }
    if(newColumn > tempColumn){
      for(final node in _mapNodes) {
        if (node.column == newColumn - 2) {
          toRemove.add(node);
        }
      }
      for(int i=0;i<3;i++) {
        var node = MapNode(newColumn + 1, newRow + i - 1,this);
        node.generateMap();
        _mapNodes.add(node);
      }
    }
    if(newRow < tempRow){
      for(final node in _mapNodes) {
        if (node.row == newRow + 2) {
          toRemove.add(node);
        }
      }
      for(int i=0;i<3;i++) {
        var node = MapNode(newColumn + i - 1, newRow - 1,this);
        node.generateMap();
        _mapNodes.add(node);
      }
    }
    if(newRow > tempRow){
      for(final node in _mapNodes) {
        if (node.row == newRow - 2) {
          toRemove.add(node);
        }
      }
      for(int i=0;i<3;i++) {
        var node = MapNode(newColumn + i - 1, newRow + 1,this);
        node.generateMap();
        _mapNodes.add(node);
      }
    }
    LoadedColumnRow? cl;
    for(final node in toRemove) {
      cl = LoadedColumnRow(node.column, node.row);
      _mapNodes.remove(node);
      if(allEls.containsKey(cl)) {
        for(final list in allEls[cl]!){
          list.removeFromParent();
        }
        allEls.remove(cl);
      }
      for(final recs in node.hits){
        if(rectHitboxes.containsKey(recs)){
          rectHitboxes[recs] = rectHitboxes[recs]! - 1;
        }
        if(rectHitboxes[recs]! < 0){
          rectHitboxes.remove(recs);
          remove(recs);          // remove(recs);
        }
      }
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
    _column = playerPos.x ~/ (GameConsts.lengthOfTileSquare.x);
    _row = playerPos.y ~/ (GameConsts.lengthOfTileSquare.y);
    for(int i=0;i<3;i++) {
      for(int j=0;j<3;j++) {
        var node = MapNode(_column + j - 1, _row + i - 1,this);
        if(isMapCompile) {
          await node.generateMap();
        }else{
          node.generateMap();
        }
        _mapNodes.add(node);
      }
    }
    orthoPlayer = null;
    orthoPlayer = OrthoPlayer();
    await add(orthoPlayer!);
    orthoPlayer?.position = playerPos;
    orthoPlayer?.priority = GamePriority.player;
    gameRef.showOverlay(overlayName: OrthoJoystick.id,isHideOther: true);
    gameRef.showOverlay(overlayName: HealthBar.id);
    gameRef.camera.followComponent(orthoPlayer!);
    gameRef.camera.zoom = 1.27;
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
      int col = orthoPlayer!.position.x ~/ (GameConsts.lengthOfTileSquare.x);
      int row = orthoPlayer!.position.y ~/ (GameConsts.lengthOfTileSquare.y);
      if (col != _column || row != _row) {
        reloadWorld(col, row);
      }
    }
  }
}