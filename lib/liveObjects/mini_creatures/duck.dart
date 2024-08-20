import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'dart:math' as math;

import 'package:game_flame/kyrgyz_game.dart';

class Duck extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{

  final List<Vector2> _groundPoints = [
    Vector2(-9.71584,-10.9642) * PhysicVals.physicScale
    ,Vector2(-9.57713,11.0908) * PhysicVals.physicScale
    ,Vector2(12.4779,11.3682) * PhysicVals.physicScale
    ,Vector2(11.923,-11.103) * PhysicVals.physicScale
    ,];

  Duck(this._startPos,this._id);
  final int _id;
  final Vector2 _startPos;
  final List<SpriteAnimation> _idles = [];
  late SpriteAnimation _idle1, _idle2, _idle3, _walkForward, _walkBack, _wolkSide;
  final double _velocity = 30;
  late Ground _groundHitBox;
  final Vector2 _source = Vector2.all(96);

  @override onLoad() async
  {
    TimerComponent timer = TimerComponent(onTick: _checkIsNeedSelfRemove,repeat: true,autoStart: true, period: 2);
    add(timer);
    anchor = Anchor.center;
    int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(3);
    rand++;
    String start = 'tiles/map/grassLand2/Characters/small animals/ducks/duck$rand';
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load('$start/small animals - duck-duck - idle - sideview.png'),
      srcSize: _source,
    );
    _idle1 = spriteSheet.createAnimation(row: 0, stepTime: 0.15,from: 0,loop: false);

    spriteSheet = SpriteSheet(
      image: await Flame.images.load('$start/small animals - duck-duck - idle 2 - sideview.png'),
      srcSize: _source,
    );
    _idle2 = spriteSheet.createAnimation(row: 0, stepTime: 0.15,from: 0,loop: false);

    spriteSheet = SpriteSheet(
      image: await Flame.images.load('$start/small animals - duck-duck - idle 3 - sideview.png'),
      srcSize: _source,
    );
    _idle3 = spriteSheet.createAnimation(row: 0, stepTime: 0.15,from: 0,loop: false);

    spriteSheet = SpriteSheet(
      image: await Flame.images.load('$start/small animals - duck-duck - walk - frontview.png'),
      srcSize: _source,
    );
    _walkForward = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0,loop: false);

    spriteSheet = SpriteSheet(
      image: await Flame.images.load('$start/small animals - duck-duck - walk - sideview.png'),
      srcSize: _source,
    );
    _wolkSide = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0,loop: false);

    spriteSheet = SpriteSheet(
      image: await Flame.images.load('$start/small animals - duck-duck - walk - backview.png'),
      srcSize: _source,
    );
    _walkBack = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0,loop: false);

    _idles.add(_idle1);
    _idles.add(_idle2);
    _idles.add(_idle3);

    BodyDef bf = BodyDef(type: BodyType.dynamic,position: _startPos * PhysicVals.physicScale,userData: BodyUserData(isQuadOptimizaion: false
    ), linearDamping: 1.5, angularDamping: 1.5);
    _groundHitBox = Ground(bf, gameRef.world.physicsWorld,isOnlyForStatic: true);
    _groundHitBox.createFixture(FixtureDef(PolygonShape()..set(_groundPoints), restitution: 0.7));
    add(TimerComponent(period: 0.6, repeat: true, onTick: checkPriority));
    position = _groundHitBox.position / PhysicVals.physicScale;
    chooseMove();
  }

  void checkPriority()
  {
    priority = position.y.toInt() + 11;
  }

  @override
  void onRemove()
  {
    _groundHitBox.destroy();
    gameRef.gameMap.loadedLivesObjs.remove(_id);
  }

  void _checkIsNeedSelfRemove()
  {
    int column = position.x ~/ GameConsts.lengthOfTileSquare.x;
    int row =    position.y ~/ GameConsts.lengthOfTileSquare.y;
    int diffCol = (column - gameRef.gameMap.column()).abs();
    int diffRow = (row - gameRef.gameMap.row()).abs();
    if(diffCol > 2 || diffRow > 2){
      removeFromParent();
    }
  }

  void chooseMove()
  {
    bool isMove = math.Random().nextBool();
    if(isMove){
      Vector2 speed = Vector2(math.Random().nextDouble() * 2 - 1, math.Random().nextDouble() * 2 - 1);
      if(speed.x > 0 && !isFlippedHorizontally){
        flipHorizontally();
      }else if(speed.x < 0 && isFlippedHorizontally){
        flipHorizontally();
      }
      if(speed.y.abs() > speed.x.abs()){
        if(speed.y > 0){
          animation = _walkForward;
        }else{
          animation = _walkBack;
        }
      }else{
        animation = _wolkSide;
      }
      _groundHitBox.applyLinearImpulse(speed * _velocity);
      animationTicker?.onFrame = regulMove;
    }else{
      int rand = math.Random().nextInt(_idles.length);
      animation = _idles[rand];
      rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(3);
      if(rand == 0){
        flipHorizontally();
      }
    }
    animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    animationTicker?.onComplete = chooseMove;
  }

  void regulMove(int index)
  {
    if(index == 0 || index == 3 || index == 7){
        gameRef.gameMap.container.add(WaterCircles(position: position - Vector2(0,20)));
    }
  }

  @override
  void update(double dt) {
    position = _groundHitBox.position / PhysicVals.physicScale;
    super.update(dt);
  }
}

class WaterCircles extends SpriteAnimationComponent
{
  WaterCircles({required super.position});

  @override
  void onLoad() async
  {
    anchor = Anchor.center;
    var spriteSheet = SpriteSheet(
        image: await Flame.images.load('tiles/map/grassLand2/Characters/small animals/ducks/duck1/small animals - duck-water - ripples.png'),
        srcSize: Vector2.all(96),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 2 / 6,from: 0,loop: false);
    animationTicker?.onComplete = removeFromParent;
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    size += Vector2(30 * dt, 30 * dt);
  }

}