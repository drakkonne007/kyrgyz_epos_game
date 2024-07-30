import 'dart:ui';
import 'package:flame/components.dart';
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
import 'package:game_flame/abstracts/item.dart';
import 'dart:math' as math;
import 'package:game_flame/kyrgyz_game.dart';

class SkeletonMage extends KyrgyzEnemy
{
  SkeletonMage(this._startPos,int id,{this.isHigh = false}){this.id = id;}
  late SpriteAnimation _animMoveShield, _animIdleShield, _animAttackStartShield, _animAttackEndShield,_animAttackLongShield,_animHurtShield,_animBlock, _animThrowShield, _animDeathShield, animAttackStart, animAttackEnd, animAttackLong, animBlock, animThrow;
  final Vector2 _spriteSheetSize = Vector2(220,220);
  final Vector2 _startPos;
  bool isHigh;
  int _variantOfHit = 0;
  bool _withShieldNow = false;
  final double dist = 352 * 352;

  final List<Vector2> hitBoxPoints = [
    Vector2(113-115,103-110),
    Vector2(109-115,114-110),
    Vector2(100-115,118-110),
    Vector2(101-115,148-110),
    Vector2(122-115,148-110),
    Vector2(124-115,108-110),
    Vector2(120-115,103-110)
  ];

  @override
  Future<void> onLoad() async
  {
    maxLoots = 2;
    chanceOfLoot = 0.12;
    health = 9;
    anchor = const Anchor(115/220,0.5);
    maxSpeed = 55;
    super.onLoad();
    Image? spriteImage;
    Image? spriteImageWithShield;
    if(isHigh){
      priority = GamePriority.high + 1;
    }

    int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    _withShieldNow = rand == 0 ? false : true;
    if(_withShieldNow){
      health = 4;
    }
    if (rand == 0) {
      spriteImage = await Flame.images.load(
          'tiles/map/prisonSet/Characters/Mage Skeleton/Mage Skeleton no shield/Mage Skeleton - all animations.png');
    }else{
      spriteImage = await Flame.images.load(
          'tiles/map/prisonSet/Characters/Mage Skeleton/Mage Skeleton no shield/Mage Skeleton - all animations.png');
    }
    if (rand == 0) {
      spriteImageWithShield = await Flame.images.load(
          'tiles/map/prisonSet/Characters/Mage Skeleton/Mage Skeleton with shield/Mage Skeleton - all animations.png');
    } else {
      spriteImageWithShield = await Flame.images.load(
          'tiles/map/prisonSet/Characters/Mage Skeleton/Mage Skeleton with shield/with rusty shield/Mage Skeleton - all animations-with rusty shield.png');
    }
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _spriteSheetSize);
    final spriteSheetWithShield = SpriteSheet(image: spriteImageWithShield,
        srcSize: _spriteSheetSize);

    animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8,loop: false);
    animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 8,loop: false);
    animAttackStart = spriteSheet.createAnimation(row: 2, stepTime: 0.08, from: 0,to: 6,loop: false);
    animAttackLong = spriteSheet.createAnimation(row: 3, stepTime: 0.08, from: 0, to: 8,loop: false);
    animAttackEnd = spriteSheet.createAnimation(row: 4, stepTime: 0.08, from: 0, to: 7, loop: false);
    animHurt = spriteSheet.createAnimation(row: 6, stepTime: 0.07, from: 0, to: 8,loop: false);
    animDeath = spriteSheet.createAnimation(row: 7, stepTime: 0.1, from: 0, to: 13,loop: false);

    _animIdleShield = spriteSheetWithShield.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8,loop: false);
    _animMoveShield = spriteSheetWithShield.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 8,loop: false);
    _animAttackStartShield = spriteSheetWithShield.createAnimation(row: 2, stepTime: 0.08, from: 0,to: 6,loop: false);
    _animAttackLongShield = spriteSheetWithShield.createAnimation(row: 3, stepTime: 0.08, from: 0, to: 8,loop: false);
    _animAttackEndShield = spriteSheetWithShield.createAnimation(row: 4, stepTime: 0.08, from: 0, to: 7, loop: false);
    _animBlock = spriteSheetWithShield.createAnimation(row: 5, stepTime: 0.07, from: 0, to: 8,loop: false);
    _animHurtShield = spriteSheetWithShield.createAnimation(row: 6, stepTime: 0.07, from: 0, to: 8,loop: false);
    _animThrowShield = spriteSheetWithShield.createAnimation(row: 7, stepTime: 0.07, from: 0, to: 8,loop: false);
    _animDeathShield = spriteSheetWithShield.createAnimation(row: 8, stepTime: 0.1, from: 0, to: 13,loop: false);

    animation = _withShieldNow ? _animIdleShield : animIdle;
    animationTicker?.onComplete = selectBehaviour;
    size = _spriteSheetSize;
    position = _startPos;
    hitBox = EnemyHitbox(hitBoxPoints,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(hitBox!);
    bodyDef.position = _startPos * PhysicVals.physicScale;
    var temUs = bodyDef.userData as BodyUserData;
    temUs.onBeginMyContact = onGround;
    groundBody = Ground(bodyDef, gameRef.world.physicsWorld, isEnemy: true);
    FixtureDef fx = FixtureDef(PolygonShape()..set(getPointsForActivs(Vector2(100-115,132-110), Vector2(24,16), scale: PhysicVals.physicScale)));
    groundBody?.createFixture(fx);
    var massData = groundBody!.getMassData();
    massData.mass = 800;
    groundBody!.setMassData(massData);
    rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(rand == 0){
      flipHorizontally();
    }
  }

  @override
  void doMagicHurt({required double hurt, required MagicDamage magicDamage}) {
    health -= hurt;
    if(health < 1){
      death(_withShieldNow ? _animDeathShield : animDeath);
    }
  }

  void chooseHit()
  {
    animation = null;
    _variantOfHit = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(3);
    if(_variantOfHit == 0){
      animation = _withShieldNow ? _animAttackLongShield :  animAttackLong;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      animationTicker?.onFrame = longAttack;
      animationTicker?.onComplete = endHit;
    }else{
      if(isFlippedHorizontally){
        gameRef.gameMap.container.add(MageSphere(position + Vector2(-48,22)));
      }else{
        gameRef.gameMap.container.add(MageSphere(position + Vector2(48,22)));
      }
      endHit();
    }
  }

  void longAttack(int index)
  {
    if(index % 2 == 0){
      return;
    }
    if(isFlippedHorizontally){
      gameRef.gameMap.container.add(MageSphere(position + Vector2(-48,22)));
    }else{
      gameRef.gameMap.container.add(MageSphere(position + Vector2(48,22)));
    }
  }

  void endHit()
  {
    animation = _withShieldNow ? _animAttackEndShield : animAttackEnd;
    animationTicker?.onComplete = selectBehaviour;
  }

  @override
  void moveIdleRandom(bool isSee){

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
      if (position.distanceToSquared(gameRef.gameMap.orthoPlayer!.position) <
          100 * 100) {
        // _rigidSec = 0.8;
        double posX = position.x - gameRef.gameMap.orthoPlayer!.position.x;
        double posY = position.y - gameRef.gameMap.orthoPlayer!.position.y;
        if (whereObstacle == ObstacleWhere.side) {
          posX = 0;
        }
        if (whereObstacle == ObstacleWhere.upDown && posY < 0) {
          posY = 0;
        }
        whereObstacle = ObstacleWhere.none;
        double angle = math.atan2(posY, posX);
        speed.x = math.cos(angle) * maxSpeed;
        speed.y = math.sin(angle) * maxSpeed;
        if (speed.x < 0 && !isFlippedHorizontally) {
          flipHorizontally();
        } else if (speed.x > 0 && isFlippedHorizontally) {
          flipHorizontally();
        }
        animation = _withShieldNow ? _animMoveShield : animMove;
        animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
        animationTicker?.onComplete = selectBehaviour;
        return;
      }
      speed.x = 0;
      speed.y = 0;
      groundBody?.clearForces();
      if (isNearPlayer(dist)) {
        animation = _withShieldNow ? _animAttackStartShield : animAttackStart;
        animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
        animationTicker?.onComplete = chooseHit;
        if (position.x < gameRef.gameMap.orthoPlayer!.position.x &&
            isFlippedHorizontally) {
          flipHorizontally();
        } else if (position.x > gameRef.gameMap.orthoPlayer!.position.x &&
            !isFlippedHorizontally) {
          flipHorizontally();
        }
        return;
      }
      animation = _withShieldNow ? _animIdleShield : animIdle;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      animationTicker?.onComplete = selectBehaviour;
    }else{
      animation = _withShieldNow ? _animIdleShield : animIdle;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      animationTicker?.onComplete = selectBehaviour;
    }
  }

  @override
  bool isNearPlayer(double dist)
  {
    var pl = gameRef.gameMap.orthoPlayer!;
    if(pl.hitBox == null){
      return false;
    }
    if(position.distanceToSquared(pl.position) > dist){
      return false;
    }
    return true;
  }

  @override
  void doHurt({required double hurt, bool inArmor = true, bool isPlayer = false})
  {
    if(isPlayer){
      wasSeen = true;
    }
    if(animation == animDeath || animation == _animDeathShield){
      return;
    }
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
  void update(double dt)
  {
    if (!isRefresh) {
      return;
    }
    super.update(dt);
    if(!isHigh) {
      int pos = position.y.toInt();
      if (pos <= 0) {
        pos = 1;
      }
      priority = pos;
    }
    position = groundBody!.position / PhysicVals.physicScale;
    if (animation == _animMoveShield || animation == animMove
        || animation == _animIdleShield || animation == animIdle) {
      groundBody?.applyLinearImpulse(speed * dt * groundBody!.mass);
    }
  }
}

class MageSphere extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  final Vector2 pos;
  MageSphere(this.pos) : super(position: pos);
  late DefaultEnemyWeapon _weapon;
  late SpriteAnimation _animLoop,_animDestroy,_animDestroy2;
  final double maxSpeed = 80;
  bool _isMove = true;
  final Vector2 speed = Vector2.zero();
  bool _isAutoAim = true;

  @override
  void onLoad() async
  {
    priority = GamePriority.maxPriority + 1;
    anchor = const Anchor(0.5,35/64);
    _weapon = DefaultEnemyWeapon([Vector2.zero()], collisionType: DCollisionType.active, radius: 10
      , isStatic: false, onObstacle: destroy, onStartWeaponHit: null, onEndWeaponHit: null, game: gameRef,isSolid: true,);
    add(_weapon);
    _weapon.damage = 1;

    Image imgLoop   = await Flame.images.load('tiles/map/prisonSet/Characters/Mage Skeleton/Mage Skeleton -projectile-loop.png');
    Image imgDestr1 = await Flame.images.load('tiles/map/prisonSet/Characters/Mage Skeleton/Mage Skeleton -projectile-destroy.png');
    Image imgDestr2 = await Flame.images.load('tiles/map/prisonSet/Characters/Mage Skeleton/Mage Skeleton -projectile-destroy2.png');

    final spriteSheetLoop = SpriteSheet(image: imgLoop,
        srcSize: Vector2(92,64));
    _animLoop = spriteSheetLoop.createAnimation(row: 0, stepTime: 0.1,loop: true);

    final spriteSheetDestroy = SpriteSheet(image: imgDestr1,
        srcSize: Vector2(92,64));
    _animDestroy = spriteSheetDestroy.createAnimation(row: 0, stepTime: 0.07,loop: false);

    final spriteSheetDestroy2 = SpriteSheet(image: imgDestr2,
        srcSize: Vector2(92,64));
    _animDestroy2 = spriteSheetDestroy2.createAnimation(row: 0, stepTime: 0.07,loop: false);

    animation = _animLoop;

    add(TimerComponent(period: 2,onTick: (){_isAutoAim = false;}));
    add(TimerComponent(period: 4,onTick: destroy));
  }

  void destroy()
  {
    _isMove = false;
    _weapon.collisionType = DCollisionType.inactive;
    int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(rand == 0){
      animation = _animDestroy;
    }else{
      animation = _animDestroy2;
    }
    animationTicker?.onComplete = removeFromParent;
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    // int pos = position.y.toInt();
    // if(pos <= 0){
    //   pos = 1;
    // }
    // priority = pos;
    if(!_isMove){
      return;
    }
    if(_isAutoAim && gameRef.gameMap.orthoPlayer != null){
      double posX = gameRef.gameMap.orthoPlayer!.position.x - position.x;
      double posY = gameRef.gameMap.orthoPlayer!.position.y - position.y;
      double angle = math.atan2(posY,posX);
      speed.x = math.cos(angle) * maxSpeed;
      speed.y = math.sin(angle) * maxSpeed;
    }
    position += speed * dt;
  }
}
