import 'dart:async';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/gearSwitch.dart';
import 'package:game_flame/Items/hBridge.dart';
import 'package:game_flame/Items/hWChest.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/Items/mapDialog.dart';
import 'package:game_flame/Items/portal.dart';
import 'package:game_flame/Items/sChest.dart';
import 'package:game_flame/Items/teleport.dart';
import 'package:game_flame/Obstacles/BigWoodLamp.dart';
import 'package:game_flame/Obstacles/altarLightning.dart';
import 'package:game_flame/Obstacles/lightConus.dart';
import 'package:game_flame/Obstacles/horizontalDoor.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/liveObjects/mini_creatures/arrowSpawn.dart';
import 'package:game_flame/liveObjects/mini_creatures/bigFlyingObelisk.dart';
import 'package:game_flame/liveObjects/mini_creatures/bird.dart';
import 'package:game_flame/liveObjects/mini_creatures/campPortal.dart';
import 'package:game_flame/liveObjects/mini_creatures/campfireSmoke.dart';
import 'package:game_flame/liveObjects/mini_creatures/flying_obelisk.dart';
import 'package:game_flame/liveObjects/mini_creatures/frog.dart';
import 'package:game_flame/liveObjects/mini_creatures/groundFire.dart';
import 'package:game_flame/liveObjects/mini_creatures/stand_obelisk.dart';
import 'package:game_flame/liveObjects/mini_creatures/nature_particals.dart';
import 'package:game_flame/liveObjects/mini_creatures/nature_particle_lower.dart';
import 'package:game_flame/liveObjects/mini_creatures/verticalBigRollingWood.dart';
import 'package:game_flame/liveObjects/mini_creatures/windblow.dart';
import 'package:game_flame/liveObjects/moose.dart';
import 'package:game_flame/liveObjects/prisonAssassin.dart';
import 'package:game_flame/liveObjects/skeleton.dart';
import 'package:game_flame/liveObjects/skeletonMage.dart';
import 'package:game_flame/liveObjects/spin_blade.dart';
import 'package:game_flame/liveObjects/strange_merchant.dart';
import 'package:game_flame/liveObjects/mini_creatures/fly.dart';
import 'package:game_flame/liveObjects/grass_golem.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:game_flame/kyrgyz_game.dart';
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
      Image imageHigh = await Flame.images.load(
          'metaData/${myGame.playerData.playerBigMap.nameForGame}/${colRow
              .column}-${colRow
              .row}_high.png'); //KyrgyzGame.cachedImgs['$column-${row}_high.png']!;
      var spriteHigh = SpriteComponent(
        sprite: Sprite(imageHigh),
        position: Vector2(colRow.column * lengthOfTileSquare.x,
            colRow.row * lengthOfTileSquare.y),
        priority: GamePriority.foregroundTile,
        size: lengthOfTileSquare + Vector2.all(1),
      );
      myGame.gameMap.allEls[colRow]!.add(spriteHigh);
      myGame.gameMap.container.add(spriteHigh);
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
          spriteList.add(Sprite(srcImage, srcSize: srcSize - Vector2.all(0.5),
              srcPosition: Vector2(
                  double.parse(anim.getAttribute('cl')!) * srcSize.x + 0.25,
                  double.parse(anim.getAttribute('rw')!) * srcSize.y + 0.25)));
          stepTimes.add(double.parse(anim.getAttribute('dr')!));
        }
        var sprAnim = SpriteAnimation.variableSpriteList(
            spriteList, stepTimes: stepTimes);
        for (final anim in obj.findAllElements('ps')) {
          var ss = SpriteAnimationComponent(animation: sprAnim,
              position: Vector2(double.parse(anim.getAttribute('x')!) - 1,
                  double.parse(anim.getAttribute('y')!) - 1),
              size: Vector2(srcSize.x + 2, srcSize.y + 2),
              priority: GamePriority.foregroundTile
          );
          myGame.gameMap.allEls[colRow]!.add(ss);
          myGame.gameMap.container.add(ss);
        }
      }
    }
    if (KyrgyzGame.cachedMapPngs.contains(
        '${colRow.column}-${colRow.row}_down.png')) {
      Image imageDown = await Flame.images.load(
          'metaData/${myGame.playerData.playerBigMap.nameForGame}/${colRow
              .column}-${colRow
              .row}_down.png'); //KyrgyzGame.cachedImgs['$column-${row}_down.png']!;
      var spriteDown = SpriteComponent(
        sprite: Sprite(imageDown),
        position: Vector2(colRow.column * lengthOfTileSquare.x,
            colRow.row * lengthOfTileSquare.y),
        size: lengthOfTileSquare + Vector2.all(1),
      );
      myGame.gameMap.allEls[colRow]!.add(spriteDown);
      myGame.gameMap.backgroundTile.add(spriteDown);
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
          spriteList.add(Sprite(srcImage, srcSize: sourceSize - Vector2.all(0.5),
              srcPosition: Vector2(
                  double.parse(anim.getAttribute('cl')!) * sourceSize.x + 0.25,
                  double.parse(anim.getAttribute('rw')!) * sourceSize.y + 0.25)));
          stepTimes.add(double.parse(anim.getAttribute('dr')!));
        }
        var sprAnim = SpriteAnimation.variableSpriteList(
            spriteList, stepTimes: stepTimes);
        for (final anim in obj.findAllElements('ps')) {
          var ss = SpriteAnimationComponent(animation: sprAnim,
            position: Vector2(double.parse(anim.getAttribute('x')!) - 1,
                double.parse(anim.getAttribute('y')!) - 1 ),
            size: Vector2(sourceSize.x + 2, sourceSize.y + 2),
          );
          myGame.gameMap.allEls[colRow]!.add(ss);
          myGame.gameMap.backgroundTile.add(ss);
        }
      }
    }
    if (KyrgyzGame.cachedObjects.containsKey(
        '${colRow.column}-${colRow.row}.objXml')) {
      var objects = KyrgyzGame.cachedObjects['${colRow.column}-${colRow
          .row}.objXml']!;
      for (final obj in objects) {
        String? name = obj.getAttribute('nm') ?? '';
        if(name == ''){
          name = obj.getAttribute('cl');
        }
        assert(name != '', 'NAME OBJECT IS EMPTY!!! $colRow, ${myGame.gameMap.currentGameWorldData?.nameForGame}');
        createLiveObj(obj, name, colRow);
        // switch (name) {
        //   case '':
        //     break;
        //   default:
        //     createLiveObj(obj, name, colRow);
        //     break;
        // }
      }
    }
  }

  Future createLiveObj(XmlElement? obj, String? name,
      LoadedColumnRow? colRow, {String? cheatName}) async
  {
    double posX = 0;
    double posY = 0;
    if(cheatName == null){
      posX = double.parse(obj!.getAttribute('x')!);
      posY = double.parse(obj.getAttribute('y')!);
      posX += double.parse(obj.getAttribute('w')!) / 2.0;
      posY -= double.parse(obj.getAttribute('h')!) / 2.0;
    }
    Vector2 position = cheatName == null ? Vector2(posX,posY) : myGame.gameMap.orthoPlayer?.position ?? myGame.gameMap.frontPlayer!.position;
    int id = int.parse(obj?.getAttribute('id') ?? '-1');
    // print(id);
    if (myGame.gameMap.loadedLivesObjs.contains(id) && cheatName == null) {
      return;
    }
    var quest = obj?.getAttribute('quest');
    if(quest != null){
      var dbQuest = myGame.quests[quest]!;
      int startShow = int.parse(obj?.getAttribute('startShow') ?? '0');
      int endShow = int.parse(obj?.getAttribute('endShow') ?? '999999999999');
      if(startShow > dbQuest.currentState || endShow < dbQuest.currentState){
        return;
      }
    }

    if(cheatName != null){
      position -= Vector2(0,200);
    }
    colRow ??= LoadedColumnRow(position.x ~/ myGame.gameMap.currentGameWorldData!.gameConsts.lengthOfTileSquare.x, position.y ~/ myGame.gameMap.currentGameWorldData!.gameConsts.lengthOfTileSquare.y);
    bool isHorReverse = obj?.getAttribute('horizontalReverse') == 'true';
    PositionComponent? positionObject;
    switch (cheatName ?? name) {
      case 'ggolem':
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = GrassGolem(position, GolemVariant.Grass,id);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'sceletM':
        myGame.gameMap.loadedLivesObjs.add(id);
        var isHigh = obj!.getAttribute('high');
        if(isHigh!=null){
          positionObject = SkeletonMage(position,id,isHigh: true);
          myGame.gameMap.container.add(positionObject);
        }else{
          positionObject = SkeletonMage(position,id);
          myGame.gameMap.container.add(positionObject);
        }
        break;
      case 'enemy':
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = GrassGolem(position, GolemVariant.Grass,id);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'wgolem':
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = GrassGolem(position, GolemVariant.Water,id);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'windb':
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = Windblow(position,id);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'moose':
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = Moose(position, MooseVariant.PurpleWithGreenHair,id);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'scelet':
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = Skeleton(position,id);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'gold':
        positionObject = LootOnMap(Gold()..isStaticObject = true, position: position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'fly':
        positionObject = Fly(position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'campS':
        positionObject = CampfireSmoke(position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'groundFire':
        positionObject = GroundFire(position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'auraLightning':
        positionObject = AuraLightning(position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'npart':
        positionObject = NaturePartical(position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'npartL':
        positionObject = NatureParticalLower(position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'strMerchant':
        int? startTrigger;
        int? endTrigger;
        if(quest != null){
          startTrigger = int.parse(obj?.getAttribute('startTrigger') ?? '0');
          endTrigger = int.parse(obj?.getAttribute('endTrigger') ?? '99999999');
        }
        positionObject = StrangeMerchant(position, StrangeMerchantVariant.black, quest: quest,startTrigger: startTrigger,endTrigger: endTrigger);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'gearSwitch':
        int target = int.parse(obj!.getAttribute('tar')!);
        positionObject = GearSwitch(position,target);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
      case 'hBridge':
        positionObject = HorizontalWoodBridge(position,id);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
      case 'chest':
        var neededItems = obj!.getAttribute('neededItems')?.split(',').toSet();
        var neededBoss = obj.getAttribute('neededBoss')?.split(',').toSet();
        positionObject = Chest(1, myItems: [Gold()], position: position,id: id, isStatic: true,neededItems: neededItems,nedeedKilledBosses: neededBoss);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'hWChest':
        var neededItems = obj!.getAttribute('neededItems')?.split(',').toSet();
        var neededBoss = obj.getAttribute('neededBoss')?.split(',').toSet();
        positionObject = HWChest(myItems: [Gold()], position: position,neededItems: neededItems,nedeedKilledBosses: neededBoss);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'sChest':
        var neededItems = obj!.getAttribute('neededItems')?.split(',').toSet();
        var neededBoss = obj.getAttribute('neededBoss')?.split(',').toSet();
        positionObject = StoneChest(myItems: [Gold()], position: position,id,neededItems: neededItems,nedeedKilledBosses: neededBoss);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'bfObelisk':
        positionObject = BigFlyingObelisk(position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'fObelisk':
        positionObject = FlyingObelisk(position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'sObelisk':
        var temp = StandHighObelisk(position);
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.container.add(temp);
        var temp2 = StandDownObelisk(position);
        myGame.gameMap.allEls[colRow]!.add(temp2);
        myGame.gameMap.container.add(temp2);
        break;
      case 'bigWoodLamp1':
      case 'bigWoodLamp2':
      case 'bigWoodLamp3':
      case 'bigWoodLamp4':
      case 'bigWoodLamp5':
        String str = cheatName ?? name!;
        str = str.replaceAll('bigWoodLamp', '');
        int level = int.parse(str);
        positionObject = BigWoodLamp(position,level);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'lightConus':
      case 'lightConusNoGrass':
      case 'lightConusSteel':
      case 'lightConusSteelNoGrass':
        positionObject = LightConus(position,cheatName ?? name!);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'telep':
        var targetPos = obj!.getAttribute('tar')!.split(',');
        Vector2 target = Vector2(
            double.parse(targetPos[0]), double.parse(targetPos[1]));
        Vector2 telSize = Vector2(double.parse(obj.getAttribute('w')!),
            double.parse(obj.getAttribute('h')!));
        var temp = Teleport(kyrGame: myGame,
            size: telSize, position: position, targetPos: target);
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.container.add(temp);
        break;
      case 'assassin':
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = PrisonAssassin(position,id);
        myGame.gameMap.container.add(positionObject);
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
        myGame.gameMap.container.add(temp);
        break;
      case 'spinBlade':
        var targetPos = obj!.getAttribute('tar')?.split(',');
        Vector2? target;
        if (targetPos != null) {
          target = Vector2(double.parse(targetPos[0]), double.parse(targetPos[1]));
        }
        positionObject = SpinBlade(position, target,id);
        myGame.gameMap.loadedLivesObjs.add(id);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'frog':
        positionObject = Frog(position,id);
        myGame.gameMap.loadedLivesObjs.add(id);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'dialog':
        bool isLoop = obj?.getAttribute('lp') == '1';
        String text = obj!.getAttribute('text')!;
        String? vectorSource = obj.getAttribute('p');
        Vector2 size = Vector2(double.parse(obj.getAttribute('w')!), double.parse(obj.getAttribute('h')!));
        MapDialog temp = MapDialog(position,text,size,vectorSource, isLoop);
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.backgroundTile.add(temp);
        break;
      case 'campPort':
        CampPortalDown campPort = CampPortalDown(position);
        myGame.gameMap.allEls[colRow]!.add(campPort);
        myGame.gameMap.container.add(campPort);
        CampPortalUp campPortUp = CampPortalUp(position);
        myGame.gameMap.allEls[colRow]!.add(campPortUp);
        myGame.gameMap.container.add(campPortUp);
        break;
      case 'bird':
        var targetPos = obj!.getAttribute('tar')?.split(';');
        List<Vector2> target = [];
        for(int i=0;i<targetPos!.length;i++){
          var source = targetPos[i].split(',');
          target.add(Vector2(double.parse(source[0]), double.parse(source[1])));
        }
        Bird bird = Bird(position, target,id);
        myGame.gameMap.loadedLivesObjs.add(id);
        myGame.gameMap.container.add(bird);
        break;
      case 'vertBRW':
        String dir = obj!.getAttribute('dir')!;
        var verticalBigRollWood = VerticaBigRollingWood(position, dir, true,id);
        myGame.gameMap.loadedLivesObjs.add(id);
        myGame.gameMap.container.add(verticalBigRollWood);
        break;
      case 'vertRW':
        String dir = obj!.getAttribute('dir')!;
        var verticalBigRollWood = VerticaBigRollingWood(position, dir, false,id);
        myGame.gameMap.loadedLivesObjs.add(id);
        myGame.gameMap.container.add(verticalBigRollWood);
        break;
      case 'hDoor':
        String? bosses = obj!.getAttribute('boss');
        String? items = obj.getAttribute('item');
        var hDoor = WoodenDoor(neededItems: items?.split(',').toSet()
            ,nedeedKilledBosses: bosses?.split(',').toSet(),startPosition: position);
        myGame.gameMap.allEls[colRow]!.add(hDoor);
        myGame.gameMap.container.add(hDoor);
      case 'vDoor':
        String? bosses = obj!.getAttribute('boss');
        String? items = obj.getAttribute('item');
        var hDoor = WoodenDoor(neededItems: items?.split(',').toSet()
            ,nedeedKilledBosses: bosses?.split(',').toSet(),startPosition: position, isVertical: true);
        myGame.gameMap.allEls[colRow]!.add(hDoor);
        myGame.gameMap.container.add(hDoor);
      case 'arrow':
        String targetPos = obj!.getAttribute('dir')!;
        ArrowSpawn spawn = ArrowSpawn(position, targetPos,id);
        myGame.gameMap.loadedLivesObjs.add(id);
        myGame.gameMap.container.add(spawn);
      default: print('wrong item: $name');
    }
    if(isHorReverse){
      positionObject?.flipHorizontally();
    }
  }
}
