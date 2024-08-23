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
import 'package:game_flame/kyrgyz_game.dart';

final List<Vector2> _groundPhy = [
  Vector2(-28.0021,-10.7072) * PhysicVals.physicScale
  ,Vector2(-27.9162,9.88758) * PhysicVals.physicScale
  ,Vector2(-25.6422,23.5745) * PhysicVals.physicScale
  ,Vector2(24.5146,23.5316) * PhysicVals.physicScale
  ,Vector2(26.617,9.54434) * PhysicVals.physicScale
  ,Vector2(26.7457,-10.6214) * PhysicVals.physicScale
  ,];

final List<Vector2> _objPoints = [
  Vector2(-26.1244,18.8973)
  ,Vector2(-26.0415,32.4314)
  ,Vector2(25.3731,32.4085)
  ,Vector2(25.3262,18.4032)
  ,];

class HorizontalWoodChest extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  HorizontalWoodChest({this.nedeedKilledBosses, this.neededItems, required this.myItems, this.isOpened = false,
    required super.position,
    super.anchor = Anchor.center,
    super.priority
  ,required this.dbId});
  bool isOpened;
  Set<String>? nedeedKilledBosses;
  Set<String>? neededItems;
  List<Item> myItems;
  late Image _spriteImg;
  late SpriteSheet _spriteSheet;
  ObjectHitbox? _objectHitbox;
  late Ground _ground;
  int dbId;
  final String _noNeededItem = 'Нет нужного предмета...';
  final String _noNeededKilledBoss = 'Сначала победите хозяина';

  @override
  void onRemove()
  {
    gameRef.world.destroyBody(_ground);
  }

  @override
  Future onLoad() async
  {
    priority = position.y.toInt();
    int rand = Random().nextInt(2);
    switch(rand){
      case 0: _spriteImg = await Flame.images.load(
          'tiles/map/prisonSet/Props/wooden chest anim-opening-color scheme1.png'); break;
      case 1: _spriteImg = await Flame.images.load(
          'tiles/map/prisonSet/Props/wooden chest anim-opening-color scheme2.png'); break;
    }

    _spriteSheet = SpriteSheet(image: _spriteImg,
        srcSize: Vector2(_spriteImg.width.toDouble() / 11, _spriteImg.height.toDouble()));
    var res = await gameRef.dbHandler.getItemStateFromDb(dbId, gameRef.gameMap.currentGameWorldData!.nameForGame);
    isOpened = res.opened;
    animation = isOpened ? _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 10, loop: false) : _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 1, loop: false);
    if(!isOpened) {
      _objectHitbox = ObjectHitbox(_objPoints,
          collisionType: DCollisionType.active, isSolid: true, isStatic: false, isLoop: true,
          autoTrigger: false, obstacleBehavoiur: checkIsIOpen, game: gameRef);
      // var asd = ObjectHitbox(obstacleBehavoiur: checkIsIOpen);
      add(_objectHitbox!);
    }
    FixtureDef fix = FixtureDef(PolygonShape()..set(_groundPhy));
    _ground = Ground(
      BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
          userData: BodyUserData(isQuadOptimizaion: false)),
      gameRef.world.physicsWorld
    );
    _ground.createFixture(fix);
  }

  void checkIsIOpen()
  {
    if(isOpened){
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
    TimerComponent timer = TimerComponent(period: animationTicker!.totalDuration(),
    removeOnFinish: true,
      onTick: (){
        for (final myItem in myItems) {
          gameRef.gameMap.container.add(LootOnMap(myItem, position: gameRef.playerPosition()));
        }
      }
    );
    gameRef.gameMap.add(timer);
    gameRef.dbHandler.changeItemState(id: dbId, worldName: gameRef.gameMap.currentGameWorldData!.nameForGame,openedAsString: '1');
  }
}