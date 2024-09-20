import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/abstracts/EnemyInfo.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'dart:math' as math;
import 'package:game_flame/kyrgyz_game.dart';

final List<Vector2> _ground = [
  Vector2(-12.9125,23.6644) * PhysicVals.physicScale
  ,Vector2(-6.92572,10.5268) * PhysicVals.physicScale
  ,Vector2(6.71077,10.0279) * PhysicVals.physicScale
  ,Vector2(10.5356,23.8307) * PhysicVals.physicScale
  ,];

final List<Vector2> _hitBoxPoints = [
  Vector2(-13.0788,23.1655)
  ,Vector2(-7.42462,11.192)
  ,Vector2(-9.7528,-8.76384)
  ,Vector2(8.70635,-18.4092)
  ,Vector2(14.6931,-1.4467)
  ,Vector2(10.0367,23.4981)
  ,];

final List<Vector2> _attack1ind12 = [ //7 - 10
  Vector2(-21.8028,-16.5089)
  ,Vector2(-22.2781,-9.61743)
  ,Vector2(-8.25757,10.344)
  ,Vector2(14.3179,23.8893)
  ,Vector2(30.4771,26.2656)
  ,Vector2(46.3987,21.5129)
  ,Vector2(60.1816,-0.824895)
  ,Vector2(52.102,-24.8261)
  ,Vector2(40.4578,-30.767)
  ,Vector2(28.8137,-27.9154)
  ,Vector2(44.0224,-22.4498)
  ,Vector2(31.4277,16.0473)
  ,Vector2(7.90169,-16.9841)
  ,Vector2(2.19842,5.35364)
  ,];

class OrcMage extends KyrgyzEnemy
{
  OrcMage(this._startPos, {required super.level, required super.id, super.isHigh, super.loots});
  final Vector2 _startPos;
  final double dist = 350 * 350;
  final Vector2 srcSize = Vector2(256,256);
  bool _castMagic = false;


  @override
  Future<void> onLoad() async
  {
    dopPriority = 38;
    maxLoots = 2;
    chanceOfLoot = 0.12;
    health = OrcMageInfo.health(level);
    anchor = const Anchor(0.484375, 0.5);
    maxSpeed = OrcMageInfo.speed;
    armor = OrcMageInfo.armor(level);
    if(isHigh){
      priority = GamePriority.high + 1;
    }

    Image sprImg = gameRef.gameMap.currentGameWorldData!.isDungeon ? await Flame.images.load('tiles/map/grassLand2/Characters/orc mage/orc2/orc mage - with hand fx - all anims.png')
    : await Flame.images.load('tiles/map/grassLand2/Characters/orc mage/orc1/orc mage - with hand fx- all anims.png');

    SpriteSheet spriteSheet = SpriteSheet(image: sprImg, srcSize: srcSize);
    int seed = DateTime.now().microsecond;
    animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 8, loop: false);
    animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 8, loop: false);
    animAttack2 = spriteSheet.createAnimation(row: 2, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, loop: false);
    animAttack = spriteSheet.createAnimation(row: 3, stepTime: 0.1 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0,to: 16, loop: false);
    animHurt = spriteSheet.createAnimation(row: 4, stepTime: 0.07 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0,to: 7, loop: false);
    animDeath = spriteSheet.createAnimation(row: 5, stepTime: 0.1 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0,to: 17, loop: false);

    animation = animIdle;
    animationTicker?.onComplete = selectBehaviour;
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
    weapon = DefaultEnemyWeapon(
        _attack1ind12,collisionType: DCollisionType.inactive, onStartWeaponHit: null, onEndWeaponHit: null, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(weapon!);
    weapon?.damage = OrcMageInfo.damage(level);
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
    }else{
      animation = animIdle;
      _castMagic = false;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      animationTicker?.onComplete = selectBehaviour;
    }
  }

  @override
  changeVertsInWeapon(int index)
  {
    if(animation == animAttack){
      if(index == 7){
        weapon?.collisionType = DCollisionType.active;
      }else if(index == 10){
        weapon?.collisionType = DCollisionType.inactive;
      }
    }else{
      if(index == 11){
        bool isSpike = math.Random().nextBool();
        if(isSpike){
          bool isBig = math.Random().nextBool();
          if(isBig){
            gameRef.gameMap.container.add(BigSpikes());
          }else{
            gameRef.gameMap.container.add(SmallSpikes());
          }
        }else{
          gameRef.gameMap.container.add(ToxicRain(!gameRef.gameMap.currentGameWorldData!.isDungeon));
        }
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

class ToxicRain extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  final List<Vector2> _hitboxPoints = [ // 5-6
    Vector2(-19.2472,20.5306)
    ,Vector2(-11.4264,25.0928)
    ,Vector2(1.60838,24.9299)
    ,Vector2(11.0586,21.5082)
    ,Vector2(3.5636,7.65881)
    ,Vector2(-11.1005,7.17)
    ,];

  final List<Vector2> _hitboxBigPoints = [ // 5-6-7
    Vector2(-16.2445,32.9798)
    ,Vector2(-4.60969,57.7803)
    ,Vector2(56.9322,43.3899)
    ,Vector2(51.1148,30.5304)
    ,Vector2(26.0081,14.6091)
    ,Vector2(-15.6321,32.9798)
    ,Vector2(52.0333,40.6343)
    ,];

  ToxicRain(this.isViolet);
  bool isViolet;
  Vector2? target;
  Vector2 speed = Vector2(150,150);
  final bool isBig = math.Random().nextBool();
  late DefaultEnemyWeapon _weapon;
  bool _isFly = true;


  @override
  void onLoad() async
  {
    opacity = 0.2;
    String fileName = '';
    anchor = Anchor.center;
    if(isBig){
      if(isViolet){
        fileName = 'atk1 fx2-energy ish fx-pack.png';
      }else{
        fileName = 'atk1 fx-energy ish fx-pack.png';
      }
    }else{
      if(isViolet){
        fileName = 'atk1 fx2-energy ish fx-single.png';
      }else{
        fileName = 'atk1 fx-energy ish fx-single.png';
      }
    }
    final spriteSheetLoop = SpriteSheet(image: await Flame.images.load('tiles/map/grassLand2/Characters/orc mage/$fileName'),
        srcSize: Vector2(192,160));
    final List<double> myTimes = isBig ? [
      1.0,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
    ] : [
      1.0,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
    ];
    priority = GamePriority.foregroundTile - 1;
    animation = spriteSheetLoop.createAnimationWithVariableStepTimes(row: 0,from: isBig ? 3 : 2, stepTimes: myTimes,loop: false);
    animationTicker?.onFrame = doFrame;
    animationTicker?.onComplete = removeFromParent;
    target = isBig ? gameRef.playerPosition() - Vector2(15,20) : gameRef.playerPosition();
    position = target! - speed;
    _weapon = DefaultEnemyWeapon(isBig ? _hitboxBigPoints : _hitboxPoints,
        collisionType: DCollisionType.inactive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    _weapon.damage = isBig ? OrcAcidRainInfo.damage(gameRef.playerData.playerLevel.value) : OrcAcidInfo.damage(gameRef.playerData.playerLevel.value);
    _weapon.coolDown = 1;
    _weapon.inArmor = false;
    add(_weapon);
    add(OpacityEffect.to(1,EffectController(duration: 0.5)));
  }

  void doFrame(int index)
  {
    if(index == 1) {
      _isFly = false;
      priority = position.y.toInt() + 25;
    }
    if(isBig){
      if(index == 2){
        _weapon.collisionType = DCollisionType.active;
      }else if(index == 5){
        _weapon.collisionType = DCollisionType.inactive;
      }
    }else{
      if(index == 3){
        _weapon.collisionType = DCollisionType.active;
      }else if(index == 5){
        _weapon.collisionType = DCollisionType.inactive;
      }
    }
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    if(_isFly){
      position += speed * dt;
    }
  }
}

class BigSpikes extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  final List<Vector2> _hitboxPoints = [ // 3-7
    Vector2(-38.56,-7.4206)
    ,Vector2(-47.0348,8.65987)
    ,Vector2(-46.3829,27.348)
    ,Vector2(-35.7351,40.8208)
    ,Vector2(26.6311,40.3862)
    ,Vector2(41.4077,25.6096)
    ,Vector2(-40.0811,13.8752)
    ,Vector2(36.4097,15.6136)
    ,Vector2(31.6291,5.18301)
    ,Vector2(16.8524,-4.16104)
    ,];
  late DefaultEnemyWeapon _weapon;

  @override
  void onLoad() async
  {
    anchor = Anchor.center;
    position = gameRef.playerPosition();
    priority = position.y.toInt() + 20;
    final sprites = SpriteSheet(image: await Flame.images.load('tiles/map/grassLand2/Characters/orc mage/atk1 fx-Spike fx-pack.png'),
        srcSize: Vector2(192,160));
    final List<double> times = [
      0.08,
      0.5,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
      0.08,
    ];
    animation = sprites.createAnimationWithVariableStepTimes(row: 0,stepTimes: times,loop:false,from: 0);
    animationTicker?.onComplete = removeFromParent;
    animationTicker?.onFrame = doFrame;
    _weapon = DefaultEnemyWeapon(_hitboxPoints,
        collisionType: DCollisionType.inactive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    _weapon.damage = ManySpikesInfo.damage(gameRef.playerData.playerLevel.value);
    _weapon.coolDown = 0.7;
    _weapon.inArmor = false;
    add(_weapon);
  }

  void doFrame(int index)
  {
    if(index == 2){
      _weapon.collisionType = DCollisionType.active;
    }else if(index == 10){
      _weapon.collisionType = DCollisionType.inactive;
    }
  }
}

class SmallSpikes extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  final List<Vector2> _hitboxPoints = [
    Vector2(-3.83916,-9.71624)
    ,Vector2(-4.36281,8.43683)
    ,Vector2(-2.26822,12.1024)
    ,Vector2(8.2047,11.7533)
    ,Vector2(0.524559,-9.71624)
    ,];
  late DefaultEnemyWeapon _weapon;


  @override
  void onLoad() async
  {
    anchor = Anchor.center;
    position = gameRef.playerPosition() - Vector2(12*5,-12);
    priority = position.y.toInt() + 12;
    final sprites = SpriteSheet(image: await Flame.images.load('tiles/map/grassLand2/Characters/orc mage/atk1 fx-Spike fx-single.png'),
        srcSize: Vector2(32,32));
    animation = sprites.createAnimation(row: 0,stepTime: 0.1,loop:false,from: 0);
    animationTicker?.onComplete = removeFromParent;
    animationTicker?.onFrame = doFrame;
    _weapon = DefaultEnemyWeapon(_hitboxPoints,
        collisionType: DCollisionType.inactive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    _weapon.damage = SpkikeInfo.damage(gameRef.playerData.playerLevel.value);
    _weapon.coolDown = 0.7;
    _weapon.inArmor = false;
    add(_weapon);
  }

  void doFrame(int index)
  {
    position.x += 12;
    _weapon.coolDown = 0.7;
    if(index == 1){
      _weapon.collisionType = DCollisionType.active;
    }else if(index == 8){
      _weapon.collisionType = DCollisionType.inactive;
    }
  }
}
