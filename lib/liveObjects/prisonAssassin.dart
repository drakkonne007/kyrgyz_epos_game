import 'dart:ui';
import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/EnemyInfo.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';

const double zoomScale = 1.3;

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
  Vector2(103 - 110,65 - 48) * zoomScale * PhysicVals.physicScale,
  Vector2(117 - 110,65 - 48) * zoomScale * PhysicVals.physicScale,
  Vector2(117 - 110,75 - 48) * zoomScale * PhysicVals.physicScale,
  Vector2(103 - 110,75 - 48) * zoomScale * PhysicVals.physicScale,
];

final List<Vector2> weaponPoints = [ //вторая колонка
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

class PrisonAssassin extends KyrgyzEnemy
{
  PrisonAssassin(this._startPos, {required super.id, required super.level});
  final Vector2 _spriteSheetSize = Vector2(220,96);
  final Vector2 _startPos;

  @override
  Future<void> onLoad() async
  {
    dopPriority = (30 * zoomScale).toInt();
    shiftAroundAnchorsForHit = 20;
    distPlayerLength = 60*60;
    armor = AssasinUndeadInfo.armor(level);
    chanceOfLoot = 0.3;
    health = AssasinUndeadInfo.health(level);
    maxLoots = 3;
    maxSpeed = AssasinUndeadInfo.speed;
    Image spriteImage = await Flame.images.load(
        'tiles/map/prisonSet/Characters/Assassin like enemy/Assassin like enemy - all animations.png');
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _spriteSheetSize);
    int seed = DateTime.now().microsecond;
    animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 7, loop: false);
    animIdle2 = spriteSheet.createAnimation(row: 1, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 10, loop: false);
    animMove = spriteSheet.createAnimation(row: 2, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 6, loop: false);
    animAttack = spriteSheet.createAnimation(row: 3, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0,to: 9, loop: false);
    animAttack2 = spriteSheet.createAnimation(row: 5, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0,to: 11, loop: false);
    animHurt = spriteSheet.createAnimation(row: 6, stepTime: 0.06 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 7,loop: false);
    animDeath = spriteSheet.createAnimation(row: 7, stepTime: 0.1 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0,loop: false);
    anchor = Anchor.center;
    animation = animIdle;
    animationTicker?.onComplete = selectBehaviour;
    size *= zoomScale;
    position = _startPos;
    hitBox = EnemyHitbox(_hitBoxPoints,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(hitBox!);
    bodyDef.position = _startPos * PhysicVals.physicScale;
    groundBody = Ground(bodyDef, gameRef.world.physicsWorld, isEnemy: true);
    FixtureDef fx = FixtureDef(PolygonShape()..set(_groundBoxPoints));
    groundBody?.createFixture(fx);
    var massData = groundBody!.getMassData();
    massData.mass = 1000;
    groundBody!.setMassData(massData);
    weapon = DefaultEnemyWeapon(
        weaponPoints,collisionType: DCollisionType.inactive, onStartWeaponHit: null, onEndWeaponHit: null, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(weapon!);
    weapon?.damage = AssasinUndeadInfo.damage(level);
    int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(rand == 0){
      flipHorizontally();
    }
    super.onLoad();
  }

  @override
  void changeVertsInWeapon(int index)
  {
    if(animation == animAttack){
      if(index == 3){
        weapon?.collisionType = DCollisionType.active;
      }else if(index == 5){
        weapon?.collisionType = DCollisionType.inactive;
      }
    }else{
      if(index == 4){
        weapon?.collisionType = DCollisionType.active;
      }else if(index == 6){
        weapon?.collisionType = DCollisionType.inactive;
      }
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
    // int pos = position.y.toInt() + (30 * zoomScale).toInt();
    // if(pos <= 0){
    //   pos = 1;
    // }
    // priority = pos;
    if(animation == animHurt || animation == animAttack || animation == animDeath || animation == null || animation == animAttack2){
      return;
    }
    groundBody?.applyLinearImpulse(speed * dt * groundBody!.mass);
  }
}