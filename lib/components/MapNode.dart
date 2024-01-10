import 'dart:async';
import 'dart:math';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/Items/portal.dart';
import 'package:game_flame/Items/teleport.dart';
import 'package:game_flame/Obstacles/flying_obelisk.dart';
import 'package:game_flame/Obstacles/stand_obelisk.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:game_flame/enemies/moose.dart';
import 'package:game_flame/enemies/spin_blade.dart';
import 'package:game_flame/enemies/strange_merchant.dart';
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

class MapNode {
  MapNode(this.myGame);

  int _id = 0;
  KyrgyzGame myGame;

  int id() => _id++;

  Future<void> generateMap(LoadedColumnRow colRow) async
  {
    int maxRow = myGame.gameMap.currentGameWorldData!.gameConsts.maxRow!;
    int maxColumn = myGame.gameMap.currentGameWorldData!.gameConsts.maxColumn!;
    Vector2 lengthOfTileSquare = myGame.gameMap.currentGameWorldData!.gameConsts
        .lengthOfTileSquare;
    if (colRow.column >= maxColumn || colRow.row >= maxRow) {
      return;
    }
    if (colRow.column < 0 || colRow.row < 0) {
      return;
    }
    myGame.gameMap.allEls.putIfAbsent(colRow, () => []);
    if (KyrgyzGame.cachedObjXmls.containsKey(
        '${colRow.column}-${colRow.row}.objXml')) {
      var objects = KyrgyzGame.cachedObjXmls['${colRow.column}-${colRow
          .row}.objXml']!;
      for (final obj in objects) {
        String? name = obj.getAttribute('nm');
        switch (name) {
          case '':
            break;
          default:
            _createLiveObj(obj, name, colRow);
            break;
        }
      }
    }
    if (KyrgyzGame.cachedAnims.containsKey(
        '${colRow.column}-${colRow.row}_high.anim')) {
      var objects = KyrgyzGame.cachedAnims['${colRow.column}-${colRow
          .row}_high.anim']!;
      for (final obj in objects) {
        Vector2 srcSize = Vector2(double.parse(obj.getAttribute('w')!),
            double.parse(obj.getAttribute('h')!));
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
              size: Vector2(srcSize.x + 1, srcSize.y + 1),
              // priority: GamePriority.high
          );
          myGame.gameMap.allEls[colRow]!.add(ss);
          myGame.gameMap.priorityHigh.add(ss);
        }
      }
    }
    if (KyrgyzGame.cachedMapPngs.contains(
        '${colRow.column}-${colRow.row}_high.png')) {
      Image _imageHigh = await Flame.images.load(
          'metaData/${myGame.playerData.playerBigMap.nameForGame}/${colRow
              .column}-${colRow
              .row}_high.png'); //KyrgyzGame.cachedImgs['$column-${row}_high.png']!;
      var spriteHigh = SpriteComponent(
        sprite: Sprite(_imageHigh),
        position: Vector2(colRow.column * lengthOfTileSquare.x,
            colRow.row * lengthOfTileSquare.y),
        // priority: GamePriority.high - 1,
        size: lengthOfTileSquare + Vector2.all(1),
      );
      myGame.gameMap.allEls[colRow]!.add(spriteHigh);
      myGame.gameMap.priorityHighMinus1.add(spriteHigh);
    }
    if (KyrgyzGame.cachedAnims.containsKey(
        '${colRow.column}-${colRow.row}_down.anim')) {
      var objects = KyrgyzGame.cachedAnims['${colRow.column}-${colRow
          .row}_down.anim']!;
      for (final obj in objects) {
        Vector2 sourceSize = Vector2(double.parse(obj.getAttribute('w')!),
            double.parse(obj.getAttribute('h')!));
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
              size: Vector2(sourceSize.x + 1, sourceSize.y + 1),
              // priority: GamePriority.ground + 1
          );
          myGame.gameMap.allEls[colRow]!.add(ss);
          myGame.gameMap.priorityGroundPlus1.add(ss);
        }
      }
    }
    if (KyrgyzGame.cachedMapPngs.contains(
        '${colRow.column}-${colRow.row}_down.png')) {
      Image _imageDown = await Flame.images.load(
          'metaData/${myGame.playerData.playerBigMap.nameForGame}/${colRow
              .column}-${colRow
              .row}_down.png'); //KyrgyzGame.cachedImgs['$column-${row}_down.png']!;
      var spriteDown = SpriteComponent(
        sprite: Sprite(_imageDown),
        position: Vector2(colRow.column * lengthOfTileSquare.x,
            colRow.row * lengthOfTileSquare.y),
        size: lengthOfTileSquare + Vector2.all(1),
        // priority: 0,
      );
      myGame.gameMap.allEls[colRow]!.add(spriteDown);
      myGame.gameMap.add(spriteDown);
    }
  }

  void createCheatElement(String name) {
    Vector2 lengthOfTileSquare = myGame.playerData.playerBigMap.gameConsts
        .lengthOfTileSquare;
    Vector2 position = Vector2(myGame.gameMap.orthoPlayer!.position.x,
        myGame.gameMap.orthoPlayer!.position.y);
    int col = position.x ~/ (lengthOfTileSquare.x);
    int row = position.y ~/ (lengthOfTileSquare.y);
    LoadedColumnRow colRow = LoadedColumnRow(col, row);
    switch (name) {
      case 'ggolem':
        myGame.gameMap.loadedLivesObjs.add(position);
        myGame.gameMap.enemyComponent.add(GrassGolem(
            position, GolemVariant.Grass,
            // priority: GamePriority.player - 2
        ));
        break;
      case 'wgolem':
        myGame.gameMap.loadedLivesObjs.add(position);
        myGame.gameMap.enemyComponent.add(GrassGolem(
            position, GolemVariant.Water,
            // priority: GamePriority.player - 2
        ));
        break;
      case 'gold':
        var temp = LootOnMap(itemFromId(2), position: position);
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.add(temp);
        break;
      case 'moose':
        myGame.gameMap.loadedLivesObjs.add(position);
        myGame.gameMap.enemyComponent.add(GrassGolem(
            position, GolemVariant.Water,
            // priority: GamePriority.player - 2
        ));
        break;
      case 'chest':
        int level = Random().nextInt(3);
        var temp = Chest(level, myItems: [itemFromId(2)], position: position);
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.add(temp);
        break;
      case 'fObelisk':
        var temp = FlyingHighObelisk(
            position, colRow.column, colRow.row,
            // priority: GamePriority.high - 1
        );
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.priorityHighMinus1.add(temp);
        var temp2 = FlyingDownObelisk(
            position, colRow.column, colRow.row,
            // priority: GamePriority.player - 2
        );
        myGame.gameMap.allEls[colRow]!.add(temp2);
        myGame.gameMap.enemyComponent.add(temp2);
        break;
      case 'sObelisk':
        var temp = StandHighObelisk(position,
            // priority: GamePriority.high - 1
        );
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.priorityHighMinus1.add(temp);
        var temp2 = StandDownObelisk(
            position,
            // priority: GamePriority.player - 2
        );
        myGame.gameMap.allEls[colRow]!.add(temp2);
        myGame.gameMap.enemyComponent.add(temp2);
        break;
    }
  }


  Future _createLiveObj(XmlElement obj, String? name,
      LoadedColumnRow colRow) async
  {
    Vector2 position = Vector2(
        double.parse(obj.getAttribute('x')!),
        double.parse(obj.getAttribute('y')!)
    );
    if (myGame.gameMap.loadedLivesObjs.contains(position)) {
      return;
    }
    switch (name) {
      case 'ggolem':
        myGame.gameMap.loadedLivesObjs.add(position);
        myGame.gameMap.enemyComponent.add(GrassGolem(
            position, GolemVariant.Grass,
            // priority: GamePriority.player - 2
        ));
        break;
      case 'enemy':
        myGame.gameMap.loadedLivesObjs.add(position);
        myGame.gameMap.enemyComponent.add(GrassGolem(
            position, GolemVariant.Grass,
            // priority: GamePriority.player - 2
        ));
        break;
      case 'wgolem':
        myGame.gameMap.loadedLivesObjs.add(position);
        myGame.gameMap.enemyComponent.add(GrassGolem(
            position, GolemVariant.Water,
            // priority: GamePriority.player - 2
        ));
        break;
      case 'moose':
        myGame.gameMap.loadedLivesObjs.add(position);
        myGame.gameMap.enemyComponent.add(Moose(
            position, MooseVariant.Blue,
            // priority: GamePriority.player - 2
        ));
        break;
      case 'gold':
        var temp = LootOnMap(itemFromId(2), position: position);
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.enemyComponent.add(temp);
        break;
      case 'strange_merchant':
        var temp = StrangeMerchant(position, StrangeMerchantVariant.black,
            // priority: GamePriority.player - 2
        );
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.enemyComponent.add(temp);
        break;
      case 'chest':
        var temp = Chest(1, myItems: [itemFromId(2)], position: position);
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.enemyComponent.add(temp);
        break;
      case 'fObelisk':
        var temp = FlyingHighObelisk(
            position, colRow.column, colRow.row,
            // priority: GamePriority.high - 1
        );
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.priorityHighMinus1.add(temp);
        var temp2 = FlyingDownObelisk(
            position, colRow.column, colRow.row,
            // priority: GamePriority.player - 2
        );
        myGame.gameMap.allEls[colRow]!.add(temp2);
        myGame.gameMap.enemyComponent.add(temp2);
        break;
      case 'sObelisk':
        var temp = StandHighObelisk(position,
            // priority: GamePriority.high - 1
        );
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.priorityHighMinus1.add(temp);
        var temp2 = StandDownObelisk(
            position,
            // priority: GamePriority.player - 2
        );
        myGame.gameMap.allEls[colRow]!.add(temp2);
        myGame.gameMap.enemyComponent.add(temp2);
        break;
      case 'telep':
        var targetPos = obj.getAttribute('tar')!.split(',');
        Vector2 target = Vector2(
            double.parse(targetPos[0]), double.parse(targetPos[1]));
        Vector2 telSize = Vector2(double.parse(obj.getAttribute('w')!),
            double.parse(obj.getAttribute('h')!));
        var temp = Teleport(
            size: telSize, position: position, targetPos: target);
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.add(temp);
        break;
      case 'portal':
        var targetPos = obj.getAttribute('tar')!.split(',');
        var world = obj.getAttribute('wrld')!;
        Vector2 target = Vector2(
            double.parse(targetPos[0]), double.parse(targetPos[1]));
        Vector2 telSize = Vector2(double.parse(obj.getAttribute('w')!),
            double.parse(obj.getAttribute('h')!));
        var temp = Portal(size: telSize,
            position: position,
            targetPos: target,
            toWorld: world);
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.add(temp);
        break;
      case 'spinBlade':
        var targetPos = obj.getAttribute('tar')?.split(',');
        Vector2? target;
        if (targetPos == null) {

        }else {
          target = Vector2(
              double.parse(targetPos[0]), double.parse(targetPos[1]));
        }
        SpinBlade spinBl = SpinBlade(position, target);
        myGame.gameMap.loadedLivesObjs.add(position);
        myGame.gameMap.enemyComponent.add(spinBl);
        break;
    }
  }
}
