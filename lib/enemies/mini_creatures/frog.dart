import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/rendering.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/dVector2.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'dart:math' as math;

import 'package:game_flame/kyrgyz_game.dart';

class Frog extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  Frog(this._startPos,);
  final Vector2 _startPos;
  final List<SpriteAnimation> _idles = [];
  late SpriteAnimation _idle1, _idle2, _idle3, _idle4, _idle5, _idle6, _walkForward, _walkBack, _wolkSide;
  final Vector2 _speed = Vector2.all(0);
  final double _velocity = 70;
  late GroundHitBox _groundHitBox;
  bool _isMove = false;

  @override onLoad() async
  {
    TimerComponent timer = TimerComponent(onTick: _checkIsNeedSelfRemove,repeat: true,autoStart: true, period: 1);
    add(timer);
    anchor = const Anchor(0.5,0.5);
    size = Vector2.all(70);
    position = _startPos;
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

    _groundHitBox = GroundHitBox(getPointsForActivs(dVector2.all(-7), dVector2.all(15)),collisionType: DCollisionType.active
        ,isSolid: false,isStatic: false,isLoop: true,obstacleBehavoiurStart: _obstacle, game: gameRef, isOnlyForStatic: true);
    add(_groundHitBox);
  }

  void regulMove(int index)
  {
    if(index == 2){
      _isMove = true;
    }else if(index == 7){
      _isMove = false;
    }
  }

  void _checkIsNeedSelfRemove()
  {
    int column = position.x ~/ gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x;
    int row =    position.y ~/ gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y;
    int diffCol = (column - gameRef.gameMap.column()).abs();
    int diffRow = (row - gameRef.gameMap.row()).abs();
    if(diffCol > GameConsts.visibleWorldWidth || diffRow > GameConsts.visibleWorldWidth){
      gameRef.gameMap.loadedLivesObjs.remove(_startPos);
      removeFromParent();
    }
  }

  void _obstacle(Set<dVector2> intersectionPoints, DCollisionEntity other)
  {
    Map<dVector2,AxesDiff> diffs = {};
    bool isUp = false;
    bool isDown = false;
    bool isLeft = false;
    bool isRight = false;
    double maxLeft = 0;
    double maxRight = 0;
    double maxUp = 0;
    double maxDown = 0;

    for(final point in intersectionPoints){
      double leftDiffX  = point.x - _groundHitBox.getMinVector().x;
      double rightDiffX = point.x - _groundHitBox.getMaxVector().x;
      double upDiffY = point.y - _groundHitBox.getMinVector().y;
      double downDiffY = point.y - _groundHitBox.getMaxVector().y;

      // print('diffs: $leftDiffX $rightDiffX $upDiffY $downDiffY');

      diffs.putIfAbsent(point, () => AxesDiff(leftDiffX,rightDiffX,upDiffY,downDiffY));
      double minDiff = math.min(leftDiffX.abs(),rightDiffX.abs());
      minDiff = math.min(minDiff,upDiffY.abs());
      minDiff = math.min(minDiff,downDiffY.abs());
      if(minDiff == leftDiffX.abs()){
        isLeft = true;
        maxLeft = math.max(maxLeft,minDiff);
      }
      if(minDiff == rightDiffX.abs()){
        isRight = true;
        maxRight = math.max(maxRight,minDiff);
      }
      if(minDiff == upDiffY.abs()){
        isUp = true;
        maxUp = math.max(maxUp,minDiff);
      }
      if(minDiff == downDiffY.abs()){
        isDown = true;
        maxDown = math.max(maxDown,minDiff);
      }
    }

    if(isDown && isUp && isLeft && isRight){
      print('What is??');
      return;
    }

    if(isDown && isUp){
      double maxLeft = 1000000000;
      double maxRight = 1000000000;
      for(final diff in diffs.values){
        maxLeft = math.min(maxLeft,diff.leftDiff.abs());
        maxRight = math.min(maxRight,diff.rightDiff.abs());
      }
      if(maxLeft > maxRight){
        position -= Vector2(maxRight,0);
      }else{
        position += Vector2(maxLeft,0);
      }
      return;
    }
    if(isLeft && isRight){
      double maxUp = 100000000;
      double maxDown = 100000000;
      for(final diff in diffs.values){
        maxUp = math.min(maxUp,diff.upDiff.abs());
        maxDown = math.min(maxDown,diff.downDiff.abs());
      }
      if(maxUp > maxDown){
        position -= Vector2(0,maxDown);
      }else{
        position += Vector2(0,maxUp);
      }
      return;
    }

    // print('maxs: $maxLeft $maxRight $maxUp $maxDown');

    if(isLeft){
      position +=  Vector2(maxLeft,0);
    }
    if(isRight){
      position -=  Vector2(maxRight,0);
    }
    if(isUp){
      position +=  Vector2(0,maxUp);
    }
    if(isDown){
      position -=  Vector2(0,maxDown);
    }
  }

  void chooseMove()
  {
    _speed.setValues(0,0);
    animation = null;
    var box = gameRef.gameMap.orthoPlayer?.groundBox ?? gameRef.gameMap.frontPlayer!.groundBox;
    if(position.distanceToSquared((box!.getMinVector() + box.getMaxVector()).toVector2() / 2)  < 1000){
      dVector2 vec = (box.getMinVector() + box.getMaxVector()) / 2;
      double angle = math.atan2(vec.y - position.y, vec.x - position.x);
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
    animationTicker?.onComplete = chooseMove;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if(_isMove) {
      position += _speed * dt;
    }
  }
}