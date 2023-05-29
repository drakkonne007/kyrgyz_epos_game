

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/players/sword_enemy.dart';

class ImagePosition extends PositionComponent
{
  ImagePosition(this.image);
  final Image image;

  @override
  void render(Canvas canvas) {
    canvas.drawImage(image, const Offset(0, 0), Paint());
  }
}

class MapNode extends Component
{
  MapNode(this.column, this.row, this.imageBatchCompiler);
  final int column;
  final int row;
  final ImageBatchCompiler imageBatchCompiler;
  TiledComponent? _tiledMap;

  static List<Layer> _unlistedLayers(
      RenderableTiledMap tileMap, List<String> layerNames)
  {
    final unlisted = <Layer>[];
    for (final layer in tileMap.map.layers) {
      if (!layerNames.contains(layer.name)) {
        unlisted.add(layer);
      }
    }
    return unlisted;
  }

  static void loadImage(List<dynamic> args) async
  {
    var sendPort = args[0] as SendPort;
    int column = args[1] as int;
    int row = args[2] as int;
    var fileName = '$column-$row.tmx';
    // var tiledMap = await TiledComponent.load(fileName, Vector2(32, 32));
    // var layerNames = ['ground','walls-1-2-3-4', 'walls-5-6-7-8'];
    // _unlistedLayers(tiledMap.tileMap, layerNames).forEach((element) {
    //   element.visible = false;
    // });
    // for (var rl in tiledMap.tileMap.renderableLayers) {
    //   rl.refreshCache();
    // }
    // final recorder = PictureRecorder();
    // final canvas = Canvas(recorder);
    // tiledMap.tileMap.render(canvas);
    // final picture = recorder.endRecording();
    // _unlistedLayers(tiledMap.tileMap, layerNames).forEach((element) {
    //   element.visible = true;
    // });
    // for (final rl in tiledMap.tileMap.renderableLayers) {
    //   rl.refreshCache();
    // }
    // final image = picture.toImageSync(tiledMap.tileMap.map.width * tiledMap.tileMap.map.tileWidth,
    //     tiledMap.tileMap.map.height * tiledMap.tileMap.map.tileHeight);
    // var bytes = await image.toByteData(format: ImageByteFormat.png);
    // picture.dispose();
    var file = File('assets/tiles/map/ancientLand/Tilesets/tile guide.png');
    var file2 = File('assets/tiles/map/ancientLand/Tilesets/tile guide.png');
    var file3 = File('assets/tiles/map/ancientLand/Tilesets/tile guide.png');
    var file4 = File('assets/tiles/map/ancientLand/Tilesets/tile guide.png');
    var list = file.readAsStringSync();
    list += file2.readAsStringSync();
    list += file3.readAsStringSync();
    list += file4.readAsStringSync();
    sendPort.send(list);
  }

  // Future<Image> createImageFromByteData(String byteData)
  // {
    // final Completer<Image> completer = Completer<Image>();
    // decodeImageFromList(byteData, (Image image) {
    //   completer.complete(image);
    // });
    // return completer.future;
  // }

  Future<void> generateMap() async
  {
    if(column > GameConsts.maxColumn || row > GameConsts.maxRow) {
      return;
    }
    if(column < 0 || row < 0) {
      return;
    }
    var fileName = '$column-$row.tmx';
    print(fileName);
    final contents = await Flame.bundle.loadString('assets/$fileName');
    var tempss = await RenderableTiledMap.fromString(contents, Vector2.all(32));
    // _tiledMap = TiledComponent(tempss);
    // _tiledMap = await TiledComponent.load(fileName, Vector2(32, 32));
    // var bground = imageBatchCompiler.compileMapLayer(
    //     tileMap: _tiledMap!.tileMap, layerNames: ['ground','walls-1-2-3-4', 'walls-5-6-7-8']);
    // // print('$column-$row.tmx');
    // // final ReceivePort receivePort = ReceivePort();
    // // var isol = await Isolate.spawn(loadImage, [receivePort.sendPort, column, row]);
    // // final Completer<String> completer = Completer<String>();
    // // receivePort.listen((data) {
    // //   if(data is String){
    // //     completer.complete(data);
    // //   }
    // // });
    // // await completer.future;
    // // var imgBytes = await completer.future;
    // // var bground = ImagePosition(await createImageFromByteData(imgBytes));
    // bground.priority = GamePriority.ground;
    // bground.position = Vector2(column * 32 * 30, row * 32 * 30) * GameConsts.gameScale;
    // bground.scale = Vector2.all(GameConsts.gameScale);
    // await add(bground);
    // final objs = _tiledMap!.tileMap.getLayer<ObjectGroup>("objects");
    // for(final obj in objs!.objects){
    //   switch(obj.name){
    //     case 'enemy': await bground.add(SwordEnemy(Vector2(obj.x + column * 32 * 30, obj.y + row * 32 * 30)));
    //     break;
    //     case 'ground': await add(Ground(size: Vector2(obj.width, obj.height) * GameConsts.gameScale,position: Vector2(obj.x + column * 32 * 30, obj.y + row * 32 * 30) * GameConsts.gameScale));
    //     break;
    //     // case 'mapWarp': await add(MapWarp(to: fileName == 'test.tmx' ? 'tiles/map/test2.tmx' : 'tiles/map/test.tmx',size: Vector2(obj.width, obj.height) * GameConsts.gameScale,position: Vector2(obj.x, obj.y) * GameConsts.gameScale));
    //     break;
    //   // case 'player': playerPos = Vector2(obj.x, obj.y);
    //   }
    // }
    // // isol.kill();
  }
}
