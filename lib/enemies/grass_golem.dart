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
  late SpriteAnimation _animMove, _animIdle, _animAttack1, _animHurt, _animDeath;
  late EnemyHitbox _hitbox;
  late GroundHitBox _groundBox;
  final Vector2 _spriteSheetSize = Vector2(224,192);
  Vector2 _startPos;
  Vector2 _speed = Vector2(0,10);
  GolemVariant spriteVariant;

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

  @override
  Future<void> onLoad() async
  {
    priority = GamePriority.player;
    Image? spriteImage;
    if(spriteVariant == GolemVariant.Water){
      try {
        spriteImage = Flame.images.fromCache(
            'tiles/sprites/players/Stone-224x192.png');
      }catch(e){
        spriteImage = await Flame.images.load(
            'tiles/sprites/players/Stone-224x192.png');
      }
    }else{
      try {
        spriteImage = Flame.images.fromCache(
            'tiles/sprites/players/Stone2-224x192.png');
      }catch(e){
        spriteImage = await Flame.images.load(
            'tiles/sprites/players/Stone2-224x192.png');
      }
    }
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _spriteSheetSize);
    _animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8);
    _animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 8);
    _animAttack1 = spriteSheet.createAnimation(row: 2, stepTime: 0.15, from: 0, to: 17);
    _animHurt = spriteSheet.createAnimation(row: 3, stepTime: 0.15, from: 0, to: 16);
    _animDeath = spriteSheet.createAnimation(row: 4, stepTime: 0.15, from: 0, to: 16);
    anchor = Anchor.center;
    animation = _animMove;
    size = _spriteSheetSize;
    position = _startPos;
    //_groundBox.anchor = Anchor.center;
    _hitbox = EnemyHitbox(size: Vector2(69,71),position: Vector2(77, 55));
    add(_hitbox);
    _groundBox = GroundHitBox(obstacleBehavoiurStart: obstacleBehaviour,size: Vector2(69,71), position: Vector2(77, 55));
    _groundBox.debugColor = BasicPalette.red.color;
    add(_groundBox);
    // _groundBox.debugMode = true;
    EWBody body = EWBody(size: Vector2(69,71),position: Vector2(77, 55));
    body.collisionType = CollisionType.active;
    // body.debugMode = true;
    body.debugColor = BasicPalette.blue.color;
    add(body);
    math.Random rand = math.Random();
    for(int i=0;i<maxLoots;i++){
      double chance = rand.nextDouble();
      if(chance >= chanceOfLoot){
        var item = itemFromId(2);
        loots.add(item);
      }
    }
  }

  void obstacleBehaviour(Set<Vector2> intersectionPoints, PositionComponent other)
  {
    _speed *= -1;
  }

  @override
  void update(double dt)
  {
    column = position.x ~/ GameConsts.lengthOfTileSquare;
    row =    position.y ~/ GameConsts.lengthOfTileSquare;
    int diffCol = (column - gameRef.gameMap.column()).abs();
    int diffRow = (row - gameRef.gameMap.row()).abs();
    if(diffCol > 2 || diffRow > 2){
      gameRef.gameMap.loadedLivesObjs.remove(_startPos);
      removeFromParent();
    }
    if(diffCol > 1 || diffRow > 1){
      return;
    }
    position += _speed * dt;
    super.update(dt);
  }

  @override
  void doHurt({required double hurt, bool inArmor = true, double permanentDamage = 0, double secsOfPermDamage = 0})async
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
          await gameRef.gameMap.add(temp);
          int col = positionOfAnchor(Anchor.center).x ~/ (GameConsts.lengthOfTileSquare);
          int row = positionOfAnchor(Anchor.center).y ~/ (GameConsts.lengthOfTileSquare);
          LoadedColumnRow tempCoord = LoadedColumnRow(col, row);
          gameRef.gameMap.allEls.putIfAbsent(tempCoord, () => []);
          gameRef.gameMap.allEls[tempCoord]!.add(temp);
        }else{
          var temp = LootOnMap(loots.first, position: positionOfAnchor(Anchor.center));
          await gameRef.gameMap.add(temp);
          int col = positionOfAnchor(Anchor.center).x ~/ (GameConsts.lengthOfTileSquare);
          int row = positionOfAnchor(Anchor.center).y ~/ (GameConsts.lengthOfTileSquare);
          LoadedColumnRow tempCoord = LoadedColumnRow(col, row);
          gameRef.gameMap.allEls.putIfAbsent(tempCoord, () => []);
          gameRef.gameMap.allEls[tempCoord]!.add(temp);
        }
      }
      animation = _animDeath;
      removeAll(children);
      SpriteAnimationTicker tick = SpriteAnimationTicker(_animDeath);
      await add(OpacityEffect.by(-0.95,EffectController(duration: tick.totalDuration()),onComplete: (){
        gameRef.gameMap.loadedLivesObjs.remove(_startPos);
        removeFromParent();
      }));
    }else{
      animation = _animHurt;
      SpriteAnimationTicker tick = SpriteAnimationTicker(_animHurt);
      tick.onComplete = (){
        animation = _animMove;
      };
    }
  }
}