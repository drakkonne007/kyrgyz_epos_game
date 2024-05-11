import 'dart:io';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/MapNode.dart';
import 'package:game_flame/components/game_worlds.dart';
import 'package:game_flame/components/precompile_animation.dart';
import 'package:game_flame/components/tile_map_component.dart';

Future precompileAll() async
{
  final listOfFullMaps = fullMapsForPreCompille();
  for (final bigWorlds in listOfFullMaps) {
    Directory dir = Directory('assets/metaData/${bigWorlds.nameForGame}');
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
    dir.createSync(recursive: true);
  }
  for (final bigWorld in listOfFullMaps) {
    Set<GroundSource> onlyGround = {};
    print('start compile ${bigWorld.nameForGame}');
    var fileName = bigWorld.source;
    var tiled = await TiledComponent.load(
        fileName, Vector2.all(320), prefix: 'assets/',
        atlasMaxX: 999999,
        atlasMaxY: 999999);
    var layersLists = tiled.tileMap.map.layers;
    MySuperAnimCompiler compilerAnimationBack = MySuperAnimCompiler();
    MySuperAnimCompiler compilerAnimation = MySuperAnimCompiler();
    if (true) {
      for (var a in layersLists) {
        if (a.type != LayerType.tileLayer) {
          continue;
        }
        await processTileType(
            clear: false,
            renderMode: RenderCompileMode.Background,
            tileMap: tiled.tileMap,
            addTiles: (tile, position, size) async {
              compilerAnimationBack.addTile(position, tile);
            },
            layersToLoad: [a.name]);
        compilerAnimationBack.addLayer();
        await processTileType(
            clear: false,
            renderMode: RenderCompileMode.Foreground,
            tileMap: tiled.tileMap,
            addTiles: (tile, position, size) async {
              compilerAnimation.addTile(position, tile);
            },
            layersToLoad: [a.name]);
        compilerAnimation.addLayer();
      }
      await compilerAnimation.compile('high', bigWorld);
      await compilerAnimationBack.compile('down', bigWorld);
    }
    // internalHitBoxes = compilerAnimationBack.
    // tiled = await TiledComponent.load(fileName, Vector2.all(320));
    Set<String> loadedFiles = {};
    for (var layer in layersLists) {
      if (layer.type == LayerType.objectGroup) {
        var objs = tiled.tileMap.getLayer<ObjectGroup>(layer.name);
        if (objs != null && true) {
          for (int cols = 0; cols < bigWorld.gameConsts.maxColumn!; cols++) {
            for (int rows = 0; rows < bigWorld.gameConsts.maxRow!; rows++) {
              var positionCurs = Vector2(
                  cols * bigWorld.gameConsts.lengthOfTileSquare.x,
                  rows * bigWorld.gameConsts.lengthOfTileSquare.y);
              String newObjs = '';
              Rectangle rec = Rectangle.fromPoints(positionCurs, Vector2(
                  positionCurs.x + bigWorld.gameConsts.lengthOfTileSquare.x,
                  positionCurs.y + bigWorld.gameConsts.lengthOfTileSquare.y));
              for (final obj in objs.objects) {
                if (obj.name == '') {
                  continue;
                }
                Rectangle objRect = Rectangle.fromPoints(
                    Vector2(obj.x, obj.y),
                    Vector2(obj.x + obj.width, obj.y + obj.height));
                if (isIntersect(rec, objRect)) {
                  newObjs +=
                  '<o nm="${obj.name}" cl="${obj.type}" x="${obj
                      .x}" y="${obj.y}" w="${obj.width}" h="${obj
                      .height}"';
                  for (final props in obj.properties) {
                    newObjs += ' ${props.name}="${props.value}"';
                  }
                  newObjs += '/>';
                  newObjs += '\n';
                }
              }
              if (newObjs != '') {
                File file = File('assets/metaData/${bigWorld
                    .nameForGame}/$cols-$rows.objXml');
                if (!loadedFiles.contains(
                    'assets/metaData/${bigWorld
                        .nameForGame}/$cols-$rows.objXml')) {
                  loadedFiles.add('assets/metaData/${bigWorld
                      .nameForGame}/$cols-$rows.objXml');
                  file.writeAsStringSync('<p>\n', mode: FileMode.append);
                }
                file.writeAsStringSync(newObjs, mode: FileMode.append);
              }
            }
          }
        }
        if (objs != null && true) {
          for (final obj in objs.objects) {
            bool isLoop = false;
            List<Vector2> points = [];
            if (obj.name != '') {
              continue;
            }
            if (obj.isPolygon) {
              isLoop = true;
              for (final point in obj.polygon) {
                points.add(Vector2(point.x + obj.x, point.y + obj.y));
              }
            }
            if (obj.isPolyline) {
              for (final point in obj.polyline) {
                points.add(Vector2(point.x + obj.x, point.y + obj.y));
              }
            }
            if (obj.isRectangle) {
              isLoop = true;
              points.add(Vector2(obj.x, obj.y));
              points.add(Vector2(obj.x, obj.y + obj.height));
              points.add(Vector2(obj.x + obj.width, obj.y + obj.height));
              points.add(Vector2(obj.x + obj.width, obj.y));
            }
            GroundSource newPoints = GroundSource();
            newPoints.isLoop = isLoop;
            newPoints.points = List.unmodifiable(points);
            onlyGround.add(newPoints);
          }
        }
      }
    }
    for (final key in loadedFiles) {
      File file = File(key);
      file.writeAsStringSync('\n</p>', mode: FileMode.append);
    }
    for (final keys in compilerAnimationBack.internalObjs.keys) {
      GroundSource newPoints = GroundSource();
      newPoints.isLoop = false;
      newPoints.points =
          List.unmodifiable(compilerAnimationBack.internalObjs[keys]!);
      onlyGround.add(newPoints);
    }
    for (final keys in compilerAnimationBack.internalObjsLoop.keys) {
      GroundSource newPoints = GroundSource();
      newPoints.isLoop = true;
      newPoints.points = List.unmodifiable(
          compilerAnimationBack.internalObjsLoop[keys]!);
      onlyGround.add(newPoints);
    }
    compilerAnimationBack.internalObjs.clear();
    compilerAnimationBack.internalObjsLoop.clear();
    File file = File('assets/metaData/${bigWorld.nameForGame}/${bigWorld.nameForGame}.grounds');
    file.writeAsStringSync('<p>\n', mode: FileMode.write);
    for(final obj in onlyGround) {
      if (obj.points.length <= 1) {
        continue;
      }
      file.writeAsStringSync('\n<o lp="${obj.isLoop
          ? '1'
          : '0'}" nm="" p="', mode: FileMode.append);
      for (int j = 0; j < obj.points.length; j++) {
        if (j > 0) {
          file.writeAsStringSync(' ', mode: FileMode.append);
        }
        file.writeAsStringSync('${obj.points.toList()[j]
            .x},${obj.points.toList()[j].y}',
            mode: FileMode.append);
      }
      file.writeAsStringSync('"/>', mode: FileMode.append);
    }
    file.writeAsStringSync('\n</p>', mode: FileMode.append);
  }
}
