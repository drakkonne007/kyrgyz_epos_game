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
  for(final bigWorlds in listOfFullMaps) {
    Directory dir = Directory('assets/metaData/${bigWorlds.nameForGame}');
    if(dir.existsSync()){
      dir.deleteSync(recursive: true);
    }
    dir.createSync(recursive: true);
  }
  for (final bigWorld in listOfFullMaps) {
    var fileName = bigWorld.source; //'top_left_bottom-slice.tmx';
    var tiled = await TiledComponent.load(fileName, Vector2.all(320));
    var layersLists = tiled.tileMap.renderableLayers;
    if (true) {
      MySuperAnimCompiler compilerAnimationBack = MySuperAnimCompiler();
      MySuperAnimCompiler compilerAnimation = MySuperAnimCompiler();
      for (var a in layersLists) {
        if (a.layer.type != LayerType.tileLayer) {
          continue;
        }
        await processTileType(
            clear: false,
            renderMode: RenderCompileMode.Background,
            tileMap: tiled.tileMap,
            addTiles: (tile, position, size) async {
              compilerAnimationBack.addTile(position, tile);
            },
            layersToLoad: [a.layer.name]);
        compilerAnimationBack.addLayer();
        await processTileType(
            clear: false,
            renderMode: RenderCompileMode.Foreground,
            tileMap: tiled.tileMap,
            addTiles: (tile, position, size) async {
              compilerAnimation.addTile(position, tile);
            },
            layersToLoad: [a.layer.name]);
        compilerAnimation.addLayer();
      }
      await compilerAnimation.compile('high',bigWorld);
      await compilerAnimationBack.compile('down',bigWorld);
    }
    // tiled = await TiledComponent.load(fileName, Vector2.all(320));
    Set<String> loadedFiles = {};
    for (var layer in layersLists) {
      if (layer.layer.type == LayerType.objectGroup) {
        var objs = tiled.tileMap.getLayer<ObjectGroup>(layer.layer.name);
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
                File file = File('assets/metaData/${bigWorld.nameForGame}/$cols-$rows.objXml');
                if (!loadedFiles.contains(
                    'assets/metaData/${bigWorld.nameForGame}/$cols-$rows.objXml')) {
                  loadedFiles.add('assets/metaData/${bigWorld.nameForGame}/$cols-$rows.objXml');
                  file.writeAsStringSync('<p>\n', mode: FileMode.append);
                }
                file.writeAsStringSync(newObjs, mode: FileMode.append);
              }
            }
          }
        }
        print('start grounds compile');
        if (objs != null && true) {
          Map<LoadedColumnRow, List<GroundSource>> objsMap = {};
          for (final obj in objs.objects) {
            if (obj.name != '') {
              continue;
            }
            bool isLoop = false;

            List<Vector2> points = [];
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
            int minCol = bigWorld.gameConsts.maxColumn!;
            int minRow = bigWorld.gameConsts.maxRow!;
            int maxCol = 0;
            int maxRow = 0;

            for (final point in points) {
              minCol =
                  min(minCol, (point.x) ~/ (bigWorld.gameConsts.lengthOfTileSquare.x));
              minRow =
                  min(minRow, (point.y) ~/ (bigWorld.gameConsts.lengthOfTileSquare.y));
              maxCol =
                  max(maxCol, (point.x) ~/ (bigWorld.gameConsts.lengthOfTileSquare.x));
              maxRow =
                  max(maxRow, (point.y) ~/ (bigWorld.gameConsts.lengthOfTileSquare.y));
            }
            //Короче вначале проверяем две точки - если обе входят - идём дальше, Если только вторая - проверяем пересечение с предыдущей
            //и добавляем вначале пересечение, потом вторую точку
            //Если только первая - ищем пересечение с гранью и начинаем сначала
            bool isReallyLoop = minCol == maxCol && minRow == maxRow &&
                isLoop;
            for (int currColInCycle = minCol; currColInCycle <=
                maxCol; currColInCycle++) {
              for (int currRowInCycle = minRow; currRowInCycle <=
                  maxRow; currRowInCycle++) {
                Vector2 topLeft = Vector2(
                    currColInCycle * bigWorld.gameConsts.lengthOfTileSquare.x,
                    currRowInCycle * bigWorld.gameConsts.lengthOfTileSquare.y);
                Vector2 topRight = Vector2(
                    (currColInCycle + 1) * bigWorld.gameConsts.lengthOfTileSquare.x,
                    currRowInCycle * bigWorld.gameConsts.lengthOfTileSquare.y);
                Vector2 bottomLeft = Vector2(
                    currColInCycle * bigWorld.gameConsts.lengthOfTileSquare.x,
                    (currRowInCycle + 1) * bigWorld.gameConsts.lengthOfTileSquare.y);
                Vector2 bottomRight = Vector2(
                    (currColInCycle + 1) * bigWorld.gameConsts.lengthOfTileSquare.x,
                    (currRowInCycle + 1) * bigWorld.gameConsts.lengthOfTileSquare.y);

                List<Vector2> coord = [];
                for (int i = -1; i < points.length - 1; i++) {
                  if (!isLoop && i == -1) {
                    continue;
                  }
                  int tF, tS;
                  if (i == -1) {
                    tF = points.length - 1;
                  } else {
                    tF = i;
                  }
                  tS = i + 1;

                  int col = points[tF].x ~/ bigWorld.gameConsts.lengthOfTileSquare.x;
                  int row = points[tF].y ~/ bigWorld.gameConsts.lengthOfTileSquare.y;
                  bool isFirst = false;
                  if (col == currColInCycle && row == currRowInCycle) {
                    coord.add(points[tF]);
                    isFirst = true;
                  }
                  col = points[tS].x ~/ bigWorld.gameConsts.lengthOfTileSquare.x;
                  row = points[tS].y ~/ bigWorld.gameConsts.lengthOfTileSquare.y;
                  bool isSecond = false;
                  if (col == currColInCycle && row == currRowInCycle) {
                    coord.add(points[tS]);
                    isSecond = true;
                  }
                  if (isFirst && isSecond) {
                    continue;
                  }
                  List<Vector2> tempCoord = [];
                  Vector2 answer = f_pointOfIntersect(
                      topLeft, topRight, points[tF], points[tS]);
                  if (answer != Vector2.zero()) {
                    tempCoord.add(answer);
                  }
                  answer = f_pointOfIntersect(
                      topRight, bottomRight, points[tF], points[tS]);
                  if (answer != Vector2.zero()) {
                    tempCoord.add(answer);
                  }
                  answer = f_pointOfIntersect(
                      bottomRight, bottomLeft, points[tF], points[tS]);
                  if (answer != Vector2.zero()) {
                    tempCoord.add(answer);
                  }
                  answer = f_pointOfIntersect(
                      bottomLeft, topLeft, points[tF], points[tS]);
                  if (answer != Vector2.zero()) {
                    tempCoord.add(answer);
                  }
                  if (isFirst && !isSecond) {
                    coord.add(tempCoord[0]);
                    GroundSource newPoints = GroundSource();
                    newPoints.isLoop = false;
                    newPoints.points = Set.unmodifiable(coord);
                    objsMap.putIfAbsent(
                        LoadedColumnRow(
                            currColInCycle, currRowInCycle), () => []);
                    objsMap[LoadedColumnRow(currColInCycle, currRowInCycle)]!
                        .add(newPoints);
                    coord.clear();
                  }
                  if (isSecond && !isFirst) {
                    Vector2 temp = coord.last;
                    coord.last = tempCoord[0];
                    coord.add(temp);
                    GroundSource newPoints = GroundSource();
                    newPoints.isLoop = false;
                    newPoints.points = Set.unmodifiable(coord);
                    objsMap.putIfAbsent(
                        LoadedColumnRow(
                            currColInCycle, currRowInCycle), () => []);
                    objsMap[LoadedColumnRow(currColInCycle, currRowInCycle)]!
                        .add(newPoints);
                    coord.clear();
                    //Записываем всё что есть
                  }
                  if (!isFirst && !isSecond && tempCoord.length == 2) {
                    if (points[tF].distanceToSquared(tempCoord.first) >
                        points[tF].distanceToSquared(tempCoord.last)) {
                      coord.clear();
                      coord.add(tempCoord.last);
                      coord.add(tempCoord.first);
                      //Записываем всё что есть
                    } else {
                      coord.clear();
                      coord.add(tempCoord.first);
                      coord.add(tempCoord.last);
                      //Записываем всё что есть
                    }
                    GroundSource newPoints = GroundSource();
                    newPoints.isLoop = false;
                    newPoints.points = Set.unmodifiable(coord);
                    objsMap.putIfAbsent(
                        LoadedColumnRow(
                            currColInCycle, currRowInCycle), () => []);
                    objsMap[LoadedColumnRow(currColInCycle, currRowInCycle)]!
                        .add(newPoints);
                    coord.clear();
                  }
                }
                if (coord.isNotEmpty) {
                  if (coord.length == 1) {
                    print('Error in calc $coord');
                  }
                  GroundSource newPoints = GroundSource();
                  newPoints.isLoop = isReallyLoop;
                  newPoints.points = Set.unmodifiable(coord);
                  objsMap.putIfAbsent(
                      LoadedColumnRow(currColInCycle, currRowInCycle), () =>
                  [
                  ]);
                  objsMap[LoadedColumnRow(currColInCycle, currRowInCycle)]!
                      .add(newPoints);
                  coord.clear();
                }
              }
            }
          }
          for (final key in objsMap.keys) {
            File file = File(
                'assets/metaData/${bigWorld.nameForGame}/${key.column}-${key.row}.objXml');
            if (!loadedFiles.contains(
                'assets/metaData/${bigWorld.nameForGame}/${key.column}-${key.row}.objXml')) {
              file.writeAsStringSync('<p>\n', mode: FileMode.append);
              loadedFiles.add(
                  'assets/metaData/${bigWorld.nameForGame}/${key.column}-${key.row}.objXml');
            }
            for (int i = 0; i < objsMap[key]!.length; i++) {
              if (objsMap[key]![i].points.length <= 1) {
                continue;
              }
              file.writeAsStringSync('\n<o lp="${objsMap[key]![i].isLoop
                  ? '1'
                  : '0'}" nm="" p="', mode: FileMode.append);
              for (int j = 0; j < objsMap[key]![i].points.length; j++) {
                if (j > 0) {
                  file.writeAsStringSync(' ', mode: FileMode.append);
                }
                file.writeAsStringSync('${objsMap[key]![i].points.toList()[j]
                    .x},${objsMap[key]![i].points.toList()[j].y}',
                    mode: FileMode.append);
              }
              file.writeAsStringSync('"/>', mode: FileMode.append);
            }
          }
        }
      }
    }

    for (final key in loadedFiles) {
      File file = File(key);
      file.writeAsStringSync('\n</p>', mode: FileMode.append);
    }
  }
}
