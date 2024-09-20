import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/abstracts/EnemyInfo.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'dart:math' as math;

class OrcWarrior extends KyrgyzEnemy
{
  OrcWarrior(this._startPos, {required super.level, required super.id, super.loots});
  final Vector2 _startPos;
  late SpriteAnimation _animIdleToMove, _animAttack1FromIdle, _animAttack1FromMove, _animPrepareToAttack2, _postAttack2;
  int _variantOfHit = 0;

  final List<Vector2> _ground = [
    Vector2(-11.4902,13.0381) * PhysicVals.physicScale
    ,Vector2(-14.2391,25.0909) * PhysicVals.physicScale
    ,Vector2(9.97208,24.2451) * PhysicVals.physicScale
    ,Vector2(7.43467,13.3553) * PhysicVals.physicScale
    ,];

  final List<Vector2> hitBoxPoints = [
    Vector2(1.12326,-23.148)
    ,Vector2(-6.93481,-21.7888)
    ,Vector2(-7.32315,-13.4395)
    ,Vector2(-16.6433,-10.527)
    ,Vector2(-17.1288,1.5116)
    ,Vector2(-8.9736,8.50173)
    ,Vector2(-13.9249,18.4044)
    ,Vector2(-13.7308,25.1033)
    ,Vector2(-9.75028,25.0062)
    ,Vector2(-8.09983,19.7636)
    ,Vector2(3.74456,20.0549)
    ,Vector2(5.00666,25.1033)
    ,Vector2(10.1522,25.0062)
    ,Vector2(6.56003,15.0064)
    ,Vector2(10.9289,3.25913)
    ,Vector2(11.123,-10.4299)
    ,Vector2(8.11339,-13.3424)
    ,Vector2(4.42415,-23.148)
    ,];

  final List<Vector2> _attack28Fra = [
    Vector2(-21.7074,11.6941)
    ,Vector2(-34.373,23.2082)
    ,Vector2(-66.9963,28.5815)
    ,Vector2(-75.0562,21.673)
    ,Vector2(-64.6935,13.2293)
    ,Vector2(-50.1089,14.3808)
    ,];

  final List<Vector2> _attack29Fra = [
    Vector2(-85.8424,-28.4123)
    ,Vector2(-70.2406,-22.2738)
    ,Vector2(-74.8444,15.8356)
    ,Vector2(-78.6809,14.8125)
    ,Vector2(-86.8655,-10.2527)
    ,];

  final List<Vector2> _attack210Fra = [
    Vector2(-0.392448,-40.6891)
    ,Vector2(-28.5269,-40.6891)
    ,Vector2(-49.4999,-34.5507)
    ,Vector2(-60.4979,-26.3661)
    ,Vector2(-60.7536,-34.2949)
    ,Vector2(-33.6423,-52.966)
    ,Vector2(-7.04241,-57.5698)
    ,];

  final List<Vector2> _attack1 = [
    Vector2(19.9695,-1.64687)
    ,Vector2(56.7586,-0.989918)
    ,Vector2(41.6488,-22.2313)
    ,Vector2(96.1756,-0.332969)
    ,Vector2(42.3058,29.2297)
    ,Vector2(56.1017,3.82771)
    ,Vector2(19.7505,4.04669)
    ,];

  final List<Vector2> _attack2End0Frame = [
    Vector2(30.3948,-46.2203)
    ,Vector2(41.9284,-34.4944)
    ,Vector2(50.0019,-12.5806)
    ,Vector2(63.2655,-12.7728)
    ,Vector2(69.609,-25.4598)
    ,Vector2(33.2782,-49.4881)
    ,];

  final List<Vector2> _attack2 = [
    Vector2(70.2148,-18.4455)
    ,Vector2(64.3978,19.3653)
    ,Vector2(22.2241,46.5116)
    ,Vector2(-11.7087,52.3286)
    ,Vector2(-47.7416,47.6753)
    ,Vector2(-82.6183,22.1637)
    ,Vector2(-89.3999,-1.73335)
    ,Vector2(-85.1214,-25.8764)
    ,Vector2(-53.6987,-49.007)
    ,Vector2(-7.87407,-56.4262)
    ,Vector2(18.0291,-50.7568)
    ,Vector2(47.3477,-30.4593)
    ,Vector2(69.9005,-1.14072)
    ,];


  @override
  Future<void> onLoad() async
  {
    dopPriority = 26;
    distPlayerLength = 93 * 93;
    shiftAroundAnchorsForHit = 80;
    maxLoots = 2;
    chanceOfLoot = 0.3;
    health = OrcInfo.health(level);
    maxSpeed = OrcInfo.speed;
    armor = OrcInfo.armor(level);
    anchor = const Anchor(0.5,0.5);

    final img = gameRef.gameMap.currentGameWorldData!.isDungeon ?await Flame.images.load('tiles/map/grassLand2/Characters/orc warrior/orc2/orc melee - anims color2-all anims-with fx.png')
        : await Flame.images.load('tiles/map/grassLand2/Characters/orc warrior/orc1/orc melee - all animations with fx.png');
    final spriteSheet = SpriteSheet(image: img, srcSize: Vector2(256,256));

    int seed = DateTime.now().microsecond;
    animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 9,loop: false);
    animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 8,loop: false);
    animHurt = spriteSheet.createAnimation(row: 7, stepTime: 0.06 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 6,loop: false);
    animDeath = spriteSheet.createAnimation(row: 8, stepTime: 0.1 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 12,loop: false);

    _animIdleToMove = spriteSheet.createAnimation(row: 2, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 2,loop: false);
    _animAttack1FromIdle = spriteSheet.createAnimation(row: 3, stepTime: 0.06 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0,to: 15,loop: false);
    _animAttack1FromMove = spriteSheet.createAnimation(row: 3, stepTime: 0.06 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 2, to: 15,loop: false);

    _animPrepareToAttack2 = spriteSheet.createAnimation(row: 4, stepTime: 0.045 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 11,loop: false);
    animAttack2 = spriteSheet.createAnimation(row: 5, stepTime: 0.07 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 4,loop: false);
    _postAttack2 = spriteSheet.createAnimation(row: 6, stepTime: 0.05 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 5,loop: false);

    animation = animIdle;
    animationTicker?.onComplete = selectBehaviour;
    position = _startPos;
    hitBox = EnemyHitbox(hitBoxPoints,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(hitBox!);
    bodyDef.position = _startPos * PhysicVals.physicScale;
    groundBody = Ground(bodyDef, gameRef.world.physicsWorld, isEnemy: true);
    FixtureDef fx = FixtureDef(PolygonShape()..set(_ground));
    groundBody?.createFixture(fx);
    var massData = groundBody!.getMassData();
    massData.mass = 1200;
    groundBody!.setMassData(massData);
    weapon = DefaultEnemyWeapon(_attack1,collisionType: DCollisionType.inactive,isStatic: false,isLoop:true,game: gameRef
        ,isSolid: false,onStartWeaponHit: null,onEndWeaponHit: null);
    weapon!.damage = OrcInfo.damage(level);
    add(weapon!);
    int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(rand == 0){
      flipHorizontally();
    }
    super.onLoad();
    // selectBehaviour();
  }

  @override
  void chooseHit()
  {
    weapon?.currentCoolDown = weapon!.coolDown;
    wasHit = true;
    animation = null;
    speed.x = 0;
    speed.y = 0;
    groundBody?.clearForces();
    _variantOfHit = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(4);
    if(_variantOfHit != 0){
      if(animation == animMove){
        animation = _animAttack1FromMove;
      }else{
        animation = _animAttack1FromIdle;
      }
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      animationTicker?.onComplete = selectBehaviour;
      animationTicker?.onFrame = changeVertsInWeapon;
    }else{
      if(animation == animMove){
        animation = _animIdleToMove.reversed();
        animationTicker?.onComplete = (){
          animation = _animPrepareToAttack2;
          animationTicker?.onFrame = changeVertsInWeapon;
          animationTicker?.onComplete = (){
            animation = animAttack2;
            animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
            animationTicker?.onFrame = changeVertsInWeapon;
            animationTicker?.onComplete = (){
              animation = _postAttack2;
              animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
              animationTicker?.onFrame = changeVertsInWeapon;
              animationTicker?.onComplete = (){
                selectBehaviour();
              };
            };
          };
        };
      }else{
        int countOfCircle = 0;
        animation = _animPrepareToAttack2;
        animationTicker?.onFrame = changeVertsInWeapon;
        animationTicker?.onComplete = (){
          animation = animAttack2;
          animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
          animationTicker?.onFrame = changeVertsInWeapon;
          animationTicker?.onComplete = (){
            if(countOfCircle++ > 5){
              animation = _postAttack2;
              animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
              animationTicker?.onFrame = changeVertsInWeapon;
              animationTicker?.onComplete = (){
                selectBehaviour();
              };
            }else{
              animationTicker?.reset();
            }
          };
        };
      }
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    }
  }

  @override
  void changeVertsInWeapon(int index)
  {
    if(_variantOfHit != 0){ // атака длинная вперёд просто
      if(index == 7){
        weapon?.coolDown = 1;
        weapon!.changeVertices(_attack1,isLoop: true);
        weapon!.collisionType = DCollisionType.active;
      }else if(index > 10){
        weapon!.collisionType = DCollisionType.inactive;
      }
    }else{
      if(animation == _animPrepareToAttack2){
        if(index == 8){
          weapon!.changeVertices(_attack28Fra,isLoop: true);
          weapon!.collisionType = DCollisionType.active;
        }
        if(index == 9){
          weapon!.changeVertices(_attack29Fra,isLoop: true);
        }
        if(index == 10){
          weapon!.changeVertices(_attack210Fra,isLoop: true);
        }
      }else if(animation == animAttack2){
        if(index == 0){
          weapon?.coolDown = 2;
          weapon!.changeVertices(_attack2,isLoop: true);
        }
      }else if(animation == _postAttack2){
        if(index == 0){
          weapon!.changeVertices(_attack2End0Frame,isLoop: true);
        }else{
          weapon!.collisionType = DCollisionType.inactive;
        }
      }
    }
  }

  @override
  void update(double dt) {
    if(isFreeze > 0){
      return;
    }
    super.update(dt);
    if (!isRefresh) {
      return;
    }
    position = groundBody!.position / PhysicVals.physicScale;
    if (animation == animMove || animation == animIdle) {
      groundBody?.applyLinearImpulse(speed * dt * groundBody!.mass);
    }
  }
}