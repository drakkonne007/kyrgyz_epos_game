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



final List<Vector2> _groundPhy = [
  Vector2(-12.4873,3.98651) * PhysicVals.physicScale
  ,Vector2(-12.4316,40.7174) * PhysicVals.physicScale
  ,Vector2(49.214,40.7174) * PhysicVals.physicScale
  ,Vector2(49.2697,4.04225) * PhysicVals.physicScale
  ,];

final List<Vector2> _openedPoints = [
  Vector2(-56.3041,20.4436) * PhysicVals.physicScale
  ,Vector2(3.08585,-6.89468) * PhysicVals.physicScale
  ,Vector2(3.40008,14.4731) * PhysicVals.physicScale
  ,Vector2(-56.6184,42.7541) * PhysicVals.physicScale
  ,];

final List<Vector2> _objPoints = [
  Vector2(-12.5979,34.0205)
  ,Vector2(-12.5979,48.264)
  ,Vector2(49.5118,48.1955)
  ,Vector2(49.4433,32.1716)
  ,];

final Vector2 pointSpawn = Vector2(16.8564,47.6186);

class StoneChest extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  StoneChest(this._id, {this.nedeedKilledBosses, this.neededItems, required this.myItems, this.isOpened
    ,required super.position,
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
  Fixture? openedF;

  @override
  void onRemove()
  {
    gameRef.world.destroyBody(_ground);
  }

  @override
  Future onLoad() async
  {
    if(isOpened == null) {
      var res = await gameRef.dbHandler.getItemStateFromDb(
          _id, gameRef.gameMap.currentGameWorldData!.nameForGame);
      isOpened = res.opened;
    }
    priority = position.y.toInt() + 40;
    FixtureDef fix = FixtureDef(PolygonShape()..set(_groundPhy));
    _ground = Ground(
        BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );
    _ground.createFixture(fix);
    fix = FixtureDef(PolygonShape()..set(_openedPoints));
    openedF = _ground.createFixture(fix);
    _spriteImg = await Flame.images.load(
        'tiles/map/prisonSet/Props/stone chest-openning animation-with dust FX.png');
    _spriteSheet = SpriteSheet(image: _spriteImg,
        srcSize: Vector2(_spriteImg.width.toDouble() / 16, _spriteImg.height.toDouble()));
    if(isOpened!){
      animation = _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 15, loop: false);
      return;
    }
    openedF!.setSensor(true);
    animation = _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 1, loop: false);
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
    openedF!.setSensor(false);
    gameRef.dbHandler.changeItemState(id: _id, worldName: gameRef.gameMap.currentGameWorldData!.nameForGame,opened: true);
    isOpened = true;
    animation = _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    animationTicker?.onComplete = (){
      int rand = Random().nextInt(4);
      if(rand == 0){
        gameRef.gameMap.container.add(Skeleton(position + pointSpawn,id:-1, level: gameRef.gameMap.currentGameWorldData!.level));
      }else {
        for (int i = 0; i<myItems.length;i++) {
          gameRef.gameMap.container.add(LootOnMap(myItems[i], position: position + Vector2(-20,45) + Vector2(i * 15,0)));
        }
      }
    };
  }
}