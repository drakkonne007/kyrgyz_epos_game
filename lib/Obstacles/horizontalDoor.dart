import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'dart:math' as math;

import 'package:game_flame/kyrgyz_game.dart';

final List<Vector2> _vertBorderP = [
  Vector2(-35.2932,-61.8109)* PhysicVals.physicScale
  ,Vector2(-23.4206,-61.8523)* PhysicVals.physicScale
  ,Vector2(-22.7246,47.5488)* PhysicVals.physicScale
  ,Vector2(-35.4647,47.2117)* PhysicVals.physicScale
  ,];

final List<Vector2> _horBorderP = [
  Vector2(-29.5375,46.166)* PhysicVals.physicScale
  ,Vector2(29.5434,46.0179)* PhysicVals.physicScale
  ,Vector2(29.5434,39.947)* PhysicVals.physicScale
  ,Vector2(-29.5375,40.2431)* PhysicVals.physicScale
  ,];

final List<Vector2> _vertObjP = [
  Vector2(-41.7419,-42.0966)
  ,Vector2(-40.8479,36.3534)
  ,Vector2(-11.1218,36.3534)
  ,Vector2(-11.1218,-42.5436)
  ,];

final List<Vector2> _horObjP = [
  Vector2(-14.7303,27.805)
  ,Vector2(-14.8784,55.3465)
  ,Vector2(23.9167,55.6426)
  ,Vector2(23.9167,27.3608)
  ,];


class WoodenDoor extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  WoodenDoor({this.nedeedKilledBosses, this.neededItems, required this.startPosition, this.isVertical = false});

  bool isVertical;
  Set<String>? nedeedKilledBosses;
  Vector2 startPosition;
  Set<String>? neededItems;
  late ObjectHitbox _vertObj;
  late ObjectHitbox _horObj;
  late Ground ground;
  bool _isOpened = false;
  late SpriteAnimation _animClosed, _animOpening, _animOpened;
  final BodyDef bf = BodyDef(userData: BodyUserData(isQuadOptimizaion: false));
  late Fixture vertBorder;
  late Fixture horBorder;

  @override
  void onRemove() {
    gameRef.world.destroyBody(ground);
  }

  @override
  Future onLoad() async
  {
    anchor = Anchor.center;
    String startName = 'tiles/map/prisonSet/Props/Wooden Doors/';
    int rand = math.Random().nextInt(5);
    switch(rand){
      case 0: startName += 'Wooden door1/horizontal-wooden door - opening animation.png'; break;
      case 1: startName += 'Wooden door1/horizontal-wooden door -variation2- opening animation.png'; break;
      case 2: startName += 'Wooden door2/horizontal - wooden door2 - opening animation.png'; break;
      case 3: startName += 'Wooden door2/horizontal - wooden door2 -variation2- opening animation.png'; break;
      case 4: startName += 'Wooden door2/horizontal - wooden door2 -variation3- opening animation.png'; break;
    }
    var spriteImg = await Flame.images.load(startName);
    var sprites = SpriteSheet(image: spriteImg,
        srcSize: Vector2(96,128));
    _animOpening = sprites.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    _animOpened = sprites.createAnimation(row: 0, stepTime: 0.08, from: 8, to: 9, loop: false);
    _animClosed = sprites.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 1, loop: false);
    animation = isVertical ? _animOpened : _animClosed;
    //18,43
    position = startPosition;
    priority = position.y.toInt() + 30;
    _vertObj = ObjectHitbox(_vertObjP,
        collisionType: isVertical ? DCollisionType.active : DCollisionType.passive, isSolid: true, isStatic: false, isLoop: true,
        autoTrigger: false, obstacleBehavoiur: checkIsIOpen, game: gameRef);
    _horObj = ObjectHitbox(_horObjP,
        collisionType: isVertical ? DCollisionType.passive : DCollisionType.active, isSolid: true, isStatic: false, isLoop: true,
        autoTrigger: false, obstacleBehavoiur: checkIsIOpen, game: gameRef);
    add(_vertObj);
    add(_horObj);

    var fx = FixtureDef(PolygonShape()..set(_vertBorderP));
    var fx2= FixtureDef(PolygonShape()..set(_horBorderP));
    ground = Ground(
      BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
          userData: BodyUserData(isQuadOptimizaion: false)),
      gameRef.world.physicsWorld,

    );
    horBorder = ground.createFixture(fx2);
    vertBorder = ground.createFixture(fx);
    if(isVertical){
      horBorder.setSensor(true);
    }else{
      vertBorder.setSensor(true);
    }
    _isOpened = isVertical;
  }

  void checkIsIOpen()
  {
    if(animation != _animClosed && animation != _animOpened){
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
    if(!_isOpened){
      animation = _animOpening;
      vertBorder.setSensor(false);
      horBorder.setSensor(true);
      _vertObj.collisionType = DCollisionType.active;
      _horObj.collisionType = DCollisionType.inactive;
    }else{
      animation = _animOpening.reversed();
      vertBorder.setSensor(true);
      horBorder.setSensor(false);
      _vertObj.collisionType = DCollisionType.inactive;
      _horObj.collisionType = DCollisionType.active;
    }
    animationTicker?.onComplete = changeHitboxes;
  }

  void changeHitboxes()
  {
    if(_isOpened){
      _isOpened = false;
      animation = _animClosed;
    }else{
      _isOpened = true;
      animation = _animOpened;
    }
  }

}