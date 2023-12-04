import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/tile_map_component.dart';
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
  Vector2 _startPos;
  MooseVariant _mooseVariant;
  late SpriteAnimation _animMove, _animIdle, _animAttack, _animHurt, _animDeath;
  late EnemyHitbox _hitbox;
  late GroundHitBox _groundBox;
  final Vector2 _spriteSheetSize = Vector2(347,192);
  Vector2 _speed = Vector2(0,0);
  final double _maxSpeed = 30;
  double _rigidSec = 2;
  EWBody? _body;
  Timer? _timer;

  @override
  double armor = 5;
  @override
  double chanceOfLoot = 10;
  @override
  int column = 0;
  @override
  int row = 0;
  @override
  double health = 10;
  @override
  int maxLoots = 2;

  void selectBehaviour()
  {
    if(gameRef.gameMap.orthoPlayer == null){
      return;
    }
    _rigidSec = 2;
    int random = math.Random().nextInt(4);
    if(random != 0){
      double posX = gameRef.gameMap.orthoPlayer!.position.x - position.x;
      double posY = gameRef.gameMap.orthoPlayer!.position.y - position.y;
      double percent = math.min(posX.abs(),posY.abs()) / math.max(posX.abs(),posY.abs());
      double isY = posY.isNegative ? -1 : 1;
      double isX = posX.isNegative ? -1 : 1;
      if(posX.isNegative && !isFlippedHorizontally){
        flipHorizontally();
      }else if(!posX.isNegative && isFlippedHorizontally){
        flipHorizontally();
      }
      _speed = Vector2(posX.abs() > posY.abs() ? _maxSpeed * isX : _maxSpeed * percent * isX,posY.abs() > posX.abs() ? _maxSpeed * isY: _maxSpeed * percent * isY);
      if(animation != _animMove){
        animation = _animMove;
      }
    }else{
      if(animation != _animIdle){
        _speed = Vector2(0,0);
        animation = _animIdle;
      }
    }
  }

  @override
  Future<void> onLoad() async
  {
    priority = GamePriority.player;
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
      _animIdle =
          spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8);
      _animMove =
          spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 8, to: 16);
      _animAttack = spriteSheet.createAnimation(
          row: 0, stepTime: 0.08, from: 16,to: 46, loop: false);
      _animHurt = spriteSheet.createAnimation(row: 0,
          stepTime: 0.07,
          from: 46,
          to: 52,
          loop: false);
      _animDeath = spriteSheet.createAnimation(row: 0,
          stepTime: 0.1,
          from: 52,
          loop: false);
    }else {
      _animIdle =
          spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8);
      _animMove =
          spriteSheet.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 8);
      _animAttack = spriteSheet.createAnimation(
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
    _timer = Timer(_animHurt.ticker().totalDuration(),autoStart: false,onTick: selectBehaviour,repeat: false);
    anchor = Anchor.center;
    animation = _animMove;
    size = _spriteSheetSize;
    position = _startPos;
    Vector2 tSize = Vector2(69,71);

    _hitbox = EnemyHitbox(getPointsForActivs(Vector2(-69/2,-71/2), tSize),
        collisionType: DCollisionType.passive,isSolid: true,isStatic: false, isLoop: true, game: gameRef);
    add(_hitbox);
    _groundBox = GroundHitBox(getPointsForActivs(Vector2(-69/2,-71/2), tSize),obstacleBehavoiurStart: obstacleBehaviour,
        collisionType: DCollisionType.active,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(_groundBox);
    _groundBox.debugColor = BasicPalette.red.color;
    _body = EWBody(getPointsForActivs(Vector2(-69/2,-71/2), tSize)
        ,collisionType: DCollisionType.active, onStartWeaponHit: onStartHit, onEndWeaponHit: onEndHit, isSolid: true, isStatic: false, isLoop: true, game: gameRef);
    _body?.activeSecs = _animAttack.ticker().totalDuration();
    add(_body!);
  }

  void onStartHit()
  {
    animation = _animAttack;
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
    if((absolutePositionOf((_body!.getPoint(3) - _body!.getPoint(0)) / 2).x -  pl.absolutePositionOf((pl.hitBox!.getPoint(3) - pl.hitBox!.getPoint(0)) / 2).x).abs() > 40
        || pl.absolutePositionOf(pl.hitBox!.getPoint(3)).y > absolutePositionOf(_body!.getPoint(2)).y
        || pl.absolutePositionOf(pl.hitBox!.getPoint(2)).y < absolutePositionOf(_body!.getPoint(3)).y){
      return false;
    }else{
      return true;
    }
  }

  void obstacleBehaviour(Set<Vector2> intersectionPoints, DCollisionEntity other)
  {
    _speed *= -1;
  }

  @override
  void update(double dt)
  {
    _timer?.update(dt);
    column = position.x ~/ GameConsts.lengthOfTileSquare.x;
    row =    position.y ~/ GameConsts.lengthOfTileSquare.y;
    int diffCol = (column - gameRef.gameMap.column()).abs();
    int diffRow = (row - gameRef.gameMap.row()).abs();
    if(diffCol > 2 || diffRow > 2){
      gameRef.gameMap.loadedLivesObjs.remove(_startPos);
      removeFromParent();
    }
    if(diffCol > 1 || diffRow > 1){
      return;
    }
    super.update(dt);
    if(animation == _animHurt || animation == _animAttack || animation == _animDeath || animation == null){
      return;
    }
    _rigidSec -= dt;
    if(_rigidSec <= 1){
      if(isNearPlayer()){
        _body?.hit(isFlippedHorizontally ? PlayerDirectionMove.Left : PlayerDirectionMove.Right);
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
    _timer!.stop();
    if(inArmor){
      health -= math.max(hurt - armor, 0);
    }else{
      health -= hurt;
    }
    if(health <1){
      _speed = Vector2.all(0);
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
      _animHurt.ticker().reset();
      animation = _animHurt;
      _timer!.start();
    }
  }

  @override
  List<Item> loots = [];
}
