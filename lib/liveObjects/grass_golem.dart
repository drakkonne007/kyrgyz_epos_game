import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'dart:math' as math;
import 'package:game_flame/kyrgyz_game.dart';

enum GolemVariant
{
  Water,
  Grass
}

final List<Vector2> _ind1 = [ //вторая колонка
  Vector2(309 - 224 - 112,503 - 192 * 2 - 192 * 0.5),
  Vector2(304 - 224 - 112,498 - 192 * 2 - 192 * 0.5),
  Vector2(299 - 224 - 112,477 - 192 * 2 - 192 * 0.5),
  Vector2(364 - 224 - 112,469 - 192 * 2 - 192 * 0.5),
  Vector2(370 - 224 - 112,484 - 192 * 2 - 192 * 0.5),
  Vector2(374 - 224 - 112,489 - 192 * 2 - 192 * 0.5),
  Vector2(369 - 224 - 112,498 - 192 * 2 - 192 * 0.5),
  Vector2(359 - 224 - 112,498 - 192 * 2 - 192 * 0.5),
  Vector2(356 - 224 - 112,485 - 192 * 2 - 192 * 0.5)
];

final List<Vector2> _ind2 = [ //пятая
  Vector2(972  - 224 * 4 - 112,493 - 192 * 2 - 192 * 0.5),
  Vector2(968  - 224 * 4 - 112,483 - 192 * 2 - 192 * 0.5),
  Vector2(971  - 224 * 4 - 112,468 - 192 * 2 - 192 * 0.5),
  Vector2(1032 - 224 * 4 - 112,466 - 192 * 2 - 192 * 0.5),
  Vector2(1043 - 224 * 4 - 112,477 - 192 * 2 - 192 * 0.5),
  Vector2(1042 - 224 * 4 - 112,489 - 192 * 2 - 192 * 0.5)
];

final List<Vector2> _ind3 = [ //восьмая
  Vector2(2135 - 224 * 9 - 112, 530 - 192 * 2 - 96),
  Vector2(2107 - 224 * 9 - 112, 505 - 192 * 2 - 96),
  Vector2(2103 - 224 * 9 - 112, 487 - 192 * 2 - 96),
  Vector2(2158 - 224 * 9 - 112, 442 - 192 * 2 - 96),
  Vector2(2174 - 224 * 9 - 112, 448 - 192 * 2 - 96),
  Vector2(2196 - 224 * 9 - 112, 480 - 192 * 2 - 96),
  Vector2(2196 - 224 * 9 - 112, 487 - 192 * 2 - 96),
  Vector2(2146 - 224 * 9 - 112, 530 - 192 * 2 - 96),
];

final List<Vector2> _hitBoxPoint = [
  Vector2(96  - 112,57  - 96),
  Vector2(88  - 112,66  - 96),
  Vector2(94  - 112,125 - 96),
  Vector2(125 - 112,124 - 96),
  Vector2(133 - 112,76  - 96),
  Vector2(101 - 112,56  - 96),
];

class GrassGolem extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>, KyrgyzEnemy
{
  GrassGolem(this._startPos,this.spriteVariant,int id){this.id = id;}
  late SpriteAnimation _animMove, _animIdle, _animAttack, _animHurt, _animDeath;
  late EnemyHitbox _hitbox;
  final Vector2 _spriteSheetSize = Vector2(224,192);
  final Vector2 _startPos;
  final Vector2 _speed = Vector2(0,0);
  final double _maxSpeed = 20;
  final GolemVariant spriteVariant;
  late DefaultEnemyWeapon _weapon;
  bool _wasHit = false;


  @override
  Future<void> onLoad() async
  {
    maxLoots = 1;
    chanceOfLoot = 0.02;
    health = 20;
    setChance();
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
    _animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8,loop: false);
    _animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 8,loop: false);
    _animAttack = spriteSheet.createAnimation(row: 2, stepTime: 0.08, from: 0,loop: false);
    _animHurt = spriteSheet.createAnimation(row: 3, stepTime: 0.07, from: 0, to: 12,loop: false);
    _animDeath = spriteSheet.createAnimation(row: 4, stepTime: 0.1, from: 0, to: 13,loop: false);
    anchor = Anchor.center;
    animation = _animIdle;
    size = _spriteSheetSize;
    position = _startPos;
    _hitbox = EnemyHitbox(_hitBoxPoint,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(_hitbox);
    _weapon = DefaultEnemyWeapon(
        _ind1,collisionType: DCollisionType.inactive, onStartWeaponHit: onStartHit, onEndWeaponHit: onEndHit, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(_weapon);
    _weapon.damage = 3;
    bodyDef.position = _startPos * PhysicVals.physicScale;
    var temUs = bodyDef.userData as BodyUserData;
    temUs.onBeginMyContact = onGround;
    groundBody = Ground(bodyDef, gameRef.world.physicsWorld, isEnemy: true);
    FixtureDef fx = FixtureDef(PolygonShape()..set(getPointsForActivs(Vector2(90 - 112,87 - 96), Vector2(41,38), scale: PhysicVals.physicScale)));
    groundBody?.createFixture(fx);
    var massData = groundBody!.getMassData();
    massData.mass = 2000;
    groundBody!.setMassData(massData);
    // _ground = Ground(getPointsForActivs(Vector2(90 - 112,87 - 96), Vector2(41,38))
    //     , collisionType: DCollisionType.passive, isSolid: false, isStatic: false, isLoop: true, gameKyrgyz: gameRef);
    // _ground.onlyForPlayer = true;
    // add(_ground);
    var defWep = DefaultEnemyWeapon(_hitBoxPoint, collisionType: DCollisionType.active, isSolid: false, isStatic: false
        , onStartWeaponHit: null, onEndWeaponHit: null, isLoop: true, game: game);
    add(defWep);
    defWep.damage = 3;
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

  void changeAttackVerts(int index)
  {
    if(index == 1){
      _weapon.changeVertices(_ind1);
      _weapon.collisionType = DCollisionType.active;
    }else if(index == 2){
      _weapon.changeVertices(_ind2,isLoop: true);
    }else if(index == 8){
      _weapon.changeVertices(_ind3,isLoop: true);
    }else if(index == 12){
      _weapon.collisionType = DCollisionType.inactive;
      _weapon.changeVertices(_ind1,isLoop: true);
    }
  }

  void selectBehaviour()
  {
    if(gameRef.gameMap.orthoPlayer == null){
      return;
    }
    if (isNearPlayer()) {
      _weapon.currentCoolDown = _weapon.coolDown;
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
      _weapon.hit();
      return;
    }
    int random = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(random != 0 || _wasHit){
      int shift = 0;
      if(position.x < gameRef.gameMap.orthoPlayer!.position.x){
        shift = -65;
      }else{
        shift = 65;
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
    _weapon.currentCoolDown = _weapon.coolDown;
    _speed.x = 0;
    _speed.y = 0;
    animation = null;
    animation = _animAttack;
    animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    animationTicker?.onFrame = changeAttackVerts;
    animationTicker?.onComplete = onEndHit;
    _wasHit = true;
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
    if(pl.hitBox!.getMinVector().y > _weapon.getMaxVector().y || pl.hitBox!.getMaxVector().y < _weapon.getMinVector().y){
      return false;
    }
    if(position.distanceToSquared(pl.position) > 75 * 75){
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
    _weapon.collisionType = DCollisionType.inactive;
    animation = null;
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
        gameRef.gameMap.container.add(temp);
      }else{
        var temp = LootOnMap(loots.first, position: positionOfAnchor(Anchor.center));
        gameRef.gameMap.container.add(temp);
      }
    }
    animation = _animDeath;
    _hitbox.collisionType = DCollisionType.inactive;
    groundBody?.setActive(false);
    if(groundBody != null){
      gameRef.world.destroyBody(groundBody!);
    }
    // removeAll(children);
    animationTicker?.onComplete = () {
      add(OpacityEffect.by(-1,EffectController(duration: animationTicker?.totalDuration()),onComplete: (){
        gameRef.gameMap.loadedLivesObjs.remove(id);
        removeFromParent();
      }));
    };
    gameRef.dbHandler.changeItemState(id: id, worldName: gameRef.gameMap.currentGameWorldData!.nameForGame,usedAsString: '1');
  }

  @override
  void update(double dt)
  {
    if(!isRefresh){
      return;
    }
    super.update(dt);
    position = groundBody!.position / PhysicVals.physicScale;
    int pos = position.y.toInt();
    if(pos <= 0){
      pos = 1;
    }
    priority = pos;
    // if(_hitbox.getMaxVector().y > gameRef.gameMap.orthoPlayer!.hitBox!.getMaxVector().y && parent != gameRef.gameMap.enemyOnPlayer){
    //   parent = gameRef.gameMap.enemyOnPlayer;
    // }else if (parent != gameRef.gameMap.enemyComponent){
    //   parent = gameRef.gameMap.enemyComponent;
    // }
    if(animation == _animHurt || animation == _animAttack || animation == _animDeath || animation == null){
      return;
    }
    groundBody?.applyLinearImpulse(_speed * dt * groundBody!.mass);
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
      var shader = gameRef.fireShader;
      shader.setFloat(0,gameRef.gameMap.shaderTime);
      shader.setFloat(1, 4); //scalse
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

  @override
  Map<MagicDamage, int> magicDamages = {};
}