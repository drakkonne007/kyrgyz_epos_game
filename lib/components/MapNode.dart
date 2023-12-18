import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/Items/teleport.dart';
import 'package:game_flame/Obstacles/flying_obelisk.dart';
import 'package:game_flame/Obstacles/stand_obelisk.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/precompile_animation.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:game_flame/enemies/moose.dart';
import 'package:game_flame/enemies/strange_merchant.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/enemies/grass_golem.dart';
import 'package:game_flame/main.dart';
import 'package:xml/xml.dart';

const int currentMaps = 0;

//function is intersect two rectangles
bool isIntersect(Rectangle rect1, Rectangle rect2)
{
  return (rect1.left < rect2.right &&
      rect2.left < rect1.right &&
      rect1.top < rect2.bottom &&
      rect2.top < rect1.bottom);
}

class MapNode
{
  MapNode(this.custMap);
  CustomTileMap custMap;
  int _id = 0;
  KyrgyzGame? myGame;
  int id() => _id++;

  Future<void> generateMap(LoadedColumnRow colRow) async
  {
    if (colRow.column >= GameConsts.maxColumn || colRow.row >= GameConsts.maxRow) {
      return;
    }
    if (colRow.column < 0 || colRow.row < 0) {
      return;
    }
    if (isMapCompile) {
      await compileAll(colRow);
      exit(0);
    }
    custMap.allEls.putIfAbsent(colRow, () => []);
    if (KyrgyzGame.cachedObjXmls.containsKey('${colRow.column}-${colRow.row}.objXml')) {
      var objects = KyrgyzGame.cachedObjXmls['${colRow.column}-${colRow.row}.objXml']!;
      for (final obj in objects) {
        String? name = obj.getAttribute('nm');
        switch (name) {
          case '':
            var points = obj.getAttribute('p')!;
            var pointsList = points.split(' ');
            List<Vector2> temp = [];
            for(final sources in pointsList){
              if(sources == ''){
                continue;
              }
              temp.add(Vector2(double.parse(sources.split(',')[0]),double.parse(sources.split(',')[1])));
            }
            if(temp.isNotEmpty) {
              // for(var i = 0; i < temp.length - 1; i++){
              //   PolygonHitbox rect = PolygonHitbox([temp[i], temp[i + 1], temp[i + 1] + Vector2.all(1), temp[i] + Vector2.all(1)]);
              //   rect.priority = 800;
              //   rect.paint.color = BasicPalette.red.color;
              //   rect.renderShape = true;
              //   custMap.add(rect);
              // }
              // if(obj.getAttribute('lp')! == '1'){
              //   PolygonHitbox rect = PolygonHitbox([temp[0], temp[temp.length - 1], temp[temp.length - 1] + Vector2.all(1), temp[0] + Vector2.all(1)]);
              //   rect.priority = 800;
              //   rect.paint.color = BasicPalette.red.color;
              //   rect.renderShape = true;
              //   custMap.add(rect);
              // }
              var ground = Ground(temp, collisionType: DCollisionType.passive,
                  isSolid: false,
                  isStatic: true,
                  isLoop: obj.getAttribute('lp')! == '1',
                  game: myGame!,
                  column: colRow.column,
                  row: colRow.row);
              custMap.allEls[colRow]!.add(ground);
              // custMap.add(ground);
            }
            break;
          default:
            _createLiveObj(obj, name, colRow);
            break;
        }
      }
    }
    if (KyrgyzGame.cachedAnims.containsKey('${colRow.column}-${colRow.row}_high.anim')) {
      var objects = KyrgyzGame.cachedAnims['${colRow.column}-${colRow.row}_high.anim']!;
      for (final obj in objects) {
        Vector2 srcSize = Vector2(double.parse(obj.getAttribute('w')!),double.parse(obj.getAttribute('h')!));
        Image srcImage = KyrgyzGame.cachedImgs[obj.getAttribute('src')!]!;
        final List<Sprite> spriteList = [];
        final List<double> stepTimes = [];
        for (final anim in obj.findAllElements('fr')) {
          spriteList.add(Sprite(srcImage, srcSize: srcSize,
              srcPosition: Vector2(
                  double.parse(anim.getAttribute('cl')!) * srcSize.x,
                  double.parse(anim.getAttribute('rw')!) * srcSize.y)));
          stepTimes.add(double.parse(anim.getAttribute('dr')!));
        }
        var sprAnim = SpriteAnimation.variableSpriteList(
            spriteList, stepTimes: stepTimes);
        for (final anim in obj.findAllElements('ps')) {
          var ss = SpriteAnimationComponent(animation: sprAnim,
              position: Vector2(double.parse(anim.getAttribute('x')!),
                  double.parse(anim.getAttribute('y')!)),
              size: Vector2(srcSize.x+1, srcSize.y+1),
              priority: GamePriority.high);
          custMap.allEls[colRow]!.add(ss);
          custMap.add(ss);
        }
      }
    }
    if (KyrgyzGame.cachedMapPngs.contains('${colRow.column}-${colRow.row}_high.png')) {
      Image _imageHigh = await Flame.images.load(
          'metaData/${colRow.column}-${colRow.row}_high.png'); //KyrgyzGame.cachedImgs['$column-${row}_high.png']!;
      var spriteHigh = SpriteComponent(
        sprite: Sprite(_imageHigh),
        position: Vector2(colRow.column * GameConsts.lengthOfTileSquare.x,
            colRow.row * GameConsts.lengthOfTileSquare.y),
        priority: GamePriority.high - 1,
        size: GameConsts.lengthOfTileSquare + Vector2.all(1),
      );
      custMap.allEls[colRow]!.add(spriteHigh);
      custMap.add(spriteHigh);
    }
    if (KyrgyzGame.cachedAnims.containsKey('${colRow.column}-${colRow.row}_down.anim')) {
      var objects = KyrgyzGame.cachedAnims['${colRow.column}-${colRow.row}_down.anim']!;
      for (final obj in objects) {
        Vector2 sourceSize = Vector2(double.parse(obj.getAttribute('w')!),double.parse(obj.getAttribute('h')!));
        Image srcImage = KyrgyzGame.cachedImgs[obj.getAttribute('src')!]!;
        final List<Sprite> spriteList = [];
        final List<double> stepTimes = [];
        for (final anim in obj.findAllElements('fr')) {
          spriteList.add(Sprite(srcImage, srcSize: sourceSize,
              srcPosition: Vector2(
                  double.parse(anim.getAttribute('cl')!) * sourceSize.x,
                  double.parse(anim.getAttribute('rw')!) * sourceSize.y)));
          stepTimes.add(double.parse(anim.getAttribute('dr')!));
        }
        var sprAnim = SpriteAnimation.variableSpriteList(
            spriteList, stepTimes: stepTimes);
        for (final anim in obj.findAllElements('ps')) {
          var ss = SpriteAnimationComponent(animation: sprAnim,
              position: Vector2(double.parse(anim.getAttribute('x')!),
                  double.parse(anim.getAttribute('y')!)),
              size: Vector2(sourceSize.x+1, sourceSize.y+1),
              priority: GamePriority.ground + 1);
          custMap.allEls[colRow]!.add(ss);
          custMap.add(ss);
        }
      }
    }
    if (KyrgyzGame.cachedMapPngs.contains('${colRow.column}-${colRow.row}_down.png')) {
      Image _imageDown = await Flame.images.load(
          'metaData/${colRow.column}-${colRow.row}_down.png'); //KyrgyzGame.cachedImgs['$column-${row}_down.png']!;
      var spriteDown = SpriteComponent(
        sprite: Sprite(_imageDown),
        position: Vector2(colRow.column * GameConsts.lengthOfTileSquare.x,
            colRow.row * GameConsts.lengthOfTileSquare.y),
        size: GameConsts.lengthOfTileSquare + Vector2.all(1),
        priority: 0,
      );
      custMap.allEls[colRow]!.add(spriteDown);
      custMap.add(spriteDown);
    }
  }

  void createCheatElement(String name) {
    Vector2 position = Vector2(myGame!.gameMap.orthoPlayer!.position.x, myGame!.gameMap.orthoPlayer!.position.y);
    int col = position.x ~/ (GameConsts.lengthOfTileSquare.x);
    int row = position.y ~/ (GameConsts.lengthOfTileSquare.y);
    LoadedColumnRow colRow = LoadedColumnRow(col, row);
    switch (name) {
      case 'ggolem':
        custMap.loadedLivesObjs.add(position);
        custMap.add(GrassGolem(
            position, GolemVariant.Grass, priority: GamePriority.player - 2));
        break;
      case 'wgolem':
        custMap.loadedLivesObjs.add(position);
        custMap.add(GrassGolem(
            position, GolemVariant.Water, priority: GamePriority.player - 2));
        break;
      case 'gold':
        var temp = LootOnMap(itemFromId(2), position: position);
        custMap.allEls[colRow]!.add(temp);
        custMap.add(temp);
        break;
      case 'moose':
        custMap.loadedLivesObjs.add(position);
        custMap.add(GrassGolem(
            position, GolemVariant.Water, priority: GamePriority.player - 2));
        break;
      case 'chest':
        int level = Random().nextInt(3);
        var temp = Chest(level, myItems: [itemFromId(2)], position: position);
        custMap.allEls[colRow]!.add(temp);
        custMap.add(temp);
        break;
      case 'fObelisk':
        var temp = FlyingHighObelisk(
            position, colRow.column, colRow.row, priority: GamePriority.high - 1);
        custMap.allEls[colRow]!.add(temp);
        custMap.add(temp);
        var temp2 = FlyingDownObelisk(
            position, colRow.column, colRow.row, priority: GamePriority.player - 2);
        custMap.allEls[colRow]!.add(temp2);
        custMap.add(temp2);
        break;
      case 'sObelisk':
        var temp = StandHighObelisk(position, priority: GamePriority.high - 1);
        custMap.allEls[colRow]!.add(temp);
        custMap.add(temp);
        var temp2 = StandDownObelisk(
            position, priority: GamePriority.player - 2);
        custMap.allEls[colRow]!.add(temp2);
        custMap.add(temp2);
        break;
    }
  }


  Future _createLiveObj(XmlElement obj, String? name, LoadedColumnRow colRow) async
  {
    Vector2 position = Vector2(
        double.parse(obj.getAttribute('x')!),
        double.parse(obj.getAttribute('y')!)
    );
    if (custMap.loadedLivesObjs.contains(position)) {
      return;
    }
    switch (name) {
      case 'ggolem':
        custMap.loadedLivesObjs.add(position);
        custMap.add(GrassGolem(
            position, GolemVariant.Grass, priority: GamePriority.player - 2));
        break;
      case 'enemy':
        custMap.loadedLivesObjs.add(position);
        custMap.add(GrassGolem(
            position, GolemVariant.Grass, priority: GamePriority.player - 2));
        break;
      case 'wgolem':
        custMap.loadedLivesObjs.add(position);
        custMap.add(GrassGolem(
            position, GolemVariant.Water, priority: GamePriority.player - 2));
        break;
      case 'moose':
        custMap.loadedLivesObjs.add(position);
        custMap.add(Moose(
            position, MooseVariant.Blue, priority: GamePriority.player - 2));
        break;
      case 'gold':
        var temp = LootOnMap(itemFromId(2), position: position);
        custMap.allEls[colRow]!.add(temp);
        custMap.add(temp);
        break;
      case 'strange_merchant':
        var temp = StrangeMerchant(position,StrangeMerchantVariant.black, priority: GamePriority.player - 2);
        custMap.allEls[colRow]!.add(temp);
        custMap.add(temp);
        break;
      case 'chest':
        var temp = Chest(1, myItems: [itemFromId(2)], position: position);
        custMap.allEls[colRow]!.add(temp);
        custMap.add(temp);
        break;
      case 'fObelisk':
        var temp = FlyingHighObelisk(
            position, colRow.column, colRow.row, priority: GamePriority.high - 1);
        custMap.allEls[colRow]!.add(temp);
        custMap.add(temp);
        var temp2 = FlyingDownObelisk(
            position, colRow.column, colRow.row, priority: GamePriority.player - 2);
        custMap.allEls[colRow]!.add(temp2);
        custMap.add(temp2);
        break;
      case 'sObelisk':
        var temp = StandHighObelisk(position, priority: GamePriority.high - 1);
        custMap.allEls[colRow]!.add(temp);
        custMap.add(temp);
        var temp2 = StandDownObelisk(
            position, priority: GamePriority.player - 2);
        custMap.allEls[colRow]!.add(temp2);
        custMap.add(temp2);
        break;
      case 'telep':
        var targetPos = obj.getAttribute('tar')!.split(',');
        Vector2 target = Vector2(double.parse(targetPos[0]), double.parse(targetPos[1]));
        Vector2 telSize = Vector2(double.parse(obj.getAttribute('w')!), double.parse(obj.getAttribute('h')!));
        var temp = Teleport(size: telSize, position: position, targetPos: target);
        custMap.allEls[colRow]!.add(temp);
        custMap.add(temp);
    }
  }

  Future compileAll(LoadedColumnRow colRow) async
  {
    if (colRow.column != 0 && colRow.row != 0) {
      return;
    }
    var fileName = 'top_left_bottom-slice.tmx';
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
      print('start compile!');
      await compilerAnimation.compile('high');
      await compilerAnimationBack.compile('down');
    }
    // tiled = await TiledComponent.load(fileName, Vector2.all(320));
    Set<String> loadedFiles = {};
    for(var layer in layersLists){
      if(layer.layer.type == LayerType.objectGroup){
        var objs = tiled.tileMap.getLayer<ObjectGroup>(layer.layer.name);
        if (objs != null && true) {
          for (int cols = 0; cols < GameConsts.maxColumn; cols++) {
            for (int rows = 0; rows < GameConsts.maxRow; rows++) {
              var positionCurs = Vector2(
                  cols * GameConsts.lengthOfTileSquare.x,
                  rows * GameConsts.lengthOfTileSquare.y);
              String newObjs = '';
              Rectangle rec = Rectangle.fromPoints(positionCurs, Vector2(
                  positionCurs.x + GameConsts.lengthOfTileSquare.x,
                  positionCurs.y + GameConsts.lengthOfTileSquare.y));
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
                  for(final props in obj.properties){
                    newObjs += ' ${props.name}="${props.value}"';
                  }
                  newObjs += '/>';
                  newObjs += '\n';
                }
              }
              if (newObjs != '') {
                File file = File('assets/metaData/$cols-$rows.objXml');
                if (!loadedFiles.contains('assets/metaData/$cols-$rows.objXml')) {
                  loadedFiles.add('assets/metaData/$cols-$rows.objXml');
                  file.writeAsStringSync('<p>\n', mode: FileMode.append);
                }
                file.writeAsStringSync(newObjs, mode: FileMode.append);
              }
            }
          }
        }
        print('END OF OBJS COMPILE');
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
            int minCol = GameConsts.maxColumn;
            int minRow = GameConsts.maxRow;
            int maxCol = 0;
            int maxRow = 0;

            for (final point in points) {
              minCol = min(minCol, (point.x) ~/ (GameConsts.lengthOfTileSquare.x));
              minRow = min(minRow, (point.y) ~/ (GameConsts.lengthOfTileSquare.y));
              maxCol = max(maxCol, (point.x) ~/ (GameConsts.lengthOfTileSquare.x));
              maxRow = max(maxRow, (point.y) ~/ (GameConsts.lengthOfTileSquare.y));
            }
            //Короче вначале проверяем две точки - если обе входят - идём дальше, Если только вторая - проверяем пересечение с предыдущей
            //и добавляем вначале пересечение, потом вторую точку
            //Если только первая - ищем пересечение с гранью и начинаем сначала
            bool isReallyLoop = minCol == maxCol && minRow == maxRow && isLoop;
            for (int currColInCycle = minCol; currColInCycle <= maxCol; currColInCycle++) {
              for (int currRowInCycle = minRow; currRowInCycle <= maxRow; currRowInCycle++) {
                Vector2 topLeft = Vector2(currColInCycle * GameConsts.lengthOfTileSquare.x,
                    currRowInCycle * GameConsts.lengthOfTileSquare.y);
                Vector2 topRight = Vector2(
                    (currColInCycle + 1) * GameConsts.lengthOfTileSquare.x,
                    currRowInCycle * GameConsts.lengthOfTileSquare.y);
                Vector2 bottomLeft = Vector2(currColInCycle * GameConsts.lengthOfTileSquare.x,
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

                  int col = points[tF].x ~/ GameConsts.lengthOfTileSquare.x;
                  int row = points[tF].y ~/ GameConsts.lengthOfTileSquare.y;
                  bool isFirst = false;
                  if (col == currColInCycle && row == currRowInCycle) {
                    coord.add(points[tF]);
                    isFirst = true;
                  }
                  col = points[tS].x ~/ GameConsts.lengthOfTileSquare.x;
                  row = points[tS].y ~/ GameConsts.lengthOfTileSquare.y;
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
                        LoadedColumnRow(currColInCycle, currRowInCycle), () => []);
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
                        LoadedColumnRow(currColInCycle, currRowInCycle), () => []);
                    objsMap[LoadedColumnRow(currColInCycle, currRowInCycle)]!
                        .add(newPoints);
                    coord.clear();
                    //Записываем всё что есть
                  }
                  if (!isFirst && !isSecond && tempCoord.length == 2) {
                    if (points[tF].distanceTo(tempCoord.first) >
                        points[tF].distanceTo(tempCoord.last)) {
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
                        LoadedColumnRow(currColInCycle, currRowInCycle), () => []);
                    objsMap[LoadedColumnRow(currColInCycle, currRowInCycle)]!
                        .add(newPoints);
                    coord.clear();
                  }
                }
                if(coord.isNotEmpty){
                  if(coord.length == 1){
                    print('Error in calc $coord');
                  }
                  GroundSource newPoints = GroundSource();
                  newPoints.isLoop = isReallyLoop;
                  newPoints.points = Set.unmodifiable(coord);
                  objsMap.putIfAbsent(
                      LoadedColumnRow(currColInCycle, currRowInCycle), () => []);
                  objsMap[LoadedColumnRow(currColInCycle, currRowInCycle)]!
                      .add(newPoints);
                  coord.clear();
                }
              }
            }
          }
          for(final key in objsMap.keys){
            File file = File('assets/metaData/${key.column}-${key.row}.objXml');
            if(!loadedFiles.contains('assets/metaData/${key.column}-${key.row}.objXml')){
              file.writeAsStringSync('<p>\n', mode: FileMode.append);
              loadedFiles.add('assets/metaData/${key.column}-${key.row}.objXml');
            }
            for(int i=0;i<objsMap[key]!.length;i++){
              if(objsMap[key]![i].points.length <= 1){
                continue;
              }
              file.writeAsStringSync('\n<o lp="${objsMap[key]![i].isLoop ? '1' : '0'}" nm="" p="', mode: FileMode.append);
              for(int j=0;j<objsMap[key]![i].points.length;j++){
                if(j > 0){
                  file.writeAsStringSync(' ', mode: FileMode.append);
                }
                file.writeAsStringSync('${objsMap[key]![i].points.toList()[j].x},${objsMap[key]![i].points.toList()[j].y}', mode: FileMode.append);
              }
              file.writeAsStringSync('"/>', mode: FileMode.append);
            }
          }
        }
      }
    }

    for(final key in loadedFiles){
      File file = File(key);
      file.writeAsStringSync('\n</p>', mode: FileMode.append);
    }
  }
}
