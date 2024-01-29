import 'dart:async';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/Items/portal.dart';
import 'package:game_flame/Items/teleport.dart';
import 'package:game_flame/enemies/mini_creatures/bigFlyingObelisk.dart';
import 'package:game_flame/enemies/mini_creatures/bird.dart';
import 'package:game_flame/enemies/mini_creatures/campPortal.dart';
import 'package:game_flame/enemies/mini_creatures/campfireSmoke.dart';
import 'package:game_flame/enemies/mini_creatures/flying_obelisk.dart';
import 'package:game_flame/enemies/mini_creatures/frog.dart';
import 'package:game_flame/enemies/mini_creatures/stand_obelisk.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:game_flame/enemies/mini_creatures/fly.dart';
import 'package:game_flame/enemies/mini_creatures/nature_particals.dart';
import 'package:game_flame/enemies/mini_creatures/nature_particle_lower.dart';
import 'package:game_flame/enemies/mini_creatures/verticalBigRollingWood.dart';
import 'package:game_flame/enemies/mini_creatures/verticalSmallRollingWood.dart';
import 'package:game_flame/enemies/mini_creatures/windblow.dart';
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
          myGame.gameMap.priorityHighMinus1.add(ss);
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
            createLiveObj(obj, name, colRow);
            break;
        }
      }
    }
  }

  Future createLiveObj(XmlElement? obj, String? name,
      LoadedColumnRow? colRow, {String? cheatName}) async
  {
    Vector2 position = cheatName == null ? Vector2(
        double.parse(obj!.getAttribute('x')!),
        double.parse(obj.getAttribute('y')!)
    ) : myGame.gameMap.orthoPlayer?.position ?? myGame.gameMap.frontPlayer!.position;
    if (myGame.gameMap.loadedLivesObjs.contains(position) && cheatName == null) {
      return;
    }

    switch (cheatName ?? name) {
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
      case 'windb':
        myGame.gameMap.loadedLivesObjs.add(position);
        myGame.gameMap.priorityHigh.add(Windblow(
            position));
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
      case 'fly':
        var fly = Fly(position);
        myGame.gameMap.allEls[colRow]!.add(fly);
        myGame.gameMap.priorityHigh.add(fly);
        break;
      case 'campS':
        var campS = CampfireSmoke(position);
        myGame.gameMap.allEls[colRow]!.add(campS);
        myGame.gameMap.priorityHigh.add(campS);
        break;
      case 'npart':
        var natParticals = NaturePartical(position);
        myGame.gameMap.allEls[colRow]!.add(natParticals);
        myGame.gameMap.priorityHigh.add(natParticals);
        break;
      case 'npartL':
        var natParticals = NatureParticalLower(position);
        myGame.gameMap.allEls[colRow]!.add(natParticals);
        myGame.gameMap.priorityHigh.add(natParticals);
        break;
      case 'strMerchant':
        var temp = StrangeMerchant(position, StrangeMerchantVariant.black);
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.enemyComponent.add(temp);
        break;
      case 'chest':
        var temp = Chest(1, myItems: [itemFromId(2)], position: position);
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.enemyComponent.add(temp);
        break;
      case 'bfObelisk':
        var temp = BigFlyingObelisk(position);
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.priorityHighMinus1.add(temp);
        break;
      case 'fObelisk':
        var temp = FlyingHighObelisk(position);
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.priorityHighMinus1.add(temp);
        var temp2 = FlyingDownObelisk(position,temp);
        myGame.gameMap.allEls[colRow]!.add(temp2);
        myGame.gameMap.enemyComponent.add(temp2);
        break;
      case 'sObelisk':
        var temp = StandHighObelisk(position);
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.priorityHighMinus1.add(temp);
        var temp2 = StandDownObelisk(position);
        myGame.gameMap.allEls[colRow]!.add(temp2);
        myGame.gameMap.enemyComponent.add(temp2);
        break;
      case 'telep':
        var targetPos = obj!.getAttribute('tar')!.split(',');
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
        var targetPos = obj!.getAttribute('tar')!.split(',');
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
        var targetPos = obj?.getAttribute('tar')?.split(',');
        Vector2? target;
        if (targetPos != null) {
          target = Vector2(double.parse(targetPos[0]), double.parse(targetPos[1]));
        }
        SpinBlade spinBl = SpinBlade(position, target);
        myGame.gameMap.loadedLivesObjs.add(position);
        myGame.gameMap.enemyComponent.add(spinBl);
        break;
      case 'frog':
        Frog frog = Frog(position);
        myGame.gameMap.loadedLivesObjs.add(position);
        myGame.gameMap.enemyComponent.add(frog);
        break;
      case 'campPort':
        CampPortalDown campPort = CampPortalDown(position);
        myGame.gameMap.allEls[colRow]!.add(campPort);
        myGame.gameMap.enemyComponent.add(campPort);
        CampPortalUp campPortUp = CampPortalUp(position);
        myGame.gameMap.allEls[colRow]!.add(campPortUp);
        myGame.gameMap.priorityHighMinus1.add(campPortUp);
        break;
      case 'bird':
        var targetPos = obj?.getAttribute('tar')?.split(';');
        List<Vector2> target = [];
        for(int i=0;i<targetPos!.length;i++){
            var source = targetPos[i].split(',');
            target.add(Vector2(double.parse(source[0]), double.parse(source[1])));
        }
        Bird bird = Bird(position, target);
        myGame.gameMap.loadedLivesObjs.add(position);
        myGame.gameMap.priorityHigh.add(bird);
        break;
      case 'vertBRW':
        String targetPos = obj!.getAttribute('tar')!;
        var verticalBigRollWood = VerticaBigRollingWood(position, double.parse(targetPos));
        myGame.gameMap.loadedLivesObjs.add(position);
        myGame.gameMap.enemyComponent.add(verticalBigRollWood);
        break;
      case 'vertRW':
        String targetPos = obj!.getAttribute('tar')!;
        var verticalBigRollWood = VerticalSmallRollingWood(position, double.parse(targetPos));
        myGame.gameMap.loadedLivesObjs.add(position);
        myGame.gameMap.enemyComponent.add(verticalBigRollWood);
        break;
    }
  }
}
