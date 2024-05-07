import 'dart:ui';
import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
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

const double zoomScale = 1.2;

final List<Vector2> _hitBoxPoints = [ //вторая колонка
  Vector2(110 - 110 ,35 - 48) * zoomScale,
  Vector2(100 - 110 ,46 - 48) * zoomScale,
  Vector2(102 - 110 ,74 - 48) * zoomScale,
  Vector2(118 - 110 ,74 - 48) * zoomScale,
  Vector2(123 - 110 ,48 - 48) * zoomScale,
  Vector2(117 - 110 ,44 - 48) * zoomScale,
  Vector2(117 - 110 ,36 - 48) * zoomScale,
];

final List<Vector2> _groundBoxPoints = [ //вторая колонка
  Vector2(103 - 110,65 - 48) * zoomScale,
  Vector2(117 - 110,65 - 48) * zoomScale,
  Vector2(117 - 110,75 - 48) * zoomScale,
  Vector2(103 - 110,75 - 48) * zoomScale,
];

final List<Vector2> _weaponPoints = [ //вторая колонка
  Vector2(746 - 110 - 220 * 3,350 - 48 - 96 * 3) * zoomScale,
  Vector2(755 - 110 - 220 * 3,355 - 48 - 96 * 3) * zoomScale,
  Vector2(770 - 110 - 220 * 3,361 - 48 - 96 * 3) * zoomScale,
  Vector2(789 - 110 - 220 * 3,362 - 48 - 96 * 3) * zoomScale,
  Vector2(798 - 110 - 220 * 3,358 - 48 - 96 * 3) * zoomScale,
  Vector2(804 - 110 - 220 * 3,352 - 48 - 96 * 3) * zoomScale,
  Vector2(804 - 110 - 220 * 3,348 - 48 - 96 * 3) * zoomScale,
  Vector2(803 - 110 - 220 * 3,346 - 48 - 96 * 3) * zoomScale,
  Vector2(796 - 110 - 220 * 3,341 - 48 - 96 * 3) * zoomScale,
  Vector2(787 - 110 - 220 * 3,341 - 48 - 96 * 3) * zoomScale,
];

class PrisonAssassin extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>, KyrgyzEnemy
{
  PrisonAssassin(this._startPos);
  late SpriteAnimation _animMove, _animIdle,_animIdle2, _animAttack,_animAttack2, _animHurt, _animDeath;
  late EnemyHitbox _hitbox;
  late GroundHitBox _groundBox;
  late Ground _ground;
  final Vector2 _spriteSheetSize = Vector2(220,96);
  final Vector2 _startPos;
  final Vector2 _speed = Vector2(0,0);
  final double _maxSpeed = 70;
  late DefaultEnemyWeapon _weapon;
  bool _wasHit = false;

  @override
  Future<void> onLoad() async
  {
    armor = 3;
    chanceOfLoot = 0.02;
    health = 10;
    maxLoots = 3;
    setChance();
    Image spriteImage = await Flame.images.load(
        'tiles/map/prisonSet/Characters/Assassin like enemy/Assassin like enemy - all animations.png');
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _spriteSheetSize);
    _animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 7, loop: false);
    _animIdle2 = spriteSheet.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 10, loop: false);
    _animMove = spriteSheet.createAnimation(row: 2, stepTime: 0.08, from: 0, to: 6, loop: false);
    _animAttack = spriteSheet.createAnimation(row: 3, stepTime: 0.08, from: 0,to: 9, loop: false);
    _animAttack2 = spriteSheet.createAnimation(row: 5, stepTime: 0.08, from: 0,to: 11, loop: false);
    _animHurt = spriteSheet.createAnimation(row: 6, stepTime: 0.05, from: 0, to: 7,loop: false);
    _animDeath = spriteSheet.createAnimation(row: 7, stepTime: 0.1, from: 0,loop: false);
    anchor = Anchor.center;
    animation = _animIdle;
    size = _spriteSheetSize * zoomScale;
    position = _startPos;
    _hitbox = EnemyHitbox(_hitBoxPoints,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(_hitbox);
    _groundBox = GroundHitBox(_groundBoxPoints,obstacleBehavoiurStart: (Set<Vector2> intersectionPoints, DCollisionEntity other){
      obstacleBehaviour(intersectionPoints, other, _groundBox, this, _speed);
    },
        collisionType: DCollisionType.active,isSolid: true,isStatic: false, isLoop: true, game: gameRef);
    add(_groundBox);
    _weapon = DefaultEnemyWeapon(
        _weaponPoints,collisionType: DCollisionType.inactive, onStartWeaponHit: onStartHit, onEndWeaponHit: onEndHit, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(_weapon);
    _weapon.damage = 3;
    _ground = Ground(_groundBoxPoints,collisionType: DCollisionType.passive, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    _ground.onlyForPlayer = true;
    add(_ground);
    add(TimerComponent(onTick: () {
      if (!checkIsNeedSelfRemove(position.x ~/
          gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x
          , position.y ~/
              gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y
          , gameRef, _startPos, this)) {
        int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
        animation = rand.isOdd ? _animIdle : _animIdle2;
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
      _weapon.hit();
      return;
    }
    int random = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(random != 0 || _wasHit){
      int shift = 0;
      if(position.x < gameRef.gameMap.orthoPlayer!.position.x){
        shift = -20;
      }else{
        shift = 20;
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
      if(animation != _animIdle && animation != _animIdle2){
        _speed.x = 0;
        _speed.y = 0;
        int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
        animation = rand.isOdd ? _animIdle : _animIdle2;
      }
    }
    animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    animationTicker?.onComplete = selectBehaviour;
  }

  void onStartHit()
  {
    _weapon.currentCoolDown = _weapon.coolDown;
    _speed.x = 0;
    _speed.y = 0;
    animation = null;
    math.Random().nextInt(2) == 0 ? animation = _animAttack : animation = _animAttack2;
    animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    animationTicker?.onFrame = changeAttackVerts;
    animationTicker?.onComplete = onEndHit;
    _wasHit = true;
  }

  void changeAttackVerts(int index)
  {
    if(animation == _animAttack){
      if(index == 3){
        _weapon.collisionType = DCollisionType.active;
      }else if(index == 5){
        _weapon.collisionType = DCollisionType.inactive;
      }
    }else{
      if(index == 4){
        _weapon.collisionType = DCollisionType.active;
      }else if(index == 6){
        _weapon.collisionType = DCollisionType.inactive;
      }
    }
  }

  void onEndHit()
  {
    selectBehaviour();
  }

  @override
  void doHurt({required double hurt, bool inArmor = true})
  {
    if(animation == _animDeath){
      return;
    }
    animation = null;
    _weapon.collisionType = DCollisionType.inactive;
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
    _hitbox.removeFromParent();
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
  void doMagicHurt({required double hurt, required MagicDamage magicDamage})
  {
    health -= hurt;
    if(health < 1){
      death();
    }
  }

  bool isNearPlayer()
  {
    var pl = gameRef.gameMap.orthoPlayer!;
    if(pl.hitBox == null){
      return false;
    }
    if(position.distanceToSquared(pl.position) > 60*60){
      return false;
    }
    if(pl.hitBox!.getMinVector().y > _hitbox.getMaxVector().y || pl.hitBox!.getMaxVector().y < _hitbox.getMinVector().y){
      return false;
    }
    return true;
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
    if(animation == _animHurt || animation == _animAttack || animation == _animDeath || animation == null){
      return;
    }
    position += _speed * dt;
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