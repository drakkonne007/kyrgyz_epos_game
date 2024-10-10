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
  HorizontalWoodChest({this.nedeedKilledBosses, this.neededItems, required this.myItems
    , this.isOpened, required super.position, required this.world
    , super.anchor = Anchor.center,required this.dbId});
  bool? isOpened;
  final Set<String>? nedeedKilledBosses;
  final Set<String>? neededItems;
  final String? world;
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
    priority = position.y.toInt() + 23;
    int rand = Random().nextInt(2);
    switch(rand){
      case 0: _spriteImg = await Flame.images.load(
          'tiles/map/prisonSet/Props/wooden chest anim-opening-color scheme1.png'); break;
      case 1: _spriteImg = await Flame.images.load(
          'tiles/map/prisonSet/Props/wooden chest anim-opening-color scheme2.png'); break;
    }
    _spriteSheet = SpriteSheet(image: _spriteImg,
        srcSize: Vector2(_spriteImg.width.toDouble() / 11, _spriteImg.height.toDouble()));
    FixtureDef fix = FixtureDef(PolygonShape()..set(_groundPhy));
    _ground = Ground(
        BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );
    _ground.createFixture(fix);
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

  void checkIsIOpen()async
  {
    if(isOpened!){
      return;
    }
    if(nedeedKilledBosses != null){
      for(final str in nedeedKilledBosses!){
        int cur = int.parse(str);
        var answ = await gameRef.dbHandler.getItemStateFromDb(cur,world ?? gameRef.gameMap.currentGameWorldData!.nameForGame);
        if(!answ.used){
          createText(text: _noNeededKilledBoss,gameRef: gameRef);
          return;
        }
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
      for (int i = 0; i<myItems.length;i++) {
        gameRef.gameMap.container.add(LootOnMap(myItems[i], position: position + Vector2(-20,24) + Vector2(i * 15,0)));
      }
    };
  }
}