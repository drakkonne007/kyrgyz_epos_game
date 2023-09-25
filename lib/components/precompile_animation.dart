import 'dart:io';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
import 'package:game_flame/components/physic_vals.dart';

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

class IntPoint
{
  IntPoint(this.x, this.y);
  int x; //column
  int y; //row
}

class AnimationPos
{
  String sourceImg = '';
  Vector2 pos = Vector2.all(-1);
  final List<IntPoint> spritePos = [];
  final List<double> stepTimes = [];
  int spriteWidth = 32;
  int spriteHeight = 32;
}

class MySuperAnimCompiler
{
  List<Map<Sprite?, List<Vector2>>> _mapsSprite = [];
  Map<Sprite?, List<Vector2>> _allSpriteMap = {};
  List<AnimationPos> _animations = [];

  Future addTile(Vector2 position, TileProcessor tileProcessor) async
  {
    var animation = await tileProcessor.getSpriteAnimation();
    if (animation == null) {
      var sprite = await tileProcessor.getSprite();
      _allSpriteMap.putIfAbsent(sprite, () => []);
      _allSpriteMap[sprite]!.add(position);
    }else{
      AnimationPos pos = AnimationPos();
      pos.pos = position;
      pos.sourceImg = tileProcessor.tileset.image!.source!;
      Image image = await Flame.images.load(pos.sourceImg);
      int maxColumn = image.width ~/ pos.spriteWidth;
      for(final frame in tileProcessor.tile.animation){
        pos.stepTimes.add(frame.duration / 1000);
        pos.spritePos.add(IntPoint(frame.tileId % maxColumn, frame.tileId ~/ maxColumn));
      }
      _animations.add(pos);
    }
  }

  void addLayer()
  {
    _mapsSprite.add(_allSpriteMap);
    _allSpriteMap = {};
  }

  Future<void> compile(String path) async
  {
    print('start compile! $path');
    final nullImage = await Flame.images.load('null_image.png');
    for (int cols = 0; cols < GameConsts.maxColumn; cols++) {
      for (int rows = 0; rows < GameConsts.maxRow; rows++) {
        bool isWas = false;
        var position = Vector2(cols * GameConsts.lengthOfTileSquare, rows * GameConsts.lengthOfTileSquare);
        Rectangle rec = Rectangle.fromPoints(position, Vector2(
            position.x + GameConsts.lengthOfTileSquare,
            position.y + GameConsts.lengthOfTileSquare));
        final composition = ImageCompositionExt();
        for (int i = 0; i < _mapsSprite.length; i++) {
          var currentSprites = _mapsSprite[i];
          for (final spr in currentSprites.keys) {
            if (spr == null) {
              continue;
            }
            for (final pos in currentSprites[spr]!) {
              if(!rec.containsPoint(pos + Vector2.all(1))){
                continue;
              }
              composition.add(spr.image, pos - position, source: spr.src);
              isWas = true;
            }
          }
        }
        if (isWas) {
          composition.add(nullImage, Vector2.all(0), source: nullImage.getBoundingRect());
          final composedImage = composition.compose();
          var byteData = await composedImage.toByteData(
              format: ImageByteFormat.png);
          File file = File('metaData/$cols-${rows}_$path.png');
          file.writeAsBytesSync(byteData!.buffer.asUint8List());
        }
      }
    }
    for (int cols = 0; cols < GameConsts.maxColumn; cols++) {
      for (int rows = 0; rows < GameConsts.maxRow; rows++) {
        var position = Vector2(cols * GameConsts.lengthOfTileSquare, rows * GameConsts.lengthOfTileSquare);
        Rectangle rec = Rectangle.fromPoints(position, Vector2(
            position.x + GameConsts.lengthOfTileSquare,
            position.y + GameConsts.lengthOfTileSquare));
        String xml = '';
        for(final anim in _animations){
          if(!rec.containsPoint(Vector2(anim.pos.x, anim.pos.y))){
            continue;
          }
          xml += '<animation source="${anim.sourceImg}" x="${anim.pos.x}" y="${anim.pos.y}">\n';
          for(int i=0;i<anim.stepTimes.length;i++){
            xml += '<stepTime="${anim.stepTimes[i]}" column="${anim.spritePos[i].x}" row="${anim.spritePos[i].y}">\n';
          }
          xml += '</animation>\n';
        }
        if(xml != '') {
          File file = File('metaData/$cols-${rows}_$path.anim');
          file.writeAsStringSync(xml, mode: FileMode.append);
        }
      }
    }
  }
}
