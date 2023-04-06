
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/main.dart';
import 'dart:math';

class OrthoPlayer extends SpriteAnimationComponent with KeyboardHandler, CollisionCallbacks, HasGameRef<KyrgyzGame>
{
  final Vector2 _startPos;
  OrthoPlayer(this._startPos);
  final double _spriteSheetWidth = 680, _spriteSheetHeight = 472;
  late SpriteAnimation _dinoDead, _dinoIdle, _dinoJump, _dinoRun, _dinoWalk;
  Vector2 _speed = Vector2.all(0);
  double _maxSpeed = 2;
  Vector2 _velocity = Vector2.all(0);
  bool _isMove = false;

  @override
  Future<void> onLoad() async{
    final spriteImage = await Flame.images.load('tiles/sprites/players/dinoFull.png');
    final spriteSheet = SpriteSheet(image: spriteImage, srcSize: Vector2(_spriteSheetWidth,_spriteSheetHeight));
    _dinoDead = spriteSheet.createAnimation(row: 0, stepTime: 0.18, from: 0,to: 8);
    _dinoIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.18, from: 8,to: 19);
    _dinoJump = spriteSheet.createAnimation(row: 3, stepTime: 0.18, from: 1,to: 12);
    _dinoRun = spriteSheet.createAnimation (row: 5, stepTime: 0.18, from: 0,to: 7);
    _dinoWalk = spriteSheet.createAnimation(row: 6, stepTime: 0.18, from: 2,to: 12);
    animation = _dinoIdle;
    size = Vector2(_spriteSheetWidth/7, _spriteSheetHeight/7);
    anchor = Anchor(0.3,0.5);
    topLeftPosition = _startPos - Vector2(0,height);
    add(RectangleHitbox(position: Vector2.all(0),size: Vector2(width*0.6,height)));
  }

  void moveRight(bool isMove){
    if(!isMove){
      if(_velocity.x > 0) {
        _velocity.x = 0;
      }
    }else{
      if (isFlippedHorizontally) {
        flipHorizontally();
      }
      _isMove = true;
      _velocity.x = 50;
      animation = _dinoRun;
    }
  }
  void moveLeft(bool isMove){
    if(!isMove){
      if(_velocity.x < 0) {
        _velocity.x = 0;
      }
    }else{
      if (!isFlippedHorizontally) {
        flipHorizontally();
      }
      _isMove = true;
      _velocity.x = -50;
      animation = _dinoRun;
    }
  }
  void moveUp(bool isMove){
    if(!isMove){
      if(_velocity.y < 0) {
        _velocity.y = 0;
      }
    }else{
      _velocity.y = -50;
      animation = _dinoRun;
      _isMove = true;
    }
  }
  void moveDown(bool isMove){
    if(!isMove){
      if(_velocity.y > 0) {
        _velocity.y = 0;
      }
    }else{
      _isMove = true;
      _velocity.y = 50;
      animation = _dinoRun;
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // if(event.isKeyPressed(LogicalKeyboardKey.keyC)){
    //   _isNeedColl = !_isNeedColl;
    // }
    if(event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      moveUp(true);
    }else{
      moveUp(false);
    }
    if(event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      moveDown(true);
    }else{
      moveDown(false);
    }
    if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      moveLeft(true);
    }else{
      moveLeft(false);
    }
    if(event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
      moveRight(true);
    }else{
      moveRight(false);
    }
    return true;
  }

  @override
  void update(double dt) {
    _speed.x = max(-_maxSpeed,min(_speed.x + dt * _velocity.x,_maxSpeed));
    _speed.y = max(-_maxSpeed,min(_speed.y + dt * _velocity.y,_maxSpeed));
    bool isXNan = _speed.x.isNegative;
    bool isYNan = _speed.y.isNegative;
    int countZero = 0;
    if(_speed.x > 0){
      _speed.x -= PhysicsVals.athmosphereResistance * dt;
    }else if(_speed.x < 0){
      _speed.x += PhysicsVals.athmosphereResistance * dt;
    }else{
      countZero++;
    }
    if(_speed.y > 0){
      _speed.y -= PhysicsVals.athmosphereResistance * dt;
    }else if(_speed.y < 0){
      _speed.y += PhysicsVals.athmosphereResistance * dt;
    }else{
      countZero++;
    }
    if(countZero == 2){
      animation = _dinoIdle;
      super.update(dt);
      return;
    }
    if(_speed.y.isNegative != isYNan){
      _speed.y = 0;
      countZero++;
    }
    if(_speed.x.isNegative != isXNan){
      _speed.x = 0;
      countZero++;
    }
    if(countZero == 2){
      animation = _dinoIdle;
    }
    position += _speed;
    super.update(dt);
  }
}