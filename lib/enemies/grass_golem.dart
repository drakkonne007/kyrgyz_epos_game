import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'dart:math' as math;
import 'package:game_flame/kyrgyz_game.dart';

enum GolemVariant
{
  Water,
  Grass
}

class GrassGolem extends SpriteAnimationComponent with HasGameRef<KyrgyzGame> implements KyrgyzEnemy
{
  GrassGolem(this._startPos,this.spriteVariant,{super.priority});
  late SpriteAnimation _animMove, _animIdle, _animAttack, _animHurt, _animDeath;
  late EnemyHitbox _hitbox;
  late GroundHitBox _groundBox;
  late Ground _ground;
  final Vector2 _spriteSheetSize = Vector2(224,192);
  Vector2 _startPos;
  Vector2 _speed = Vector2(0,0);
  double _maxSpeed = 30;
  GolemVariant spriteVariant;
  double _rigidSec = 2;
  EWBody? _body;
  Timer? _timer;

  @override
  int column=0;
  @override
  int row=0;
  @override
  int maxLoots = 2;
  @override
  double chanceOfLoot = 0.8;
  @override
  double armor = 0;
  @override
  List<Item> loots = [];
  @override
  double health = 3;

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
    Image? spriteImage;
    if(spriteVariant == GolemVariant.Water){
      spriteImage = await Flame.images.load(
          'tiles/sprites/players/Stone-224x192.png');
    }else{
      spriteImage = await Flame.images.load(
          'tiles/sprites/players/Stone2-224x192.png');
    }
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _spriteSheetSize);
    _animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8);
    _animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 8);
    _animAttack = spriteSheet.createAnimation(row: 2, stepTime: 0.08, from: 0);
    _animHurt = spriteSheet.createAnimation(row: 3, stepTime: 0.07, from: 0, to: 12);
    _animDeath = spriteSheet.createAnimation(row: 4, stepTime: 0.1, from: 0, to: 13);
    _animAttack.loop = false;
    _animHurt.loop = false;
    _timer = Timer(_animHurt.ticker().totalDuration(),autoStart: false,onTick: selectBehaviour,repeat: false);
    anchor = Anchor.center;
    animation = _animMove;
    size = _spriteSheetSize;
    position = _startPos;
    Vector2 tSize = Vector2(69,71);
    _hitbox = EnemyHitbox(getPointsForActivs(-tSize/2, tSize),
        collisionType: DCollisionType.passive,isSolid: true,isStatic: false, isLoop: true, game: gameRef);
    add(_hitbox);
    _groundBox = GroundHitBox(getPointsForActivs(-tSize/2, tSize),obstacleBehavoiurStart: obstacleBehaviour,
        collisionType: DCollisionType.active,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(_groundBox);
    _groundBox.debugColor = BasicPalette.red.color;
    _body = EWBody(getPointsForActivs(-tSize/2, tSize)
        ,collisionType: DCollisionType.active, onStartWeaponHit: onStartHit, onEndWeaponHit: onEndHit, isSolid: true, isStatic: false, isLoop: true, game: gameRef);
    _body?.activeSecs = _animAttack.ticker().totalDuration();
    add(_body!);
    tSize = Vector2(66,78);
    _ground = Ground(getPointsForActivs(-tSize/2, tSize), collisionType: DCollisionType.passive, isSolid: true, isStatic: false, isLoop: true, game: gameRef);
    _ground.onlyForPlayer = true;
    add(_ground);
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
    if(_body!.getCenter().distanceTo(pl.hitBox!.getCenter()) > _body!.width/2 + 50){
      return false;
    }
    if(pl.hitBox!.getPoint(0).y > _body!.getPoint(1).y || pl.hitBox!.getPoint(1).y < _body!.getPoint(0).y){
      return false;
    }
    return true;
  }

  void obstacleBehaviour(Set<Vector2> intersectionPoints, DCollisionEntity other)
  {
    _speed *= -1;
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    _timer?.update(dt);
    column = position.x ~/ gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x;
    row =    position.y ~/ gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y;
    int diffCol = (column - gameRef.gameMap.column()).abs();
    int diffRow = (row - gameRef.gameMap.row()).abs();
    if(diffCol > 2 || diffRow > 2){
      gameRef.gameMap.loadedLivesObjs.remove(_startPos);
      removeFromParent();
    }
    if(diffCol > 1 || diffRow > 1){
      return;
    }
    if(animation == _animHurt || animation == _animAttack || animation == _animDeath || animation == null){
      return;
    }
    _rigidSec -= dt;
    if(_rigidSec <= 1 && isNearPlayer()){
      _body?.currentCoolDown = _body?.coolDown ?? 0;
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
      _body?.hit();
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
}