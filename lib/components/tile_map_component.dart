import 'dart:io';
import 'dart:isolate';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/MapNode.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/main.dart';
import 'package:game_flame/overlays/health_bar.dart';
import 'package:game_flame/overlays/joysticks.dart';
import 'package:game_flame/players/front_player.dart';
import 'package:game_flame/players/ortho_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';


void _loadObjs(SendPort mySendPort) async
{
  ReceivePort mikeReceivePort = ReceivePort();
  mySendPort.send(mikeReceivePort.sendPort);
  await for (final message in mikeReceivePort) {
    if (message is List) {
      print('start _loadObjs');
      final SendPort mikeResponseSendPort = message[0];
      Map<String,String> objXmls = {};
      String path = message[1];
      for(int cl = 0; cl < GameConsts.maxColumn; cl++) {
        for (int rw = 0; rw < GameConsts.maxRow; rw++) {
          try {
            var file = File('$path/$cl-$rw.objXml');
            // var temp = await rootBundle.loadString('assets/metaData/$cl-$rw.objXml',cache: false);
            objXmls['$cl-$rw.objXml'] = file.readAsStringSync();
          } catch (e) {
            e;
          }
        }
      }
      mikeResponseSendPort.send(objXmls);
    }
  }
}

void _loadAnims(SendPort mySendPort) async
{
  ReceivePort mikeReceivePort = ReceivePort();
  mySendPort.send(mikeReceivePort.sendPort);
  await for (final message in mikeReceivePort) {
    if (message is List) {
      print('start _loadAnims');
      final SendPort mikeResponseSendPort = message[0];
      Map<String, String> anims = {};
      Map<String, Uint8List> tiledPngs = {};
      String path = message[1];
      for (int cl = 0; cl < GameConsts.maxColumn; cl++) {
        for (int rw = 0; rw < GameConsts.maxRow; rw++) {
          try {
            var file = File('$path/$cl-${rw}_high.anim').readAsStringSync();
            // var temp = await rootBundle.loadString(
            //     'assets/metaData/$cl-${rw}_high.anim', cache: false);
            anims['$cl-${rw}_high.anim'] = file;
            var objects
            = XmlDocument.parse(file).findAllElements('an');
            for (final obj in objects) {
              var file = File('$path/${obj.getAttribute('src')!}');
              // var temp = await rootBundle.load(obj.getAttribute('src')!);
              tiledPngs[obj.getAttribute('src')!] = file.readAsBytesSync();
            }
          } catch (e) {
            e;
          }
          try {
            var file = File('$path/$cl-${rw}_down.anim').readAsStringSync();
            // var temp = await rootBundle.loadString(
            //     'assets/metaData/$cl-${rw}_down.anim', cache: false);
            anims['$cl-${rw}_down.anim'] = file;
            var objects
            = XmlDocument.parse(file).findAllElements('an');
            for (final obj in objects) {
              var file = File('$path/${obj.getAttribute('src')!}');
              // var temp = await rootBundle.load(obj.getAttribute('src')!);
              tiledPngs[obj.getAttribute('src')!] = file.readAsBytesSync();
            }
          } catch (e) {
            e;
          }
        }
      }
      mikeResponseSendPort.send([anims, tiledPngs]);
    }
  }
}

Future<void> _loadPngs(SendPort mySendPort) async
{
  ReceivePort mikeReceivePort = ReceivePort();
  mySendPort.send(mikeReceivePort.sendPort);
  await for (final message in mikeReceivePort) {
    if (message is List) {
      print('start _loadPngs');
      final SendPort mikeResponseSendPort = message[0];
      Map<String, Uint8List> pngs = {};
      String path = message[1];
      for (int cl = 0; cl < GameConsts.maxColumn; cl++) {
        for (int rw = 0; rw < GameConsts.maxRow; rw++) {
          try {
            var file = File('$path/$cl-${rw}_high.png');
            // var temp = await rootBundle.load('assets/metaData/$cl-${rw}_high.png');
            pngs['$cl-${rw}_high.png'] = file.readAsBytesSync();
          } catch (e) {
            e;
          }
          try {
            var file = File('$path/$cl-${rw}_down.png');
            // var temp = await rootBundle.load('assets/metaData/$cl-${rw}_down.png');
            pngs['$cl-${rw}_down.png'] = file.readAsBytesSync();
          } catch (e) {
            e;
          }
        }
      }
      mikeResponseSendPort.send(pngs);
    }
  }
}

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

  Future preloadAnimAndObj() async
  {
    KyrgyzGame.objXmls.clear();
    KyrgyzGame.anims.clear();
    KyrgyzGame.tiledPngs.clear();
    KyrgyzGame.animsImgs.clear();

    var dir = await getApplicationCacheDirectory();

    // for (int cl = 0; cl < GameConsts.maxColumn; cl++) {
    //   for (int rw = 0; rw < GameConsts.maxRow; rw++) {
    //     try{
    //       var temp = await rootBundle.loadString(
    //           'assets/metaData/$cl-$rw.objXml', cache: false);
    //       File file = File('${dir.path}/$cl-$rw.objXml');
    //       file.writeAsStringSync(temp);
    //     }catch(e){
    //       e;
    //     }
    //     try {
    //       var temp1 = await rootBundle.loadString(
    //           'assets/metaData/$cl-${rw}_high.anim', cache: false);
    //       File file = File('${dir.path}/$cl-${rw}_high.anim');
    //       file.writeAsStringSync(temp1);
    //       var objects = XmlDocument.parse(temp1.toString()).findAllElements(
    //           'an');
    //       for (final obj in objects) {
    //         var path = obj.getAttribute('src')!.split('/');
    //         path.removeLast();
    //         Directory dirSs = Directory('${dir.path}/${path.join('/')}');
    //         dirSs.createSync(recursive: true);
    //         File file = File('${dir.path}/${obj.getAttribute('src')!}');
    //         var temp = await rootBundle.load('assets/${obj.getAttribute('src')!}');
    //         file.writeAsBytesSync(temp.buffer.asUint8List());
    //       }
    //     }catch(e){
    //       e;
    //     }
    //     try {
    //       var temp3 = await rootBundle.loadString(
    //           'assets/metaData/$cl-${rw}_down.anim', cache: false);
    //       File file = File('${dir.path}/$cl-${rw}_down.anim');
    //       file.writeAsStringSync(temp3);
    //       var objects = XmlDocument.parse(temp3.toString()).findAllElements('an');
    //       for (final obj in objects) {
    //         var path = obj.getAttribute('src')!.split('/');
    //         path.removeLast();
    //         Directory dirSs = Directory('${dir.path}/${path.join('/')}');
    //         dirSs.createSync(recursive: true);
    //         File file = File('${dir.path}/${obj.getAttribute('src')!}');
    //         var temp = await rootBundle.load('assets/${obj.getAttribute('src')!}');
    //         file.writeAsBytesSync(temp.buffer.asUint8List());
    //       }
    //     }catch(e){
    //       e;
    //     }
    //     try {
    //       var temp5 = await rootBundle.load(
    //           'assets/metaData/$cl-${rw}_high.png');
    //       File file = File('${dir.path}/$cl-${rw}_high.png');
    //       file.writeAsBytesSync(temp5.buffer.asUint8List());
    //     }catch(e){
    //       e;
    //     }
    //     try {
    //       var temp6 = await rootBundle.load('assets/metaData/$cl-${rw}_down.png');
    //       File file = File('${dir.path}/$cl-${rw}_down.png');
    //       file.writeAsBytesSync(temp6.buffer.asUint8List());
    //     }catch(e){
    //       e;
    //     }
    //   }
    // }

    ReceivePort objsReceivePort = ReceivePort();
    Isolate.spawn<SendPort>(_loadObjs, objsReceivePort.sendPort,errorsAreFatal: false);
    SendPort objsSendPort = await objsReceivePort.first;
    ReceivePort objResponseReceivePort = ReceivePort();
    objsSendPort.send([
      objResponseReceivePort.sendPort
      ,dir.path
    ]);

    ReceivePort upPngsReceivePort = ReceivePort();
    Isolate.spawn<SendPort>(_loadPngs, upPngsReceivePort.sendPort,errorsAreFatal: false);
    SendPort upPngsSendPort = await upPngsReceivePort.first;
    ReceivePort upPngsResponseReceivePort = ReceivePort();
    upPngsSendPort.send([
      upPngsResponseReceivePort.sendPort
      ,dir.path
    ]);

    ReceivePort animsReceivePort = ReceivePort();
    Isolate.spawn<SendPort>(_loadAnims, animsReceivePort.sendPort,errorsAreFatal: false);
    SendPort animsSendPort = await animsReceivePort.first;
    ReceivePort animsResponseReceivePort = ReceivePort();
    animsSendPort.send([
      animsResponseReceivePort.sendPort
      ,dir.path
    ]);

    final animPngsResponse = await animsResponseReceivePort.first;
    if(animPngsResponse is List){
      print('animPngsResponse');
      KyrgyzGame.anims = animPngsResponse[0];
      KyrgyzGame.animsImgs = animPngsResponse[1];
    }
    animsResponseReceivePort.close();
    animsReceivePort.close();

    final objsResponse = await objResponseReceivePort.first;
    if(objsResponse is Map<String,String>){
      print('objsResponse');
      KyrgyzGame.objXmls = objsResponse;
    }
    objResponseReceivePort.close();
    objsReceivePort.close();

    final upPngsResponse = await upPngsResponseReceivePort.first;
    if(upPngsResponse is Map<String,Uint8List>){
      print('upPngsResponse');
      KyrgyzGame.tiledPngs = upPngsResponse;
    }
    upPngsResponseReceivePort.close();
    upPngsReceivePort.close();

    // static Map<String,String> objXmls = {};
    // static Map<String,String> anims = {};
    // static Map<String,Uint8List> tiledPngs = {};
    // static Map<String,Uint8List> animsImgs = {};

    // gameRef.prefs.setStringList('objs', KyrgyzGame.objXmls.keys.toList());
    // gameRef.prefs.setStringList('objs', KyrgyzGame.objXmls.keys.toList());
    // gameRef.prefs.setStringList('objs', KyrgyzGame.objXmls.keys.toList());
    isCached = true;
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