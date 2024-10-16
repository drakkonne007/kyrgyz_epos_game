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
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'dart:math' as math;

enum MooseVariant
{
  Wool,
  WoolWithGreenHair,
  Blue,
  BlueWithGreenHair,
  Purple,
  PurpleWithGreenHair,
}

final List<Vector2> ind1 = [ //3 индекс и по 7
  Vector2(1105 - 3 * 347 - 158,446 - 192*2 - 96),
  Vector2(1115 - 3 * 347 - 158,423 - 192*2 - 96),
  Vector2(1129 - 3 * 347 - 158,420 - 192*2 - 96),
  Vector2(1143 - 3 * 347 - 158,429 - 192*2 - 96),
  Vector2(1140 - 3 * 347 - 158,442 - 192*2 - 96),
  Vector2(1174 - 3 * 347 - 158,460 - 192*2 - 96),
  Vector2(1173 - 3 * 347 - 158,464 - 192*2 - 96),
  Vector2(1135 - 3 * 347 - 158,446 - 192*2 - 96),
  Vector2(1132 - 3 * 347 - 158,451 - 192*2 - 96),
  Vector2(1121 - 3 * 347 - 158,454 - 192*2 - 96),
];

final List<Vector2> ind2 = [ //3 индекс и по 7
  Vector2(2510 - 7 * 347 - 158,445 - 192*2 - 96),
  Vector2(2501 - 7 * 347 - 158,440 - 192*2 - 96),
  Vector2(2526 - 7 * 347 - 158,409 - 192*2 - 96),
  Vector2(2545 - 7 * 347 - 158,396 - 192*2 - 96),
  Vector2(2553 - 7 * 347 - 158,396 - 192*2 - 96),
  Vector2(2564 - 7 * 347 - 158,414 - 192*2 - 96),
  Vector2(2557 - 7 * 347 - 158,420 - 192*2 - 96),
  Vector2(2551 - 7 * 347 - 158,421 - 192*2 - 96),
  Vector2(2570 - 7 * 347 - 158,460 - 192*2 - 96),
  Vector2(2566 - 7 * 347 - 158,462 - 192*2 - 96),
  Vector2(2547 - 7 * 347 - 158,423 - 192*2 - 96),
  Vector2(2533 - 7 * 347 - 158,431 - 192*2 - 96),
  Vector2(2521 - 7 * 347 - 158,445 - 192*2 - 96),
];

final List<Vector2> ind3 = [ //до 9-го
  Vector2(3271 - 9 * 347 - 158,417 - 192*2 - 96),
  Vector2(3306 - 9 * 347 - 158,417 - 192*2 - 96),
  Vector2(3337 - 9 * 347 - 158,429 - 192*2 - 96),
  Vector2(3364 - 9 * 347 - 158,460 - 192*2 - 96),
  Vector2(3373 - 9 * 347 - 158,479 - 192*2 - 96),
  Vector2(3374 - 9 * 347 - 158,507 - 192*2 - 96),
  Vector2(3397 - 9 * 347 - 158,507 - 192*2 - 96),
  Vector2(3398 - 9 * 347 - 158,479 - 192*2 - 96),
  Vector2(3384 - 9 * 347 - 158,446 - 192*2 - 96),
  Vector2(3351 - 9 * 347 - 158,419 - 192*2 - 96),
  Vector2(3319 - 9 * 347 - 158,410 - 192*2 - 96),
  Vector2(3292 - 9 * 347 - 158,409 - 192*2 - 96),
];

final List<Vector2> rad = [ //до 9-го
  Vector2(3733 - 10 * 347 - 158, 492 - 192*2 - 96),
];

final List<Vector2> hitBoxPoint = [
  Vector2(152 - 158,70  - 96),
  Vector2(146 - 158,89  - 96),
  Vector2(153 - 158,112 - 96),
  Vector2(160 - 158,112 - 96),
  Vector2(167 - 158,97  - 96),
  Vector2(163 - 158,70  - 96),
];

class Moose extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>, KyrgyzEnemy {

  Moose(this._startPos, this._mooseVariant);
  final Vector2 _startPos;
  final MooseVariant _mooseVariant;
  late SpriteAnimation _animMove, _animIdle, animAttack, _animHurt, _animDeath;
  final Vector2 _spriteSheetSize = Vector2(347,192);
  final Vector2 _speed = Vector2(0,0);
  final double _maxSpeed = 50;
  late GroundHitBox _groundBox;
  late Ground _ground;
  late EnemyHitbox _hitBox;
  DefaultEnemyWeapon? _weapon;
  bool _wasHit = false;

  @override
  Future<void> onLoad() async
  {
    maxLoots = 2;
    chanceOfLoot = 0.08;
    health = 4;
    maxLoots = 2;
    setChance();
    Image? spriteImage;
    switch(_mooseVariant)
    {
      case MooseVariant.Wool: spriteImage = await Flame.images.load('tiles/sprites/players/moose1-347x192.png'); break;
      case MooseVariant.WoolWithGreenHair: spriteImage = await Flame.images.load('tiles/sprites/players/moose2-347x192.png'); break;
      case MooseVariant.Blue: spriteImage = await Flame.images.load('tiles/sprites/players/moose3-347x192.png'); break;
      case MooseVariant.BlueWithGreenHair: spriteImage = await Flame.images.load('tiles/sprites/players/moose4-347x192.png'); break;
      case MooseVariant.Purple: spriteImage = await Flame.images.load('tiles/sprites/players/moose5-347x192.png'); break;
      case MooseVariant.PurpleWithGreenHair: spriteImage = await Flame.images.load('tiles/sprites/players/moose6-347x192.png'); break;
    }

    if(_mooseVariant == MooseVariant.Purple){
      final spriteSheet = SpriteSheet(image: spriteImage,
          srcSize: _spriteSheetSize);
      _animIdle =
          spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8, loop: false);
      _animMove =
          spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 8, to: 16, loop: false);
      animAttack = spriteSheet.createAnimation(
          row: 0, stepTime: 0.08, from: 16,to: 46, loop: false);
      _animHurt = spriteSheet.createAnimation(row: 0,
          stepTime: 0.07,
          from: 46,
          to: 52,
          loop: false);
      _animDeath = spriteSheet.createAnimation(row: 0,
          stepTime: 0.1,
          from: 52,
          to: 67,
          loop: false);
    }else {
      final spriteSheet = SpriteSheet(image: spriteImage,
          srcSize: _spriteSheetSize);
      _animIdle =
          spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8, loop: false);
      _animMove =
          spriteSheet.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 8, loop: false);
      animAttack = spriteSheet.createAnimation(
          row: 2, stepTime: 0.08, from: 0, loop: false);
      _animHurt = spriteSheet.createAnimation(row: 3,
          stepTime: 0.07,
          from: 0,
          to: 6,
          loop: false);
      _animDeath = spriteSheet.createAnimation(row: 4,
          stepTime: 0.1,
          from: 0,
          to: 15,
          loop: false);
    }
    position = _startPos;
    animation = _animIdle;
    animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    size = _spriteSheetSize;
    const double percentOfWidth = 158/347;
    Vector2 staticConstAnchor = Vector2(size.x * percentOfWidth,size.y/2);
    anchor = const Anchor(percentOfWidth, 0.5);
    _hitBox = EnemyHitbox(hitBoxPoint,collisionType: DCollisionType.passive
        ,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(_hitBox);
    _groundBox = GroundHitBox(getPointsForActivs(Vector2(145,97) - staticConstAnchor, Vector2(24,25))
        ,obstacleBehavoiurStart: (Set<Vector2> intersectionPoints, DCollisionEntity other){
          obstacleBehaviour(intersectionPoints, other, _groundBox, this);
        },
        collisionType: DCollisionType.active,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(_groundBox);
    _ground = Ground(getPointsForActivs(Vector2(145,97) - staticConstAnchor, Vector2(24,25))
        , collisionType: DCollisionType.passive, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    _ground.onlyForPlayer = true;
    add(_ground);
    _weapon = DefaultEnemyWeapon(ind1, collisionType: DCollisionType.inactive, isSolid: false, isStatic: false
        , onStartWeaponHit: onStartHit, onEndWeaponHit: onEndHit, isLoop: true, game: game);
    add(_weapon!);
    _weapon!.damage = 3;
    add(TimerComponent(onTick: () {
      if (!checkIsNeedSelfRemove(position.x ~/
          gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x
          , position.y ~/
              gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y
          , gameRef, _startPos, this)) {
        animation = _animIdle;
        animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      }
    },repeat: true,period: 2));
    int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(rand == 0){
      flipHorizontally();
    }
    selectBehaviour();
  }

  void selectBehaviour()
  {
    if(gameRef.gameMap.orthoPlayer == null){
      return;
    }
    if(isNearPlayer()) {
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
      _weapon?.hit();
      return;
    }
    int random = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(random != 0 || _wasHit){
      int shift = 0;
      if(position.x < gameRef.gameMap.orthoPlayer!.position.x){
        shift = -100;
      }else{
        shift = 100;
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
      animation = _animMove;
    }else{
      if(animation != _animIdle){
        _speed.x = 0;
        _speed.y = 0;
        animation = _animIdle;
      }
    }
    animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    animationTicker?.onComplete = selectBehaviour;
  }

  void onStartHit()
  {
    _weapon?.currentCoolDown = _weapon?.coolDown ?? 0;
    _speed.x = 0;
    _speed.y = 0;
    animation = null;
    animation = animAttack;
    animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    animationTicker?.onFrame = changeAttackVerts;
    animationTicker?.onComplete = onEndHit;
    _wasHit = true;
  }

  void changeAttackVerts(int index)
  {
    if(index == 3) {
      _weapon?.collisionType = DCollisionType.active;
      _weapon?.changeVertices(ind1,isLoop: true);
    }else if(index == 7){
      _weapon?.changeVertices(ind2,isLoop: true);
    }else if(index == 9){
      _weapon?.changeVertices(ind3,isLoop: true);
    }else if(index == 10){
      _weapon?.changeVertices(rad,radius: 55);
    }else if(index == 17){
      _weapon?.collisionType = DCollisionType.inactive;
    }
  }

  void onEndHit()
  {
    selectBehaviour();
  }



  bool isNearPlayer()
  {
    var pl = gameRef.gameMap.orthoPlayer!;
    if(pl.hitBox == null){
      return false;
    }
    if(position.distanceToSquared(pl.position) > 10000){
      return false;
    }
    if(pl.hitBox!.getMinVector().y > _hitBox.getMaxVector().y || pl.hitBox!.getMaxVector().y < _hitBox.getMinVector().y){
      return false;
    }
    return true;
  }




  @override
  void doHurt({required double hurt, bool inArmor = true})
  {
    if(animation == _animDeath){
      return;
    }
    animation = null;
    _weapon?.collisionType = DCollisionType.inactive;
    if(inArmor){
      health -= math.max(hurt - armor, 0);
    }else{
      health -= hurt;
    }
    if(health <1){
      death();
    }else{
      animation = _animHurt;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      animationTicker?.onComplete = selectBehaviour;
    }
  }

  void death()
  {
    _speed.x = 0;
    _speed.y = 0;
    if(loots.isNotEmpty) {
      if(loots.length > 1){
        var temp = Chest(0, myItems: loots, position: positionOfAnchor(Anchor.center));
        gameRef.gameMap.enemyComponent.add(temp);
      }else{
        var temp = LootOnMap(loots.first, position: positionOfAnchor(Anchor.center));
        gameRef.gameMap.enemyComponent.add(temp);
      }
    }
    animation = _animDeath;
    _hitBox.removeFromParent();
    _groundBox.collisionType = DCollisionType.inactive;
    _ground.collisionType = DCollisionType.inactive;
    // removeAll(children);
    animationTicker?.onComplete = () {
      add(OpacityEffect.by(-1,EffectController(duration: animationTicker?.totalDuration()),onComplete: (){
        gameRef.gameMap.loadedLivesObjs.remove(_startPos);
        removeFromParent();
      }));
    };
  }

  @override
  void update(double dt)
  {
    if(!isRefresh){
      return;
    }
    super.update(dt);
    if(_groundBox.getMaxVector().y > gameRef.gameMap.orthoPlayer!.groundBox!.getMaxVector().y){
      parent = gameRef.gameMap.enemyOnPlayer;
    }else{
      parent = gameRef.gameMap.enemyComponent;
    }
    if(animation == _animHurt || animation == animAttack || animation == _animDeath || animation == null){
      return;
    }
    position += _speed * dt;
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
}
