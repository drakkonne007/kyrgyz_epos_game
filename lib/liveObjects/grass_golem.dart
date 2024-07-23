import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'dart:math' as math;

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

class GrassGolem extends KyrgyzEnemy
{
  GrassGolem(this._startPos,this.spriteVariant,int id){this.id = id;}
  late SpriteAnimation _animMove, _animIdle, _animAttack, _animHurt, _animDeath;
  final Vector2 _spriteSheetSize = Vector2(224,192);
  final Vector2 _startPos;
  final GolemVariant spriteVariant;
  final double distPlayerLength = 75 * 75;


  @override
  Future<void> onLoad() async
  {
    maxLoots = 1;
    chanceOfLoot = 0.02;
    health = 20;
    maxSpeed = 20;
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
    hitBox = EnemyHitbox(_hitBoxPoint,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(hitBox!);
    weapon = DefaultEnemyWeapon(
        _ind1,collisionType: DCollisionType.inactive, onStartWeaponHit: onStartHit, onEndWeaponHit: onEndHit, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(weapon!);
    weapon?.damage = 3;
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
          , gameRef, _startPos)) {
        animation = _animIdle;
        animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      }
    },repeat: true,period: 2));
    int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(rand == 0){
      flipHorizontally();
    }
    super.onLoad();
    selectBehaviour();
  }

  void changeAttackVerts(int index)
  {
    if(index == 1){
      weapon?.changeVertices(_ind1);
      weapon?.collisionType = DCollisionType.active;
    }else if(index == 2){
      weapon?.changeVertices(_ind2,isLoop: true);
    }else if(index == 8){
      weapon?.changeVertices(_ind3,isLoop: true);
    }else if(index == 12){
      weapon?.collisionType = DCollisionType.inactive;
      weapon?.changeVertices(_ind1,isLoop: true);
    }
  }

  void selectBehaviour()
  {
    if(gameRef.gameMap.orthoPlayer == null){
      return;
    }
    if (isNearPlayer(distPlayerLength)) {
      weapon?.currentCoolDown = weapon?.coolDown ?? 0;
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
      weapon?.hit();
      return;
    }
    int random = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(random != 0 || wasHit){
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
      speed.x = math.cos(angle) * maxSpeed;
      speed.y = math.sin(angle) * maxSpeed;
      if(speed.x < 0 && !isFlippedHorizontally){
        flipHorizontally();
      }else if(speed.x > 0 && isFlippedHorizontally){
        flipHorizontally();
      }
      animation = _animMove;
    }else{
      if(animation != _animIdle){
        speed.x = 0;
        speed.y = 0;
        animation = _animIdle;
      }
    }
    animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    animationTicker?.onComplete = selectBehaviour;
  }

  void onStartHit()
  {
    weapon?.currentCoolDown = weapon?.coolDown ?? 0;
    speed.x = 0;
    speed.y = 0;
    animation = null;
    animation = _animAttack;
    animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    animationTicker?.onFrame = changeAttackVerts;
    animationTicker?.onComplete = onEndHit;
    wasHit = true;
  }

  void onEndHit()
  {
    selectBehaviour();
  }

  @override
  void doHurt({required double hurt, bool inArmor = true})
  {
    if(animation == _animDeath || hurt == 0){
      return;
    }
    if(!internalPhysHurt(hurt,inArmor)){
      return;
    }
    if(health < 1){
      death(_animDeath);
    }else{
      animation = _animHurt;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      animationTicker?.onComplete = selectBehaviour;
    }
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
    groundBody?.applyLinearImpulse(speed * dt * groundBody!.mass);
  }

  @override
  void doMagicHurt({required double hurt, required MagicDamage magicDamage}) {
    health -= hurt;
    if(health < 1){
      death(_animDeath);
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