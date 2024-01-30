import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Items/chest.dart';
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

class Moose extends SpriteAnimationComponent with HasGameRef<KyrgyzGame> implements KyrgyzEnemy {

  Moose(this._startPos, this._mooseVariant);
  final Vector2 _startPos;
  final MooseVariant _mooseVariant;
  late SpriteAnimation _animMove, _animIdle, animAttack, _animHurt, _animDeath;
  final Vector2 _spriteSheetSize = Vector2(347,192);
  final Vector2 _speed = Vector2(0,0);
  final double _maxSpeed = 50;
  late GroundHitBox _groundBox;
  double _rigidSec = 2;
  EWBody? _body;
  EWMooseHummer? _hummer;
  ObstacleWhere _whereObstacle = ObstacleWhere.none;
  bool _wasHit = false;

  @override
  List<Item> loots = [];
  @override
  double armor = 0;//5;
  @override
  double chanceOfLoot = 10;
  @override
  int column = 0;
  @override
  int row = 0;
  @override
  double health = 1;//10;
  @override
  int maxLoots = 2;

  bool _isRefresh = true;

  @override
  Future<void> onLoad() async
  {
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

    Vector2 tSize = Vector2(28,54);

    var hitbox = EnemyHitbox(getPointsForActivs(Vector2(143,68) - staticConstAnchor, tSize)
        ,collisionType: DCollisionType.passive,isSolid: true,isStatic: false, isLoop: true, game: gameRef);
    add(hitbox);
    _groundBox = GroundHitBox(getPointsForActivs(Vector2(143,68) - staticConstAnchor, tSize)
        ,obstacleBehavoiurStart: obstacleBehaviour,
        collisionType: DCollisionType.active,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(_groundBox);
    _body = EWBody(getPointsForActivs(Vector2(143,68) - staticConstAnchor, tSize)
        ,collisionType: DCollisionType.active, onStartWeaponHit: onStartHit, onEndWeaponHit: onEndHit, isSolid: true, isStatic: false, isLoop: true, game: gameRef);
    _body?.activeSecs = animAttack.ticker().totalDuration();
    add(_body!);
    var ground = Ground(getPointsForActivs(Vector2(143,68) - staticConstAnchor, tSize)
        , collisionType: DCollisionType.passive, isSolid: true, isStatic: false, isLoop: true, game: gameRef);
    ground.onlyForPlayer = true;
    add(ground);
    List<Vector2> list = [Vector2(-21,-9), Vector2(-38,-46), Vector2(-52,-44), Vector2(-60,-60), Vector2(-32, -74), Vector2(-21,-53), Vector2(-33,-49), Vector2(-15,-11)];
    _hummer = EWMooseHummer(list,collisionType: DCollisionType.inactive,isSolid: true,isStatic: false,
        isLoop: false, game: gameRef, onStartWeaponHit: onStartHit, onEndWeaponHit: onEndHit);
    add(_hummer!);
    TimerComponent timer = TimerComponent(onTick: checkIsNeedSelfRemove,repeat: true,autoStart: true, period: 1);
    add(timer);
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
    _wasHit = true;
    _speed.x = 0;
    _speed.y = 0;
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
    if(_body!.getCenter().distanceTo(pl.hitBox!.getCenter()) > _body!.width * 0.5 + 120){
      return false;
    }
    if(pl.hitBox!.getPoint(0).y > _body!.getPoint(1).y || pl.hitBox!.getPoint(1).y < _body!.getPoint(0).y){
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
      double upDiffY = point.y - _groundBox.getPoint(0).y;
      double downDiffY = point.y - _groundBox.getPoint(1).y;

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
          gameRef.gameMap.add(temp);
        }else{
          var temp = LootOnMap(loots.first, position: positionOfAnchor(Anchor.center));
          gameRef.gameMap.add(temp);
        }
      }
      animation = _animDeath;
      removeAll(children);
      add(OpacityEffect.by(-0.95,EffectController(duration: _animDeath.ticker().totalDuration()),onComplete: (){
        gameRef.gameMap.loadedLivesObjs.remove(_startPos);
        removeFromParent();
      }));
    }else{
      animation = null;
      animation = _animHurt;
      animationTicker?.onComplete = selectBehaviour;
    }
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    _rigidSec -= dt;
    if(!_isRefresh){
      return;
    }
    if(animation == _animHurt || animation == animAttack || animation == _animDeath || animation == null){
      return;
    }
    if(_rigidSec <= 0){
      _rigidSec = 1;
      if(isNearPlayer()){
        var pl = gameRef.gameMap.orthoPlayer!;
        if(pl.hitBox!.getCenter().x > _body!.getCenter().x){
          if(isFlippedHorizontally){
            flipHorizontally();
          }
        }
        if(pl.hitBox!.getCenter().x < _body!.getCenter().x){
          if(!isFlippedHorizontally){
            flipHorizontally();
          }
        }
        _hummer?.hit();
      }else{
        selectBehaviour();
      }
    }
    position += _speed * dt;
  }
}
