import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/RenderText.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/liveObjects/skeleton.dart';
import 'package:game_flame/kyrgyz_game.dart';

const double myScale = 0.7;

final List<Vector2> _groundPhyWithHorns = [
  Vector2(-37.252,-29.5332) * PhysicVals.physicScale * myScale
  ,Vector2(-48.83,-18.8128) * PhysicVals.physicScale * myScale
  ,Vector2(-50.3309,-7.44913) * PhysicVals.physicScale * myScale
  ,Vector2(-37.6808,0.484002) * PhysicVals.physicScale * myScale
  ,Vector2(-26.1027,27.2851) * PhysicVals.physicScale * myScale
  ,Vector2(25.7843,28.1427) * PhysicVals.physicScale * myScale
  ,Vector2(33.2886,1.12723) * PhysicVals.physicScale * myScale
  ,Vector2(50.6557,-8.09235) * PhysicVals.physicScale * myScale
  ,Vector2(49.5836,-17.7408) * PhysicVals.physicScale * myScale
  ,Vector2(36.7191,-29.9621) * PhysicVals.physicScale * myScale
  ,Vector2(28.3572,-22.8866) * PhysicVals.physicScale * myScale
  ,Vector2(-28.2468,-22.6722) * PhysicVals.physicScale * myScale
  ,];

final List<Vector2> _groundPhyNoHorns = [
  Vector2(-28.9005,-22.7831) * myScale * PhysicVals.physicScale
  ,Vector2(-25.8418,27.4937) * myScale * PhysicVals.physicScale
  ,Vector2(25.3909,26.9202) * myScale * PhysicVals.physicScale
  ,Vector2(29.0231,-22.592) * myScale * PhysicVals.physicScale
  ,];

final List<Vector2> _objPoints = [
  Vector2(-56.9092,-40.1559) * myScale
  ,Vector2(-57.5661,50.837) * myScale
  ,Vector2(57.7354,51.1655) * myScale
  ,Vector2(56.4215,-42.7839) * myScale
  ,];


class ChestGrass2 extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  ChestGrass2(this._id, {this.nedeedKilledBosses, this.neededItems, required this.myItems, this.isOpened
    ,required super.position,
    required this.withHorns,
    super.anchor = Anchor.center});
  bool? isOpened;
  Set<String>? nedeedKilledBosses;
  Set<String>? neededItems;
  List<Item> myItems;
  late Image _spriteImg;
  late SpriteSheet _spriteSheet;
  ObjectHitbox? _objectHitbox;
  late Ground _ground;
  int _id;
  final String _noNeededItem = 'Нет нужного предмета...';
  final String _noNeededKilledBoss = 'Сначала победите хозяина';
  bool withHorns;

  @override
  void onRemove()
  {
    gameRef.world.destroyBody(_ground);
  }

  @override
  Future onLoad() async
  {
    if(isOpened == null){
      var res = await gameRef.dbHandler.getItemStateFromDb(_id, gameRef.gameMap.currentGameWorldData!.nameForGame);
      isOpened = res.opened;
    }
    priority = position.y.toInt() + (27 * myScale).toInt();
    FixtureDef fix = FixtureDef(PolygonShape()..set(withHorns ? _groundPhyWithHorns : _groundPhyNoHorns));
    _ground = Ground(
        BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );
    _ground.createFixture(fix);
    _spriteImg = await Flame.images.load(withHorns ?
        'tiles/map/grassLand2/Props/Animated props/chests-opening.png' : 'tiles/map/grassLand2/Props/Animated props/chests-opening-no horns.png');
    _spriteSheet = SpriteSheet(image: _spriteImg,
        srcSize: Vector2(_spriteImg.width.toDouble() / 8, _spriteImg.height.toDouble()));
    if(isOpened!){
      animation = _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 7, loop: false);
      size *= myScale;
      return;
    }
    animation = _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 1, loop: false);
    size *= myScale;
    _objectHitbox = ObjectHitbox(_objPoints,
        collisionType: DCollisionType.active, isSolid: true, isStatic: false, isLoop: true,
        autoTrigger: false, obstacleBehavoiur: checkIsIOpen, game: gameRef);
    add(_objectHitbox!);
  }

  void checkIsIOpen()
  {
    if(isOpened!){
      return;
    }
    if(nedeedKilledBosses != null){
      if(!gameRef.playerData.killedBosses.containsAll(nedeedKilledBosses!)){
        createText(text: _noNeededKilledBoss,gameRef: gameRef);
        return;
      }
    }
    if(neededItems != null){
      var setItems = gameRef.playerData.itemInventar.keys.toSet();
      if(!setItems.containsAll(neededItems!)){
        createText(text: _noNeededItem,gameRef: gameRef);
        return;
      }
      for(final myNeeded in neededItems!) {
        Item temp = itemFromName(myNeeded);
        temp.getEffectFromInventar(gameRef);
      }
    }
    _objectHitbox?.removeFromParent();
    isOpened = true;
    animation = _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    animationTicker?.onComplete = (){
      for (int i = 0; i<myItems.length;i++) {
        gameRef.gameMap.container.add(LootOnMap(myItems[i], position: position + Vector2(-20,45) + Vector2(i * 15,0)));
      }
      gameRef.dbHandler.changeItemState(id: _id, worldName: gameRef.gameMap.currentGameWorldData!.nameForGame,opened: true);
    };
  }
}