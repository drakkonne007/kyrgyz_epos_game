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
import 'package:game_flame/components/tile_map_component.dart';
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
  GrassGolem(this._startPos,this.spriteVariant);
  late SpriteAnimation _animMove, _animIdle, _animAttack, _animHurt, _animDeath;
  late EnemyHitbox _hitbox;
  late GroundHitBox _groundBox;
  final Vector2 _spriteSheetSize = Vector2(224,192);
  Vector2 _startPos;
  Vector2 _speed = Vector2(0,0);
  double _maxSpeed = 20;
  GolemVariant spriteVariant;
  double _rigidSec = 2;
  SpriteAnimationTicker? _tickerHurt;
  SpriteAnimationTicker? _tickerAttack;
  EWBody? _body;

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

  void onEndAnimation()
  {
    print('Hohoho');
    selectBehaviour();
  }

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
    _tickerAttack = SpriteAnimationTicker(_animAttack);
    _tickerAttack?.onComplete = onEndAnimation;
    _animHurt.loop = false;
    _tickerHurt = SpriteAnimationTicker(_animHurt);
    _tickerHurt!.onComplete = onEndAnimation;
    anchor = Anchor.center;
    animation = _animMove;
    size = _spriteSheetSize;
    position = _startPos;
    //_groundBox.anchor = Anchor.center;
    _hitbox = EnemyHitbox(size: Vector2(69,71),position: Vector2(77, 55));
    add(_hitbox);
    _groundBox = GroundHitBox(obstacleBehavoiurStart: obstacleBehaviour,size: Vector2(69,71), position: Vector2(77, 55));
    add(_groundBox);
    // _groundBox.debugMode = true;
    _groundBox.debugColor = BasicPalette.red.color;
    _body = EWBody(size: Vector2(69,71),position: Vector2(77, 55), onStartWeaponHit: onStartHit, onEndWeaponHit: onEndHit);
    _body?.collisionType = CollisionType.active;
    // body.debugMode = true;
    _body?.debugColor = BasicPalette.blue.color;
    _body?.activeSecs = _tickerAttack!.totalDuration();
    add(_body!);
    math.Random rand = math.Random();
    for(int i=0;i<maxLoots;i++){
      double chance = rand.nextDouble();
      if(chance >= chanceOfLoot){
        var item = itemFromId(2);
        loots.add(item);
      }
    }
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
    if((absolutePositionOf(_body!.center).x -  pl.absolutePositionOf(pl.hitBox.center).x).abs() > 80
        || pl.absolutePositionOf(pl.hitBox.positionOfAnchor(Anchor.topRight)).y > absolutePositionOf(_body!.positionOfAnchor(Anchor.bottomRight)).y
    || pl.absolutePositionOf(pl.hitBox.positionOfAnchor(Anchor.bottomRight)).y < absolutePositionOf(_body!.positionOfAnchor(Anchor.topRight)).y){
      return false;
    }else{
      return true;
    }
  }

  void obstacleBehaviour(Set<Vector2> intersectionPoints, PositionComponent other)
  {
    _speed *= -1;
  }

  @override
  void update(double dt)
  {
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
    if(animation == _animHurt || animation == _animAttack || animation == _animDeath){
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
    if(inArmor){
      health -= math.max(hurt - armor, 0);
    }else{
      health -= hurt;
    }
    if(health <1){
      _speed = Vector2.all(0);
      if(loots.isNotEmpty) {
        if(loots.length > 1){
          var temp = Chest(myItems: loots, position: positionOfAnchor(Anchor.center));
          gameRef.gameMap.add(temp);
          int col = positionOfAnchor(Anchor.center).x ~/ (GameConsts.lengthOfTileSquare.x);
          int row = positionOfAnchor(Anchor.center).y ~/ (GameConsts.lengthOfTileSquare.y);
          LoadedColumnRow tempCoord = LoadedColumnRow(col, row);
          gameRef.gameMap.allEls.putIfAbsent(tempCoord, () => []);
          gameRef.gameMap.allEls[tempCoord]!.add(temp);
        }else{
          var temp = LootOnMap(loots.first, position: positionOfAnchor(Anchor.center));
          gameRef.gameMap.add(temp);
          int col = positionOfAnchor(Anchor.center).x ~/ (GameConsts.lengthOfTileSquare.x);
          int row = positionOfAnchor(Anchor.center).y ~/ (GameConsts.lengthOfTileSquare.y);
          LoadedColumnRow tempCoord = LoadedColumnRow(col, row);
          gameRef.gameMap.allEls.putIfAbsent(tempCoord, () => []);
          gameRef.gameMap.allEls[tempCoord]!.add(temp);
        }
      }
      animation = _animDeath;
      removeAll(children);
      add(OpacityEffect.by(-0.95,EffectController(duration: _animDeath.ticker().totalDuration()),onComplete: (){
        gameRef.gameMap.loadedLivesObjs.remove(_startPos);
        removeFromParent();
      }));
    }else{
      animation = _animHurt;
      animation?.ticker().reset();
    }
  }
}