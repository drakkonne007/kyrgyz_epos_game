import 'dart:async';
import 'dart:io';
import 'package:flame/experimental.dart';
import 'package:game_flame/components/precompile_animation.dart';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/enemies/grass_golem.dart';
import 'package:xml/xml.dart';


const List<String> mapsForCompile = [
  'top_left_anim.tmx', //0
  'top_left_bottom.tmx',
  'top_right_anim.tmx', //2
  'top_right_bottom.tmx',
  'bottom_left_anim.tmx', //4
  'bottom_left_bottom.tmx',
  'bottom_right_anim.tmx', //6
  'bottom_right_bottom.tmx',
];

const int currentMaps = 0;

//function is intersect two rectangles
bool isIntersect(Rectangle rect1, Rectangle rect2) {
  return (rect1.left < rect2.right &&
      rect2.left < rect1.right &&
      rect1.top < rect2.bottom &&
      rect2.top < rect1.bottom);
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
  bool isMapCompile = true; //Надо ли компилить просто карту

  int id() => _id++;

  Future<void> generateMap() async
  {
    if(column > GameConsts.maxColumn || row > GameConsts.maxRow) {
      return;
    }
    if(column < 0 || row < 0) {
      return;
    }
    if(isMapCompile) {
      if (column != 0 || row != 0) {
        return;
      }
    }
    isNeedLoadEnemy = !gameRef.gameMap.loadedColumns.contains(column) || !gameRef.gameMap.loadedRows.contains(row);
    _image = await Flame.images.load('0-0.png');
    position = Vector2(column * GameConsts.lengthOfTileSquare, row * GameConsts.lengthOfTileSquare);
    var fileName = isMapCompile ? mapsForCompile[currentMaps] : '$column-$row.tmx';
    if(isMapCompile) {
      var tiled = await TiledComponent.load(fileName, Vector2.all(320));
      if(false) {
        var layersLists = tiled.tileMap.renderableLayers;
        MySuperAnimCompiler compilerAnimation = MySuperAnimCompiler();
        for (var a in layersLists) {
          print('start read layer ${a.layer.name}');
          await processTileType(
              tileMap: tiled.tileMap, addTiles: (tile, position, size) async {
            compilerAnimation.addTile(position, tile);
          }, layersToLoad: [a.layer.name]);
          compilerAnimation.addLayer();
        }
        print('start compile!');
        await compilerAnimation.compile();
      }
      tiled = await TiledComponent.load(mapsForCompile[currentMaps + 1], Vector2.all(320));
      var objs = tiled.tileMap.getLayer<ObjectGroup>("objects");
      if(objs != null){
        File file = File('$column-$row.tmx');
        String newObjs = '';
        Rectangle rec = Rectangle.fromPoints(position, Vector2(position.x + GameConsts.lengthOfTileSquare,position.y + GameConsts.lengthOfTileSquare));
        for(final obj in objs.objects){
          Rectangle objRect = Rectangle.fromPoints(Vector2(obj.x, obj.y), Vector2(obj.x + obj.width, obj.y + obj.height));
          if(isIntersect(rec, objRect)) {
            newObjs += '<object name="${obj.name}" class="${obj.type}" x="${obj.x}" y="${obj.y}" width="${obj.width}" height="${obj.height}"/>';
            newObjs += '\n';
          }
        }
        file.writeAsStringSync(newObjs);
      }
      print('precompile done');
      exit(0);
    }
    //Закончить стирать

    print(fileName);
    final text = await Flame.assets.readFile(fileName);
    final objects = XmlDocument.parse(text.toString()).findAllElements('object');
    for(final obj in objects) {
      switch(obj.getAttribute('name')) {
        case 'enemy':  await createEnemy(obj); break;
        case 'ground': await add(Ground(size: Vector2(double.parse(obj.getAttribute('width')!), double.parse(obj.getAttribute('height')!)),position: Vector2(double.parse(obj.getAttribute('x')!), double.parse(obj.getAttribute('y')!)))); break;
      }
    }
  }

  Future<void> createEnemy(XmlElement obj) async
  {
    if(!isNeedLoadEnemy){
      print('already exists');
      return;
    }
    await gameRef.gameMap.add(GrassGolem(Vector2(
        double.parse(obj.getAttribute('x')!) + column * GameConsts.lengthOfTileSquare,
        double.parse(obj.getAttribute('y')!) + row * GameConsts.lengthOfTileSquare), GolemVariant.Water));
  }

  @override
  void render(Canvas canvas)
  {
    if(_image != null) {
      canvas.drawImage(_image!, const Offset(0, 0), Paint());
    }
  }
}
