
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/enemies/grass_golem.dart';
import 'package:xml/xml.dart';


Future processTileType(
    {required RenderableTiledMap tileMap,
      required TileProcessorFunc addTiles,
      required List<String> layersToLoad,
      bool clear = true}) async {
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
  Map<SpriteAnimation?, List<Vector2>> _allMap = {};
  Map<SpriteAnimation?, SpriteAnimationTicker> _tickers = {};

  Future addTile(Vector2 position, TileProcessor tileProcessor) async {
    var animation = await tileProcessor.getSpriteAnimation();
    if (animation == null) {
      return;
    }
    if (!_allMap.containsKey(animation)) {
      _allMap.putIfAbsent(animation, () => []);
      _tickers.putIfAbsent(animation, () => animation.ticker());
    }
    _allMap[animation]!.add(position);
  }

  Future<void> compile() async {
    for (int i = 0; i < 16; i++) {
      print('start write frame $i');
      final composition = ImageCompositionExt();
      for (final anim in _allMap.keys) {
        if (anim == null) {
          continue;
        }
        final sprite = _tickers[anim]!.getSprite();
        for (final pos in _allMap[anim]!) {
          composition.add(sprite.image, pos, source: sprite.src);
        }
      }
      final composedImage = composition.compose();
      // composedImage.resize(Vector2.all(92000));
      var byteData = await composedImage.toByteData(format: ImageByteFormat.png);
      File file = File('$i.png');
      file.writeAsBytesSync(byteData!.buffer.asUint8List());
      print('$i - written file');
      for (final anim in _allMap.keys) {
        _tickers[anim]!.currentIndex++;
        if (_tickers[anim]!.currentIndex == anim!.frames.length) {
          _tickers[anim]!.currentIndex = 0;
        }
      }
    }
  }
}

Future<SpriteAnimationComponent> waterElement(List<Vector2> positionsAnim) async
{
  final spriteImage = await Flame.images.load('tiles/map/ancientLand/Tilesets/Tileset-Animated Terrains-8 frames.png');
  final spriteSheet = SpriteSheet(image: spriteImage, srcSize: Vector2(32,32));
  List<Sprite> newSprites = [];
  for (int i=0;i<8;i++) {
    final sprite = spriteSheet.getSprite(1, i);
    final composition = ImageCompositionExt();
    for (final pos in positionsAnim) {
      composition.add(sprite.image, pos, source: sprite.src);
    }
    final composedImage = composition.compose();
    newSprites.add(Sprite(composedImage));
  }
  final spriteAnimation = SpriteAnimation.variableSpriteList(newSprites,
      stepTimes:[0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1]);
  return SpriteAnimationComponent(
      animation: spriteAnimation,
      position: Vector2.all(0),
      size: newSprites.first.image.size);
}

class Water extends SpriteAnimationComponent
{
  Water(this.positionsAnim);
  List<Vector2> positionsAnim;
  @override
  Future<void> onLoad() async
  {
    final spriteImage = await Flame.images.load('tiles/map/ancientLand/Tilesets/Tileset-Animated Terrains-8 frames.png');
    final spriteSheet = SpriteSheet(image: spriteImage, srcSize: Vector2(32,32));
    animation = spriteSheet.createAnimation(row: 1, stepTime: 0.1, from: 0,to: 8);
    size = Vector2(33, 33);
    position = Vector2.all(0);
  }
}

class MapNode extends PositionComponent with HasGameRef<KyrgyzGame>
{
  MapNode(this.column, this.row, this.imageBatchCompiler);
  final int column;
  final int row;
  final ImageBatchCompiler imageBatchCompiler;
  Image? _image;
  int _id = 0;
  bool isNeedLoadEnemy = true;

  int id() => _id++;

  Future<void> generateMap() async
  {
    if(column > GameConsts.maxColumn || row > GameConsts.maxRow) {
      return;
    }
    if(column < 0 || row < 0) {
      return;
    }
    if(column != 0 || row != 0) {
      return;
    }
    isNeedLoadEnemy = !gameRef.gameMap.loadedColumns.contains(column) || !gameRef.gameMap.loadedRows.contains(row);
    _image = await Flame.images.load('0-0.png');
    position = Vector2(column * GameConsts.lengthOfTileSquare, row * GameConsts.lengthOfTileSquare);
    // var fileName = '$column-$row.tmx';
    var fileName = 'test_anim.tmx';
    var tiled = await TiledComponent.load(fileName, Vector2.all(300*32));
    var layersLists = tiled.tileMap.renderableLayers;
    MySuperAnimCompiler compilerAnimation = MySuperAnimCompiler();
    for(var a in layersLists){
      print('start read layer ${a.layer.name}');
      await processTileType(tileMap: tiled.tileMap,addTiles: (tile, position,size) async {
        compilerAnimation.addTile(position, tile);
      },layersToLoad: [a.layer.name]);
    }
    print('start compile!');
    await compilerAnimation.compile();
    return;


    print(fileName);
    final text = await Flame.assets.readFile(fileName);
    final objects = XmlDocument.parse(text.toString()).findAllElements('object');
    bool isWater = false;
    List<Vector2> waterPoses = [];
    for(final obj in objects) {
      switch(obj.getAttribute('name')) {
        case 'enemy':  await createEnemy(obj); break;
        case 'ground': await add(Ground(size: Vector2(double.parse(obj.getAttribute('width')!), double.parse(obj.getAttribute('height')!)),position: Vector2(double.parse(obj.getAttribute('x')!), double.parse(obj.getAttribute('y')!)))); break;
        case 'water':  waterPoses.add(Vector2(double.parse(obj.getAttribute('x')!), double.parse(obj.getAttribute('y')!)));//  await add(Water(Vector2(double.parse(obj.getAttribute('x')!), double.parse(obj.getAttribute('y')!)))); isWater = true; break;
      }
    }
    if(waterPoses.length > 0) {
      add(await waterElement(waterPoses));
    }
  }

  Future<void> createEnemy(XmlElement obj) async{
    if(!isNeedLoadEnemy){
      print('already exists');
      return;
    }
    await gameRef.gameMap.add(GrassGolem(Vector2(
        double.parse(obj.getAttribute('x')!) + column * GameConsts.lengthOfTileSquare,
        double.parse(obj.getAttribute('y')!) + row * GameConsts.lengthOfTileSquare), GolemVariant.Water));
  }

  @override
  void render(Canvas canvas) {
    if(_image != null) {
      canvas.drawImage(_image!, const Offset(0, 0), Paint());
    }
  }
}
