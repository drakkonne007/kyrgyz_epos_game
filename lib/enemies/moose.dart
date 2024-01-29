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

  Moose(this._startPos, this._mooseVariant,{super.priority});
  final Vector2 _startPos;
  final MooseVariant _mooseVariant;
  late SpriteAnimation animMove, animIdle, animAttack, animHurt, animDeath;
  final Vector2 _spriteSheetSize = Vector2(347,192);
  final Vector2 _speed = Vector2(0,0);
  final double _maxSpeed = 50;
  double _rigidSec = 4;
  EWBody? _body;
  EWMooseHummer? _hummer;


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
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _spriteSheetSize);
    if(_mooseVariant == MooseVariant.Purple){
      animIdle =
          spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8);
      animMove =
          spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 8, to: 16);
      animAttack = spriteSheet.createAnimation(
          row: 0, stepTime: 0.08, from: 16,to: 46, loop: false);
      animHurt = spriteSheet.createAnimation(row: 0,
          stepTime: 0.07,
          from: 46,
          to: 52,
          loop: false);
      animDeath = spriteSheet.createAnimation(row: 0,
          stepTime: 0.1,
          from: 52,
          loop: false);
    }else {
      animIdle =
          spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8);
      animMove =
          spriteSheet.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 8);
      animAttack = spriteSheet.createAnimation(
          row: 2, stepTime: 0.08, from: 0, loop: false);
      animHurt = spriteSheet.createAnimation(row: 3,
          stepTime: 0.07,
          from: 0,
          to: 6,
          loop: false);
      animDeath = spriteSheet.createAnimation(row: 4,
          stepTime: 0.1,
          from: 0,
          to: 15,
          loop: false);
    }
    position = _startPos;
    animation = animIdle;
    size = _spriteSheetSize;
    const double percentOfWidth = 158/347;
    Vector2 staticConstAnchor = Vector2(size.x * percentOfWidth,size.y/2);
    anchor = const Anchor(percentOfWidth, 0.5);

    Vector2 tSize = Vector2(28,54);

    var hitbox = EnemyHitbox(getPointsForActivs(Vector2(143,68) - staticConstAnchor, tSize)
        ,collisionType: DCollisionType.passive,isSolid: true,isStatic: false, isLoop: true, game: gameRef);
    add(hitbox);
    var groundBox = GroundHitBox(getPointsForActivs(Vector2(143,68) - staticConstAnchor, tSize)
        ,obstacleBehavoiurStart: obstacleBehaviour,
        collisionType: DCollisionType.active,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(groundBox);
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
    _rigidSec = 3;
    if(gameRef.gameMap.orthoPlayer == null){
      return;
    }
    int random = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(4);
    if(random != 0){
      int shift = 0;
      if(position.x < gameRef.gameMap.orthoPlayer!.position.x){
        shift = -70;
      }else{
        shift = 70;
      }
      double posX = gameRef.gameMap.orthoPlayer!.position.x - position.x + shift;
      double posY = gameRef.gameMap.orthoPlayer!.position.y - position.y;
      double percent = math.min(posX.abs(),posY.abs()) / math.max(posX.abs(),posY.abs());
      double isY = posY.isNegative ? -1 : 1;
      double isX = posX.isNegative ? -1 : 1;
      if(posX.isNegative && !isFlippedHorizontally){
        flipHorizontally();
      }else if(!posX.isNegative && isFlippedHorizontally){
        flipHorizontally();
      }
      _speed.x = posX.abs() > posY.abs() ? _maxSpeed * isX : _maxSpeed * percent * isX;
      _speed.y = posY.abs() > posX.abs() ? _maxSpeed * isY: _maxSpeed * percent * isY;
      animation = animMove;
    }else{
      if(animation != animIdle){
        _speed.x = 0;
        _speed.y = 0;
        animation = animIdle;
      }
    }
  }



  void onStartHit()
  {
    // animation = animAttack;
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
    if(_body!.getCenter().distanceTo(pl.hitBox!.getCenter()) > _body!.width * 0.5 + 150){
      return false;
    }
    if(pl.hitBox!.getPoint(0).y > _body!.getPoint(1).y || pl.hitBox!.getPoint(1).y < _body!.getPoint(0).y){
      return false;
    }
    return true;
  }

  void obstacleBehaviour(Set<Vector2> intersectionPoints, DCollisionEntity other)
  {
    _speed.x = 0;
    _speed.y = 0;
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    _rigidSec -= dt;
    if(!_isRefresh){
      return;
    }
    if(animation == animHurt || animation == animAttack || animation == animDeath || animation == null){
      return;
    }
    if(_rigidSec <= 1){
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
      }
    }
    if(_rigidSec <= 0){
      selectBehaviour();
    }
    position += _speed * dt;
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
      animation = animDeath;
      removeAll(children);
      add(OpacityEffect.by(-0.95,EffectController(duration: animDeath.ticker().totalDuration()),onComplete: (){
        gameRef.gameMap.loadedLivesObjs.remove(_startPos);
        removeFromParent();
      }));
    }else{
      animation = null;
      animation = animHurt;
      animationTicker?.onComplete = selectBehaviour;
    }
  }

  @override
  List<Item> loots = [];
}
