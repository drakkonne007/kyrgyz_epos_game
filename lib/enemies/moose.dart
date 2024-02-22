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

class Moose extends SpriteAnimationComponent with HasGameRef<KyrgyzGame> implements KyrgyzEnemy {

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
  double _rigidSec = 2;
  DefaultEnemyWeapon? _weapon;
  ObstacleWhere _whereObstacle = ObstacleWhere.none;
  bool _wasHit = false;

  @override
  List<Item> loots = [];
  @override
  double armor = 0;//5;
  @override
  double chanceOfLoot = 0.3;
  @override
  int column = 0;
  @override
  int row = 0;
  @override
  double health = 4;//10;
  @override
  int maxLoots = 2;

  bool _isRefresh = true;

  @override
  Future<void> onLoad() async
  {
    math.Random rand2 = math.Random(DateTime.now().microsecondsSinceEpoch);
    for(int i=0;i<maxLoots;i++){
      double chance = rand2.nextDouble();
      if(chance >= chanceOfLoot){
        var item = Gold();
        loots.add(item);
      }
    }
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
          spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8);
      _animMove =
          spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 8, to: 16);
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
          spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8);
      _animMove =
          spriteSheet.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 8);
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
    size = _spriteSheetSize;
    const double percentOfWidth = 158/347;
    Vector2 staticConstAnchor = Vector2(size.x * percentOfWidth,size.y/2);
    anchor = const Anchor(percentOfWidth, 0.5);
    _hitBox = EnemyHitbox(hitBoxPoint,collisionType: DCollisionType.passive
        ,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(_hitBox);
    _groundBox = GroundHitBox(getPointsForActivs(Vector2(145,97) - staticConstAnchor, Vector2(24,25))
        ,obstacleBehavoiurStart: obstacleBehaviour,
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
    add(TimerComponent(onTick: checkIsNeedSelfRemove,repeat: true,period: 1));
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
      if(_whereObstacle == ObstacleWhere.side){
        posX = 0;
      }
      if(_whereObstacle == ObstacleWhere.upDown){
        posY = 0;
      }
      _whereObstacle = ObstacleWhere.none;
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
  }

  void onStartHit()
  {
    _speed.x = 0;
    _speed.y = 0;
    animation = null;
    animation = animAttack;
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
      _weapon?.changeVertices(rad,isLoop: true,radius: 55);
    }else if(index == 17){
      _weapon?.collisionType = DCollisionType.inactive;
    }
  }

  void onEndHit()
  {
    selectBehaviour();
  }

  void checkIsNeedSelfRemove()
  {
    column = position.x ~/ gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x;
    row =    position.y ~/ gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y;
    int diffCol = (column - gameRef.gameMap.column()).abs();
    int diffRow = (row - gameRef.gameMap.row()).abs();
    if(diffCol > 2 || diffRow > 2){
      gameRef.gameMap.loadedLivesObjs.remove(_startPos);
      removeFromParent();
    }
    if(diffCol > 1 || diffRow > 1){
      animation = _animIdle;
      _isRefresh = false;
    }else{
      _isRefresh = true;
    }
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

  void obstacleBehaviour(Set<Vector2> intersectionPoints, DCollisionEntity other)
  {
    Map<Vector2,AxesDiff> diffs = {};
    bool isUp = false;
    bool isDown = false;
    bool isLeft = false;
    bool isRight = false;
    double maxLeft = 0;
    double maxRight = 0;
    double maxUp = 0;
    double maxDown = 0;

    for(final point in intersectionPoints){
      double leftDiffX  = point.x - _groundBox.getMinVector().x;
      double rightDiffX = point.x - _groundBox.getMaxVector().x;
      double upDiffY = point.y - _groundBox.getMinVector().y;
      double downDiffY = point.y - _groundBox.getMaxVector().y;

      // print('diffs: $leftDiffX $rightDiffX $upDiffY $downDiffY');

      diffs.putIfAbsent(point, () => AxesDiff(leftDiffX,rightDiffX,upDiffY,downDiffY));
      double minDiff = math.min(leftDiffX.abs(),rightDiffX.abs());
      minDiff = math.min(minDiff,upDiffY.abs());
      minDiff = math.min(minDiff,downDiffY.abs());
      if(minDiff == leftDiffX.abs()){
        isLeft = true;
        maxLeft = math.max(maxLeft,minDiff);
      }
      if(minDiff == rightDiffX.abs()){
        isRight = true;
        maxRight = math.max(maxRight,minDiff);
      }
      if(minDiff == upDiffY.abs()){
        isUp = true;
        maxUp = math.max(maxUp,minDiff);
      }
      if(minDiff == downDiffY.abs()){
        isDown = true;
        maxDown = math.max(maxDown,minDiff);
      }
    }

    if(isDown && isUp && isLeft && isRight){
      print('What is??');
      return;
    }

    if(isDown && isUp){
      double maxLeft = 1000000000;
      double maxRight = 1000000000;
      for(final diff in diffs.values){
        maxLeft = math.min(maxLeft,diff.leftDiff.abs());
        maxRight = math.min(maxRight,diff.rightDiff.abs());
      }
      if(maxLeft > maxRight){
        position -= Vector2(maxRight,0);
      }else{
        position += Vector2(maxLeft,0);
      }
      return;
    }
    if(isLeft && isRight){
      double maxUp = 100000000;
      double maxDown = 100000000;
      for(final diff in diffs.values){
        maxUp = math.min(maxUp,diff.upDiff.abs());
        maxDown = math.min(maxDown,diff.downDiff.abs());
      }
      if(maxUp > maxDown){
        position -= Vector2(0,maxDown);
      }else{
        position += Vector2(0,maxUp);
      }
      return;
    }

    // print('maxs: $maxLeft $maxRight $maxUp $maxDown');

    if(isLeft){
      _whereObstacle = ObstacleWhere.side;
      position +=  Vector2(maxLeft,0);
    }
    if(isRight){
      _whereObstacle = ObstacleWhere.side;
      position -=  Vector2(maxRight,0);
    }
    if(isUp){
      _whereObstacle = ObstacleWhere.upDown;
      position +=  Vector2(0,maxUp);
    }
    if(isDown){
      _whereObstacle = ObstacleWhere.upDown;
      position -=  Vector2(0,maxDown);
    }
  }



  @override
  void doHurt({required double hurt, bool inArmor = true, double permanentDamage = 0, double secsOfPermDamage = 0})
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
        add(OpacityEffect.by(-0.95,EffectController(duration: animationTicker?.totalDuration()),onComplete: (){
          gameRef.gameMap.loadedLivesObjs.remove(_startPos);
          removeFromParent();
        }));
      };
    }else{
      animation = _animHurt;
      animationTicker?.onComplete = selectBehaviour;
    }
  }

  @override
  void update(double dt)
  {
    if(!_isRefresh){
      return;
    }
    super.update(dt);
    if(_groundBox.getMaxVector().y > gameRef.gameMap.orthoPlayer!.groundBox!.getMaxVector().y){
      parent = gameRef.gameMap.enemyOnPlayer;
    }else{
      parent = gameRef.gameMap.enemyComponent;
    }
    _rigidSec -= dt;
    if(animation == _animHurt || animation == animAttack || animation == _animDeath || animation == null){
      return;
    }
    if(_rigidSec <= 0){
      _rigidSec = 1;
      if(isNearPlayer()){
        var pl = gameRef.gameMap.orthoPlayer!;
        if(pl.position.x > position.x){
          if(isFlippedHorizontally){
            flipHorizontally();
          }
        }
        if(pl.position.x < position.x){
          if(!isFlippedHorizontally){
            flipHorizontally();
          }
        }
        _weapon?.hit();
      }else{
        selectBehaviour();
      }
    }
    position += _speed * dt;
  }
}
