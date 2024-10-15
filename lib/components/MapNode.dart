import 'dart:async';
import 'dart:math';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/cupOfBloodDungeon.dart';
import 'package:game_flame/Items/cupOfBuff.dart';
import 'package:game_flame/Items/gateBossPrison.dart';
import 'package:game_flame/Items/gearSwitch.dart';
import 'package:game_flame/Items/grass2Chest.dart';
import 'package:game_flame/Items/hBridge.dart';
import 'package:game_flame/Items/hWChest.dart';
import 'package:game_flame/Items/prisonGate.dart';
import 'package:game_flame/Items/shrineExperience.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/liveObjects/lightning.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/Items/mapDialog.dart';
import 'package:game_flame/Items/portal.dart';
import 'package:game_flame/Items/sChest.dart';
import 'package:game_flame/Items/teleport.dart';
import 'package:game_flame/Items/trigger.dart';
import 'package:game_flame/Items/vWChest.dart';
import 'package:game_flame/Items/verticalSteelGate.dart';
import 'package:game_flame/Obstacles/BigWoodLamp.dart';
import 'package:game_flame/Obstacles/altarLightning.dart';
import 'package:game_flame/Obstacles/fireCandelubr.dart';
import 'package:game_flame/Obstacles/lightConus.dart';
import 'package:game_flame/Obstacles/horizontalDoor.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/liveObjects/Citizien.dart';
import 'package:game_flame/liveObjects/goblin.dart';
import 'package:game_flame/liveObjects/humanWarrior.dart';
import 'package:game_flame/liveObjects/mini_creatures/BigFlicker.dart';
import 'package:game_flame/liveObjects/mini_creatures/WoodStairway.dart';
import 'package:game_flame/liveObjects/arrowSpawn.dart';
import 'package:game_flame/liveObjects/mini_creatures/bigFlyingObelisk.dart';
import 'package:game_flame/liveObjects/mini_creatures/bird.dart';
import 'package:game_flame/liveObjects/mini_creatures/campPortal.dart';
import 'package:game_flame/liveObjects/mini_creatures/campfireSmoke.dart';
import 'package:game_flame/liveObjects/mini_creatures/candleFire.dart';
import 'package:game_flame/liveObjects/mini_creatures/crystalEffect.dart';
import 'package:game_flame/liveObjects/mini_creatures/duck.dart';
import 'package:game_flame/liveObjects/mini_creatures/flying_obelisk.dart';
import 'package:game_flame/liveObjects/mini_creatures/frog.dart';
import 'package:game_flame/liveObjects/mini_creatures/groundFire.dart';
import 'package:game_flame/liveObjects/mini_creatures/stand_obelisk.dart';
import 'package:game_flame/liveObjects/mini_creatures/nature_particals.dart';
import 'package:game_flame/liveObjects/mini_creatures/nature_particle_lower.dart';
import 'package:game_flame/liveObjects/mini_creatures/training_doll.dart';
import 'package:game_flame/liveObjects/sceletBoss.dart';
import 'package:game_flame/liveObjects/verticalBigRollingWood.dart';
import 'package:game_flame/liveObjects/mini_creatures/windblow.dart';
import 'package:game_flame/liveObjects/moose.dart';
import 'package:game_flame/liveObjects/ogr.dart';
import 'package:game_flame/liveObjects/orc.dart';
import 'package:game_flame/liveObjects/orcMage.dart';
import 'package:game_flame/liveObjects/pot.dart';
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
  KyrgyzGame myGame;

  Future<void> generateMap(LoadedColumnRow colRow) async
  {
    int maxRow = myGame.gameMap.currentGameWorldData!.gameConsts.maxRow;
    int maxColumn = myGame.gameMap.currentGameWorldData!.gameConsts.maxColumn;
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
        position: Vector2(colRow.column * GameConsts.lengthOfTileSquare.x,
            colRow.row * GameConsts.lengthOfTileSquare.y),
        priority: GamePriority.foregroundTile,
        size: GameConsts.lengthOfTileSquare + Vector2.all(1),
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
        position: Vector2(colRow.column * GameConsts.lengthOfTileSquare.x,
            colRow.row * GameConsts.lengthOfTileSquare.y),
        size: GameConsts.lengthOfTileSquare + Vector2.all(1),
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
          name = obj.getAttribute('cl') ?? '';
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

  Future createLiveObj(XmlElement obj, String name,
      LoadedColumnRow? colRow) async
  {
    double posX = double.parse(obj.getAttribute('x')!);
    double posY = double.parse(obj.getAttribute('y')!);
    int level = myGame.gameMap.currentGameWorldData!.level;
    if(obj.getAttribute('level') != null){
      level = int.parse(obj.getAttribute('level')!);
    }
    level = max(myGame.playerData.playerLevel.value, level);
    Vector2 position = Vector2(posX,posY);
    int id = int.parse(obj.getAttribute('id') ?? '-1');
    if (myGame.gameMap.loadedLivesObjs.contains(id)) {
      return;
    }
    var quest = obj.getAttribute('quest');
    int startShow;
    int endShow;
    if(quest != null){
      var dbQuest = myGame.quests[quest]!;
      print(quest);
      startShow = int.parse(obj.getAttribute('startShow') ?? '0');
      endShow = int.parse(obj.getAttribute('endShow') ?? '999999999999');
      print(dbQuest.currentState);
      print(startShow);
      print(name);
      if(startShow > dbQuest.currentState || endShow <= dbQuest.currentState){
        return;
      }
    }else{
      startShow = 0;
      endShow = 999999999999;
    }
    int? startTrigger;
    int? endTrigger;
    if(quest != null){
      startTrigger = int.parse(obj.getAttribute('startTrigger') ?? '0');
      endTrigger = int.parse(obj.getAttribute('endTrigger') ?? '99999999');
    }
    if(obj.getAttribute('oneUse') != null || name == 'bossScelet' || name == 'pot'
        || name == 'vertBRW' || name == 'vertRW'){
      var dd = await myGame.dbHandler.getItemStateFromDb(id, myGame.gameMap.currentGameWorldData!.nameForGame);
      if(dd.used){
        return;
      }
    }
    if(name == 'ggolem' || name == 'sceletM'
        || name == 'wgolem' || name == 'moose' || name == 'orcMage' || name == 'orc'
        || name == 'ogr'
        || name == 'assassin'){
      var dd = await myGame.dbHandler.getItemStateFromDb(id, myGame.gameMap.currentGameWorldData!.nameForGame);
      int need = Random().nextInt(6);
      if(dd.used && need != 0){
        return;
      }
    }
    colRow ??= LoadedColumnRow(position.x ~/ GameConsts.lengthOfTileSquare.x, position.y ~/ GameConsts.lengthOfTileSquare.y);
    bool isHorReverse = obj.getAttribute('horizontalReverse') == 'true';
    PositionComponent? positionObject;
    switch (name) {
      case 'ggolem':
        var items = obj.getAttribute('items')?.split(',');
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        bool citizen = obj.getAttribute('citizen') == '1';
        positionObject = GrassGolem(position, GolemVariant.Grass,id:id, level: level, loots: list, quest: quest, startTrigger: startTrigger, endTrigger: endTrigger, citizen: citizen);
        myGame.gameMap.loadedLivesObjs.add(id);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'sceletM':
        var items = obj.getAttribute('items')?.split(',');
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        myGame.gameMap.loadedLivesObjs.add(id);
        bool isHigh = obj.getAttribute('high') == '1';
        bool citizen = obj.getAttribute('citizen') == '1';
        positionObject = SkeletonMage(position,id:id,isHigh: isHigh, level: level,loots: list, quest: quest, startTrigger: startTrigger, endTrigger: endTrigger, citizen: citizen);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'enemy':
        bool citizen = obj.getAttribute('citizen') == '1';
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = GrassGolem(position, GolemVariant.Grass,id:id, level: level, quest: quest, startTrigger: startTrigger, endTrigger: endTrigger, citizen: citizen);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'wgolem':
        bool citizen = obj.getAttribute('citizen') == '1';
        var items = obj.getAttribute('items')?.split(',');
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = GrassGolem(position, GolemVariant.Water,id:id, level: level,loots: list, quest: quest, startTrigger: startTrigger, endTrigger: endTrigger, citizen: citizen);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'windb':
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = Windblow(position,id);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'moose':
        bool citizen = obj.getAttribute('citizen') == '1';
        var items = obj.getAttribute('items')?.split(',');
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = Moose(position, id:id, level: level,loots: list, quest: quest, startTrigger: startTrigger, endTrigger: endTrigger, citizen: citizen);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'scelet':
        bool citizen = obj.getAttribute('citizen') == '1';
        var items = obj.getAttribute('items')?.split(',');
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = Skeleton(position,id:id, level: level,loots: list, quest: quest, startTrigger: startTrigger, endTrigger: endTrigger, citizen: citizen);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'orc':
        bool citizen = obj.getAttribute('citizen') == '1';
        var items = obj.getAttribute('items')?.split(',');
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = OrcWarrior(position,id:id, level: level,loots: list, quest: quest, startTrigger: startTrigger, endTrigger: endTrigger, citizen: citizen);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'orcMage':
        bool citizen = obj.getAttribute('citizen') == '1';
        var items = obj.getAttribute('items')?.split(',');
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = OrcMage(position,id:id, level: level,loots: list, quest: quest, startTrigger: startTrigger, endTrigger: endTrigger, citizen: citizen);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'ogr'://'ogr' 'bossScelet' 'pot'
        bool citizen = obj.getAttribute('citizen') == '1';
        var items = obj.getAttribute('items')?.split(',');
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = Ogr(position,id:id, level: level,loots: list, quest: quest, startTrigger: startTrigger, endTrigger: endTrigger, citizen: citizen);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'bossScelet':
        bool citizen = obj.getAttribute('citizen') == '1';
        var items = obj.getAttribute('items')?.split(',');
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = BossScelet(position,id:id, level: level,loots: list, quest: quest, startTrigger: startTrigger, endTrigger: endTrigger, citizen: citizen);
        myGame.gameMap.container.add(positionObject);
      case 'goblin':
        bool citizen = obj.getAttribute('citizen') == '1';
        var items = obj.getAttribute('items')?.split(',');
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = Goblin(position,id:id, level: level,loots: list, quest: quest, startTrigger: startTrigger, endTrigger: endTrigger, citizen: citizen);
        myGame.gameMap.container.add(positionObject);
        break;//Pot
      case 'pot':
        bool citizen = obj.getAttribute('citizen') == '1';
        var items = obj.getAttribute('items')?.split(',');
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = Pot(position,id: id, level: level,loots: list, quest: quest, startTrigger: startTrigger, endTrigger: endTrigger, citizen: citizen);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'trainingDoll':
        positionObject = TrainingDoll(position: position, id: id);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'assassin':
        bool citizen = obj.getAttribute('citizen') == '1';
        var items = obj.getAttribute('items')?.split(',');
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        myGame.gameMap.loadedLivesObjs.add(id);
        positionObject = PrisonAssassin(position,id:id, level: level,loots: list, quest: quest, startTrigger: startTrigger, endTrigger: endTrigger, citizen: citizen);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'gold':
        positionObject = LootOnMap(Gold(myGame.gameMap.currentGameWorldData!.level)..isStaticObject = true, position: position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'item':
        String? name = obj.getAttribute('name');
        name ??= 'gold100';
        positionObject = LootOnMap(itemFromName(name), position: position, id: id);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'fly':
        positionObject = Fly(position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'duck':
        positionObject = Duck(position, id);
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

        positionObject = StrangeMerchant(position, StrangeMerchantVariant.black, quest: quest,startTrigger: startTrigger,endTrigger: endTrigger);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'woodStairway':
        positionObject = WoodStairway(position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'lightning160':
        positionObject = LightningTrap(position: position, srcHeight: 160);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'lightning96':
        positionObject = LightningTrap(position: position, srcHeight: 96);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'lightning46':
        positionObject = LightningTrap(position: position, srcHeight: 46);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'gearSwitch':
        int target = int.parse(obj.getAttribute('tar')!);
        positionObject = GearSwitch(position,target);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'blueBigFlicker':
        positionObject = BigFlicker(position,ColorState.blue,id);
        myGame.gameMap.loadedLivesObjs.add(id);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'whiteBigFlicker':
        positionObject = BigFlicker(position,ColorState.yellow,id);
        myGame.gameMap.loadedLivesObjs.add(id);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'candleFire':
        positionObject = CandleFire(position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'crystalEffect':
        positionObject = CrystalEffect(position: position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'hBridge':
        positionObject = HorizontalWoodBridge(position,id);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'verticalSteelGate':
        positionObject = VerticalSteelGate(position, id);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'prisonGateCircle':
        positionObject = PrisonGate(id, position: position, circle: true);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'gateBossPrison':
        positionObject = GateBossPrison(id, position: position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'prisonGateRect':
        positionObject = PrisonGate(id, position: position, circle: false);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'chest':
        var items = obj.getAttribute('items')?.split(',');
        var neededItems = obj.getAttribute('neededItems')?.split(',').toSet();
        var neededBoss = obj.getAttribute('neededBoss')?.split(',').toSet();
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        positionObject = Chest(1, myItems: list ?? itemsFromLevel(myGame.gameMap.currentGameWorldData!.level), position: position,id: id, isStatic: true,neededItems: neededItems,nedeedKilledBosses: neededBoss);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'hWChest':
        var neededBoss = obj.getAttribute('neededBoss')?.split(',').toSet();
        var items = obj.getAttribute('items')?.split(',');
        var neededItems = obj.getAttribute('neededItems')?.split(',').toSet();
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        String? worldName = obj.getAttribute('world');
        positionObject = HorizontalWoodChest(world: worldName,myItems: list ?? itemsFromLevel(myGame.gameMap.currentGameWorldData!.level), position: position,neededItems: neededItems,nedeedKilledBosses: neededBoss, dbId: id);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'vWChest':
        var items = obj.getAttribute('items')?.split(',');
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        var neededItems = obj.getAttribute('neededItems')?.split(',').toSet();
        var neededBoss = obj.getAttribute('neededBoss')?.split(',').toSet();
        String? worldName = obj.getAttribute('world');
        positionObject = VerticalWoodChest(world: worldName, myItems: list ?? itemsFromLevel(myGame.gameMap.currentGameWorldData!.level), position: position,neededItems: neededItems,nedeedKilledBosses: neededBoss, dbId: id);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'sChest':
        var items = obj.getAttribute('items')?.split(',');
        var neededItems = obj.getAttribute('neededItems')?.split(',').toSet();
        var neededBoss = obj.getAttribute('neededBoss')?.split(',').toSet();
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        String? worldName = obj.getAttribute('world');
        positionObject = StoneChest(world: worldName, id, myItems: list ?? itemsFromLevel(myGame.gameMap.currentGameWorldData!.level), position: position,neededItems: neededItems,nedeedKilledBosses: neededBoss);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;//chestGrass2Horns
      case 'chestGrass2Horns':
        var items = obj.getAttribute('items')?.split(',');
        var neededItems = obj.getAttribute('neededItems')?.split(',').toSet();
        var neededBoss = obj.getAttribute('neededBoss')?.split(',').toSet();
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        String? worldName = obj.getAttribute('world');
        positionObject = ChestGrass2(id,world: worldName, withHorns: true,myItems: list ?? itemsFromLevel(myGame.gameMap.currentGameWorldData!.level), position: position,neededItems: neededItems,nedeedKilledBosses: neededBoss);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'chestGrass2':
        var items = obj.getAttribute('items')?.split(',');
        var neededItems = obj.getAttribute('neededItems')?.split(',').toSet();
        var neededBoss = obj.getAttribute('neededBoss')?.split(',').toSet();
        List<Item>? list;
        if(items != null){
          list = [];
          list = items.map((e) => itemFromName(e)).toList();
        }
        String? worldName = obj.getAttribute('world');
        positionObject = ChestGrass2(id,world:worldName, withHorns: false,myItems: list ?? itemsFromLevel(myGame.gameMap.currentGameWorldData!.level), position: position,neededItems: neededItems,nedeedKilledBosses: neededBoss);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'cupOfSilver':
        positionObject = CupOfBuff(id,blood: false, position: position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'cupOfBlood':
        positionObject = CupOfBuff(id,blood: true, position: position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'cupOfBloodDungeon':
        positionObject = CupOfBloodDungeon(id,position: position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'shrineExperience':
        positionObject = ShrineExperience(id,onGrass: true, position: position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'shrineExperienceNoGrass':
        positionObject = ShrineExperience(id,onGrass: false, position: position);
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
        String str = name;
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
        positionObject = LightConus(position, name);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'fireCandelubr':
        positionObject = FireCandelubr(position);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'telep':
        var targetPos = obj.getAttribute('tar')!.split(',');
        Vector2 target = Vector2(
            double.parse(targetPos[0]), double.parse(targetPos[1]));
        var temp = Teleport(kyrGame: myGame,position: position, targetPos: target);
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.container.add(temp);
        break;
      case 'portal':
        var targetPos = obj.getAttribute('tar')!.split(',');
        var world = obj.getAttribute('wrld')!;
        Vector2 target = Vector2(
            double.parse(targetPos[0]), double.parse(targetPos[1]));
        String? antiDialog = obj.getAttribute('antiDialog');
        String? worldCheck = obj.getAttribute('world');
        var neededItems = obj.getAttribute('neededItems')?.split(',').toSet();
        var neededBoss = obj.getAttribute('neededBoss')?.split(',').toSet();
        var temp = Portal(world: worldCheck, antiDialog: antiDialog, position: position, targetPos: target
            , toWorld: world, neededItems: neededItems, nedeedKilledBosses: neededBoss);
        myGame.gameMap.allEls[colRow]!.add(temp);
        myGame.gameMap.container.add(temp);
        break;
      case 'trigger':
        Vector2 telSize = Vector2(double.parse(obj.getAttribute('w')!),
            double.parse(obj.getAttribute('h')!));
        bool? removeOnTrigger;
        if(obj.getAttribute('removeOnTrigger') != null){
          removeOnTrigger = obj.getAttribute('removeOnTrigger') == '1';
        }
        bool? autoTrigger;
        if(obj.getAttribute('autoTrigger') != null){
          autoTrigger = obj.getAttribute('autoTrigger') == '1';
        }
        String? dialog = obj.getAttribute('dialog');
        int? startTrigger;
        int? endTrigger;
        int? onTrigger;
        if(obj.getAttribute('startTrigger') != null){
          startTrigger = int.parse(obj.getAttribute('startTrigger')!);
        }
        if(obj.getAttribute('endTrigger') != null){
          endTrigger = int.parse(obj.getAttribute('endTrigger')!);
        }
        if(obj.getAttribute('onTrigger') != null){
          onTrigger = int.parse(obj.getAttribute('onTrigger')!);
        }
        var neededItems = obj.getAttribute('neededItems')?.split(',').toSet();
        bool? isEndQuest;
        if(obj.getAttribute('isEndQuest') != null){
          isEndQuest = obj.getAttribute('isEndQuest') == '1';
        }
        var neededBoss = obj.getAttribute('neededBoss')?.split(',').toSet();
        bool ground = obj.getAttribute('ground') == '1';
        String? quest = obj.getAttribute('quest');
        String? dialogNegative = obj.getAttribute('dialogNegative');
        String? worldName = obj.getAttribute('world');
        positionObject = Trigger(size: telSize,position: position,kyrGame: myGame,removeOnTrigger: removeOnTrigger
            ,autoTrigger: autoTrigger,dialog: dialog,startTrigger: startTrigger
            ,endTrigger: endTrigger,onTrigger: onTrigger,quest: quest,isEndQuest: isEndQuest
            , needKilledBosses: neededBoss, needItems: neededItems, ground: ground, world: worldName
            ,dialogNegative: dialogNegative, startShow: startShow, endShow: endShow);
        myGame.gameMap.allEls[colRow]!.add(positionObject);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'spinBlade':
        var targetPos = obj.getAttribute('tar')?.split(',');
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
        bool isLoop = obj.getAttribute('lp') == '1';
        String text = obj.getAttribute('text')!;
        String? vectorSource = obj.getAttribute('p');
        Vector2 size = Vector2(double.parse(obj.getAttribute('w')!), double.parse(obj.getAttribute('h')!));
        bool big = obj.getAttribute('big') == '1';
        MapDialog temp = MapDialog(position,text,size,vectorSource, isLoop, big, id);
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
        var targetPos = obj.getAttribute('tar')?.split(';');
        List<Vector2> target = [];
        for(int i=0;i<targetPos!.length;i++){
          var source = targetPos[i].split(',');
          target.add(Vector2(double.parse(source[0]), double.parse(source[1])));
        }
        positionObject = Bird(position, target,id);
        myGame.gameMap.loadedLivesObjs.add(id);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'human':
        bool citizen = obj.getAttribute('citizen') == '1';
        positionObject = HumanWarrior(position, id:id, level: level, quest: quest, startTrigger: startTrigger, endTrigger: endTrigger, citizen: citizen);
        myGame.gameMap.loadedLivesObjs.add(id);
        myGame.gameMap.container.add(positionObject);
        break;
      case 'vertBRW':
        String dir = obj.getAttribute('dir')!;
        var verticalBigRollWood = VerticaBigRollingWood(position, dir, true,id);
        myGame.gameMap.loadedLivesObjs.add(id);
        myGame.gameMap.container.add(verticalBigRollWood);
        break;
      case 'vertRW':
        String dir = obj.getAttribute('dir')!;
        var verticalBigRollWood = VerticaBigRollingWood(position, dir, false,id);
        myGame.gameMap.loadedLivesObjs.add(id);
        myGame.gameMap.container.add(verticalBigRollWood);
        break;
      case 'hDoor':
        String? bosses = obj.getAttribute('boss');
        String? items = obj.getAttribute('item');
        var hDoor = WoodenDoor(neededItems: items?.split(',').toSet()
            ,nedeedKilledBosses: bosses?.split(',').toSet(),startPosition: position);
        myGame.gameMap.allEls[colRow]!.add(hDoor);
        myGame.gameMap.container.add(hDoor);
      case 'vDoor':
        String? bosses = obj.getAttribute('boss');
        String? items = obj.getAttribute('item');
        var hDoor = WoodenDoor(neededItems: items?.split(',').toSet()
            ,nedeedKilledBosses: bosses?.split(',').toSet(),startPosition: position, isVertical: true);
        myGame.gameMap.allEls[colRow]!.add(hDoor);
        myGame.gameMap.container.add(hDoor);
      case 'arrow':
        String targetPos = obj.getAttribute('dir')!;
        ArrowSpawn spawn = ArrowSpawn(position, targetPos,id);
        myGame.gameMap.loadedLivesObjs.add(id);
        myGame.gameMap.container.add(spawn);
      default: print('wrong item: $name');
    }
    if(isHorReverse){
      positionObject?.flipHorizontally();
    }
    if(positionObject is KyrgyzEnemy){
      myGame.gameMap.allEnemies[id] = positionObject;
    }
  }
}
