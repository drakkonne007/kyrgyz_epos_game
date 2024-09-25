import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/abstracts/EnemyInfo.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
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

class Moose extends KyrgyzEnemy
{

  Moose(this._startPos, {required super.id, required super.level, super.loots,required super.citizen,required super.quest,required super.startTrigger,required super.endTrigger});
  final Vector2 _startPos;
  final Vector2 _spriteSheetSize = Vector2(347,192);


  @override
  Future<void> onLoad() async
  {
    beast = true;
    dopPriority = 26;
    highQuest = 70  - 96;
    shiftAroundAnchorsForHit = 100;
    distPlayerLength = 10000;
    maxLoots = 2;
    chanceOfLoot = 0.3;
    health = MooseInfo.health(level);
    maxSpeed = MooseInfo.speed;
    armor = MooseInfo.armor(level);
    Image? spriteImage;
    int randMy = math.Random().nextInt(5);

    switch(randMy){
      case 0: spriteImage = await Flame.images.load('tiles/sprites/players/moose1-347x192.png'); break;
      case 1: spriteImage = await Flame.images.load('tiles/sprites/players/moose2-347x192.png'); break;
      case 2: spriteImage = await Flame.images.load('tiles/sprites/players/moose3-347x192.png'); break;
      case 3: spriteImage = await Flame.images.load('tiles/sprites/players/moose4-347x192.png'); break;
      case 4: spriteImage = await Flame.images.load('tiles/sprites/players/moose6-347x192.png'); break;
      default: spriteImage = await Flame.images.load('tiles/sprites/players/moose1-347x192.png'); break;
    }
    int seed = DateTime.now().microsecond;
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _spriteSheetSize);
    animIdle =
        spriteSheet.createAnimation(row: 0, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 8, loop: false);
    animMove =
        spriteSheet.createAnimation(row: 1, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 8, loop: false);
    animAttack = spriteSheet.createAnimation(
        row: 2, stepTime: 0.07 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, loop: false);
    animHurt = spriteSheet.createAnimation(row: 3,
        stepTime: 0.06 + math.Random(seed++).nextDouble() / 40 - 0.0125,
        from: 0,
        to: 6,
        loop: false);
    animDeath = spriteSheet.createAnimation(row: 4,
        stepTime: 0.1 + math.Random(seed++).nextDouble() / 40 - 0.0125,
        from: 0,
        to: 15,
        loop: false);
    position = _startPos;
    animation = animIdle;
    animationTicker?.onComplete = selectBehaviour;
    const double percentOfWidth = 158/347;
    Vector2 staticConstAnchor = Vector2(size.x * percentOfWidth,size.y/2);
    anchor = const Anchor(percentOfWidth, 0.5);
    hitBox = EnemyHitbox(hitBoxPoint,collisionType: DCollisionType.passive
        ,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(hitBox!);
    bodyDef.position = _startPos * PhysicVals.physicScale;
    groundBody = Ground(bodyDef, gameRef.world.physicsWorld, isEnemy: true);
    var massData = groundBody!.getMassData();
    massData.mass = 1400;
    FixtureDef fx = FixtureDef(PolygonShape()..set(getPointsForActivs(Vector2(145,97) - staticConstAnchor, Vector2(24,25), scale: PhysicVals.physicScale)));
    groundBody?.createFixture(fx);
    groundBody?.setMassData(massData);
    // _ground = Ground(getPointsForActivs(Vector2(145,97) - staticConstAnchor, Vector2(24,25))
    //     , collisionType: DCollisionType.passive, isSolid: false, isStatic: false, isLoop: true, gameKyrgyz: gameRef);
    // _ground.onlyForPlayer = true;
    weapon = DefaultEnemyWeapon(ind1, collisionType: DCollisionType.inactive, isSolid: false, isStatic: false
        , onStartWeaponHit: null, onEndWeaponHit: null, isLoop: true, game: game);
    add(weapon!);
    weapon!.damage = MooseInfo.damage(level);
    int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(rand == 0){
      flipHorizontally();
    }
    super.onLoad();
  }

  @override
  void changeVertsInWeapon(int index)
  {
    // if(index == 3) {
    //   weapon?.changeVertices(ind1,isLoop: true);
    // }
    if(index == 7){
      weapon?.collisionType = DCollisionType.active;
      weapon?.changeVertices(ind2,isLoop: true);
    }else if(index == 9){
      weapon?.changeVertices(ind3,isLoop: true);
    }else if(index == 10){
      weapon?.changeVertices(rad,radius: 55, isSolid: true);
    }else if(index == 12){
      weapon?.collisionType = DCollisionType.inactive;
    }
  }

  @override
  void update(double dt)
  {
    if(isFreeze > 0){
      return;
    }
    super.update(dt);
    if(!isRefresh){
      return;
    }
    position = groundBody!.position / PhysicVals.physicScale;
    // int pos = position.y.toInt() + 26;
    // if(pos <= 0){
    //   pos = 1;
    // }
    // priority = pos;
    if(animation == animHurt || animation == animAttack || animation == animDeath || animation == null){
      return;
    }
    groundBody?.applyLinearImpulse(speed * dt * groundBody!.mass);
  }

}
