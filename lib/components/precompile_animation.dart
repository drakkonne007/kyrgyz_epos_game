import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';

enum RenderCompileMode{
  Background,
  Foreground,
  All
}

Future processTileType(
    {required RenderableTiledMap tileMap,
      required TileProcessorFunc addTiles,
      required List<String> layersToLoad,
      required RenderCompileMode renderMode,
      bool clear = true}) async
{
  for (final layer in layersToLoad) {
    final tileLayer = tileMap.getLayer<TileLayer>(layer);
    final tileData = tileLayer?.data;
    if (tileData != null) {
      int xOffset = 0;
      int yOffset = 0;
      print('start read tiles!');
      for (var tileId in tileData) {
        bool isNeedAdd = true;
        if (tileId != 0) {
          final tileset = tileMap.map.tilesetByTileGId(tileId);
          final firstGid = tileset.firstGid;
          if (firstGid != null) {
            tileId = tileId - firstGid; //+ 1;
          }
          final tileData = tileset.tiles[tileId];
          if(renderMode == RenderCompileMode.Background && (tileData.class_ == 'high' || tileLayer!.name.startsWith('xx'))) {
            isNeedAdd = false;
          }
          if(renderMode == RenderCompileMode.Foreground){
            if(tileData.class_ != 'high' && !tileLayer!.name.startsWith('xx')) {
              print('${tileData.class_} ${tileLayer!.name} - not high');
              isNeedAdd = false;
            }
          }
          if(isNeedAdd){
            final position = Vector2(xOffset.toDouble() * tileMap.map.tileWidth,
                yOffset.toDouble() * tileMap.map.tileWidth);
            final tileProcessor = TileProcessor(tileData, tileset);
            await addTiles(
                tileProcessor,
                position,
                Vector2(tileMap.map.tileWidth.toDouble(),
                    tileMap.map.tileWidth.toDouble()));
          }
        }
        xOffset++;
        if (xOffset == tileLayer?.width) {
          xOffset = 0;
          yOffset++;
        }
      }
    }
  }
  if (clear) {
    tileMap.map.layers
        .removeWhere((element) => layersToLoad.contains(element.name));
    for (var rl in tileMap.renderableLayers) {
      rl.refreshCache();
    }
  }
}

class AnimationPos
{
  late Vector2 position;
  late SpriteAnimation animation;
}

class MySuperAnimCompiler
{
  List<Map<Sprite?, List<Vector2>>> _MapsSprite = [];
  List<AnimationPos> _animSprites = [];
  Map<Sprite?, List<Vector2>> _allSpriteMap = {};
  Future addTile(Vector2 position, TileProcessor tileProcessor) async
  {
    var animation = await tileProcessor.getSpriteAnimation();
    if (animation == null) {
      var sprite = await tileProcessor.getSprite();
      if(!_allSpriteMap.containsKey(sprite)) {
        _allSpriteMap.putIfAbsent(sprite, () => []);
      }
      _allSpriteMap[sprite]!.add(position);
    }
  }

  void addLayer()
  {
    _MapsSprite.add(_allSpriteMap);
    _allSpriteMap = {};
  }

  Future<void> compile(String path) async
  {
    print('start compile! $path');
    bool isWas = false;
    final composition = ImageCompositionExt();
    for (int i = 0; i < _MapsSprite.length; i++) {
      var currentSprites = _MapsSprite[i];
      for (final spr in currentSprites.keys) {
        if (spr == null) {
          continue;
        }
        for (final pos in currentSprites[spr]!) {
          composition.add(spr.image, pos, source: spr.src);
          isWas = true;
        }
      }
    }
    if(isWas){
      final composedImage = composition.compose();
      var byteData = await composedImage.toByteData(
          format: ImageByteFormat.png);
      File file = File('$path.png');
      file.writeAsBytesSync(byteData!.buffer.asUint8List());
      // File file2 = File('$path anims.txt');
      // String text = '';
      // for(int i=0; i<_animSprites.length; i++){
      //   text += '<animTile x="${_animSprites[i].position.x}"'
      //       ' y="${_animSprites[i].position.y}">\n';
      //   for(int j=0;j<_animSprites[i].animation.frames.length;j++){
      //     text += '<frame '
      //         ' time="${_animSprites[i].animation.frames[j].stepTime}" '
      //         ' src="${_animSprites[i].animation.frames[j].sprite.image} '
      //         ' x="${_animSprites[i].animation.frames[j].sprite.srcPosition.x}"'
      //         ' y="${_animSprites[i].animation.frames[j].sprite.srcPosition.y}"/>\n';
      //   }
      //   text += '\n</animTile>\n';
      // }
      // file2.writeAsStringSync(text);
    }
  }
}
