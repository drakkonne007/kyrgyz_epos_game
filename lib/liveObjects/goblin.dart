import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'dart:math' as math;

final List<Vector2> _ground = [
  Vector2(-11.0052,30.7297) * PhysicVals.physicScale
  ,Vector2(-14.9522,18.7306) * PhysicVals.physicScale
  ,Vector2(11.73,17.1518) * PhysicVals.physicScale
  ,Vector2(6.67772,30.5719) * PhysicVals.physicScale
  ,];

final List<Vector2> _attack1ind2 = [ //5 frame - boldu
  Vector2(23.4703,17.6709)
  ,Vector2(29.1106,33.9148)
  ,Vector2(44.452,35.9453)
  ,Vector2(59.1167,27.8233)
  ,Vector2(60.0192,13.6099)
  ,Vector2(47.1594,4.58549)
  ,Vector2(34.074,4.35988)
  ,Vector2(46.4825,12.0306)
  ,Vector2(46.2569,24.8904)
  ,];

final List<Vector2> _attack2ind8 = [ //10 всё
  Vector2(-11.0099,3.22065)
  ,Vector2(10.7379,24.7214)
  ,Vector2(28.0374,28.4284)
  ,Vector2(46.8196,23.98)
  ,Vector2(49.0438,10.3876)
  ,Vector2(40.147,2.23211)
  ,Vector2(21.1176,6.4334)
  ,Vector2(27.5431,16.3188)
  ,];

final List<Vector2> _hitBoxPoint = [
  Vector2(-10.7231,30.436)
  ,Vector2(-6.43053,5.39616)
  ,Vector2(1.08142,-4.0236)
  ,Vector2(7.75872,-3.66588)
  ,Vector2(8.23566,11.1196)
  ,Vector2(6.68558,30.5552)
  ,];

class Goblin extends KyrgyzEnemy
{
  Goblin(this._startPos,int id){this.id = id;}
  final Vector2 _startPos;
  final srcSize = Vector2(160,128);


  @override
  Future<void> onLoad() async
  {
    shiftAroundAnchorsForHit = 45;
    distPlayerLength = 55 * 55;
    maxLoots = 3;
    chanceOfLoot = 0.02;
    health = 30;
    maxSpeed = 40;


    SpriteSheet spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Enemy 2/enemy 2-atk1-no combo.png'
    ), srcSize: srcSize);
    animAttack = spriteSheet.createAnimation(row: 0, stepTime: 0.05, from: 0, loop: false);

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Enemy 2/enemy 2-death.png'
    ), srcSize: srcSize);
    animDeath = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, loop: false);

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Enemy 2/enemy 2-idle.png'
    ), srcSize: srcSize);
    animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Enemy 2/enemy 2-walk.png'
    ), srcSize: srcSize);
    animMove = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Enemy 2/enemy 2-hurt.png'
    ), srcSize: srcSize);
    animHurt = spriteSheet.createAnimation(row: 0, stepTime: 0.06, from: 0, loop: false);

    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Enemy 2/enemy 2-atk1.png'
    ), srcSize: srcSize);
    List<Sprite> temp = [];
    List<double> times = [];
    for(int i = 0; i < spriteSheet.columns; i++){
      temp.add(spriteSheet.getSprite(0, i));
      times.add(0.05);
    }
    spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/mountainLand/Characters/Enemy 2/enemy 2-atk2.png'
    ), srcSize: srcSize);
    for(int i = 0; i < spriteSheet.columns; i++){
      temp.add(spriteSheet.getSprite(0, i));
      times.add(0.05);
    }
    animAttack2 = SpriteAnimation.variableSpriteList(temp,stepTimes: times,loop: false);

    anchor = const Anchor(0.5,0.5);
    animation = animIdle;
    animationTicker?.onComplete = selectBehaviour;
    position = _startPos;
    hitBox = EnemyHitbox(_hitBoxPoint,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(hitBox!);
    weapon = DefaultEnemyWeapon(
        _attack1ind2,collisionType: DCollisionType.inactive, onStartWeaponHit: null, onEndWeaponHit: null, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(weapon!);
    weapon?.damage = 4;
    bodyDef.position = _startPos * PhysicVals.physicScale;
    var temUs = bodyDef.userData as BodyUserData;
    temUs.onBeginMyContact = onGround;
    groundBody = Ground(bodyDef, gameRef.world.physicsWorld, isEnemy: true);
    FixtureDef fx = FixtureDef(PolygonShape()..set(_ground));
    groundBody?.createFixture(fx);
    var massData = groundBody!.getMassData();
    massData.mass = 600;
    groundBody!.setMassData(massData);
    int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(rand == 0){
      flipHorizontally();
    }
    super.onLoad();
  }

  @override
  void changeVertsInWeapon(int index)
  {
    if(index == 2){
      weapon?.changeVertices(_attack1ind2, isLoop: true);
      weapon?.collisionType = DCollisionType.active;
    }else if(index == 5){
      weapon?.collisionType = DCollisionType.inactive;
    }
    if(animation == animAttack2){
      if(index == 8){
        weapon?.changeVertices(_attack2ind8, isLoop: true);
        weapon?.collisionType = DCollisionType.active;
      }else if(index > 9){
        weapon?.collisionType = DCollisionType.inactive;
      }
    }
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    if(!isRefresh){
      return;
    }
    position = groundBody!.position / PhysicVals.physicScale;
    int pos = position.y.toInt() + 30;
    if(pos <= 0){
      pos = 1;
    }
    priority = pos;
    if(animation == animHurt || animation == animAttack || animation == animDeath || animation == null){
      return;
    }
    groundBody?.applyLinearImpulse(speed * dt * groundBody!.mass);
  }
}