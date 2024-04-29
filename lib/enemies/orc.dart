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
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'dart:math' as math;
import 'package:game_flame/kyrgyz_game.dart';

class Orc extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>,KyrgyzEnemy
{
  Orc(this._startPos);
  late SpriteAnimation _animMove, _animIdle, _animAttack,_animAttack2, _animHurt, _animDeath;
  late SpriteAnimation _animMoveShield, _animIdleShield, _animAttackShield, _animAttack2Shield,_animHurtShield,_animBlock, _animThrowShield, _animDeathShield;
  late EnemyHitbox _hitbox;
  late GroundHitBox _groundBox;
  late Ground _ground;
  final Vector2 _spriteSheetSize = Vector2(256,256);
  final Vector2 _startPos;
  final Vector2 _speed = Vector2(0,0);
  final double _maxSpeed = 70;
  bool _wasHit = false;
  late DefaultEnemyWeapon _defWeapon;
  int _variantOfHit = 0;
  bool _withShieldNow = false;

  final List<Vector2> _groundBoxPoint = [
    Vector2(-12.7688,24.3802)
    ,Vector2(-12.657,13.0969)
    ,Vector2(9.57438,12.8735)
    ,Vector2(9.79781,24.6036)
  ];

  final List<Vector2> _hitBoxPoints = [
    Vector2(-12.5261,24.0219)
    ,Vector2(-12.6612,-11.3823)
    ,Vector2(-5.6344,-21.382)
    ,Vector2(-0.769701,-23.8143)
    ,Vector2(4.90578,-18.5442)
    ,Vector2(9.50022,-11.1121)
    ,Vector2(9.63535,24.4273)
  ];

  final List<Vector2> _attack6indPoints = [
    Vector2(-33.9283,-0.090098)
    ,Vector2(29.6762,-1.49459)
    ,Vector2(29.6079,4.45102)
    ,Vector2(-33.9486,2.81085)
  ];

  final List<Vector2> _attack7indPoints = [
    Vector2(33.6384,-0.780144)
    ,Vector2(60.1689,-0.780144)
    ,Vector2(60.1689,-5.40472)
    ,Vector2(40.9404,-21.5907)
    ,Vector2(79.8842,-11.9765)
    ,Vector2(94.9749,-0.0499483)
    ,Vector2(71.0001,22.0993)
    ,Vector2(41.0621,28.7928)
    ,Vector2(61.0208,10.903)
    ,Vector2(56.5179,3.60103)
    ,Vector2(33.5167,3.60103)
    ,];

  final List<Vector2> _attackUntil13Points = [
    Vector2(29.9799,-0.239536)
    ,Vector2(55.7717,-0.361627)
    ,Vector2(59.8169,-7.59391)
    ,Vector2(62.5969,-2.60762)
    ,Vector2(76.716,-0.731025)
    ,Vector2(78.9054,1.50301)
    ,Vector2(76.6267,4.58599)
    ,Vector2(62.1501,5.88173)
    ,Vector2(59.648,10.5285)
    ,Vector2(55.2201,3.13193)
    ,Vector2(30.1587,2.84344)
    ,];

  final List<Vector2> _attackStartCircle1Points = [
    Vector2(-29.5755,8.6857)
    ,Vector2(-34.0515,8.6857)
    ,Vector2(-43.0034,12.778)
    ,Vector2(-61.291,13.0338)
    ,Vector2(-75.2305,19.8117)
    ,Vector2(-72.0334,25.9502)
    ,Vector2(-51.0602,27.1012)
    ,Vector2(-34.1794,22.4973)
    ,Vector2(-22.286,12.1386)
    ,];

  final List<Vector2> _attackStartCircle2Points = [
    Vector2(-70.1093,-21.3481)
    ,Vector2(-68.8995,-8.04021)
    ,Vector2(-75.8127,15.119)
    ,Vector2(-81.6889,8.8971)
    ,Vector2(-86.5281,-11.324)
    ,Vector2(-86.3553,-27.3971)
    ,];

  final List<Vector2> _attackStartCircle3Points = [
    Vector2(-60.6553,-26.8065)
    ,Vector2(-59.7585,-34.5788)
    ,Vector2(-39.2814,-51.1698)
    ,Vector2(-7.89315,-57.1485)
    ,Vector2(-1.91444,-41.006)
    ,Vector2(-6.24901,-36.8209)
    ,Vector2(-14.7687,-39.8102)
    ,Vector2(-35.0963,-39.6607)
    ,Vector2(-49.2957,-35.4756)
    ,];

  final List<Vector2> _attackCirclePoints = [
    Vector2(64.6976,-19.6358)
    ,Vector2(69.7391,-0.633043)
    ,Vector2(52.2876,33.8822)
    ,Vector2(8.07715,52.1093)
    ,Vector2(-12.089,52.1093)
    ,Vector2(-57.8957,43.0391)
    ,Vector2(-82.9778,23.4204)
    ,Vector2(-91.1729,-1.91006)
    ,Vector2(-85.0171,-24.8731)
    ,Vector2(-55.0731,-50.1829)
    ,Vector2(-8.37475,-56.956)
    ,Vector2(23.4182,-50.353)
    ,Vector2(50.8971,-34.6237)
    ,Vector2(67.6409,-9.71517)
    ,];

  @override
  Future<void> onLoad() async
  {
    maxLoots = 2;
    chanceOfLoot = 0.07;
    health = 3;
    setChance();
    int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    Image? spriteImage;
    if(rand == 0){
      spriteImage = await Flame.images.load(
          'assets/tiles/map/grassLand2/Characters/orc warrior/orc1/orc melee - all animations with fx.png'
      );
    }else{
      spriteImage = await Flame.images.load(
          'assets/tiles/map/grassLand2/Characters/orc warrior/orc2/orc melee - anims color2-all anims-with fx.png'
      );
    }
    anchor = const Anchor(0.5,0.5);
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _spriteSheetSize);
    _animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8,loop: false);
    _animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 8,loop: false);
    _animAttack = spriteSheet.createAnimation(row: 2, stepTime: 0.08, from: 0,loop: false);
    _animAttack2 = spriteSheet.createAnimation(row: 3, stepTime: 0.08, from: 0, to: 13, loop: false);
    _animHurt = spriteSheet.createAnimation(row: 4, stepTime: 0.07, from: 0, to: 8,loop: false);
    _animDeath = spriteSheet.createAnimation(row: 5, stepTime: 0.1, from: 0, to: 13,loop: false);

    animation = _withShieldNow ? _animIdleShield : _animIdle;
    size = _spriteSheetSize;
    position = _startPos;
    _hitbox = EnemyHitbox(_hitBoxPoints,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(_hitbox);
    _groundBox = GroundHitBox(getPointsForActivs(Vector2(-11,127-110), Vector2(22,21)) ,obstacleBehavoiurStart: (Set<Vector2> intersectionPoints, DCollisionEntity other){
      obstacleBehaviour(intersectionPoints, other, _groundBox, this);
    },
        collisionType: DCollisionType.active,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(_groundBox);
    // _groundBox.debugColor = BasicPalette.red.color;
    _ground = Ground(getPointsForActivs(Vector2(-11,127-110), Vector2(22,21))
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
    _defWeapon = DefaultEnemyWeapon(_attack1PointsOnStart,collisionType: DCollisionType.inactive,isStatic: false,isLoop:true,game: gameRef
        ,isSolid: false,onStartWeaponHit: null,onEndWeaponHit: null);
    _defWeapon.damage = 3;
    add(_defWeapon);
    rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(rand == 0){
      flipHorizontally();
    }
    selectBehaviour();
  }

  void chooseHit()
  {
    _defWeapon.currentCoolDown = _defWeapon.coolDown;
    _wasHit = true;
    animation = null;
    _speed.x = 0;
    _speed.y = 0;
    _variantOfHit = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(_variantOfHit == 0){
      animation = _withShieldNow ? _animAttackShield : _animAttack;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    }else{
      animation = _withShieldNow ? _animAttack2Shield : _animAttack2;
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

  void selectBehaviour()
  {
    if(gameRef.gameMap.orthoPlayer == null){
      return;
    }
    if (isNearPlayer()) {
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
    int random = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(random != 0 || _wasHit){
      int shift = 0;
      if(position.x < gameRef.gameMap.orthoPlayer!.position.x){
        shift = -50;
      }else{
        shift = 50;
      }
      double posX = gameRef.gameMap.orthoPlayer!.position.x - position.x + shift;
      double posY = gameRef.gameMap.orthoPlayer!.position.y - position.y;
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
    }else{
      if(animation != _animIdle && animation != _animIdleShield){
        _speed.x = 0;
        _speed.y = 0;
        animation = _withShieldNow ? _animIdleShield : _animIdle;
      }
    }
    animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    animationTicker?.onComplete = selectBehaviour;
  }

  bool isNearPlayer()
  {
    var pl = gameRef.gameMap.orthoPlayer!;
    if(pl.hitBox == null){
      return false;
    }
    if(position.distanceToSquared(pl.position) > math.pow(_hitbox.width * 0.5 + 60,2)){
      return false;
    }
    if(pl.hitBox!.getMinVector().y > _hitbox.getMaxVector().y || pl.hitBox!.getMaxVector().y < _hitbox.getMinVector().y){
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
    _defWeapon.collisionType = DCollisionType.inactive;
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
    _groundBox.collisionType = DCollisionType.inactive;
    _ground.collisionType = DCollisionType.inactive;
    // removeAll(children);
    if(loots.isNotEmpty) {
      if (loots.length > 1) {
        var temp = Chest(
            0, myItems: loots, position: positionOfAnchor(Anchor.center));
        gameRef.gameMap.enemyComponent.add(temp);
      } else {
        var temp = LootOnMap(
            loots.first, position: positionOfAnchor(Anchor.center));
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
    if(_groundBox.getMaxVector().y > gameRef.gameMap.orthoPlayer!.groundBox!.getMaxVector().y){
      parent = gameRef.gameMap.enemyOnPlayer;
    }else{
      parent = gameRef.gameMap.enemyComponent;
    }
    if (animation == _animMoveShield || animation == _animMove
        || animation == _animIdleShield || animation == _animIdle) {
      position += _speed * dt;
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


}