import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/abstracts/EnemyInfo.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'dart:math' as math;

final List<Vector2> _grPoints = [
  Vector2(-5.4813,14.0557) * PhysicVals.physicScale * 1.2
  ,Vector2(-6.58885,31.3151) * PhysicVals.physicScale * 1.2
  ,Vector2(7.25555,31.2228) * PhysicVals.physicScale * 1.2
  ,Vector2(4.94815,14.0557) * PhysicVals.physicScale * 1.2
  ,];

final List<Vector2> _hitBox = [
  Vector2(-4.92848,31.173) * 1.2
  ,Vector2(-3.71149,-12.0856) * 1.2
  ,Vector2(3.03729,-10.7579) * 1.2
  ,Vector2(5.25,30.8411) * 1.2
  ,];

final List<Vector2> _attack = [ //4-5
  Vector2(12.7893,-31.5024) * 1.2
  ,Vector2(-19.2604,-25.3173) * 1.2
  ,Vector2(-37.0659,-10.1359) * 1.2
  ,Vector2(-35.5665,12.73) * 1.2
  ,Vector2(-7.45263,13.1049) * 1.2
  ,Vector2(-19.6353,-0.0149048) * 1.2
  ,Vector2(-33.1299,1.29707) * 1.2
  ,Vector2(-21.1347,-4.32569) * 1.2
  ,Vector2(-20.5724,-13.1347) * 1.2
  ,];

class HumanWarrior extends KyrgyzEnemy
{
  HumanWarrior(this._startPos, {required super.level, required super.id,required super.citizen,required super.quest,required super.startTrigger,required super.endTrigger});
  final Vector2 _startPos;

  @override
  Future<void> onLoad() async
  {
    beast = false;
    dopPriority = (31 * 1.2).toInt();
    highQuest = -12 * 1.2;
    isReverseBody = true;
    shiftAroundAnchorsForHit = 65;
    distPlayerLength = 75 * 75;
    maxLoots = 1;
    chanceOfLoot = 0.3;
    health = HumanInfo.health(level);
    maxSpeed = HumanInfo.speed;
    armor = HumanInfo.armor(level);
    Image? spriteImage;
    bool isMale = math.Random().nextBool();
    if(quest != null){
      citizen = true;
    }
    if(citizen){
      if (isMale) {
        int type = math.Random().nextInt(120) + 1;
        spriteImage = await Flame.images.load('tiles/sprites/humanNPC/Male/NoWeapon/$type.png');
      }else{
        int type = math.Random().nextInt(420) + 1;
        spriteImage = await Flame.images.load('tiles/sprites/humanNPC/Female/NoWeapon/$type.png');
      }
    }else {
      if (isMale) {
        int type = math.Random().nextInt(450) + 1;
        spriteImage =
        await Flame.images.load('tiles/sprites/humanNPC/Male/Weapon/$type.png');
      } else {
        int type = math.Random().nextInt(420) + 1;
        spriteImage = await Flame.images.load(
            'tiles/sprites/humanNPC/Female/Weapon/$type.png');
      }
    }
    SpriteSheet spriteSheet = SpriteSheet(
        image: spriteImage,
        srcSize:  Vector2(80,64));
    int seed = DateTime.now().microsecond;
    animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.13 + math.Random(seed++).nextDouble() / 40 - 0.0125,from: 0, to: 5, loop: false);
    animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.13 + math.Random(seed++).nextDouble() / 40 - 0.0125,from: 0, to: 8, loop: false);
    animAttack = spriteSheet.createAnimation(row: 5, stepTime: 0.13 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to:6,loop: false);
    animHurt = animIdle;
    animDeath = spriteSheet.createAnimation(row: 6, stepTime: 0.13 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, to: 10,loop: false);
    anchor = Anchor.center;
    animation = animIdle;
    animationTicker?.onComplete = selectBehaviour;
    position = _startPos;
    hitBox = EnemyHitbox(_hitBox,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(hitBox!);
    weapon = DefaultEnemyWeapon(
        _attack,collisionType: DCollisionType.inactive, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(weapon!);
    weapon?.damage = HumanInfo.damage(level);
    bodyDef.position = _startPos * PhysicVals.physicScale;
    groundBody = Ground(bodyDef, gameRef.world.physicsWorld, isEnemy: true);
    FixtureDef fx = FixtureDef(PolygonShape()..set(_grPoints));
    groundBody?.createFixture(fx);
    var massData = groundBody!.getMassData();
    massData.mass = 800;
    groundBody!.setMassData(massData);
    size *= 1.2;
    scale = Vector2(-1,1);
    super.onLoad();
  }

  @override
  void changeVertsInWeapon(int index)
  {
    if(index == 4){
      weapon?.collisionType = DCollisionType.active;
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