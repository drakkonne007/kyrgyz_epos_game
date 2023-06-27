import 'dart:io';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';

Future processTileType(
    {required RenderableTiledMap tileMap,
      required TileProcessorFunc addTiles,
      required List<String> layersToLoad,
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
        if (tileId != 0) {
          final tileset = tileMap.map.tilesetByTileGId(tileId);
          final firstGid = tileset.firstGid;
          if (firstGid != null) {
            tileId = tileId - firstGid; //+ 1;
          }
          final tileData = tileset.tiles[tileId];
          final position = Vector2(xOffset.toDouble() * tileMap.map.tileWidth,
              yOffset.toDouble() * tileMap.map.tileWidth);
          final tileProcessor = TileProcessor(tileData, tileset);
          await addTiles(
              tileProcessor,
              position,
              Vector2(tileMap.map.tileWidth.toDouble(),
                  tileMap.map.tileWidth.toDouble()));
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

class MySuperAnimCompiler {
  List<Map<SpriteAnimation?, List<Vector2>>> _MapsAnim = [];
  List<Map<Sprite?, List<Vector2>>> _MapsSprite = [];
  Map<SpriteAnimation?, List<Vector2>> _allAnimMap = {};
  Map<Sprite?, List<Vector2>> _allSpriteMap = {};
  Map<SpriteAnimation?, SpriteAnimationTicker> _tickers = {};

  Future addTile(Vector2 position, TileProcessor tileProcessor) async
  {
    var animation = await tileProcessor.getSpriteAnimation();
    if (animation == null) {
      var sprite = await tileProcessor.getSprite();
      if(!_allSpriteMap.containsKey(sprite)) {
        _allSpriteMap.putIfAbsent(sprite, () => []);
      }
      _allSpriteMap[sprite]!.add(position);
    }else {
      if (!_allAnimMap.containsKey(animation)) {
        _allAnimMap.putIfAbsent(animation, () => []);
        _tickers.putIfAbsent(animation, () => animation.ticker());
      }
      _allAnimMap[animation]!.add(position);
    }
  }

  void addLayer()
  {
    _MapsAnim.add(_allAnimMap);
    _MapsSprite.add(_allSpriteMap);
    _allAnimMap = {};
    _allSpriteMap = {};
  }

  Future<void> compile() async
  {
    for (int i = 0; i < 16; i++) {
      print('start write frame $i');
      final composition = ImageCompositionExt();
      for (int i = 0; i < _MapsAnim.length; i++) {
        var currentAnims = _MapsAnim[i];
        var currentSprites = _MapsSprite[i];

        for (final anim in currentAnims.keys) {
          if (anim == null) {
            continue;
          }
          final sprite = _tickers[anim]!.getSprite();
          for (final pos in currentAnims[anim]!) {
            composition.add(sprite.image, pos, source: sprite.src);
          }
        }

        for (final spr in currentSprites.keys) {
          if (spr == null) {
            continue;
          }
          for (final pos in currentSprites[spr]!) {
            composition.add(spr.image, pos, source: spr.src);
          }
        }
      }
      final composedImage = composition.compose();
      // composedImage.resize(Vector2.all(92000));
      var byteData = await composedImage.toByteData(
          format: ImageByteFormat.png);
      File file = File('$i.png');
      file.writeAsBytesSync(byteData!.buffer.asUint8List());
      print('$i - written file');
      for (final anim in _tickers.keys) {
        _tickers[anim]!.currentIndex++;
        if (_tickers[anim]!.currentIndex == anim!.frames.length) {
          _tickers[anim]!.currentIndex = 0;
        }
      }
    }
  }
}
