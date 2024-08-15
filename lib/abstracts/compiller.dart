import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/game_worlds.dart';
import 'package:game_flame/components/physic_vals.dart';
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
    print('start compile ${bigWorld.nameForGame}');
    var fileName = bigWorld.source;
    var tiled = await TiledComponent.load(fileName, Vector2.all(320), prefix: 'assets/', atlasMaxX: 999999,atlasMaxY: 999999);
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
      await compilerAnimation.compile('high',bigWorld);
      await compilerAnimationBack.compile('down',bigWorld);
    }
    final fullCompose = ImageCompositionExt();
    for (int cols = 0; cols < bigWorld.gameConsts.maxColumn; cols++) {
      for (int rows = 0; rows < bigWorld.gameConsts.maxRow; rows++) {
        if (File(
            'assets/metaData/${bigWorld.nameForGame}/$cols-${rows}_down.png')
            .existsSync()) {
          var data = File(
              'assets/metaData/${bigWorld.nameForGame}/$cols-${rows}_down.png').readAsBytesSync();
          ui.Codec codec = await ui.instantiateImageCodec(data);
          ui.FrameInfo fi = await codec.getNextFrame();
          fullCompose.add(fi.image, Vector2(GameConsts.lengthOfTileSquare.x * cols,
              GameConsts.lengthOfTileSquare.y * rows));
        }
        if (File(
            'assets/metaData/${bigWorld.nameForGame}/$cols-${rows}_high.png')
            .existsSync()) {
          var data = File(
              'assets/metaData/${bigWorld.nameForGame}/$cols-${rows}_high.png').readAsBytesSync();
          ui.Codec codec = await ui.instantiateImageCodec(data);
          ui.FrameInfo fi = await codec.getNextFrame();
          fullCompose.add(fi.image, Vector2(GameConsts.lengthOfTileSquare.x * cols,
              GameConsts.lengthOfTileSquare.y * rows));
        }
      }
    }
    {
      var composedImage = fullCompose.compose();
      composedImage = await composedImage.resize(
          Vector2(composedImage.width / 4, composedImage.height / 4));
      var byteData = await composedImage.toByteData(
          format: ui.ImageByteFormat.png);
      File fileDdsdsd = File(
          'assets/metaData/${bigWorld.nameForGame}/fullMap.png');
      fileDdsdsd.writeAsBytesSync(byteData!.buffer.asUint8List());
    }

    // internalHitBoxes = compilerAnimationBack.
    // tiled = await TiledComponent.load(fileName, Vector2.all(320));
    Set<String> loadedFiles = {};
    for (var layer in layersLists) {
      if (layer.type == LayerType.objectGroup) {
        var objs = tiled.tileMap.getLayer<ObjectGroup>(layer.name);
        if (objs != null && true) {
          for (int cols = 0; cols < bigWorld.gameConsts.maxColumn; cols++) {
            for (int rows = 0; rows < bigWorld.gameConsts.maxRow; rows++) {
              String newObjs = '';
              for (final obj in objs.objects) {
                if (obj.name == '' && obj.type == '' && obj.gid == null) {
                  continue;
                }
                String name = '';
                bool isReversedHorizontally = false;
                if(obj.name == '' && obj.type == ''){
                  int gid = obj.gid! & 0xFFFFFFF;
                  isReversedHorizontally = (obj.gid! & 0x80000000) != 0;
                  final tileset = tiled.tileMap.map.tilesetByTileGId(gid);
                  name = tileset.tiles.first.type!;
                  assert(name != '','ERROR ${tileset.name}');
                }else{
                  name = obj.name;
                }
                Vector2 center = Vector2(obj.x + obj.width / 2, obj.gid != null ? obj.y - obj.height / 2 : obj.y + obj.height / 2);
                if (center.x ~/ GameConsts.lengthOfTileSquare.x == cols && center.y ~/ GameConsts.lengthOfTileSquare.y == rows) {
                  newObjs +=
                  '\n<o id="${obj.id}" nm="$name" cl="${obj.type}" x="${obj.x}" '
                      '${isReversedHorizontally ? 'horizontalReverse="true"' : ''}  y="${obj.y}" w="${obj.width}" h="${obj.height}"';
                  for (final props in obj.properties) {
                    newObjs += ' ${props.name}="${props.value}" ';
                  }
                  bool isLoop = false;
                  List<Point> points = [];
                  if(obj.polygon.isNotEmpty){
                    isLoop = true;
                    points = obj.polygon;
                  }
                  if(obj.polyline.isNotEmpty){
                    points = obj.polyline;
                  }
                  if(points.isNotEmpty){
                    newObjs += isLoop ? ' lp="1"' : ' lp="0"';
                    newObjs += ' p="';
                  }
                  for(final point in points){
                    newObjs += '${point.x + obj.x},${point.y + obj.y} ';
                  }
                  if(points.isNotEmpty){
                    newObjs += '"';
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
        if (objs != null && true) {
          Map<LoadedColumnRow, Set<GroundSource>> objsMap = {};
          for (final obj in objs.objects) {
            if (obj.name != '' || obj.type != '' || obj.gid != null) {
              continue;
            }
            bool isLoop = false;
            bool isPlayer = obj.properties.has('playerObstacle');
            bool isEnemy = obj.properties.has('enemyObstacle');
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
            int minCol = bigWorld.gameConsts.maxColumn;
            int minRow = bigWorld.gameConsts.maxRow;
            int maxCol = 0;
            int maxRow = 0;

            for (final point in points) {
              minCol =
                  min(minCol, (point.x) ~/ (GameConsts.lengthOfTileSquare.x));
              minRow =
                  min(minRow, (point.y) ~/ (GameConsts.lengthOfTileSquare.y));
              maxCol =
                  max(maxCol, (point.x) ~/ (GameConsts.lengthOfTileSquare.x));
              maxRow =
                  max(maxRow, (point.y) ~/ (GameConsts.lengthOfTileSquare.y));
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
                    currColInCycle * GameConsts.lengthOfTileSquare.x,
                    currRowInCycle * GameConsts.lengthOfTileSquare.y);
                Vector2 topRight = Vector2(
                    (currColInCycle + 1) * GameConsts.lengthOfTileSquare.x,
                    currRowInCycle * GameConsts.lengthOfTileSquare.y);
                Vector2 bottomLeft = Vector2(
                    currColInCycle * GameConsts.lengthOfTileSquare.x,
                    (currRowInCycle + 1) * GameConsts.lengthOfTileSquare.y);
                Vector2 bottomRight = Vector2(
                    (currColInCycle + 1) * GameConsts.lengthOfTileSquare.x,
                    (currRowInCycle + 1) * GameConsts.lengthOfTileSquare.y);

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

                  Vector2 tFTrue = Vector2(max(0,points[tF].x),max(0,points[tF].y));
                  Vector2 tSTrue = Vector2(max(0,points[tS].x),max(0,points[tS].y));


                  int col = tFTrue.x ~/ GameConsts.lengthOfTileSquare.x;
                  int row = tFTrue.y ~/ GameConsts.lengthOfTileSquare.y;
                  bool isFirst = false;
                  if (col == currColInCycle && row == currRowInCycle) {
                    coord.add(tFTrue);
                    isFirst = true;
                  }
                  col = tSTrue.x ~/ GameConsts.lengthOfTileSquare.x;
                  row = tSTrue.y ~/ GameConsts.lengthOfTileSquare.y;
                  bool isSecond = false;
                  if (col == currColInCycle && row == currRowInCycle) {
                    coord.add(tSTrue);
                    isSecond = true;
                  }
                  if (isFirst && isSecond) {
                    continue;
                  }
                  List<Vector2> tempCoord = [];
                  Vector2 answer = f_pointOfIntersect(
                      topLeft, topRight, tFTrue, tSTrue);
                  if (answer != Vector2.zero()) {
                    tempCoord.add(answer);
                  }
                  answer = f_pointOfIntersect(
                      topRight, bottomRight, tFTrue, tSTrue);
                  if (answer != Vector2.zero()) {
                    tempCoord.add(answer);
                  }
                  answer = f_pointOfIntersect(
                      bottomRight, bottomLeft, tFTrue, tSTrue);
                  if (answer != Vector2.zero()) {
                    tempCoord.add(answer);
                  }
                  answer = f_pointOfIntersect(
                      bottomLeft, topLeft, tFTrue, tSTrue);
                  if (answer != Vector2.zero()) {
                    tempCoord.add(answer);
                  }
                  if (isFirst && !isSecond) {
                    if(tempCoord.isEmpty){
                      print('tFTrue, tSTrue = $tFTrue, $tSTrue');
                    }
                    coord.add(tempCoord[0]);
                    GroundSource newPoints = GroundSource();
                    newPoints.isPlayer = isPlayer;
                    newPoints.isEnemy = isEnemy;
                    newPoints.isLoop = false;
                    newPoints.points = List.unmodifiable(coord);
                    objsMap.putIfAbsent(
                        LoadedColumnRow(
                            currColInCycle, currRowInCycle), () => {});
                    objsMap[LoadedColumnRow(currColInCycle, currRowInCycle)]!
                        .add(newPoints);
                    coord.clear();
                  }
                  if (isSecond && !isFirst) {
                    Vector2 temp = coord.last;
                    coord.last = tempCoord[0];
                    coord.add(temp);
                    GroundSource newPoints = GroundSource();
                    newPoints.isPlayer = isPlayer;
                    newPoints.isEnemy = isEnemy;
                    newPoints.isLoop = false;
                    newPoints.points = List.unmodifiable(coord);
                    objsMap.putIfAbsent(
                        LoadedColumnRow(
                            currColInCycle, currRowInCycle), () => {});
                    objsMap[LoadedColumnRow(currColInCycle, currRowInCycle)]!
                        .add(newPoints);
                    coord.clear();
                    //Записываем всё что есть
                  }
                  if (!isFirst && !isSecond && tempCoord.length == 2) {
                    if (tFTrue.distanceToSquared(tempCoord.first) >
                        tFTrue.distanceToSquared(tempCoord.last)) {
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
                    newPoints.isPlayer = isPlayer;
                    newPoints.isEnemy = isEnemy;
                    newPoints.isLoop = false;
                    newPoints.points = List.unmodifiable(coord);
                    objsMap.putIfAbsent(
                        LoadedColumnRow(
                            currColInCycle, currRowInCycle), () => {});
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
                  newPoints.isPlayer = isPlayer;
                  newPoints.isEnemy = isEnemy;
                  newPoints.isLoop = isReallyLoop;
                  newPoints.points = List.unmodifiable(coord);
                  objsMap.putIfAbsent(
                      LoadedColumnRow(currColInCycle, currRowInCycle), () => {});
                  objsMap[LoadedColumnRow(currColInCycle, currRowInCycle)]!
                      .add(newPoints);
                  coord.clear();
                }
              }
            }
          }
          for(final keys in compilerAnimationBack.internalObjs.keys){
            int col = keys.x ~/ GameConsts.lengthOfTileSquare.x;
            int row = keys.y ~/ GameConsts.lengthOfTileSquare.y;
            GroundSource newPoints = GroundSource();
            newPoints.isLoop = false;
            newPoints.points = List.unmodifiable(compilerAnimationBack.internalObjs[keys]!);
            objsMap.putIfAbsent(LoadedColumnRow(col, row), () => {});
            objsMap[LoadedColumnRow(col, row)]!.add(newPoints);
          }
          for(final keys in compilerAnimationBack.internalObjsLoop.keys){
            int col = keys.x ~/ GameConsts.lengthOfTileSquare.x;
            int row = keys.y ~/ GameConsts.lengthOfTileSquare.y;
            GroundSource newPoints = GroundSource();
            newPoints.isLoop = true;
            newPoints.points = List.unmodifiable(compilerAnimationBack.internalObjsLoop[keys]!);
            objsMap.putIfAbsent(LoadedColumnRow(col, row), () => {});
            objsMap[LoadedColumnRow(col, row)]!.add(newPoints);
          }
          compilerAnimationBack.internalObjs.clear();
          compilerAnimationBack.internalObjsLoop.clear();
          compilerAnimation.internalObjs.clear();
          compilerAnimation.internalObjsLoop.clear();

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
              if (objsMap[key]!.elementAt(i).points.length <= 1) {
                continue;
              }
              file.writeAsStringSync('\n<o lp="${objsMap[key]!.elementAt(i).isLoop
                  ? '1'
                  : '0'}" ${objsMap[key]!.elementAt(i).isPlayer ? 'player="1"' : '' } ${objsMap[key]!.elementAt(i).isEnemy ? 'enemy="1"' : '' } nm="_g" p="', mode: FileMode.append);
              for (int j = 0; j < objsMap[key]!.elementAt(i).points.length; j++) {
                if (j > 0) {
                  file.writeAsStringSync(' ', mode: FileMode.append);
                }
                file.writeAsStringSync('${objsMap[key]!.elementAt(i).points.toList()[j]
                    .x},${objsMap[key]!.elementAt(i).points.toList()[j].y}',
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
    for (var layer in layersLists) {
      File file = File(
          'assets/metaData/${bigWorld.nameForGame}/sqlObjects.sql');
      if(layer.type == LayerType.objectGroup){
        var objs = tiled.tileMap.getLayer<ObjectGroup>(layer.name);
        if (objs != null) {
          for(final obj in objs.objects){
            if (obj.name == '' && obj.type == '' && obj.gid == null) {
              continue;
            }
            String? id,opened,quest,used;
            id = obj.id.toString();
            opened = obj.properties.getValue('opened') ?? '""';
            if(opened == '""'){
              opened = obj.properties.getValue('open') ?? '""';
            }
            quest = obj.properties.getValue('quest') ?? '""';
            used = obj.properties.getValue('used') ?? '""';
            file.writeAsStringSync('INSERT INTO ${bigWorld.nameForGame} (id,opened,quest,used) VALUES ($id,$opened,\'$quest\',$used) ON CONFLICT DO NOTHING;\n', mode: FileMode.append);
          }
        }
      }
    }
  }
}
