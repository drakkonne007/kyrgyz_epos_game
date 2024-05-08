import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'dart:math' as math;

final List<Vector2> _objPoints = [
  Vector2(45 - 48,85 - 64),
  Vector2(45 - 48,110 - 64),
  Vector2(55 - 48,110 - 64),
  Vector2(55 - 48,85 - 64),
];

final List<Vector2> _objOpenedPoints = [
  Vector2(770 - 48  - 96 * 8,40 - 64),
  Vector2(810 - 48  - 96 * 8,40 - 64),
  Vector2(810 - 48  - 96 * 8,60 - 64),
  Vector2(770 - 48  - 96 * 8,60 - 64),
];

final List<Vector2> _groundPoints = [
  Vector2(20 - 48,101 - 64),
  Vector2(20 - 48,110 - 64),
  Vector2(76 - 48,110 - 64),
  Vector2(76 - 48,101 - 64),
];

final List<Vector2> _openedPoints = [
  Vector2(788 - 48  - 96 * 8,58 - 64),
  Vector2(793 - 48  - 96 * 8,58 - 64),
  Vector2(793 - 48  - 96 * 8,110 - 64),
  Vector2(788 - 48  - 96 * 8,110 - 64),
];

final List<Vector2> _startOpenedPoints = [
  Vector2(788 - 48  - 96 * 8,25 - 64),
  Vector2(793 - 48  - 96 * 8,25 - 64),
  Vector2(793 - 48  - 96 * 8,110 - 64),
  Vector2(788 - 48  - 96 * 8,110 - 64),
];


class WoodenDoor extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  WoodenDoor({this.nedeedKilledBosses, this.neededItems, required this.startPosition, this.isVertical = false});

  bool isVertical;
  Set<String>? nedeedKilledBosses;
  Vector2 startPosition;
  Set<String>? neededItems;
  ObjectHitbox? _objectHitbox;
  Body? ground;
  bool _isOpened = false;
  late SpriteAnimation _animClosed, _animOpening, _animOpened;
  final BodyDef bf = BodyDef(userData: BodyUserData(LoadedColumnRow(0,0), false));

  @override
  Future onLoad() async
  {
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
    anchor = Anchor.center;
    //18,43
    position = startPosition - Vector2(18 - 48,43 - 74);
    _objectHitbox = ObjectHitbox(isVertical ? _objOpenedPoints : _objPoints,
        collisionType: DCollisionType.active, isSolid: true, isStatic: false, isLoop: true,
        autoTrigger: false, obstacleBehavoiur: checkIsIOpen, game: gameRef);
    add(_objectHitbox!);
    Shape sh = PolygonShape()..set(isVertical ? _startOpenedPoints : _groundPoints);
    FixtureDef fx = FixtureDef(sh);
    ground = gameRef.world.createBody(bf)..createFixture(fx);
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
      gameRef.world.destroyBody(ground!);
      Shape sh = PolygonShape()..set(isVertical ? _startOpenedPoints : _openedPoints);
      FixtureDef fx = FixtureDef(sh);
      ground = gameRef.world.createBody(bf)..createFixture(fx);
      // ground?.changeVertices(isVertical ? _startOpenedPoints : _openedPoints,isLoop: true, isSolid: true);
      _objectHitbox?.changeVertices(_objOpenedPoints,isLoop: true, isSolid: true);
    }else{
      animation = _animOpening.reversed();
      gameRef.world.destroyBody(ground!);
      Shape sh = PolygonShape()..set(_groundPoints);
      FixtureDef fx = FixtureDef(sh);
      ground = gameRef.world.createBody(bf)..createFixture(fx);
      // ground?.changeVertices(_groundPoints,isLoop: true, isSolid: true);
      _objectHitbox?.changeVertices(_objPoints,isLoop: true, isSolid: true);
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

  @override
  void update(double dt)
  {
    super.update(dt);
    // ground?.doDebug();
    // if(ground!.getMaxVector().y > gameRef.gameMap.orthoPlayer!.groundBox!.getMaxVector().y){
    //   parent = gameRef.gameMap.enemyOnPlayer;
    // }else{
    //   parent = gameRef.gameMap.enemyComponent;
    // }
  }
}