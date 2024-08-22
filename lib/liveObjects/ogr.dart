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
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'dart:math' as math;

const double zoomScale = 1.4;

final List<Vector2> _ground = [
  Vector2(-8.69533,0.113669) * PhysicVals.physicScale * zoomScale
  ,Vector2(-11.7451,14.4909) * PhysicVals.physicScale * zoomScale
  ,Vector2(12.2171,14.9992) * PhysicVals.physicScale * zoomScale
  ,Vector2(9.31257,0.0410569) * PhysicVals.physicScale * zoomScale
  ,];

final List<Vector2> _attack1ind7 = [
  Vector2(-9.53588,0.313003) * zoomScale
  ,Vector2(-18.0629,-6.99587) * zoomScale
  ,Vector2(-15.9514,-15.5229) * zoomScale
  ,Vector2(-2.87669,-9.26974) * zoomScale
  ,];

final List<Vector2> _attack1ind8 = [
  Vector2(10.7823,-5.18749) * zoomScale
  ,Vector2(3.16294,8.78138) * zoomScale
  ,Vector2(23.058,12.8733) * zoomScale
  ,Vector2(42.1065,2.57299) * zoomScale
  ,Vector2(45.9162,-12.948) * zoomScale
  ,Vector2(34.6282,-26.4936) * zoomScale
  ,Vector2(17.5551,-29.7388) * zoomScale
  ,Vector2(10.359,-18.0276) * zoomScale
  ,Vector2(34.6282,-15.6289) * zoomScale
  ,Vector2(25.7389,-4.0587) * zoomScale
  ,];

final List<Vector2> _attack1ind9 = [
  Vector2(24.5266,-29.0825) * zoomScale
  ,Vector2(37.3453,-16.2637) * zoomScale
  ,Vector2(27.1827,4.29243) * zoomScale
  ,Vector2(38.8466,-1.2508) * zoomScale
  ,Vector2(43.3505,-14.416) * zoomScale
  ,Vector2(36.3059,-26.1954) * zoomScale
  ,];


final List<Vector2> _hitBoxPoint = [
  Vector2(-8.69533,0.113669) * zoomScale
  ,Vector2(-11.7451,14.4909) * zoomScale
  ,Vector2(12.2171,14.9992) * zoomScale
  ,Vector2(4.63,-29.9448) * zoomScale
  ,Vector2(-4.78062,-28.7938) * zoomScale
  ,];

class Ogr extends KyrgyzEnemy
{
  Ogr(this._startPos, {required super.level, required super.id});
  final Vector2 _startPos;
  final srcSize = Vector2(256,224);


  @override
  Future<void> onLoad() async
  {
    dopPriority = (15 * zoomScale).toInt();
    shiftAroundAnchorsForHit = 60;
    distPlayerLength = 70 * 70;
    maxLoots = 3;
    chanceOfLoot = 0.02;
    health = OgrInfo.health(level);
    maxSpeed = OgrInfo.speed;
    armor = OgrInfo.armor(level);
    int seed = DateTime.now().microsecond;
    if(gameRef.gameMap.currentGameWorldData!.isDungeon) {
      SpriteSheet spriteSheet = SpriteSheet(image: await Flame.images.load(
          'tiles/map/mountainLand/Characters/Enemy 1/variation1/enemy 1 var1-atk1.png'
      ), srcSize: srcSize);
      animAttack = spriteSheet.createAnimation(
          row: 0, stepTime: 0.07 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, loop: false);

      spriteSheet = SpriteSheet(image: await Flame.images.load(
          'tiles/map/mountainLand/Characters/Enemy 1/variation1/enemy 1 var1-death.png'
      ), srcSize: srcSize);
      animDeath = spriteSheet.createAnimation(row: 0, stepTime: 0.1 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, loop: false);

      spriteSheet = SpriteSheet(image: await Flame.images.load(
          'tiles/map/mountainLand/Characters/Enemy 1/variation1/enemy 1 var1-idle.png'
      ), srcSize: srcSize);
      animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, loop: false);

      spriteSheet = SpriteSheet(image: await Flame.images.load(
          'tiles/map/mountainLand/Characters/Enemy 1/variation1/enemy 1 var1-walk.png'
      ), srcSize: srcSize);
      animMove = spriteSheet.createAnimation(row: 0,stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125,from: 0,loop: false);

      spriteSheet = SpriteSheet(image: await Flame.images.load(
          'tiles/map/mountainLand/Characters/Enemy 1/variation1/enemy 1 var1-hurt.png'
      ), srcSize: srcSize);
      animHurt = spriteSheet.createAnimation(row: 0, stepTime: 0.06 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, loop: false);

      spriteSheet = SpriteSheet(image: await Flame.images.load(
          'tiles/map/mountainLand/Characters/Enemy 1/enemy 1-atk2.png'
      ), srcSize: srcSize);
      animAttack2 = spriteSheet.createAnimation(row: 0, stepTime: 0.07 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, loop: false);

    }else{
      SpriteSheet spriteSheet = SpriteSheet(image: await Flame.images.load(
          'tiles/map/mountainLand/Characters/Enemy 1/enemy 1-atk1.png'
      ), srcSize: srcSize);
      animAttack = spriteSheet.createAnimation(row: 0, stepTime: 0.07 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, loop: false);

      spriteSheet = SpriteSheet(image: await Flame.images.load(
          'tiles/map/mountainLand/Characters/Enemy 1/enemy 1-death.png'
      ), srcSize: srcSize);
      animDeath = spriteSheet.createAnimation(row: 0, stepTime: 0.1 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, loop: false);

      spriteSheet = SpriteSheet(image: await Flame.images.load(
          'tiles/map/mountainLand/Characters/Enemy 1/enemy 1-idle.png'
      ), srcSize: srcSize);
      animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, loop: false);

      spriteSheet = SpriteSheet(image: await Flame.images.load(
          'tiles/map/mountainLand/Characters/Enemy 1/enemy 1-walk.png'
      ), srcSize: srcSize);
      animMove = spriteSheet.createAnimation(row: 0, stepTime: 0.08 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, loop: false);

      spriteSheet = SpriteSheet(image: await Flame.images.load(
          'tiles/map/mountainLand/Characters/Enemy 1/enemy 1-hurt.png'
      ), srcSize: srcSize);
      animHurt = spriteSheet.createAnimation(row: 0, stepTime: 0.07 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, loop: false);

      spriteSheet = SpriteSheet(image: await Flame.images.load(
          'tiles/map/mountainLand/Characters/Enemy 1/enemy 1-atk2.png'
      ), srcSize: srcSize);
      animAttack2 = spriteSheet.createAnimation(row: 0, stepTime: 0.07 + math.Random(seed++).nextDouble() / 40 - 0.0125, from: 0, loop: false);
    }
    anchor = const Anchor(0.44922,0.5);
    animation = animIdle;
    animationTicker?.onComplete = selectBehaviour;
    position = _startPos;
    hitBox = EnemyHitbox(_hitBoxPoint,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(hitBox!);
    weapon = DefaultEnemyWeapon(
        _attack1ind7,collisionType: DCollisionType.inactive, onStartWeaponHit: null, onEndWeaponHit: null, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(weapon!);
    weapon?.damage = OgrInfo.damage(level);
    bodyDef.position = _startPos * PhysicVals.physicScale;
    groundBody = Ground(bodyDef, gameRef.world.physicsWorld, isEnemy: true);
    FixtureDef fx = FixtureDef(PolygonShape()..set(_ground));
    groundBody?.createFixture(fx);
    var massData = groundBody!.getMassData();
    massData.mass = 2000;
    groundBody!.setMassData(massData);
    int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(rand == 0){
      flipHorizontally();
    }
    size *= zoomScale;
    super.onLoad();
  }

  @override
  void changeVertsInWeapon(int index)
  {
    if(animation == animAttack) {
      if (index == 7) {
        weapon?.changeVertices(_attack1ind7, isLoop: true);
        weapon?.collisionType = DCollisionType.active;
      } else if (index == 8) {
        weapon?.changeVertices(_attack1ind8, isLoop: true);
      } else if (index == 9) {
        weapon?.changeVertices(_attack1ind9, isLoop: true);
      } else if (index == 10) {
        weapon?.collisionType = DCollisionType.inactive;
      }
    }else{
      if (index == 9) {
        if(isFlippedHorizontally) {
          gameRef.gameMap.container.add(
              CrystalAttack(position: position - Vector2(42.3036, -4.86464))..flipHorizontally());
        }else{
          gameRef.gameMap.container.add(
              CrystalAttack(position: position + Vector2(42.3036, -4.86464)));
        }
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
    // int pos = position.y.toInt() + (15 * zoomScale).toInt();
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



class CrystalAttack extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  final List<Vector2> _ind1 = [
    Vector2(-39.0797,2.11664)
    ,Vector2(10.3252,-14.2934)
    ,Vector2(20.276,0.196315)
    ,Vector2(8.92858,16.9556)
    ,Vector2(-36.1119,5.60815)
    ,Vector2(6.6591,11.02)
    ,Vector2(8.754,-8.70703)
    ,Vector2(-4.16458,6.48103)
    ,Vector2(-6.78321,-2.42232)
    ,Vector2(-21.0984,2.29122)
    ,];

  final List<Vector2> _ind2 = [
    Vector2(-39.064,4.48612)
    ,Vector2(45.5454,-31.7751)
    ,Vector2(70.9786,0.4571)
    ,Vector2(50.3299,39.9919)
    ,Vector2(-34.5314,7.50789)
    ,Vector2(48.819,31.1784)
    ,Vector2(45.2936,-22.7098)
    ,Vector2(21.1195,17.0768)
    ,Vector2(13.3133,-7.34913)
    ,Vector2(-7.83911,6.75245)
    ,];

  CrystalAttack({required super.position});
  DefaultEnemyWeapon? weapon;

  @override
  void onLoad()async
  {
    priority = GamePriority.maxPriority;
    anchor = const Anchor(0.320313,0.5);
    SpriteSheet spr = SpriteSheet(image: await Flame.images.load('tiles/map/mountainLand/Characters/Enemy 1/enemy 1-atk2-crystals.png'), srcSize: Vector2(128,128));
    animation = spr.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    animationTicker?.onComplete = removeFromParent;
    animationTicker?.onFrame = changeVerts;
    weapon = DefaultEnemyWeapon(_ind1, collisionType: DCollisionType.active, isStatic: false, game: gameRef,isLoop: true);
    // weapon!.coolDown = 1;
    weapon!.damage = 4;
    add(weapon!);
  }

  void changeVerts(int index)
  {
    if (index == 1) {
      weapon?.changeVertices(_ind2, isLoop: true);
    }else if(index == 3){
      weapon?.collisionType = DCollisionType.inactive;
    }
  }
}