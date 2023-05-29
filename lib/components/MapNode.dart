

import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
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

  static void loadImage(List<dynamic> args)
  {
    var sendPort = args[0] as SendPort;
    int column = args[1] as int;
    int row = args[2] as int;
    var fileName = '$column-$row.tmx';
    var tiledMap = TiledComponent.load(fileName, Vector2(32, 32));
    var layerNames = ['ground','walls-1-2-3-4', 'walls-5-6-7-8'];
    _unlistedLayers(tiledMap.tileMap, layerNames).forEach((element) {
      element.visible = false;
    });
    for (var rl in tiledMap.tileMap.renderableLayers) {
      rl.refreshCache();
    }
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    tiledMap.tileMap.render(canvas);
    final picture = recorder.endRecording();
    _unlistedLayers(tiledMap.tileMap, layerNames).forEach((element) {
      element.visible = true;
    });
    for (final rl in tiledMap.tileMap.renderableLayers) {
      rl.refreshCache();
    }
    final image = picture.toImageSync(tiledMap.tileMap.map.width * tiledMap.tileMap.map.tileWidth,
        tiledMap.tileMap.map.height * tiledMap.tileMap.map.tileHeight);
    var bytes = await image.toByteData(format: ImageByteFormat.png);
    picture.dispose();
    sendPort.send(bytes);
  }

  @override
  Future<void> onLoad() async
  {
    await generateMap();
  }

  Future<Image> createImageFromByteData(ByteData byteData)
  {
    final Completer<Image> completer = Completer<Image>();
    decodeImageFromList(byteData.buffer.asUint8List(), (Image image) {
      completer.complete(image);
    });
    return completer.future;
  }

  Future<void> generateMap() async
  {
    if(column > GameConsts.maxColumn || row > GameConsts.maxRow) {
      return;
    }
    if(column < 0 || row < 0) {
      return;
    }
    var fileName = '$column-$row.tmx';
    _tiledMap = await TiledComponent.load(fileName, Vector2(32, 32));
    print('$column-$row.tmx');
    final ReceivePort receivePort = ReceivePort();
    var isol = await Isolate.spawn(loadImage, [receivePort.sendPort, column, row]);
    final Completer<ByteData> completer = Completer<ByteData>();
    receivePort.listen((data) {
      if(data is ByteData){
        completer.complete(data);
      }
    });
    await completer.future;
    var imgBytes = await completer.future;
    var bground = ImagePosition(await createImageFromByteData(imgBytes));
    bground.priority = GamePriority.ground;
    bground.position = Vector2(column * 32 * 30, row * 32 * 30) * GameConsts.gameScale;
    bground.scale = Vector2.all(GameConsts.gameScale);
    await add(bground);
    final objs = _tiledMap!.tileMap.getLayer<ObjectGroup>("objects");
    for(final obj in objs!.objects){
      switch(obj.name){
        case 'enemy': await bground.add(SwordEnemy(Vector2(obj.x + column * 32 * 30, obj.y + row * 32 * 30)));
        break;
        case 'ground': await add(Ground(size: Vector2(obj.width, obj.height) * GameConsts.gameScale,position: Vector2(obj.x + column * 32 * 30, obj.y + row * 32 * 30) * GameConsts.gameScale));
        break;
        // case 'mapWarp': await add(MapWarp(to: fileName == 'test.tmx' ? 'tiles/map/test2.tmx' : 'tiles/map/test.tmx',size: Vector2(obj.width, obj.height) * GameConsts.gameScale,position: Vector2(obj.x, obj.y) * GameConsts.gameScale));
        break;
      // case 'player': playerPos = Vector2(obj.x, obj.y);
      }
    }
    isol.kill();
  }
}
