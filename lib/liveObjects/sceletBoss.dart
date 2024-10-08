import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/abstracts/EnemyInfo.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'dart:math' as math;
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/magicEffects/fireEffect.dart';
import 'package:game_flame/weapon/magicEffects/lightningEffect.dart';
import 'package:game_flame/weapon/magicEffects/poisonEffect.dart';

final List<Vector2> _ground = [
  Vector2(-18.9757,51.3625) * PhysicVals.physicScale
  ,Vector2(-13.9162,28.7051) * PhysicVals.physicScale
  ,Vector2(10.9409,28.4851) * PhysicVals.physicScale
  ,Vector2(17.5402,51.8025) * PhysicVals.physicScale
  ,];

final List<Vector2> _hitBoxPoints = [
  Vector2(-17.8758,47.403)
  ,Vector2(-10.3966,2.74802)
  ,Vector2(-4.23734,-2.97134)
  ,Vector2(-2.03759,-14.41)
  ,Vector2(9.84107,-13.9701)
  ,Vector2(9.84107,26.7253)
  ,Vector2(12.7007,46.963)
  ,];

final List<Vector2> _attack1ind7 = [ //loop
  Vector2(-21.2302,-9.74929)
  ,Vector2(12.8354,-6.37088)
  ,Vector2(14.8061,-45.2225)
  ,Vector2(7.20474,-59.0177)
  ,Vector2(-36.7145,-45.7856)
  ,Vector2(9.73854,-43.5333)
  ,Vector2(-7.71654,-18.4768)
  ,Vector2(-33.8992,-42.6887)
  ,];

final List<Vector2> _attack1ind8 = [ //not loop
  Vector2(40.9875,30.1862)
  ,Vector2(113.54,32.0892)
  ,Vector2(119.487,24.9529)
  ,Vector2(41.4633,20.909)
  ,Vector2(115.918,18.5303)
  ,Vector2(104.262,-5.25731)
  ,Vector2(66.2024,11.394)
  ,Vector2(94.2717,-14.7723)
  ,Vector2(79.5234,-25.7146)
  ,Vector2(63.3479,-2.87856)
  ,Vector2(65.9645,-29.0449)
  ,Vector2(54.7843,-33.8024)
  ,Vector2(53.8328,-19.0541)
  ,Vector2(37.4194,-33.8024)
  ,Vector2(47.4102,-33.8024)
  ,];

final List<Vector2> _attack1ind9 = [ //11 всё loop
  Vector2(47.3989,37.9661)
  ,Vector2(117.999,39.0278)
  ,Vector2(123.573,31.8616)
  ,Vector2(117.999,27.3495)
  ,Vector2(47.3989,25.757)
  ,];

final List<Vector2> _attack2ind4 = [ //loop
  Vector2(-15.2436,18.1963) //
  ,Vector2(16.3714,-5.62322)
  ,Vector2(52.1008,-29.8759)
  ,Vector2(30.2301,-45.6834)
  ,Vector2(-13.9444,8.23543)
  ,Vector2(12.2571,-52.6127)
  ,Vector2(-2.90077,-57.8097)
  ,Vector2(-15.8933,-2.3751)
  ,Vector2(-15.0271,-58.4594)
  ,Vector2(-20.0076,-52.6127)
  ,Vector2(-26.5038,0.873021)
  ,];

final List<Vector2> _attack2ind5 = [ //loop 7 всё
  Vector2(-92.5495,28.0245)
  ,Vector2(-15.093,23.0107)
  ,Vector2(-16.0748,37.2441)
  ,Vector2(-92.5495,39.5652)
  ,];

final List<Vector2> _attack3ind6 = [ //loop
  Vector2(-60.1981,-28.9098)
  ,Vector2(-60.1981,-4.04638)
  ,Vector2(-48.8966,37.1415)
  ,Vector2(-40.1065,50.4522)
  ,Vector2(-30.8141,55.7262)
  ,Vector2(-20.7683,55.7262)
  ,Vector2(-19.0103,39.6529)
  ,Vector2(-26.7958,4.24142)
  ,Vector2(-34.3302,46.4339)
  ,Vector2(-40.6088,0.976525)
  ,Vector2(-48.8966,21.0682)
  ,Vector2(-51.1569,-12.083)
  ,];

final List<Vector2> _attack3ind7 = [ //loop 9 всё
  Vector2(-32.3611,-11.8097)
  ,Vector2(-35.0009,38.8751)
  ,Vector2(-23.5616,55.2421)
  ,Vector2(-10.7144,47.6746)
  ,Vector2(-5.78671,22.3321)
  ,Vector2(-13.1783,-7.58599)
  ,Vector2(-23.5616,-13.3936)
  ,Vector2(-22.3297,46.2667)
  ,];

//Вторая атака будет на 18 индексе и в этой точке: [
// Vector2(0.852862,-11.841)
// ,];

class BossScelet extends KyrgyzEnemy
{
  BossScelet(this._startPos,{required super.id, required super.level, super.isHigh, super.loots,required super.citizen,required super.quest,required super.startTrigger,required super.endTrigger});
  final Vector2 _startPos;
  final double dist = 700 * 700;
  final Vector2 srcSize = Vector2(351,207);
  late SpriteAnimation animRevealing, animReturnAfterAttack, animAttack3Start, animAttack3Loop, animAttack3End;
  bool wakeUp = false;
  TimerComponent? timer;
  int _attacksCount = 0;
  int loopMagic = 0;
  int _lockedHurts = 0;


  @override
  Future<void> onLoad() async
  {
    beast = true;
    dopPriority = 52;
    highQuest = -14.41;
    maxLoots = 10;
    chanceOfLoot = 0.9;
    health = SceletBossInfo.health(level);
    armor = SceletBossInfo.armor(level);
    anchor = const Anchor(0.450142,0.5);
    maxSpeed = SceletBossInfo.speed;
    distPlayerLength = 500;
    if(isHigh){
      priority = GamePriority.high + 1;
    }

    SpriteSheet spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Boss/boss anims-atk1.png'
    ), srcSize: srcSize);
    animAttack = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false); //Взмах мечом вправо

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Boss/boss anims-atk1-return to neutral position.png'
    ), srcSize: srcSize);
    animReturnAfterAttack = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Boss/boss anims-atk2.png'
    ), srcSize: srcSize);
    animAttack2 = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false); //Комбо атака влево после первой атаки

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Boss/boss anims-atk3.png'
    ), srcSize: srcSize);
    animAttack3Start = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false); //Начало атаки магией вниз

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Boss/boss anims-atk3-loop.png'
    ), srcSize: srcSize);
    animAttack3Loop = spriteSheet.createAnimation(row: 0, stepTime: 0.07, from: 0, loop: false); //Магия летит

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Boss/boss anims-atk3-return.png'
    ), srcSize: srcSize);
    animAttack3End = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false); //Убирание меча обратно

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Boss/boss anims-death.png'
    ), srcSize: srcSize);
    animDeath = spriteSheet.createAnimation(row: 0, stepTime: 0.15, from: 0, loop: false);

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Boss/boss anims-idle.png'
    ), srcSize: srcSize);
    animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, loop: false);

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Boss/boss anims-walk.png'
    ), srcSize: srcSize);
    animMove = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, loop: false);

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Boss/boss anims-hurt.png'
    ), srcSize: srcSize);
    animHurt = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, loop: false);

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Boss/boss anims-resurrect-packed sheet.png'
    ), srcSize: srcSize);

    List<Sprite> sprts = [];
    for(int i=0;i<59;i++){
      sprts.add(spriteSheet.getSpriteById(i));
    }
    animRevealing = SpriteAnimation.spriteList(sprts, stepTime: 0.07, loop: false);

    wakeUp = isHigh;
    animation = isHigh ? animIdle : spriteSheet.createAnimation(row: 0, stepTime: 0.07, from: 0,to: 1, loop: false);
    position = _startPos;
    hitBox = EnemyHitbox(_hitBoxPoints,
        collisionType: DCollisionType.inactive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
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
        _attack1ind7,collisionType: DCollisionType.inactive, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(weapon!);
    weapon?.damage = SceletBossInfo.damage(level);
    super.onLoad();
  }

  @override
  void doHurt({required double hurt, bool inArmor=true})
  {
    if(animation == animDeath){
      return;
    }
    if(!internalPhysHurt(hurt,inArmor)){
      return;
    }
    _lockedHurts++;
    if(health < 1){
      weapon?.collisionType = DCollisionType.inactive;
      death(animDeath);
    }else{
      if((animation == animAttack || animation == animAttack2) && animationTicker!.currentIndex > 1 || _lockedHurts < 6){
        return;
      }
      _lockedHurts = 0;
      weapon?.collisionType = DCollisionType.inactive;
      animation = animHurt;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      animationTicker?.onComplete = selectBehaviour;
    }
  }

  @override
  void doMagicHurt({required double hurt,required MagicDamage magicDamage})
  {
    if(animation == animDeath){
      return;
    }
    internalPhysHurt(hurt,false);
    Component magicAnim;
    switch(magicDamage){
      case MagicDamage.fire:
        isFreeze = 0;
        magicAnim = FireEffect(position: Vector2(width * anchor.x, height * anchor.y));
        break;
      case MagicDamage.ice:
        magicAnim = ColorEffect(opacityTo: 0.1, BasicPalette.blue.color, EffectController(duration: 0.51 * magicScaleFreeze,reverseDuration: 0.51 * magicScaleFreeze));
        break;
      case MagicDamage.lightning:
        magicAnim = LightningEffect(position: Vector2(width * anchor.x, height * anchor.y));
        break;
      case MagicDamage.none:
        throw 'NON MAGIC HAS MAGIC DAMAGE!!!';
        magicAnim = LightningEffect(position: Vector2(width * anchor.x, height * anchor.y));
        break;
      case MagicDamage.poison:
        magicAnim = PoisonEffect(position: Vector2(width * anchor.x, height * anchor.y));
        break;
      case MagicDamage.copyOfPlayer:
        magicAnim = LightningEffect(position: Vector2(width * anchor.x, height * anchor.y));
        break;
    }
    add(magicAnim);
    if(health < 1){
      weapon?.collisionType = DCollisionType.inactive;
      death(animDeath);
    }
  }

  @override
  void selectBehaviour() {
    if(citizen){
      moveIdleRandom(false);
      return;
    }
    if (gameRef.gameMap.orthoPlayer == null) {
      return;
    }
    if(!wasSeen && !isHigh){
      wasSeen = isNearPlayer(500 * 500, isDistanceWeapon: true);
    }
    if (wasSeen || isHigh) {
      if(!wakeUp){
        animation = animRevealing;
        animationTicker?.onComplete = (){
          print(hitBox?.collisionType);
          hitBox?.collisionType = DCollisionType.passive;
          wakeUp = true;
          selectBehaviour();
        };
        if(timer != null){
          timer!.removeFromParent();
          timer = null;
        }
        return;
      }
      weapon?.collisionType = DCollisionType.inactive;
      bool isReallyWantHit = true;
      if(_attacksCount > 3){
        isReallyWantHit = math.Random().nextBool();
      }
      if(isReallyWantHit && isNearPlayer(120 * 120)) {
        weapon?.currentCoolDown = weapon?.coolDown ?? 0;
        var pl = gameRef.gameMap.orthoPlayer!;
        if(isReverseBody){
          if (pl.position.x > position.x && !isFlippedHorizontally) {
            flipHorizontally();
          }
          if (pl.position.x < position.x && isFlippedHorizontally) {
            flipHorizontally();
          }
        }else{
          if (pl.position.x > position.x && isFlippedHorizontally) {
            flipHorizontally();
          }
          if (pl.position.x < position.x && !isFlippedHorizontally) {
            flipHorizontally();
          }
        }
        _attacksCount++;
        setAttack(false);
        return;
      }
      int rand = math.Random().nextInt(3);
      if(rand == 0){
        _attacksCount = 0;
        setAttack(true);
        return;
      }
      _attacksCount = 0;
      moveIdleRandom(isSee());
    }
  }

  void setAttack(bool isMagic){
    weapon?.currentCoolDown = weapon!.coolDown;
    animation = null;
    speed.x = 0;
    speed.y = 0;
    groundBody?.clearForces();
    if(isMagic){
      animation = animAttack3Start;
      animationTicker?.onComplete = changeFromAttack;
      animationTicker?.onFrame = changeVertsInWeapon;
      return;
    }else{
      animation = animAttack;
      animationTicker?.onComplete = changeFromAttack;
      animationTicker?.onFrame = changeVertsInWeapon;
      return;
    }
  }

  void changeFromAttack()
  {
    if(animation == animAttack3Start){
      loopMagic = 0;
      animation = animAttack3Loop;
      animationTicker?.onFrame = changeVertsInWeapon;
      animationTicker?.onComplete = (){
        animation = null;
        animation = animAttack3Loop;
        animationTicker?.onFrame = changeVertsInWeapon;
        animationTicker?.onComplete = changeFromAttack;
      };
    }else if(animation == animAttack3Loop){
      loopMagic++;
      if(loopMagic < 11){
        animationTicker?.reset();
      }else{
        animation = animAttack3End;
        animationTicker?.onComplete = selectBehaviour;
      }
    }else if(animation == animAttack){
      bool continueAttack = math.Random().nextBool();
      if(continueAttack){
        weapon?.currentCoolDown = weapon!.coolDown;
        animation = animAttack2;
        animationTicker?.onFrame = changeVertsInWeapon;
        animationTicker?.onComplete = selectBehaviour;
      }else{
        animation = animReturnAfterAttack;
        animationTicker?.onComplete = selectBehaviour;
      }
    }
  }

  @override
  void chooseHit()
  {

  }

  @override
  changeVertsInWeapon(int index)
  {
    if(animation == animAttack3Start){
      if(index == 6){
        weapon?.changeVertices(_attack3ind6,isLoop: true);
        weapon?.collisionType = DCollisionType.active;
      }else if(index == 7){
        weapon?.changeVertices(_attack3ind7,isLoop: true);
      }else if(index == 9){
        weapon?.collisionType = DCollisionType.inactive;
      }else if(index == 19) {
        gameRef.gameMap.container.add(BossCircleBoom(true, position: position));
      }
    }else if(animation == animAttack){
      if(index == 7){
        weapon?.changeVertices(_attack1ind7,isLoop: true);
        weapon?.collisionType = DCollisionType.active;
      }else if(index == 8){
        weapon?.changeVertices(_attack1ind8);
      }else if(index == 9){
        weapon?.changeVertices(_attack1ind9,isLoop: true);
        gameRef.gameMap.container.add(BossBoom(position: position + (!isFlippedHorizontally ? Vector2(60,30) : Vector2(-60,30)), right: !isFlippedHorizontally));
      }else if(index == 11){
        weapon?.collisionType = DCollisionType.inactive;
      }
    }else if(animation == animAttack2){
      if(index == 4){
        weapon?.collisionType = DCollisionType.active;
        weapon?.changeVertices(_attack2ind4,isLoop: true);
      }else if(index == 5){
        weapon?.changeVertices(_attack2ind5,isLoop: true);
        gameRef.gameMap.container.add(BossBoom(position: position + (isFlippedHorizontally ? Vector2(45,30) : Vector2(-45,30)),right: isFlippedHorizontally));
      }else if(index == 7){
        weapon?.collisionType = DCollisionType.inactive;
      }
    }else if(animation == animAttack3Loop){
      if(index.isOdd){
        gameRef.gameMap.container.add(FallingCrystal());
      }
      if(index == 0 || index == 1){
        gameRef.gameMap.container.add(BossCircleBoom(false, position: position));
      }
    }
  }

  @override
  void update(double dt)
  {
    // print(hitBox?.collisionType);
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


class BossBoom extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  BossBoom({required super.position, required this.right});
  final List<Vector2> _weapons = [
    Vector2(-22.8436,20.9839)
    ,Vector2(41.0804,26.6124)
    ,Vector2(72.4393,7.71664)
    ,Vector2(73.0423,-11.5812)
    ,Vector2(46.5079,-17.2097)
    ,Vector2(-4.14882,-15.6015)
    ,Vector2(51.3323,-2.13328)
    ,Vector2(35.4519,18.7727)
    ,Vector2(-8.16919,-3.94245)
    ,];

  late DefaultEnemyWeapon _weapon;
  bool right;

  @override
  void onLoad() async
  {
    anchor = const Anchor(0.450142,0.5);
    priority = position.y.toInt() + 26;
    final spriteSheetLoop = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Boss/boss anims-atk1-fx1.png'),
        srcSize: Vector2(174, 149));
    animation = spriteSheetLoop.createAnimation(row: 0, stepTime: 0.1, loop: false);
    animationTicker?.onComplete = removeFromParent;
    _weapon = DefaultEnemyWeapon(
        _weapons,collisionType: DCollisionType.active, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(_weapon);
    _weapon.damage = SceletBoomInfo.damage(gameRef.playerData.playerLevel.value) / 2;
    if(!right){
      flipHorizontally();
    }
  }
}

class BossCircleBoom extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  BossCircleBoom(this.isLong, {required super.position});
  final List<Vector2> _weapons = [
    Vector2(-50.323,13.1202)
    ,Vector2(-62.8435,36.3726)
    ,Vector2(-53.5425,77.1539)
    ,Vector2(-1.6716,82.1621)
    ,Vector2(72.3786,64.6333)
    ,Vector2(42.3293,14.5511)
    ,Vector2(28.3778,66.422)
    ,Vector2(-42.0952,42.0963)
    ,Vector2(22.6541,38.519)
    ,Vector2(17.6458,13.8356)
    ,];

  late DefaultEnemyWeapon _weapon;
  final bool isLong;

  @override
  void onLoad() async
  {
    anchor = const Anchor(0.450142,0.5);
    priority = position.y.toInt() + 82;
    final spriteSheetLoop = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Boss/boss anims-atk3-fx-loop.png'),
        srcSize: Vector2(351, 207));
    animation = spriteSheetLoop.createAnimation(row: 0, stepTime: isLong ? 0.1 : 0.07, loop: false);
    animationTicker?.onComplete = removeFromParent;
    _weapon = DefaultEnemyWeapon(
        _weapons,collisionType: DCollisionType.active, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(_weapon);
    _weapon.damage = SceletBoomInfo.damage(gameRef.playerData.playerLevel.value) / 2;
  }
}

class FallingCrystal extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  FallingCrystal();
  final List<Vector2> _weaponsInd8 = [
    Vector2(-15.7647,41.7777)
    ,Vector2(-0.38695,71.9417)
    ,Vector2(15.9766,41.9748)
    ,Vector2(0.795955,28.7657)
  ];

  final List<Vector2> _weaponsInd9 = [
    Vector2(-0.181489,89.3642)
    ,Vector2(12.8986,62.8599)
    ,Vector2(0.506936,52.8777)
    ,Vector2(-11.8847,61.1388)
    ,];

  final List<Vector2> _weaponsInd10 = [
    Vector2(-12.5379,76.2842)
    ,Vector2(-6.34207,88.6758)
    ,Vector2(3.9843,89.02)
    ,Vector2(11.9012,75.5957)
    ,Vector2(0.197969,69.7441)
    ,];

  late DefaultEnemyWeapon _weapon;

  @override
  void onLoad() async
  {
    position = gameRef.playerPosition() - Vector2(0,89) + Vector2(math.Random().nextDouble() * 200 - 100,math.Random().nextDouble() * 200 - 100) ;
    anchor = Anchor.center;
    priority = position.y.toInt() + 89;
    bool isContrastCrystall = math.Random().nextBool();
    String startString = 'tiles/map/mountainLand/Characters/Boss/';
    final spriteSheetLoop = SpriteSheet(image: await Flame.images.load(
        '$startString${isContrastCrystall ? 'boss atk 3 projectile-1-falling anim.png' : 'boss atk 3 projectile-2-falling anim.png'}'),
        srcSize: Vector2(96, 224));
    animation = spriteSheetLoop.createAnimation(row: 0, stepTime: 0.08, loop: false);
    animationTicker?.onFrame = changeFrames;
    animationTicker?.onComplete = removeFromParent;
    _weapon = DefaultEnemyWeapon(
        _weaponsInd8,collisionType: DCollisionType.inactive, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(_weapon);
    _weapon.damage = SceletBoomInfo.damage(gameRef.playerData.playerLevel.value) / 2;
  }

  void changeFrames(int index)
  {
    if(index == 8){
      _weapon.collisionType = DCollisionType.active;
    }else if(index == 9){
      _weapon.changeVertices(_weaponsInd9, isLoop: true);
    }else if(index == 10){
      _weapon.changeVertices(_weaponsInd10, isLoop: true);
    }else if(index == 11){
      _weapon.collisionType = DCollisionType.inactive;
    }
  }
}
