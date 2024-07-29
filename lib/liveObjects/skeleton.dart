import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'dart:math' as math;

class Skeleton extends KyrgyzEnemy
{
  Skeleton(this._startPos,int id){this.id = id;}
  late SpriteAnimation _animMoveShield, _animIdleShield, _animAttackShield, _animAttack2Shield,_animHurtShield,_animBlock, _animThrowShield, _animDeathShield;
  final Vector2 _spriteSheetSize = Vector2(220,220);
  final Vector2 _startPos;
  late DefaultEnemyWeapon _defWeapon;
  int _variantOfHit = 0;
  bool _withShieldNow = false;

  final List<Vector2> hitBoxPoints = [
    Vector2(115-115,100-110),
    Vector2(109-115,104-110),
    Vector2(110-115,112-110),
    Vector2(103-115,116-110),
    Vector2(101-115,148-110),
    Vector2(122-115,148-110),
    Vector2(124-115,106-110)
  ];

  final List<Vector2> _attack1PointsOnStart = [
    Vector2(501 - 555,573 - 550),
    Vector2(532 - 555,581 - 550),
    Vector2(771 - 775,551 - 550),
    Vector2(748 - 775,527 - 550),
  ];

  final List<Vector2> _attack1PointsOnEnd = [
    Vector2(995  - 995,531 - 550),
    Vector2(1032 - 995,581 - 550),
    Vector2(1059 - 995,585 - 550),
    Vector2(1053 - 995,561 - 550),
    Vector2(1033 - 995,541 - 550),
  ];

  final List<Vector2> _attack2PointsOnStart = [
    Vector2(500 - 555,794 - 770),
    Vector2(729 - 775,759 - 770),
    Vector2(754 - 775,785 - 770),
    Vector2(748 - 775,527 - 770),
  ];

  final List<Vector2> _attack2PointsOnEnd = [
    Vector2(965  - 220 * 4 - 115,777 - 770),
    Vector2(987  - 220 * 4 - 115,797 - 770),
    Vector2(1004 - 220 * 4 - 115,800 - 770),
    Vector2(1042 - 220 * 4 - 115,785 - 770),
    Vector2(1028 - 220 * 4 - 115,804 - 770),
    Vector2(1016 - 220 * 4 - 115,809 - 770),
    Vector2(994  - 220 * 4 - 115,808 - 770),
    Vector2(977  - 220 * 4 - 115,801 - 770),
    Vector2(967  - 220 * 4 - 115,787 - 770),
  ];

  @override
  Future<void> onLoad() async
  {
    distPlayerLength = 65 * 65;
    shiftAroundAnchorsForHit = 50;
    maxLoots = 2;
    chanceOfLoot = 0.07;
    health = 3;
    maxSpeed = 40;
    anchor = const Anchor(0.5,0.5);
    Image? spriteImage;
    Image? spriteImageWithShield;
    int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    _withShieldNow = rand == 0 ? false : true;
    if(_withShieldNow){
      health = 4;
    }
    if (rand == 0) {
      spriteImage = await Flame.images.load(
          'tiles/map/prisonSet/Characters/Skeleton 1/no shield/Skeleton 1 - all animations.png');
    }else{
      spriteImage = await Flame.images.load(
          'tiles/map/prisonSet/Characters/Skeleton 1/no shield/rusty sword/Skeleton - all animations-with rusty sword.png');
    }
    if (rand == 0) {
      spriteImageWithShield = await Flame.images.load(
          'tiles/map/prisonSet/Characters/Skeleton 1/with shield/Skeleton 1 - all animations.png');
    } else {
      spriteImageWithShield = await Flame.images.load(
          'tiles/map/prisonSet/Characters/Skeleton 1/with shield/with rusty sword and shield/Skeleton - all animations-with rusty shield and sword.png');
    }
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _spriteSheetSize);
    final spriteSheetWithShield = SpriteSheet(image: spriteImageWithShield,
        srcSize: _spriteSheetSize);

    animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8,loop: false);
    animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 8,loop: false);
    animAttack = spriteSheet.createAnimation(row: 2, stepTime: 0.08, from: 0,loop: false);
    animAttack2 = spriteSheet.createAnimation(row: 3, stepTime: 0.08, from: 0, to: 13, loop: false);
    animHurt = spriteSheet.createAnimation(row: 4, stepTime: 0.06, from: 0, to: 8,loop: false);
    animDeath = spriteSheet.createAnimation(row: 5, stepTime: 0.1, from: 0, to: 13,loop: false);

    _animIdleShield = spriteSheetWithShield.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8,loop: false);
    _animMoveShield = spriteSheetWithShield.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 8,loop: false);
    _animAttackShield = spriteSheetWithShield.createAnimation(row: 2, stepTime: 0.08, from: 0,loop: false);
    _animAttack2Shield = spriteSheetWithShield.createAnimation(row: 3, stepTime: 0.08, from: 0, to: 13, loop: false);
    _animBlock = spriteSheetWithShield.createAnimation(row: 4, stepTime: 0.07, from: 0, to: 8,loop: false);
    _animHurtShield = spriteSheetWithShield.createAnimation(row: 5, stepTime: 0.07, from: 0, to: 8,loop: false);
    _animThrowShield = spriteSheetWithShield.createAnimation(row: 6, stepTime: 0.07, from: 0, to: 8,loop: false);
    _animDeathShield = spriteSheetWithShield.createAnimation(row: 7, stepTime: 0.1, from: 0, to: 13,loop: false);

    animation = _withShieldNow ? _animIdleShield : animIdle;
    size = _spriteSheetSize;
    position = _startPos;
    hitBox = EnemyHitbox(hitBoxPoints,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(hitBox!);
    bodyDef.position = _startPos * PhysicVals.physicScale;
    var temUs = bodyDef.userData as BodyUserData;
    temUs.onBeginMyContact = onGround;
    groundBody = Ground(bodyDef, gameRef.world.physicsWorld, isEnemy: true);
    FixtureDef fx = FixtureDef(PolygonShape()..set(getPointsForActivs(Vector2(-11,127-110), Vector2(22,21),scale: PhysicVals.physicScale)));
    groundBody?.createFixture(fx);
    var massData = groundBody!.getMassData();
    massData.mass = 800;
    groundBody!.setMassData(massData);
    _defWeapon = DefaultEnemyWeapon(_attack1PointsOnStart,collisionType: DCollisionType.inactive,isStatic: false,isLoop:true,game: gameRef
        ,isSolid: false,onStartWeaponHit: null,onEndWeaponHit: null);
    _defWeapon.damage = 3;
    add(_defWeapon);
    rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(rand == 0){
      flipHorizontally();
    }
    super.onLoad();
    selectBehaviour();
  }

  void chooseHit()
  {
    _defWeapon.currentCoolDown = _defWeapon.coolDown;
    wasHit = true;
    animation = null;
    speed.x = 0;
    speed.y = 0;
    groundBody?.clearForces();
    _variantOfHit = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(_variantOfHit == 0){
      animation = _withShieldNow ? _animAttackShield : animAttack;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    }else{
      animation = _withShieldNow ? _animAttack2Shield : animAttack2;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    }
    animationTicker?.onComplete = selectBehaviour;
    animationTicker?.onFrame = changeVertsInWeapon;
  }

  void changeVertsInWeapon(int index)
  {
    if(_variantOfHit == 0){
      if(index == 2 || index == 3){
        _defWeapon.changeVertices(_attack1PointsOnStart,isLoop: true);
        _defWeapon.collisionType = DCollisionType.active;
      }else if(index == 4 || index == 5){
        _defWeapon.changeVertices(_attack1PointsOnEnd,isLoop: true);
      }else{
        _defWeapon.collisionType = DCollisionType.inactive;
      }
    }else{
      if(index == 2){
        _defWeapon.changeVertices(_attack2PointsOnStart,isLoop: true);
        _defWeapon.collisionType = DCollisionType.active;
      }else if(index == 4){
        _defWeapon.changeVertices(_attack2PointsOnEnd,isLoop: true);
      }else if(index == 7){
        _defWeapon.collisionType = DCollisionType.inactive;
      }
    }
  }

  @override
  void selectBehaviour()
  {
    if(gameRef.gameMap.orthoPlayer == null){
      return;
    }
    isSee();
    print(wasSeen);
    if(wasSeen) {
      if (isNearPlayer(distPlayerLength)) {
        _defWeapon.currentCoolDown = _defWeapon.coolDown;
        var pl = gameRef.gameMap.orthoPlayer!;
        if (pl.position.x > position.x) {
          if (isFlippedHorizontally) {
            flipHorizontally();
          }
        }
        if (pl.position.x < position.x) {
          if (!isFlippedHorizontally) {
            flipHorizontally();
          }
        }
        chooseHit();
        return;
      }
      moveIdleRandom(true);
    }else{
      moveIdleRandom(isSee());
    }
  }

   @override
   void moveIdleRandom(bool isSee)
   {
     int random = math.Random(DateTime
         .now()
         .microsecondsSinceEpoch).nextInt(2);
     if (random != 0 || wasHit) {
       int shift = 0;
       if (position.x < gameRef.gameMap.orthoPlayer!.position.x) {
         shift = -50;
       } else {
         shift = 50;
       }
       double posX = isSee ? gameRef.gameMap.orthoPlayer!.position.x - position.x + shift : math.Random().nextDouble() * 500 - 250;
       double posY = isSee ? gameRef.gameMap.orthoPlayer!.position.y - position.y: math.Random().nextDouble() * 500 - 250;
       if (whereObstacle == ObstacleWhere.side) {
         posX = 0;
       }
       if (whereObstacle == ObstacleWhere.upDown && posY < 0) {
         posY = 0;
       }
       whereObstacle = ObstacleWhere.none;
       double angle = math.atan2(posY, posX);
       speed.x = math.cos(angle) * (isSee ? maxSpeed : maxSpeed / 2);
       speed.y = math.sin(angle) * (isSee ? maxSpeed : maxSpeed / 2);
       if (speed.x < 0 && !isFlippedHorizontally) {
         flipHorizontally();
       } else if (speed.x > 0 && isFlippedHorizontally) {
         flipHorizontally();
       }
       animation = _withShieldNow ? _animMoveShield : animMove;
     } else {
       if (animation != animIdle && animation != _animIdleShield) {
         speed.x = 0;
         speed.y = 0;
         groundBody?.clearForces();
         animation = _withShieldNow ? _animIdleShield : animIdle;
       }
     }
     animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
     animationTicker?.onComplete = selectBehaviour;
   }

  @override
  void doHurt({required double hurt, bool inArmor = true})
  {
    if(animation == animDeath || animation == _animDeathShield){
      return;
    }
    _defWeapon.collisionType = DCollisionType.inactive;
    if(inArmor) {
      if (_withShieldNow &&
          ((position.x < gameRef.gameMap.orthoPlayer!.position.x &&
              !isFlippedHorizontally)
              || (position.x > gameRef.gameMap.orthoPlayer!.position.x &&
                  isFlippedHorizontally))) {
        int rand = math.Random(DateTime
            .now()
            .microsecondsSinceEpoch).nextInt(3);
        if (rand == 0) {
          speed.x = 0;
          speed.y = 0;
          groundBody?.clearForces();
          animation = _animBlock;
          animationTicker?.isLastFrame ?? false
              ? animationTicker?.reset()
              : null;
          animationTicker?.onComplete = selectBehaviour;
          return;
        }
      }
    }
    if(!internalPhysHurt(hurt, inArmor)){
      return;
    }
    if(health <1){
      death(_withShieldNow ? _animDeathShield : animDeath);
    }else{
      if(_withShieldNow){
        int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(3);
        if (rand == 0) {
          _withShieldNow = false;
          speed.x = 0;
          speed.y = 0;
          groundBody?.clearForces();
          animation = _animThrowShield;
          animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
          animationTicker?.onComplete = selectBehaviour;
          animationTicker?.onFrame = dropShield;
          return;
        }
      }
      animation = _withShieldNow ? _animHurtShield : animHurt;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      animationTicker?.onComplete = selectBehaviour;
    }
  }

  void dropShield(int index)
  {
    if(index == 4){
      DroppedShield droppedShield = DroppedShield(position,isFlippedHorizontally);
      gameRef.gameMap.container.add(droppedShield);
    }
  }

  @override
  void update(double dt) {
    position = groundBody!.position / PhysicVals.physicScale;
    if (!isRefresh) {
      return;
    }
    int pos = position.y.toInt() + 38;
    if(pos <= 0){
      pos = 1;
    }
    priority = pos;
    super.update(dt);
    // if(hitBox.getMaxVector().y > gameRef.gameMap.orthoPlayer!.hitBox!.getMaxVector().y && parent != gameRef.gameMap.enemyOnPlayer){
    //   parent = gameRef.gameMap.enemyOnPlayer;
    // }else if(parent != gameRef.gameMap.enemyComponent){
    //   parent = gameRef.gameMap.enemyComponent;
    // }
    if (animation == _animMoveShield || animation == animMove
        || animation == _animIdleShield || animation == animIdle) {
      groundBody?.applyLinearImpulse(speed * dt * groundBody!.mass);
    }
  }
}


class DroppedShield extends SpriteAnimationComponent
{
  final Vector2 pos;
  bool isFlipped;
  DroppedShield(this.pos,this.isFlipped) : super(position: pos);

  @override
  void onLoad() async
  {
    Image img = await Flame.images.load('tiles/map/prisonSet/Characters/Skeleton 1/with shield/Skeleton 1 - animations-shield drop.png');
    final spriteSheetWithShield = SpriteSheet(image: img,
        srcSize: Vector2(96,64));
    animation = spriteSheetWithShield.createAnimation(row: 0, stepTime: 0.1,loop: false);
    add(OpacityEffect.by(-1,EffectController(duration: animationTicker?.totalDuration())));
    animationTicker?.onComplete = removeFromParent;
    if(isFlipped){
      flipHorizontally();
    }
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    int pos = position.y.toInt();
    if(pos <= 0){
      pos = 1;
    }
    priority = pos;
  }


}