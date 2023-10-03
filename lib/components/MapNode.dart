import 'dart:async';
import 'dart:io';
import 'package:flame/collisions.dart';
import 'package:flame/experimental.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/components/precompile_animation.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/enemies/grass_golem.dart';
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
  MapNode(this.tileMap);
  CustomTileMap tileMap;
  bool isMapCompile = false; //Надо ли компилить просто карту

  Future<void> generateMap(int column, int row) async
  {
    if (column >= GameConsts.maxColumn || row >= GameConsts.maxRow) {
      return;
    }
    if (column < 0 || row < 0) {
      return;
    }
    if (isMapCompile) {
      await compileAll(column,row);
      exit(0);
    }
    Image? _imageDown, _highImg;
    LoadedColumnRow lcr = LoadedColumnRow(column, row);
    if (KyrgyzGame.tiledPngs.containsKey('metaData/$column-${row}_high.png')) {
      _highImg = KyrgyzGame.tiledPngs['metaData/$column-${row}_high.png'];
    }
    if (KyrgyzGame.tiledPngs.containsKey('metaData/$column-${row}_down.png')) {
      _imageDown = KyrgyzGame.tiledPngs['metaData/$column-${row}_down.png'];
    }
    if (_imageDown != null) {
      var spriteDown = SpriteComponent(
        sprite: Sprite(_imageDown),
        position: Vector2(column * GameConsts.lengthOfTileSquare,
            row * GameConsts.lengthOfTileSquare),
        size: Vector2.all(GameConsts.lengthOfTileSquare+1),
        priority: 0,
      );
      tileMap.add(spriteDown);
      tileMap.allEls.putIfAbsent(lcr, () => []);
      tileMap.allEls[lcr]!.add(spriteDown);
    }
    if (KyrgyzGame.anims.containsKey('metaData/$column-${row}_down.anim')) {
      var objects = XmlDocument.parse(KyrgyzGame.anims['metaData/$column-${row}_down.anim']!).findAllElements('an');
      for (final obj in objects) {
        Image srcImage = KyrgyzGame.animsImgs[obj.getAttribute('src')!]!;
        final List<Sprite> spriteList = [];
        final List<double> stepTimes = [];
        for (final anim in obj.findAllElements('fr')) {
          spriteList.add(Sprite(srcImage, srcSize: Vector2.all(32),
              srcPosition: Vector2(
                  double.parse(anim.getAttribute('cl')!) * 32,
                  double.parse(anim.getAttribute('rw')!) * 32)));
          stepTimes.add(double.parse(anim.getAttribute('dr')!));
        }
        var sprAnim = SpriteAnimation.variableSpriteList(
            spriteList, stepTimes: stepTimes);
        for(final anim in obj.findAllElements('ps')){
          var ss = SpriteAnimationComponent(animation: sprAnim,
            position: Vector2(double.parse(anim.getAttribute('x')!),
                double.parse(anim.getAttribute('y')!)),
            size: Vector2.all(33),
              priority: GamePriority.ground + 1);
          tileMap.add(ss);
          tileMap.allEls.putIfAbsent(lcr, () => []);
          tileMap.allEls[lcr]!.add(ss);
        }
      }
    }
    if (KyrgyzGame.anims.containsKey('metaData/$column-${row}_high.anim')) {
      var objects =
      XmlDocument.parse(KyrgyzGame.anims['metaData/$column-${row}_high.anim']!).findAllElements('an');
      for (final obj in objects) {
        Image srcImage = KyrgyzGame.animsImgs[obj.getAttribute('src')!]!;
        final List<Sprite> spriteList = [];
        final List<double> stepTimes = [];
        for (final anim in obj.findAllElements('fr')) {
          spriteList.add(Sprite(srcImage, srcSize: Vector2.all(32),
              srcPosition: Vector2(
                  double.parse(anim.getAttribute('cl')!) * 32,
                  double.parse(anim.getAttribute('rw')!) * 32)));
          stepTimes.add(double.parse(anim.getAttribute('dr')!));
        }
        var sprAnim = SpriteAnimation.variableSpriteList(
            spriteList, stepTimes: stepTimes);
        for(final anim in obj.findAllElements('ps')){
          var ss = SpriteAnimationComponent(animation: sprAnim,
              position: Vector2(double.parse(anim.getAttribute('x')!),
                  double.parse(anim.getAttribute('y')!)),
              priority: GamePriority.high,
              size: Vector2.all(33));
          tileMap.add(ss);
          tileMap.allEls.putIfAbsent(lcr, () => []);
          tileMap.allEls[lcr]!.add(ss);
        }
      }
    }
    if (_highImg != null) {
      var spriteHigh = SpriteComponent(
        sprite: Sprite(_highImg!),
        position: Vector2(column * GameConsts.lengthOfTileSquare,
            row * GameConsts.lengthOfTileSquare),
        priority: GamePriority.high - 1,
        size: Vector2.all(GameConsts.lengthOfTileSquare+1),
      );
      tileMap.add(spriteHigh);
      tileMap.allEls.putIfAbsent(lcr, () => []);
      tileMap.allEls[lcr]!.add(spriteHigh);
    }
    if (KyrgyzGame.objXmls.containsKey('metaData/$column-$row.objXml')) {
      var objects = XmlDocument.parse(KyrgyzGame.objXmls['metaData/$column-$row.objXml']!).findAllElements('obj');
      for (final obj in objects) {
        Vector2 size = Vector2(
            double.parse(obj.getAttribute('w')!),
            double.parse(obj.getAttribute('h')!)
        );
        Vector2 position = Vector2(
            double.parse(obj.getAttribute('x')!),
            double.parse(obj.getAttribute('y')!)
        );
        String? name = obj.getAttribute('nm');
        switch (name) {
          case '':
            bool isNeed = true;
            for(final hit in tileMap.rectHitboxes.keys){
              if(hit.position == position && hit.size == size){
                tileMap.rectHitboxes[hit] = tileMap.rectHitboxes[hit]! + 1;
                isNeed = false;
                tileMap.allRecs.putIfAbsent(lcr, () => []);
                tileMap.allRecs[lcr]!.add(hit);
                break;
              }
            }
            if(isNeed){
              var ground = Ground(size: size, position: position);
              tileMap.add(ground);
              tileMap.rectHitboxes.putIfAbsent(ground, () => 0);
              tileMap.allRecs.putIfAbsent(lcr, () => []);
              tileMap.allRecs[lcr]!.add(ground);
            }
            break;
          default: createLiveObj(position,name,column,row); break;
        }
      }
    }
  }

  Future<void> createLiveObj(Vector2 position,String? name, int column, int row) async
  {
    if (tileMap.loadedLivesObjs.contains(position)) {
      return;
    }
    switch(name){
      case 'enemy':
        tileMap.loadedLivesObjs.add(position);
        tileMap.add(GrassGolem(position, GolemVariant.Water));
        break;
      case 'gold':
        var temp = LootOnMap(itemFromId(2), position: position);
        tileMap.add(temp);
        tileMap.allEls.putIfAbsent(LoadedColumnRow(column, row), () => []);
        tileMap.allEls[LoadedColumnRow(column, row)]!.add(temp);
        break;
      case 'chest':
        var temp = Chest(myItems: [itemFromId(2)], position: position);
        tileMap.add(temp);
        tileMap.allEls.putIfAbsent(LoadedColumnRow(column, row), () => []);
        tileMap.allEls[LoadedColumnRow(column, row)]!.add(temp);
        break;
    }    
  }

  Future<void> compileAll(int column, int row) async
  {
    if(column != 0 && row != 0) {
      return;
    }
    var fileName = 'top_left_bottom.tmx';
    var tiled = await TiledComponent.load(fileName, Vector2.all(320));
    if (true) {
      var layersLists = tiled.tileMap.renderableLayers;
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
    var objs = tiled.tileMap.getLayer<ObjectGroup>("objects");
    if (objs != null) {
      for (int cols = 0; cols < GameConsts.maxColumn; cols++) {
        for (int rows = 0; rows < GameConsts.maxRow; rows++) {
          var positionCurs = Vector2(cols * GameConsts.lengthOfTileSquare,
              rows * GameConsts.lengthOfTileSquare);
          String newObjs = '';
          Rectangle rec = Rectangle.fromPoints(positionCurs, Vector2(
              positionCurs.x + GameConsts.lengthOfTileSquare,
              positionCurs.y + GameConsts.lengthOfTileSquare));
          for (final obj in objs.objects) {
            Rectangle objRect = Rectangle.fromPoints(Vector2(obj.x, obj.y),
                Vector2(obj.x + obj.width, obj.y + obj.height));
            if (isIntersect(rec, objRect)) {
              newObjs +=
              '<obj nm="${obj.name}" cl="${obj.type}" x="${obj
                  .x}" y="${obj.y}" w="${obj.width}" h="${obj
                  .height}"/>';
              newObjs += '\n';
            }
          }
          if (newObjs != '') {
            File file = File('assets/metaData/$cols-$rows.objXml');
            file.writeAsStringSync('<p>\n', mode: FileMode.append);
            file.writeAsStringSync(newObjs, mode: FileMode.append);
            file.writeAsStringSync('\n</p>', mode: FileMode.append);
          }
        }
      }
    }
    print('precompile done');
  }
}