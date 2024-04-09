import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/abstracts/dVector2.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/enemies/skeleton.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'dart:math' as math;
import 'package:game_flame/kyrgyz_game.dart';

class SkeletonMage extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>, KyrgyzEnemy
{
  SkeletonMage(this._startPos,{this.isHigh = false});
  late SpriteAnimation _animMove, _animIdle, _animAttackStart,_animAttackEnd,_animAttackLong, _animHurt, _animDeath;
  late SpriteAnimation _animMoveShield, _animIdleShield, _animAttackStartShield, _animAttackEndShield,_animAttackLongShield,_animHurtShield,_animBlock, _animThrowShield, _animDeathShield;
  late EnemyHitbox _hitbox;
  late GroundHitBox _groundBox;
  late Ground _ground;
  final Vector2 _spriteSheetSize = Vector2(220,220);
  final Vector2 _startPos;
  final Vector2 _speed = Vector2(0,0);
  final double _maxSpeed = 70;
  bool isHigh;
  int _variantOfHit = 0;
  bool _withShieldNow = false;

  final List<dVector2> _hitBoxPoints = [
    dVector2(113-115,103-110),
    dVector2(109-115,114-110),
    dVector2(100-115,118-110),
    dVector2(101-115,148-110),
    dVector2(122-115,148-110),
    dVector2(124-115,108-110),
    dVector2(120-115,103-110)
  ];

  @override
  Future<void> onLoad() async
  {
    maxLoots = 2;
    chanceOfLoot = 0.12;
    health = 3;
    setChance();
    anchor = const Anchor(115/220,0.5);
    Image? spriteImage;
    Image? spriteImageWithShield;

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

    _animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8,loop: false);
    _animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 8,loop: false);
    _animAttackStart = spriteSheet.createAnimation(row: 2, stepTime: 0.08, from: 0,to: 6,loop: false);
    _animAttackLong = spriteSheet.createAnimation(row: 3, stepTime: 0.08, from: 0, to: 8,loop: false);
    _animAttackEnd = spriteSheet.createAnimation(row: 4, stepTime: 0.08, from: 0, to: 7, loop: false);
    _animHurt = spriteSheet.createAnimation(row: 6, stepTime: 0.07, from: 0, to: 8,loop: false);
    _animDeath = spriteSheet.createAnimation(row: 7, stepTime: 0.1, from: 0, to: 13,loop: false);

    _animIdleShield = spriteSheetWithShield.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8,loop: false);
    _animMoveShield = spriteSheetWithShield.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 8,loop: false);
    _animAttackStartShield = spriteSheetWithShield.createAnimation(row: 2, stepTime: 0.08, from: 0,to: 6,loop: false);
    _animAttackLongShield = spriteSheetWithShield.createAnimation(row: 3, stepTime: 0.08, from: 0, to: 8,loop: false);
    _animAttackEndShield = spriteSheetWithShield.createAnimation(row: 4, stepTime: 0.08, from: 0, to: 7, loop: false);
    _animBlock = spriteSheetWithShield.createAnimation(row: 5, stepTime: 0.07, from: 0, to: 8,loop: false);
    _animHurtShield = spriteSheetWithShield.createAnimation(row: 6, stepTime: 0.07, from: 0, to: 8,loop: false);
    _animThrowShield = spriteSheetWithShield.createAnimation(row: 7, stepTime: 0.07, from: 0, to: 8,loop: false);
    _animDeathShield = spriteSheetWithShield.createAnimation(row: 8, stepTime: 0.1, from: 0, to: 13,loop: false);

    animation = _withShieldNow ? _animIdleShield : _animIdle;
    size = _spriteSheetSize;
    position = _startPos;
    _hitbox = EnemyHitbox(_hitBoxPoints,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(_hitbox);
    _groundBox = GroundHitBox(getPointsForActivs(dVector2(100-115,132-110), dVector2(24,16)) ,obstacleBehavoiurStart: (Set<dVector2> intersectionPoints, DCollisionEntity other){
      obstacleBehaviour(intersectionPoints, other, _groundBox, this);
    },
        collisionType: DCollisionType.active,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(_groundBox);
    // _groundBox.debugColor = BasicPalette.red.color;
    _ground = Ground(getPointsForActivs(dVector2(100-115,132-110), dVector2(24,16))
        , collisionType: DCollisionType.passive, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    _ground.onlyForPlayer = true;
    add(_ground);
    add(TimerComponent(onTick: () {
      if (!checkIsNeedSelfRemove(position.x ~/
          gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x
          , position.y ~/
              gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y
          , gameRef, _startPos, this)) {
        animation = _withShieldNow ? _animIdleShield : _animIdle;
        animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      }
    },repeat: true,period: 2));
    rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(rand == 0){
      flipHorizontally();
    }
    selectBehaviour();
  }

  @override
  void doMagicHurt({required double hurt, required MagicDamage magicDamage}) {
    health -= hurt;
    if(health < 1){
      death();
    }
  }

  @override
  void render(Canvas canvas)
  {
    super.render(canvas);
    if(magicDamages.isNotEmpty){
      var shader = gameRef.telepShader;
      shader.setFloat(0,gameRef.gameMap.shaderTime);
      shader.setFloat(1, 1); //scalse
      shader.setFloat(2, 0); //offsetX
      shader.setFloat(3, 0);
      shader.setFloat(4,math.max(size.x,30)); //size
      shader.setFloat(5,math.max(size.y,30));
      final paint = Paint()..shader = shader;
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          0,
          math.max(size.x,30),
          math.max(size.y,30),
        ),
        paint,
      );
    }
  }

  void chooseHit()
  {
    animation = null;
    _variantOfHit = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(3);
    if(_variantOfHit == 0){
      animation = _withShieldNow ? _animAttackLongShield :  _animAttackLong;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      animationTicker?.onFrame = longAttack;
      animationTicker?.onComplete = endHit;
    }else{
      if(isFlippedHorizontally){
        gameRef.gameMap.priorityHighMinus1.add(MageSphere(position + Vector2(-48,22)));
      }else{
        gameRef.gameMap.priorityHighMinus1.add(MageSphere(position + Vector2(48,22)));
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
      gameRef.gameMap.priorityHighMinus1.add(MageSphere(position + Vector2(-48,22)));
    }else{
      gameRef.gameMap.priorityHighMinus1.add(MageSphere(position + Vector2(48,22)));
    }
  }

  void endHit()
  {
    animation = _withShieldNow ? _animAttackEndShield : _animAttackEnd;
    animationTicker?.onComplete = selectBehaviour;
  }

  void selectBehaviour()
  {
    if(gameRef.gameMap.orthoPlayer == null){
      return;
    }
    if(position.distanceToSquared(gameRef.gameMap.orthoPlayer!.position) < 100 * 100){
      // _rigidSec = 0.8;
      double posX = position.x - gameRef.gameMap.orthoPlayer!.position.x;
      double posY = position.y - gameRef.gameMap.orthoPlayer!.position.y;
      if(whereObstacle == ObstacleWhere.side){
        posX = 0;
      }
      if(whereObstacle == ObstacleWhere.upDown && posY < 0){
        posY = 0;
      }
      whereObstacle = ObstacleWhere.none;
      double angle = math.atan2(posY,posX);
      _speed.x = math.cos(angle) * _maxSpeed;
      _speed.y = math.sin(angle) * _maxSpeed;
      if(_speed.x < 0 && !isFlippedHorizontally){
        flipHorizontally();
      }else if(_speed.x > 0 && isFlippedHorizontally){
        flipHorizontally();
      }
      animation = _withShieldNow ? _animMoveShield : _animMove;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      animationTicker?.onComplete = selectBehaviour;
      return;
    }
    _speed.x = 0;
    _speed.y = 0;
    if(isNearPlayer()){
      animation = _withShieldNow ? _animAttackStartShield : _animAttackStart;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      animationTicker?.onComplete = chooseHit;
      if(position.x < gameRef.gameMap.orthoPlayer!.position.x && isFlippedHorizontally){
        flipHorizontally();
      }else if(position.x > gameRef.gameMap.orthoPlayer!.position.x && !isFlippedHorizontally){
        flipHorizontally();
      }
      return;
    }
    animation = _withShieldNow ? _animIdleShield : _animIdle;
    animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    animationTicker?.onComplete = selectBehaviour;
  }

  bool isNearPlayer()
  {
    var pl = gameRef.gameMap.orthoPlayer!;
    if(pl.hitBox == null){
      return false;
    }
    if(position.distanceToSquared(pl.position) > 352 * 352){
      return false;
    }
    return true;
  }

  @override
  void doHurt({required double hurt, bool inArmor = true})
  {
    if(animation == _animDeath || animation == _animDeathShield){
      return;
    }
    animation = null;
    if(inArmor){
      if(_withShieldNow && ((position.x < gameRef.gameMap.orthoPlayer!.position.x && !isFlippedHorizontally)
          || (position.x > gameRef.gameMap.orthoPlayer!.position.x && isFlippedHorizontally))){
        int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(3);
        if(rand == 0){
          _speed.x = 0;
          _speed.y = 0;
          animation = _animBlock;
          animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
          animationTicker?.onComplete = selectBehaviour;
          return;
        }
      }
      health -= math.max(hurt - armor, 0);
    }else{
      health -= hurt;
    }
    if(health <1){
      death();
    }else{
      if(_withShieldNow){
        int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(3);
        if (rand == 0) {
          _withShieldNow = false;
          _speed.x = 0;
          _speed.y = 0;
          animation = _animThrowShield;
          animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
          animationTicker?.onComplete = selectBehaviour;
          animationTicker?.onFrame = dropShield;
          return;
        }
      }
      animation = _withShieldNow ? _animHurtShield : _animHurt;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      animationTicker?.onComplete = selectBehaviour;
    }
  }

  void death()
  {
    _speed.x = 0;
    _speed.y = 0;
    _hitbox.removeFromParent();
    _ground.collisionType = DCollisionType.inactive;
    // removeAll(children);
    if(loots.isNotEmpty) {
      if(loots.length > 1){
        var temp = Chest(0, myItems: loots, position: positionOfAnchor(Anchor.center));
        gameRef.gameMap.enemyComponent.add(temp);
      }else{
        var temp = LootOnMap(loots.first, position: positionOfAnchor(Anchor.center));
        gameRef.gameMap.enemyComponent.add(temp);
      }
    }
    animation = _withShieldNow ? _animDeathShield : _animDeath;
    animationTicker?.onComplete = () {
      add(OpacityEffect.by(-1,EffectController(duration: animationTicker?.totalDuration()),onComplete: (){
        gameRef.gameMap.loadedLivesObjs.remove(_startPos);
        removeFromParent();
      }));
    };
  }

  void dropShield(int index)
  {
    if(index == 4){
      DroppedShield droppedShield = DroppedShield(position,isFlippedHorizontally);
      gameRef.gameMap.enemyComponent.add(droppedShield);
    }
  }

  @override
  void update(double dt) {
    if (!isRefresh) {
      return;
    }
    super.update(dt);
    if(!isHigh) {
      if (_groundBox
          .getMaxVector()
          .y > gameRef.gameMap.orthoPlayer!.groundBox!.getMaxVector().y) {
        parent = gameRef.gameMap.enemyOnPlayer;
      } else {
        parent = gameRef.gameMap.enemyComponent;
      }
    }
    if (animation == _animMoveShield || animation == _animMove
        || animation == _animIdleShield || animation == _animIdle) {
      position += _speed * dt;
    }
  }
}

class MageSphere extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  final Vector2 pos;
  MageSphere(this.pos) : super(position: pos);
  late DefaultEnemyWeapon _weapon;
  late SpriteAnimation _animLoop,_animDestroy,_animDestroy2;
  final double _maxSpeed = 80;
  bool _isMove = true;
  final Vector2 _speed = Vector2.zero();
  bool _isAutoAim = true;

  @override
  void onLoad() async
  {
    anchor = const Anchor(0.5,35/64);
    _weapon = DefaultEnemyWeapon([dVector2.zero()], collisionType: DCollisionType.active, radius: 10
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
    if(!_isMove){
      return;
    }
    if(_isAutoAim && gameRef.gameMap.orthoPlayer != null){
      double posX = gameRef.gameMap.orthoPlayer!.position.x - position.x;
      double posY = gameRef.gameMap.orthoPlayer!.position.y - position.y;
      double angle = math.atan2(posY,posX);
      _speed.x = math.cos(angle) * _maxSpeed;
      _speed.y = math.sin(angle) * _maxSpeed;
    }
    position += _speed * dt;
  }
}
