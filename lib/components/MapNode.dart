
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/players/sword_enemy.dart';
import 'package:xml/xml.dart';

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

  Iterable<XmlElement> getObjects(String name)
  {
    final text = File('assets/0-0.tmx').readAsString();
    final document = XmlDocument.parse(text.toString()).findAllElements('object');
    return document;
  }

  Future<void> generateMap() async
  {
    if(column > GameConsts.maxColumn || row > GameConsts.maxRow) {
      return;
    }
    if(column < 0 || row < 0) {
      return;
    }
    isNeedLoadEnemy = !gameRef.gameMap.loadedColumns.contains(column) || !gameRef.gameMap.loadedRows.contains(row);
    _image = await Flame.images.load('0-0.png');
    position = Vector2(column * 32 * 30, row * 32 * 30) * GameConsts.gameScale;
    scale = Vector2.all(GameConsts.gameScale);
    var fileName = '$column-$row.tmx';
    final text = await Flame.assets.readFile(fileName);
    final objects = XmlDocument.parse(text.toString()).findAllElements('object');
    for(final obj in objects) {
      switch(obj.getAttribute('name')) {
        case 'enemy':  await createEnemy(obj); break;
        case 'ground': add(Ground(size: Vector2(double.parse(obj.getAttribute('width')!), double.parse(obj.getAttribute('height')!)),position: Vector2(double.parse(obj.getAttribute('x')!) + column * 32 * 30, double.parse(obj.getAttribute('y')!) + row * 32 * 30))); break;
      }
    }
  }

  Future<void> createEnemy(XmlElement obj) async{
    if(!isNeedLoadEnemy){
      print('already exists');
      return;
    }
    await gameRef.gameMap.add(SwordEnemy(Vector2(
      double.parse(obj.getAttribute('x')!) + column * 32 * 30,
      double.parse(obj.getAttribute('y')!) + row * 32 * 30) *
      GameConsts.gameScale));
  }

  @override
  void render(Canvas canvas) {
    if(_image != null) {
      canvas.drawImage(_image!, const Offset(0, 0), Paint());
    }
  }
}
