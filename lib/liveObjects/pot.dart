import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/liveObjects/skeleton.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'dart:math' as math;
import 'package:game_flame/kyrgyz_game.dart';

final List<Vector2> _ground = [
  Vector2(-12.2508,15.3288) * PhysicVals.physicScale
  ,Vector2(-8.96699,28.8095) * PhysicVals.physicScale
  ,Vector2(7.62466,28.8095) * PhysicVals.physicScale
  ,Vector2(11.9454,15.8473) * PhysicVals.physicScale
  ,];

final List<Vector2> _hitBoxPoints = [
  Vector2(-14.8432,-3.16395)
  ,Vector2(-8.4485,28.9824)
  ,Vector2(7.45183,28.9824)
  ,Vector2(14.7107,-2.64546)
  ,Vector2(0.365811,-8.34884)
  ,];

final List<Vector2> _attack1ind12 = [ //17 всё
  Vector2(9.19474,14.9207)
  ,Vector2(26.2462,19.5292)
  ,Vector2(28.2048,21.9487)
  ,Vector2(35.2328,21.7183)
  ,Vector2(38.8044,18.7227)
  ,Vector2(37.9979,11.4643)
  ,Vector2(36.3849,8.46881)
  ,Vector2(29.357,8.81444)
  ,Vector2(25.4397,12.9621)
  ,Vector2(11.7294,9.96657)
  ,];

//Вторая атака будет на 18 индексе и в этой точке: [
// Vector2(0.852862,-11.841)
// ,];

class Pot extends KyrgyzEnemy
{
  Pot(this._startPos,int id,{this.isHigh = false}){this.id = id; super.isHigh = isHigh;}
  final Vector2 _startPos;
  bool isHigh;
  final double dist = 350 * 350;
  final Vector2 srcSize = Vector2(160,128);
  late SpriteAnimation animRevealing;
  bool wakeUp = false;
  TimerComponent? timer;
  bool _castMagic = false;


  @override
  Future<void> onLoad() async
  {
    dopPriority = 30;
    maxLoots = 2;
    chanceOfLoot = 0.12;
    health = 15;
    anchor = Anchor.center;
    maxSpeed = 35;
    if(isHigh){
      priority = GamePriority.high + 1;
    }

    SpriteSheet spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Pot Creature/Pot Creature-atk1.png'
    ), srcSize: srcSize);
    animAttack = spriteSheet.createAnimation(row: 0, stepTime: 0.05 + math.Random().nextDouble() / 40 - 0.0125, from: 0, loop: false);

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Pot Creature/Pot Creature-death.png'
    ), srcSize: srcSize);
    animDeath = spriteSheet.createAnimation(row: 0, stepTime: 0.1 + math.Random().nextDouble() / 40 - 0.0125, from: 0, loop: false);

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Pot Creature/Pot Creature-idle.png'
    ), srcSize: srcSize);
    animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08 + math.Random().nextDouble() / 40 - 0.0125, from: 0, loop: false);

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Pot Creature/Pot Creature-walk.png'
    ), srcSize: srcSize);
    animMove = spriteSheet.createAnimation(row: 0, stepTime: 0.08 + math.Random().nextDouble() / 40 - 0.0125, from: 0, loop: false);

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Pot Creature/Pot Creature-hurt.png'
    ), srcSize: srcSize);
    animHurt = spriteSheet.createAnimation(row: 0, stepTime: 0.07 + math.Random().nextDouble() / 40 - 0.0125, from: 0, loop: false);

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Pot Creature/Pot Creature-atk2.png'
    ), srcSize: srcSize);
    animAttack2 = spriteSheet.createAnimation(row: 0, stepTime: 0.05 + math.Random().nextDouble() / 40 - 0.0125, from: 0, loop: false);

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Pot Creature/Pot Creature-revealing itself.png'
    ), srcSize: srcSize);
    animRevealing = spriteSheet.createAnimation(row: 0, stepTime: 0.07 + math.Random().nextDouble() / 40 - 0.0125, from: 0, loop: false);

    wakeUp = isHigh;
    animation = isHigh ? animIdle : spriteSheet.createAnimation(row: 0, stepTime: 0.07 + math.Random().nextDouble() / 40 - 0.0125, from: 0,to: 1, loop: false);
    position = _startPos;
    hitBox = EnemyHitbox(_hitBoxPoints,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(hitBox!);
    bodyDef.position = _startPos * PhysicVals.physicScale;
    groundBody = Ground(bodyDef, gameRef.world.physicsWorld, isEnemy: true);
    FixtureDef fx = FixtureDef(PolygonShape()..set(_ground));
    groundBody?.createFixture(fx);
    var massData = groundBody!.getMassData();
    massData.mass = 800;
    groundBody!.setMassData(massData);
    timer = TimerComponent(period: 1, onTick: selectBehaviour,repeat: true);
    add(timer!);
    weapon = DefaultEnemyWeapon(
        _attack1ind12,collisionType: DCollisionType.inactive, onStartWeaponHit: null, onEndWeaponHit: null, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(weapon!);
    weapon?.damage = 2;
    super.onLoad();
  }

  @override
  void selectBehaviour() {
    if (gameRef.gameMap.orthoPlayer == null) {
      return;
    }
    if(!wasSeen && !isHigh){
      isSee();
    }
    if (wasSeen || isHigh) {
      if(!wakeUp){
        if(isNearPlayer(200 * 200, isDistanceWeapon: true)){
          wakeUp = true;
          animation = animRevealing;
          animationTicker?.onComplete = selectBehaviour;
        }else{
          return;
        }
      }
      if(timer != null){
        timer!.removeFromParent();
        timer = null;
      }
      if (isNearPlayer(70 * 70, isDistanceWeapon: true)) {
        int rand = math.Random().nextInt(3);
        if (rand < 2) {
          // _rigidSec = 0.8;
          double posX = position.x - gameRef.gameMap.orthoPlayer!.position.x;
          double posY = position.y - gameRef.gameMap.orthoPlayer!.position.y;
          for(final temp in myContactMap.values){
            if(temp == ObstacleWhere.up && posY < 0){
              posY = 0;
            }
            if(temp == ObstacleWhere.down && posY > 0){
              posY = 0;
            }
            if(temp == ObstacleWhere.left && posX < 0){
              posX = 0;
            }
            if(temp == ObstacleWhere.right && posX > 0){
              posX = 0;
            }
          }
          if(posX == 0 && posY == 0){
            posX = posY = math.Random().nextDouble() * 500 - 250;
          }
          double angle = math.atan2(posY, posX);
          speed.x = math.cos(angle) * maxSpeed;
          speed.y = math.sin(angle) * maxSpeed;
          if (speed.x < 0 && !isFlippedHorizontally) {
            flipHorizontally();
          } else if (speed.x > 0 && isFlippedHorizontally) {
            flipHorizontally();
          }
          animation = animMove;
          animationTicker?.isLastFrame ?? false
              ? animationTicker?.reset()
              : null;
          animationTicker?.onComplete = selectBehaviour;
          return;
        }else{
          weapon?.currentCoolDown = weapon?.coolDown ?? 0;
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
          animation = animAttack;
          animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
          animationTicker?.onFrame = changeVertsInWeapon;
          animationTicker?.onComplete = selectBehaviour;
          return;
        }
      }
      if (!_castMagic && isNearPlayer(dist, isDistanceWeapon: true)) {
        _castMagic = true;
        animation = animAttack2;
        animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
        animationTicker?.onComplete = selectBehaviour;
        animationTicker?.onFrame = changeVertsInWeapon;
        if (position.x < gameRef.gameMap.orthoPlayer!.position.x &&
            isFlippedHorizontally) {
          flipHorizontally();
        } else if (position.x > gameRef.gameMap.orthoPlayer!.position.x &&
            !isFlippedHorizontally) {
          flipHorizontally();
        }
        return;
      }
      animation = animIdle;
      _castMagic = false;
      speed.x = 0;
      speed.y = 0;
      groundBody?.clearForces();
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      animationTicker?.onComplete = selectBehaviour;
    }
  }

  @override
  changeVertsInWeapon(int index)
  {
    if(animation == animAttack){
      if(index == 12){
        weapon?.collisionType = DCollisionType.active;
      }else if(index == 17){
        weapon?.collisionType = DCollisionType.inactive;
      }
    }else{
      if(index == 18){
        gameRef.gameMap.container.add(PotBubble(position: position + Vector2(0,-12)));
      }
    }
  }

  @override
  void update(double dt)
  {
    if(isFreeze > 0){
      return;
    }
    super.update(dt);
    if (!isRefresh) {
      return;
    }
    position = groundBody!.position / PhysicVals.physicScale;
    if (animation == animMove
        || animation == animIdle) {
      groundBody?.applyLinearImpulse(speed * dt * groundBody!.mass);
    }
  }
}

class PotBubble extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  final List<Vector2> _hitboxPoints = [
    Vector2(-10.7276,2.51066)
    ,Vector2(-0.755925,9.84616)
    ,Vector2(9.73154,-0.297456)
    ,Vector2(-0.469382,-10.4984)
    ,];

  PotBubble({required super.position});
  Vector2? target;
  double gravity = 250;
  Vector2 speed = Vector2.zero();
  double secTime = 2.1;
  EnemyHitbox? hitBox;
  late TimerComponent timer;

  @override
  void onLoad() async
  {
    priority = GamePriority.maxPriority + 1;
    anchor = Anchor.center;
    final spriteSheetLoop = SpriteSheet(image: await Flame.images.load('tiles/map/mountainLand/Characters/Pot Creature/atk2 projectile-travelling.png'),
        srcSize: Vector2(32,32));
    animation = spriteSheetLoop.createAnimation(row: 0, stepTime: 0.08,loop: true);
    target = gameRef.gameMap.orthoPlayer!.position;
    speed = Vector2((target!.x - position.x) / secTime, (target!.y - position.y)/secTime - secTime/2 * gravity + 1);
    timer = TimerComponent(period: secTime, onTick: (){
      gameRef.gameMap.container.add(PotSplash(position: position));
      removeFromParent();
    });
    add(timer);
    hitBox = EnemyHitbox(_hitboxPoints,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef, onStartColl: perfectDelete);
    add(hitBox!);
  }

  void perfectDelete(DCollisionEntity other)
  {
    hitBox?.collisionType = DCollisionType.inactive;
    timer.removeFromParent();
    speed.setZero();
    add(ScaleEffect.to(Vector2.all(0.01),EffectController(duration: 0.5),onComplete: (){
      removeFromParent();
    }));
    add(OpacityEffect.to(0,EffectController(duration: 0.5)));
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    speed.y += gravity * dt;
    // print('position and speed: ${position.y}, ${target!.y}');
    position += speed * dt;
  }
}

class PotSplash extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{

  PotSplash({required super.position});

  final List<Vector2> _weapons = [
    Vector2(-0.65143,-4.85678)
    ,Vector2(-19.8676,-0.159481)
    ,Vector2(-30.7568,8.80808)
    ,Vector2(-33.1055,26.3162)
    ,Vector2(-15.5974,30.3729)
    ,Vector2(21.1269,30.3729)
    ,Vector2(31.3756,26.9567)
    ,Vector2(30.5215,11.7973)
    ,Vector2(20.9134,0.908087)
    ,Vector2(2.33776,-5.07029)
    ,Vector2(-25.2055,23.327)
    ,Vector2(22.835,23.5405)
    ,Vector2(-0.437917,5.60538)
    ,];

  late DefaultEnemyWeapon _weapon;

  @override
  void onLoad() async
  {
    anchor = Anchor.center;
    priority = position.y.toInt() + 30;
    final spriteSheetLoop = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Pot Creature/atk2 projectile-splash.png'),
        srcSize: Vector2(160, 128));
    animation = spriteSheetLoop.createAnimation(row: 0, stepTime: 0.1, loop: false);
    animationTicker?.onComplete = removeFromParent;
    animationTicker?.onFrame = animChange;
    _weapon = DefaultEnemyWeapon(
        _weapons,collisionType: DCollisionType.inactive, onStartWeaponHit: null, onEndWeaponHit: null, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(_weapon);
    _weapon.damage = 4;
    _weapon.inArmor = false;
  }

  void animChange(int index)
  {
    if(index == 1){
      _weapon.collisionType = DCollisionType.active;
    }else if(index == 3){
      _weapon.collisionType = DCollisionType.inactive;
    }
  }
}
