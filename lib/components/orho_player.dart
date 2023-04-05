
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/components/physicsVals.dart';
import 'package:game_flame/main.dart';

class OrthoPlayer extends SpriteAnimationComponent with KeyboardHandler, CollisionCallbacks, PhysicsVals, HasGameRef<KyrgyzGame>
{
  final Vector2 _startPos;
  OrthoPlayer(this._startPos);
  late double _spriteSheetWidth = 680, _spriteSheetHeight = 472;
  late SpriteAnimation _dinoDead, _dinoIdle, _dinoJump, _dinoRun, _dinoWalk;
  Vector2 _speed = Vector2.all(0);
  double _maxSpeed = 7;
  Vector2 _velocity = Vector2.all(0);

  @override
  Future<void> onLoad() async{
    final spriteImage = await Flame.images.load('dinoFull.png');
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
      _isXMove = false;
    }else{
      if (isFlippedHorizontally) {
        flipHorizontally();
      }
      _velocity.x = 50;
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
      _velocity.x = -50;
      _isXMove = true;
      animation = _dinoRun;
    }
  }
  void moveUp(bool isMove){
    if(!isMove){
      _isXMove = false;
    }else{
      if (!isFlippedHorizontally) {
        flipHorizontally();
      }
      _velocity.y = -50;
      _isXMove = true;
      animation = _dinoRun;
    }
  }
  void moveDown(bool isMove){
    if(!isMove){
      _isXMove = false;
    }else{
      if (!isFlippedHorizontally) {
        flipHorizontally();
      }
      _velocity.y = 50;
      _isXMove = true;
      animation = _dinoRun;
    }
  }

  @override
  void update(double dt) {
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
}