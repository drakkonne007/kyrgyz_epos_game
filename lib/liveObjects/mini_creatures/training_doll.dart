import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

final List<Vector2> _groundPoints = [
  Vector2(-8.82466,6.33684) * PhysicVals.physicScale
  ,Vector2(-8.35575,28.6883) * PhysicVals.physicScale
  ,Vector2(7.58727,28.8446) * PhysicVals.physicScale
  ,Vector2(8.8377,5.71162) * PhysicVals.physicScale
  ,];

final List<Vector2> _hitboxPoint = [
  Vector2(-8.08437,-25.8041)
  ,Vector2(-8.67502,17.5108)
  ,Vector2(8.65095,17.7077)
  ,Vector2(6.87897,-25.6072)
  ,];

class TrainingDoll extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  TrainingDoll({required super.position, required this.id});

  late Ground _ground;
  late EnemyHitbox _hitbox;
  late SpriteAnimation _hit1, _hit2,_hit3, _idle;
  int id;
  bool used = false;

  @override
  void onRemove()
  {
    _ground.destroy();
  }

  @override
  void onLoad() async
  {
    var dd = await gameRef.dbHandler.getItemStateFromDb(id, gameRef.gameMap.currentGameWorldData!.nameForGame);
    used = dd.used;
    anchor = const Anchor(0.5, 0.5);
    priority = position.y.toInt() + 29;
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load(
          'tiles/map/grassLand2/Props/Animated props/trainning dummy-hit1.png'),
      srcSize: Vector2.all(128)
    );
    _hit1 = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    _idle = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to:1, loop: false);
    spriteSheet = SpriteSheet(
        image: await Flame.images.load(
            'tiles/map/grassLand2/Props/Animated props/trainning dummy-hit2.png'),
        srcSize: Vector2.all(128)
    );
    _hit2 = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    spriteSheet = SpriteSheet(
        image: await Flame.images.load(
            'tiles/map/grassLand2/Props/Animated props/trainning dummy-hit3.png'),
        srcSize: Vector2.all(128)
    );
    _hit3 = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    animation = _idle;
    FixtureDef fix = FixtureDef(PolygonShape()..set(_groundPoints));
    _ground = Ground(
        BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );
    _ground.createFixture(fix);
    _hitbox = EnemyHitbox(_hitboxPoint,
        collisionType: DCollisionType.passive,isSolid: true,isStatic: false, isLoop: true, game: gameRef, onStartColl: changeAnim);
    add(_hitbox);
  }

  void changeAnim(DCollisionEntity other)
  {
    if(!used){
      used = true;
      gameRef.playerData.addLevel(300);
      gameRef.dbHandler.changeItemState(id: id, worldName: gameRef.gameMap.currentGameWorldData!.nameForGame, used: true);
    }
    if(animation == _idle){
      int rand = Random().nextInt(3);
      switch(rand){
        case 0: animation = _hit1; break;
        case 1: animation = _hit2; break;
        case 2: animation = _hit3; break;
      }
      animationTicker?.onComplete = (){
        animation = _idle;
      };
    }
  }
}