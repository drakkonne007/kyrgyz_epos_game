import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/player.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

class FrontPlayer extends SpriteAnimationComponent with KeyboardHandler, CollisionCallbacks, HasGameRef<KyrgyzGame> implements MainPlayer
{
  Vector2 _startPos;
  FrontPlayer(this._startPos);
  late double _spriteSheetWidth = 680, _spriteSheetHeight = 472;
  late SpriteAnimation _dinoDead, _dinoIdle, _dinoJump, _dinoRun, _dinoWalk;
  double _maxXSpeed = 7;
  double _velocity = 0;
  double _speedY = 0;
  double _speedX = 0;
  bool _isOnGround = false;
  bool _isXMove = false;
  bool _isNeedColl = false;

  @override
  Future<void> onLoad() async{
    final spriteImage = await Flame.images.load('assets/tiles/sprites/players/dinoFull.png');
    final spriteSheet = SpriteSheet(image: spriteImage, srcSize: Vector2(_spriteSheetWidth,_spriteSheetHeight));
    _dinoDead = spriteSheet.createAnimation(row: 0, stepTime: 0.18, from: 0,to: 8);
    _dinoIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.18, from: 8,to: 19);
    _dinoJump = spriteSheet.createAnimation(row: 3, stepTime: 0.18, from: 1,to: 12);
    _dinoRun = spriteSheet.createAnimation (row: 5, stepTime: 0.18, from: 0,to: 7);
    _dinoWalk = spriteSheet.createAnimation(row: 6, stepTime: 0.18, from: 2,to: 12);
    animation = _dinoDead;
    size = Vector2(_spriteSheetWidth/7, _spriteSheetHeight/7);
    anchor = const Anchor(0.3,0.5);
    topLeftPosition = _startPos - Vector2(0,height);
    add(RectangleHitbox(position: Vector2.all(0),size: Vector2(width*0.6,height)));
    // print("${_topHit.isColliding}, ${_botHit.isColliding},${_leftHit.isColliding},${_rightHit.isColliding}");
  }

  void moveRight(bool isMove){
    if(!isMove){
      _isXMove = false;
    }else{
      if (isFlippedHorizontally) {
        flipHorizontally();
      }
      _velocity = 50;
      _isXMove = true;
      animation = _dinoRun;
    }
  }
  void moveLeft(bool isMove){
    if(!isMove){
      _isXMove = false;
    }else{
      if (!isFlippedHorizontally) {
        flipHorizontally();
      }
      _velocity = -50;
      _isXMove = true;
      animation = _dinoRun;
    }
  }
  void moveUp(bool isMove){
    if(isMove){
      if(_isOnGround) {
        _isOnGround = false;
        _speedY = -17;
        _dinoJump.reset();
        animation = _dinoJump;
      }
    }
  }

  void doGroundCalc(Set<Vector2> points, PositionComponent other) {
    int isTop = 0,
        isBott = 0,
        isLeft = 0,
        isRight = 0;
    for (final point in points) {
      if (point.x.round() == center.x.round() &&
          point.y.round() == center.y.round()) {
        print('ERROR in collision');
        position.y = other.y - height / 2;
        return;
      }
      if(_isNeedColl) {
        gameRef.add(TimePoint(point));
      }
      if (point.y.round() >= other.y.round() && point.y.round() <= other.y.round() + 5) {
        if(point.x.round() > other.x.round() + 5 && point.x.round() < (other.x + other.width - 5).round()){
          if(_speedY > 0) {
            _isOnGround = true;
            _speedY = 0;
            if(_isXMove){
              animation = _dinoRun;
            }else{
              animation = _dinoIdle;
            }
          }
          position.y = other.y - height / 2;
          return;
        }
        isBott++;
      }
      if (point.y.round() <= (other.y + other.height).round() && point.y.round() >= (other.y + other.height).round() - 5) {
        if(point.x.round() > other.x.round() + 5 && point.x.round() < (other.x + other.width - 5).round()){
          if(_speedY < 0) {
            _speedY = 0;
          }
          position.y = other.y + other.height + height / 2;
          return;
        }
        isTop++;
      }
      if (point.x.round() >= other.x.round() && point.x.round() <= other.x.round() + 1) {
        isLeft++;
      }
      if (point.x.round() <= (other.x + other.width).round() && point.x.round() >= (other.x + other.width).round() - 1) {
        isRight++;
      }
    }
    if(_isNeedColl){
      print("$isRight - right, $isLeft - left, $isTop - top, $isBott - bot");
      print('length = ${points.length}');
    }
    if (isBott == points.length || (isBott > isRight && isBott > isLeft)) {
      if(_speedY > 0) {
        _isOnGround = true;
        _speedY = 0;
        if(_isXMove){
          animation = _dinoRun;
        }else{
          animation = _dinoIdle;
        }
      }
      position.y = other.y - height / 2;
    } else if (isTop == points.length || (isTop > isRight && isTop > isLeft)) {
      if(_speedY < 0) {
        _speedY = 0;
      }
      position.y = other.y + other.height + height / 2;
    } else if (isLeft == points.length || (isLeft > isTop && isLeft > isBott)) {
      _speedX *= -1 * OrthoPlayerVals.rigidy;
      position.x = other.x - width * 0.3;
    } else if (isRight == points.length || (isRight > isTop && isRight > isBott)) {
      _speedX *= -1 * OrthoPlayerVals.rigidy;
      position.x = other.x + other.width + width * 0.3;
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if(event.isKeyPressed(LogicalKeyboardKey.keyC)){
      _isNeedColl = !_isNeedColl;
    }
    if(event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      moveUp(true);
    }
    if(event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      // if(_isOnGround) {
      // _isOnGround = false;
      // _speedY += 150;
      // dinoJump.reset();
      // animation = dinoJump;
      // }
    }
    if(!event.isKeyPressed(LogicalKeyboardKey.arrowRight) && !event.isKeyPressed(LogicalKeyboardKey.arrowLeft)){
      moveLeft(false);
      moveRight(false);
    }else if(event.isKeyPressed(LogicalKeyboardKey.arrowRight) && event.isKeyPressed(LogicalKeyboardKey.arrowLeft)){
      moveLeft(false);
      moveRight(false);
    }else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
      moveRight(true);
    }else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      moveLeft(true);
    }
    return true;
  }

  @override
  void update(double dt) {
    if(!_isOnGround) {
      _speedY += OrthoPlayerVals.gravity * dt;
      position.y += min(_speedY,28);
    }
    if(_isXMove) {
      if (_speedX.abs() > _maxXSpeed) {
        _speedX.isNegative ? _speedX = -_maxXSpeed : _speedX = _maxXSpeed;
      }
      _speedX += _velocity * dt;
      position.x += min(_maxXSpeed,_speedX);
    }else if(_speedX != 0){
      bool isSign = _speedX.isNegative;
      if(_speedX.isNegative != _velocity.isNegative){
        _velocity*=-1;
      }
      _speedX -= _velocity * dt;
      if(isSign != _speedX.isNegative){
        _speedX = 0;
        _velocity = 0;
        animation = _dinoIdle;
      }else{
        position.x += min(_maxXSpeed,_speedX);
      }
    }
    if(_speedX == 0) {
      animation = _dinoIdle;
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    if (other.parent is MapObstacle) {
      doGroundCalc(points, other);
    }
    super.onCollisionStart(points, other);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if(other.parent is MapObstacle){
      doGroundCalc(points,other);
    }
    super.onCollision(points,other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if(other.parent is MapObstacle){
      _isOnGround = false;
    }
    super.onCollisionEnd(other);
  }

  @override
  void doHurt({required double hurt, bool inArmor = true, double permanentDamage = 0, double secsOfPermDamage = 0}) {
    // TODO: implement doHurt
  }

}
