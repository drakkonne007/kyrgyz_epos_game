import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'dart:math' as math;

import 'package:game_flame/kyrgyz_game.dart';

class Frog extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  Frog(this._startPos,this._id);
  final int _id;
  final Vector2 _startPos;
  final List<SpriteAnimation> _idles = [];
  late SpriteAnimation _idle1, _idle2, _idle3, _idle4, _idle5, _idle6, _walkForward, _walkBack, _wolkSide;
  final Vector2 _speed = Vector2.all(0);
  final double _velocity = 50;
  late Ground _groundHitBox;

  @override onLoad() async
  {
    TimerComponent timer = TimerComponent(onTick: _checkIsNeedSelfRemove,repeat: true,autoStart: true, period: 2);
    add(timer);
    anchor = const Anchor(0.5,0.5);
    size = Vector2.all(70);
    int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(5);
    rand++;
    String start = 'tiles/map/grassLand2/Characters/small animals/frogs/frog$rand';
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load('$start/small animals - frog-frog- idle - sideview.png'),
      srcSize: Vector2(96,96),
    );
    // decorator = PaintDecorator.grayscale();
    _idle1 = spriteSheet.createAnimation(row: 0, stepTime: 0.15,from: 0,loop: false);
    spriteSheet = SpriteSheet(
      image: await Flame.images.load('$start/small animals - frog-frog - idle 1 - frontview.png'),
      srcSize: Vector2(96,96),
    );
    _idle2 = spriteSheet.createAnimation(row: 0, stepTime: 0.15,from: 0,loop: false);
    spriteSheet = SpriteSheet(
      image: await Flame.images.load('$start/small animals - frog-frog - idle 2 - frontview.png'),
      srcSize: Vector2(96,96),
    );
    _idle3 = spriteSheet.createAnimation(row: 0, stepTime: 0.15,from: 0,loop: false);
    spriteSheet = SpriteSheet(
      image: await Flame.images.load('$start/small animals - frog-frog - idle 2 - sideview.png'),
      srcSize: Vector2(96,96),
    );
    _idle4 = spriteSheet.createAnimation(row: 0, stepTime: 0.15,from: 0,loop: false);
    spriteSheet = SpriteSheet(
      image: await Flame.images.load('$start/small animals - frog-frog - idle 3 - frontview.png'),
      srcSize: Vector2(96,96),
    );
    _idle5 = spriteSheet.createAnimation(row: 0, stepTime: 0.15,from: 0,loop: false);
    spriteSheet = SpriteSheet(
      image: await Flame.images.load('$start/small animals - frog-frog - idle 3 - sideview.png'),
      srcSize: Vector2(96,96),
    );
    _idle6 = spriteSheet.createAnimation(row: 0, stepTime: 0.15,from: 0,loop: false);
    spriteSheet = SpriteSheet(
      image: await Flame.images.load('$start/small animals - frog-frog - walk - frontview.png'),
      srcSize: Vector2(96,96),
    );
    _walkForward = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0,loop: false);
    spriteSheet = SpriteSheet(
      image: await Flame.images.load('$start/small animals - frog-frog - walk - sideview.png'),
      srcSize: Vector2(96,96),
    );
    _wolkSide = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0,loop: false);
    spriteSheet = SpriteSheet(
      image: await Flame.images.load('$start/small animals - frog-frog - walk - backview.png'),
      srcSize: Vector2(96,96),
    );
    _walkBack = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0,loop: false);

    _idles.add(_idle1);
    _idles.add(_idle2);
    _idles.add(_idle3);
    _idles.add(_idle4);
    _idles.add(_idle5);
    _idles.add(_idle6);
    chooseMove();

    BodyDef bf = BodyDef(type: BodyType.dynamic,position: _startPos * PhysicVals.physicScale,userData: BodyUserData(isQuadOptimizaion: false
    ), linearDamping: 6, angularDamping: 6);
    _groundHitBox = Ground(bf, gameRef.world.physicsWorld,isOnlyForStatic: true);
    _groundHitBox.createFixture(FixtureDef(PolygonShape()..set(getPointsForActivs(Vector2.all(-7), Vector2.all(15), scale: PhysicVals.physicScale))));
    position = _groundHitBox.position / PhysicVals.physicScale;
  }

  void regulMove(int index)
  {
    if(index == 2){
      _groundHitBox.applyLinearImpulse(_speed);
    }else if(index == 7){
      _groundHitBox.clearForces();
    }
  }

  void _checkIsNeedSelfRemove()
  {
    int column = position.x ~/ GameConsts.lengthOfTileSquare.x;
    int row =    position.y ~/ GameConsts.lengthOfTileSquare.y;
    int diffCol = (column - gameRef.gameMap.column()).abs();
    int diffRow = (row - gameRef.gameMap.row()).abs();
    if(diffCol > 2 || diffRow > 2){
      gameRef.gameMap.loadedLivesObjs.remove(_id);
      _groundHitBox.destroy();
      removeFromParent();
    }
  }

  void chooseMove()
  {
    var box = gameRef.playerPosition() + Vector2(0, 20);
    if(position.distanceToSquared(box)  < 2000){
      double angle = math.atan2(box.y - position.y, box.x - position.x);
      double cos = math.cos(angle);
      double sin = math.sin(angle);
      if(sin.abs() > cos.abs()){
        if(sin < 0){
          animation = _walkForward;
          _speed.setValues(0, _velocity);
        }else{
          animation = _walkBack;
          _speed.setValues(0, -_velocity);
        }
      }else{
        animation = _wolkSide;
        if(cos > 0){
          if(isFlippedHorizontally){
            flipHorizontally();
          }
          _speed.setValues(-_velocity, 0);
        }else{
          if(!isFlippedHorizontally){
            flipHorizontally();
          }
          _speed.setValues(_velocity, 0);
        }
      }
      animationTicker?.onFrame = regulMove;
    }else{
      int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(_idles.length);
      animation = _idles[rand];
      rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(3);
      if(rand == 0){
        flipHorizontally();
      }
    }
    animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    animationTicker?.onComplete = chooseMove;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position = _groundHitBox.position / PhysicVals.physicScale;
  }
}