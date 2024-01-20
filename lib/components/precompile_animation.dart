import 'dart:io';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
import 'package:game_flame/components/game_worlds.dart';

enum RenderCompileMode
{
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

  @override
  bool operator ==(other)
  {
    if(other is IntPoint){
      if(x != other.x || y != other.y){
        return false;
      }
      return true;
    }else{
      return false;
    }
  }

  @override
  int get hashCode => x.hashCode + y.hashCode;
}

class AnimationPos
{
  String sourceImg = '';
  final List<IntPoint> spritePos = [];
  final List<double> stepTimes = [];
  int width = 0;
  int height = 0;

  @override
  operator ==(other)
  {
    if(other is AnimationPos){
      if(spritePos.length == other.spritePos.length){
        for(int i=0;i<spritePos.length;i++){
          if(spritePos[i] != other.spritePos[i]){
            return false;
          }
        }
      }else{
        return false;
      }
      if(stepTimes.length == other.stepTimes.length){
        for(int i=0;i<stepTimes.length;i++){
          if(stepTimes[i] != other.stepTimes[i]){
            return false;
          }
        }
      }else{
        return false;
      }
      if(sourceImg != other.sourceImg){
        return false;
      }
    }else{
      return false;
    }
    return true;
  }
  @override
  int get hashCode => sourceImg.hashCode + spritePos[0].hashCode + stepTimes[0].hashCode;
}

class MySuperAnimCompiler {
  List<Map<Sprite?, List<Vector2>>> _mapsSprite = [];
  Map<Sprite?, List<Vector2>> _allSpriteMap = {};
  Map<AnimationPos, List<Vector2>> _animations = {};

  Future addTile(Vector2 position, TileProcessor tileProcessor) async
  {
    var animation = await tileProcessor.getSpriteAnimation();
    if (animation == null) {
      var sprite = await tileProcessor.getSprite();
      _allSpriteMap.putIfAbsent(sprite, () => []);
      _allSpriteMap[sprite]!.add(position);
    } else {
      AnimationPos pos = AnimationPos();
      pos.sourceImg = tileProcessor.tileset.image!.source!;
      pos.width = tileProcessor.tileset.tileWidth!;
      pos.height = tileProcessor.tileset.tileHeight!;
      Image image = await Flame.images.load(pos.sourceImg);
      int maxColumn = image.width ~/ pos.width;
      for (final frame in tileProcessor.tile.animation) {
        pos.stepTimes.add(frame.duration / 1000);
        pos.spritePos.add(
            IntPoint(frame.tileId % maxColumn, frame.tileId ~/ maxColumn));
      }
      _animations.putIfAbsent(pos, () => []);
      _animations[pos]!.add(position);
    }
  }

  void addLayer() {
    _mapsSprite.add(_allSpriteMap);
    _allSpriteMap = {};
  }

  Future<void> compile(String path, GameWorldData worldData) async
  {
    final nullImage = await Flame.images.load('null_image-352px.png');
    for (int cols = 0; cols < worldData.gameConsts.maxColumn!; cols++) {
      for (int rows = 0; rows < worldData.gameConsts.maxRow!; rows++) {
        bool isWas = false;
        var position = Vector2(cols * worldData.gameConsts.lengthOfTileSquare.x,
            rows * worldData.gameConsts.lengthOfTileSquare.y);
        final composition = ImageCompositionExt();
        for (int i = 0; i < _mapsSprite.length; i++) {
          var currentSprites = _mapsSprite[i];
          for (final spr in currentSprites.keys) {
            if (spr == null) {
              continue;
            }
            for (final pos in currentSprites[spr]!) {
              int column = pos.x ~/ worldData.gameConsts.lengthOfTileSquare.x;
              int row =    pos.y ~/ worldData.gameConsts.lengthOfTileSquare.y;
              if (column != cols || row != rows) {
                continue;
              }
              composition.add(spr.image, pos - position, source: spr.src, isAntiAlias: true);
              isWas = true;
            }
          }
        }
        if (isWas) {
          composition.add(
              nullImage, Vector2.all(0), source: nullImage.getBoundingRect(),isAntiAlias: true);
          final composedImage = composition.compose();
          var byteData = await composedImage.toByteData(
              format: ImageByteFormat.png);
          File file = File('assets/metaData/${worldData.nameForGame}/$cols-${rows}_$path.png');
          file.writeAsBytesSync(byteData!.buffer.asUint8List());
        }
      }
    }
    for (int cols = 0; cols < worldData.gameConsts.maxColumn!; cols++) {
      for (int rows = 0; rows < worldData.gameConsts.maxRow!; rows++) {
        bool isStartFile = false;
        for (final anim in _animations.keys) {
          String animText = '';
          List<Vector2> currentPoints = _animations[anim]!;
          for (final point in currentPoints) {
            int column = point.x ~/ worldData.gameConsts.lengthOfTileSquare.x;
            int row =    point.y ~/ worldData.gameConsts.lengthOfTileSquare.y;
            if (column != cols || row != rows) {
              continue;
            }
            if (animText == '') {
              animText = '<an src="${anim.sourceImg}" w="${anim.width}" h="${anim.height}" >\n';
              for (int i = 0; i < anim.stepTimes.length; i++) {
                animText +=
                '<fr dr="${anim.stepTimes[i]}" cl="${anim.spritePos[i]
                    .x}" rw="${anim.spritePos[i].y}"/>\n';
              }
            }
            animText +=
            '<ps x="${point.x}" y="${point.y}"/>\n';
          }
          if (animText != '') {
            File file = File('assets/metaData/${worldData.nameForGame}/$cols-${rows}_$path.anim');
            if(!isStartFile){
              isStartFile = true;
              file.writeAsStringSync('<p>\n', mode: FileMode.append);
            }
            file.writeAsStringSync(animText, mode: FileMode.append);
            file.writeAsStringSync('</an>\n', mode: FileMode.append);
          }
        }
        if (isStartFile) {
          File file = File('assets/metaData/${worldData.nameForGame}/$cols-${rows}_$path.anim');
          file.writeAsStringSync('</p>\n', mode: FileMode.append);
        }
      }
    }
  }
}
