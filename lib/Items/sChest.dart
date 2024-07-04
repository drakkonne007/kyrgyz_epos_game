import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/enemies/skeleton.dart';
import 'package:game_flame/kyrgyz_game.dart';



final List<Vector2> _groundPhy = [
  Vector2(-12.4873,3.98651) * PhysicVals.physicScale
  ,Vector2(-12.4316,40.7174) * PhysicVals.physicScale
  ,Vector2(49.214,40.7174) * PhysicVals.physicScale
  ,Vector2(49.2697,4.04225) * PhysicVals.physicScale
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
  StoneChest(this._id, {this.nedeedKilledBosses, this.neededItems, required this.myItems, this.isOpened = false
    ,Sprite? sprite,
    bool? autoResize,
    required super.position,
    Vector2? size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor = Anchor.center,
    super.priority});
  bool isOpened;
  Set<int>? nedeedKilledBosses;
  Set<String>? neededItems;
  List<Item> myItems;
  late Image _spriteImg;
  late SpriteSheet _spriteSheet;
  ObjectHitbox? _objectHitbox;
  late Ground _ground;
  int _id;

  @override
  void onRemove()
  {
    gameRef.world.destroyBody(_ground);
  }

  @override
  Future onLoad() async
  {
    priority = position.y.toInt();
     _spriteImg = await Flame.images.load(
          'tiles/map/prisonSet/Props/stone chest-openning animation-with dust FX.png');
    _spriteSheet = SpriteSheet(image: _spriteImg,
        srcSize: Vector2(_spriteImg.width.toDouble() / 16, _spriteImg.height.toDouble()));
    animation = isOpened ? _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 15, loop: false) : _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 1, loop: false);

    // var asd = ObjectHitbox(obstacleBehavoiur: checkIsIOpen);
    if(!isOpened) {
      _objectHitbox = ObjectHitbox(_objPoints,
          collisionType: DCollisionType.active, isSolid: true, isStatic: false, isLoop: true,
          autoTrigger: false, obstacleBehavoiur: checkIsIOpen, game: gameRef);
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
        print('not kill needed boss');
        return;
      }
    }
    if(neededItems != null){
      for(final myNeeded in neededItems!) {
        bool isNeed = true;
        for(final playerHas in gameRef.playerData.itemInventar.keys){
          if(playerHas == myNeeded){
            isNeed = false;
            break;
          }
        }
        if(isNeed){
          print('not has nedeed item');
          return;
        }
      }
    }
    _objectHitbox?.removeFromParent();
    isOpened = true;
    animation = _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    TimerComponent timer = TimerComponent(period: animationTicker!.totalDuration(),
    removeOnFinish: true,
      onTick: (){
        int rand = Random().nextInt(4);
        if(rand == 0){
          gameRef.gameMap.container.add(Skeleton(position + pointSpawn,-1));
        }else {
          for (final myItem in myItems) {
            gameRef.gameMap.container.add(LootOnMap(myItem, position: gameRef.gameMap.orthoPlayer?.position ?? gameRef.gameMap.frontPlayer!.position));
          }
        }
      }
    );
    gameRef.gameMap.add(timer);
  }
}