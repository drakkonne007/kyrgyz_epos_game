import 'dart:async';
import 'dart:io';
import 'package:flame/collisions.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/Obstacles/flying_obelisk.dart';
import 'package:game_flame/Obstacles/stand_obelisk.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
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

class MapNode extends Component
{
  MapNode(this.column, this.row, this.custMap);
  final int column;
  CustomTileMap custMap;
  final int row;
  int _id = 0;

  int id() => _id++;

  Future<void> generateMap() async
  {
    if (column >= GameConsts.maxColumn || row >= GameConsts.maxRow) {
      return;
    }
    if (column < 0 || row < 0) {
      return;
    }
    if (isMapCompile) {
      await compileAll();
      exit(0);
    }
    LoadedColumnRow lcr = LoadedColumnRow(column, row);
    if (KyrgyzGame.cachedMapPngs.containsKey('$column-${row}_down.png')) {
      Image _imageDown = await Flame.images.load('metaData/$column-${row}_down.png');//KyrgyzGame.cachedImgs['$column-${row}_down.png']!;
      var spriteDown = SpriteComponent(
        sprite: Sprite(_imageDown),
        position: Vector2(column * GameConsts.lengthOfTileSquare.x,
            row * GameConsts.lengthOfTileSquare.y),
        size: GameConsts.lengthOfTileSquare+Vector2.all(1),
        priority: 0,
      );
      add(spriteDown);
    }
    if (KyrgyzGame.cachedAnims.containsKey('$column-${row}_down.anim')) {
      var objects = KyrgyzGame.cachedAnims['$column-${row}_down.anim']!;
      for (final obj in objects) {
        print(obj.getAttribute('src')!);
        Image srcImage = KyrgyzGame.cachedImgs[obj.getAttribute('src')!]!;
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
              size: Vector2.all(34),
              priority: GamePriority.ground + 1);
          add(ss);
        }
      }
    }
    if (KyrgyzGame.cachedMapPngs.containsKey('$column-${row}_high.png')) {
      Image _imageHigh = await Flame.images.load('metaData/$column-${row}_high.png');//KyrgyzGame.cachedImgs['$column-${row}_high.png']!;
      var spriteHigh = SpriteComponent(
        sprite: Sprite(_imageHigh),
        position: Vector2(column * GameConsts.lengthOfTileSquare.x,
            row * GameConsts.lengthOfTileSquare.y),
        priority: GamePriority.high - 1,
        size: GameConsts.lengthOfTileSquare+Vector2.all(1),
      );
      add(spriteHigh);
    }
    if (KyrgyzGame.cachedAnims.containsKey('$column-${row}_high.anim')) {
      var objects = KyrgyzGame.cachedAnims['$column-${row}_high.anim']!;
      for (final obj in objects) {
        Image srcImage = KyrgyzGame.cachedImgs[obj.getAttribute('src')!]!;
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
              size: Vector2.all(34),
              priority: GamePriority.high);
          add(ss);
        }
      }
    }
    if (KyrgyzGame.cachedObjXmls.containsKey('$column-$row.objXml')) {
      var objects = KyrgyzGame.cachedObjXmls['$column-$row.objXml']!;
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
            var ground = Ground([position,position + Vector2(0, size.y),position + size,position + Vector2(size.x, 0)],collisionType: DCollisionType.passive,isSolid: false,isStatic: true,isLoop: true);
            add(ground);
            break;
          default: createLiveObj(position,name); break;
        }
      }
    }
  }

  Future<void> createLiveObj(Vector2 position,String? name) async
  {
    if (custMap.loadedLivesObjs.contains(position)) {
      return;
    }
    switch(name){
      case 'ggolem':
        custMap.loadedLivesObjs.add(position);
        custMap.add(GrassGolem(position, GolemVariant.Grass,priority: GamePriority.player - 2));
        break;
      case 'wgolem':
        custMap.loadedLivesObjs.add(position);
        custMap.add(GrassGolem(position, GolemVariant.Water,priority: GamePriority.player - 2));
        break;
      case 'gold':
        var temp = LootOnMap(itemFromId(2), position: position);
        add(temp);
        break;
      case 'chest':
        var temp = Chest(1, myItems: [itemFromId(2)], position: position);
        add(temp);
        break;
      case 'fObelisk':
        var temp = FlyingHighObelisk(position,column,row,priority: GamePriority.high - 1);
        add(temp);
        var temp2 = FlyingDownObelisk(position,column,row,priority: GamePriority.player - 2);
        add(temp2);
        break;
      case 'sObelisk':
        var temp = StandHighObelisk(position,priority: GamePriority.high - 1);
        add(temp);
        var temp2 = StandDownObelisk(position,priority: GamePriority.player - 2);
        add(temp2);
        break;
    }
  }

  Future<void> compileAll() async
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
          var positionCurs = Vector2(cols * GameConsts.lengthOfTileSquare.x,
              rows * GameConsts.lengthOfTileSquare.y);
          String newObjs = '';
          Rectangle rec = Rectangle.fromPoints(positionCurs, Vector2(
              positionCurs.x + GameConsts.lengthOfTileSquare.x,
              positionCurs.y + GameConsts.lengthOfTileSquare.y));
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