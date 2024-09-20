import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/EnemyInfo.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/Items/Dresses/item.dart';
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
  GrassGolem(this._startPos,this.spriteVariant,{required super.level,required super.id, super.loots});
  final Vector2 _spriteSheetSize = Vector2(224,192);
  final Vector2 _startPos;
  final GolemVariant spriteVariant;


  @override
  Future<void> onLoad() async
  {
    dopPriority = 29;
    shiftAroundAnchorsForHit = 65;
    distPlayerLength = 75 * 75;
    maxLoots = 1;
    chanceOfLoot = 0.4;
    health = GollemInfo.health(level);
    maxSpeed = GollemInfo.speed;
    armor = GollemInfo.armor(level);
    Image? spriteImage;
    int randVar = math.Random().nextInt(2);
    if(randVar == 0){
      spriteImage = await Flame.images.load(
          'tiles/sprites/players/Stone-224x192.png');
    }else{
      spriteImage = await Flame.images.load(
          'tiles/sprites/players/Stone2-224x192.png');
    }
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _spriteSheetSize);
    int seed = DateTime.now().microsecond;
    animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 8,loop: false);
    animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 8,loop: false);
    animAttack = spriteSheet.createAnimation(row: 2, stepTime: 0.07 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0,loop: false);
    animHurt = spriteSheet.createAnimation(row: 3, stepTime: 0.07 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 12,loop: false);
    animDeath = spriteSheet.createAnimation(row: 4, stepTime: 0.1 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 13,loop: false);
    anchor = Anchor.center;
    animation = animIdle;
    animationTicker?.onComplete = selectBehaviour;
    position = _startPos;
    hitBox = EnemyHitbox(_hitBoxPoint,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(hitBox!);
    weapon = DefaultEnemyWeapon(
        _ind1,collisionType: DCollisionType.inactive, onStartWeaponHit: null, onEndWeaponHit: null, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(weapon!);
    weapon?.damage = GollemInfo.damage(level);
    bodyDef.position = _startPos * PhysicVals.physicScale;
    groundBody = Ground(bodyDef, gameRef.world.physicsWorld, isEnemy: true);
    FixtureDef fx = FixtureDef(PolygonShape()..set(getPointsForActivs(Vector2(90 - 112,87 - 96), Vector2(41,38), scale: PhysicVals.physicScale)));
    groundBody?.createFixture(fx);
    var massData = groundBody!.getMassData();
    massData.mass = 2000;
    groundBody!.setMassData(massData);
    super.onLoad();
  }

  @override
  void changeVertsInWeapon(int index)
  {
    if(index == 7){
      weapon?.changeVertices(_ind3,isLoop: true);
      weapon?.collisionType = DCollisionType.active;
    }else if(index == 10){
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
    if(animation == animHurt || animation == animAttack || animation == animDeath || animation == null){
      return;
    }
    groundBody?.applyLinearImpulse(speed * dt * groundBody!.mass);
  }
}