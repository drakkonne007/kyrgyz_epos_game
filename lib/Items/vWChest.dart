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
  Vector2(-19.7296,-17.6581) * PhysicVals.physicScale
  ,Vector2(-17.9958,43.0723) * PhysicVals.physicScale
  ,Vector2(11.4409,43.3681) * PhysicVals.physicScale
  ,Vector2(13.0669,-17.7537) * PhysicVals.physicScale
  ,];

final List<Vector2> _objPoints = [
  Vector2(13.0233,-17.9948)
  ,Vector2(31.61,-17.9948)
  ,Vector2(30.7178,43.4157)
  ,Vector2(11.0903,43.4157)
  ,];

class VerticalWoodChest extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  VerticalWoodChest({this.nedeedKilledBosses, this.neededItems, required this.myItems, this.isOpened,
    required super.position,
    super.anchor = Anchor.center
    ,required this.dbId});
  bool? isOpened;
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
    priority = position.y.toInt() + 43;
    int rand = Random().nextInt(2);
    switch(rand){
      case 0: _spriteImg = await Flame.images.load(
          'tiles/map/prisonSet/Props/wooden chest anim - vertical-opening-color scheme1.png'); break;
      case 1: _spriteImg = await Flame.images.load(
          'tiles/map/prisonSet/Props/wooden chest anim - vertical-opening-color scheme2.png'); break;
    }
    FixtureDef fix = FixtureDef(PolygonShape()..set(_groundPhy));
    _ground = Ground(
        BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );
    _ground.createFixture(fix);
    _spriteSheet = SpriteSheet(image: _spriteImg,
        srcSize: Vector2(_spriteImg.width.toDouble() / 11, _spriteImg.height.toDouble()));
    if(isOpened == null) {
      var res = await gameRef.dbHandler.getItemStateFromDb(
          dbId, gameRef.gameMap.currentGameWorldData!.nameForGame);
      isOpened = res.opened;
    }
    if(isOpened!){
      animation = _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 10, loop: false);
      return;
    }
    animation = _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 1, loop: false);
    _objectHitbox = ObjectHitbox(_objPoints,
        collisionType: DCollisionType.active, isSolid: true, isStatic: false, isLoop: true,
        autoTrigger: false, obstacleBehavoiur: checkIsIOpen, game: gameRef);
    // var asd = ObjectHitbox(obstacleBehavoiur: checkIsIOpen);
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
    gameRef.dbHandler.changeItemState(id: dbId, worldName: gameRef.gameMap.currentGameWorldData!.nameForGame,opened: true);
    isOpened = true;
    animation = _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    animationTicker?.onComplete = (){
      for (int i=0;i<myItems.length;i++) {
        if(!isFlippedHorizontally){
          gameRef.gameMap.container.add(LootOnMap(myItems[i], position: position + Vector2(50,0) + Vector2(0,i * 15)));
        }else{
          gameRef.gameMap.container.add(LootOnMap(myItems[i], position: position - Vector2(50,0) + Vector2(0,i * 15)));
        }
      }
    };
  }
}