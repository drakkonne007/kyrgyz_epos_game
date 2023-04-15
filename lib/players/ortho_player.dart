
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/components/ground_component.dart';
import 'package:game_flame/components/helper.dart';
import 'package:game_flame/overlays/death_menu.dart';
import 'package:game_flame/overlays/health_bar.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/main.dart';
import 'dart:math' as math;

class OrthoPlayer extends SpriteAnimationComponent with KeyboardHandler, CollisionCallbacks, HasGameRef<KyrgyzGame>
{
  static final OrthoPlayer _orthoPlayer = OrthoPlayer._internal();

  factory OrthoPlayer() {
    return _orthoPlayer;
  }

  OrthoPlayer._internal();

  final double _spriteSheetWidth = 112.5, _spriteSheetHeight = 112.5;
  late SpriteAnimation _leftMove, _rightMove, _upMove, _downMove, _rightUpMove, _rightDownMove, _leftUpMove, _leftDownMove, _idleAnimation;
  Vector2 _speed = Vector2.all(0);
  double _maxSpeed = 300;
  Vector2 _velocity = Vector2.all(0);
  double _startSpeed = 600;
  double _runCoef = 1.3;
  late RectangleHitbox _hitBox;
  late RectangleHitbox _groundBox;
  bool _isPlayerRun = false;

  void doHurt({required int hurt,bool inArmor=true,int permanentDamage = 0, double secsOfPermDamage=0}){
    if(inArmor){
      if(OrthoPLayerVals.armor.value < hurt){
        OrthoPLayerVals.health.value -= (hurt - OrthoPLayerVals.armor.value);
        OrthoPLayerVals.armor.value = 0;
      }
    }else{
      OrthoPLayerVals.health.value -= hurt - OrthoPLayerVals.armor.value;
    }
    if(OrthoPLayerVals.health.value <1){
      gameRef.pauseEngine();
      _isPlayerRun = false;
      _velocity *= 0;
      _speed *= 0;
      gameRef.showOverlay(overlayName: DeathMenu.id,isHideOther: true);
    }
  }

  void refreshMoves(){
    _velocity *= 0;
    _speed *= 0;
    animation?.reset();
  }

  @override
  Future<void> onLoad() async{
    // debugMode = true;
    final spriteImage = await Flame.images.load('tiles/sprites/players/dubina.png');
    final spriteSheet = SpriteSheet(image: spriteImage, srcSize: Vector2(_spriteSheetWidth,_spriteSheetHeight));
    _leftMove = spriteSheet.createAnimation(row: 0, stepTime: 0.3, from: 0,to: 4);
    _rightMove = spriteSheet.createAnimation(row: 4, stepTime: 0.3, from: 0,to: 4);
    _upMove = spriteSheet.createAnimation(row: 2, stepTime: 0.3, from: 0,to: 4);
    _downMove = spriteSheet.createAnimation (row: 6, stepTime: 0.3, from: 0,to: 4);
    _rightUpMove = spriteSheet.createAnimation(row: 3, stepTime: 0.3, from: 0,to: 4);
    _rightDownMove = spriteSheet.createAnimation(row: 5, stepTime: 0.3, from: 0,to: 4);
    _leftUpMove = spriteSheet.createAnimation(row: 1, stepTime: 0.3, from: 0,to: 4);
    _leftDownMove = spriteSheet.createAnimation(row: 7, stepTime: 0.3, from: 0,to: 4);
    _idleAnimation = spriteSheet.createAnimation(row: 6, stepTime: 0.3, from: 6,to: 7);
    animation = _idleAnimation;
    size = Vector2(_spriteSheetWidth, _spriteSheetHeight);
    _hitBox = RectangleHitbox(position: Vector2(width/4,15),size: Vector2(width/2,height*0.6));
    _hitBox.collisionType = CollisionType.passive;
    _hitBox.debugMode=true;
    add(_hitBox);
    anchor = Anchor(_hitBox.center.x / width, _hitBox.center.y / height);
    _groundBox = RectangleHitbox(position: Vector2(width/4,height*0.6 - 5),size: Vector2(width/2,20));
    _groundBox.debugMode = true;
    add(_groundBox);
    OrthoPlayerMove.isChange.addListener(() {movePlayer(OrthoPlayerMove.directMove, OrthoPlayerMove.isRun);});
  }

  void movePlayer(PlayerDirectionMove direct, bool isRun){
    switch(direct){
      case PlayerDirectionMove.Right: {
        _velocity.x = _startSpeed;
        _velocity.y = 0;
        animation = _rightMove;
      }
      break;
      case PlayerDirectionMove.Up: {
        _velocity.y = -_startSpeed;
        _velocity.x = 0;
        animation = _upMove;
      }
      break;
      case PlayerDirectionMove.Left: {
        _velocity.x = -_startSpeed;
        _velocity.y = 0;
        animation = _leftMove;
      }
      break;
      case PlayerDirectionMove.Down:{
        _velocity.y = _startSpeed;
        _velocity.x = 0;
        animation = _downMove;
      }
      break;
      case PlayerDirectionMove.RightUp:{
        _velocity.y = -_startSpeed;
        _velocity.x = _startSpeed;
        animation = _rightUpMove;
      }
      break;
      case PlayerDirectionMove.RightDown:{
        _velocity.y = _startSpeed;
        _velocity.x = _startSpeed;
        animation = _rightDownMove;
      }
      break;
      case PlayerDirectionMove.LeftUp:{
        _velocity.y = -_startSpeed;
        _velocity.x = -_startSpeed;
        animation = _leftUpMove;
      }
      break;
      case PlayerDirectionMove.LeftDown:{
        _velocity.y = _startSpeed;
        _velocity.x = -_startSpeed;
        animation = _leftDownMove;
      }
      break;
      case PlayerDirectionMove.NoMove:{
        _velocity *= 0;
      }
      break;
    }
    if(isRun && OrthoPLayerVals.energy.value > 0.1){
      _runCoef = 1.3;
      _isPlayerRun = true;
    }else{
      _runCoef = 1;
      _isPlayerRun = false;
    }
    _velocity *= _runCoef;
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    bool isRun = false;
    if(event.isKeyPressed(LogicalKeyboardKey.shiftLeft) || event.isKeyPressed(LogicalKeyboardKey.shiftRight)){
      isRun = true;
    }
    if(!event.isKeyPressed(LogicalKeyboardKey.arrowUp) && !event.isKeyPressed(LogicalKeyboardKey.arrowDown)
        && !event.isKeyPressed(LogicalKeyboardKey.arrowLeft) && !event.isKeyPressed(LogicalKeyboardKey.arrowRight)){
      _velocity *= 0;
      _runCoef = 1;
    }else{
      Vector2 velo = Vector2.all(0);
      if(event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
        velo.y = -_startSpeed;
      }
      if(event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
        velo.y = _startSpeed;
      }
      if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
        velo.x = -_startSpeed;
      }
      if(event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
        velo.x = _startSpeed;
      }
      doMoveFromVector2(velo, isRun);
    }
    return true;
  }

  void doMoveFromVector2(Vector2 vel, bool isRun){
    if(vel.x > 0 && vel.y == 0){
      movePlayer(PlayerDirectionMove.Right,isRun);
    }else if(vel.x < 0 && vel.y == 0){
      movePlayer(PlayerDirectionMove.Left,isRun);
    }else if(vel.x > 0 && vel.y > 0){
      movePlayer(PlayerDirectionMove.RightDown,isRun);
    }else if(vel.x > 0 && vel.y < 0){
      movePlayer(PlayerDirectionMove.RightUp,isRun);
    }else if(vel.x < 0 && vel.y < 0){
      movePlayer(PlayerDirectionMove.LeftUp,isRun);
    }else if(vel.x < 0 && vel.y > 0){
      movePlayer(PlayerDirectionMove.LeftDown,isRun);
    }else if(vel.x == 0 && vel.y > 0){
      movePlayer(PlayerDirectionMove.Down,isRun);
    }else if(vel.x == 0 && vel.y < 0){
      movePlayer(PlayerDirectionMove.Up,isRun);
    }
  }

  void groundCalcLines(Set<Vector2> points, PositionComponent other){
    if(points.length < 2){
      return;
    }
    var df = Line.fromPoints(points.first, points.last);
    if(df.angle == -0.0){
      return;
    }
    // print(df.angle);
    if((df.angle.abs() - math.pi).abs() < (df.angle.abs() - math.pi/2).abs()){
      _speed.y = 0;
      if(positionOfAnchor(anchor).y < other.center.y){
        position.y = other.y - _hitBox.height/2;
      }else{
        position.y = other.y + other.height - (_hitBox.height/2-_groundBox.height);
      }
    }else{
      _speed.x = 0;
      if(positionOfAnchor(anchor).x > other.center.x){
        position.x=other.x + other.width + _hitBox.width/2;
      }else{
        position.x=other.x - _hitBox.width/2;
      }
    }
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    // for(final as in points){
    //   gameRef.add(TimePoint(as));
    // }
    if(other is Ground) {
      groundCalcLines(points,other);
    }
    super.onCollisionStart(points, other);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    // for(final as in points){
    //   gameRef.add(TimePoint(as));
    // }
    if(other is Ground) {
      groundCalcLines(points,other);
    }
    super.onCollision(points, other);
  }

  @override
  void update(double dt) {
    _speed.x = math.max(-_maxSpeed * _runCoef,math.min(_speed.x + dt * _velocity.x,_maxSpeed * _runCoef));
    _speed.y = math.max(-_maxSpeed * _runCoef,math.min(_speed.y + dt * _velocity.y,_maxSpeed * _runCoef));
    bool isXNan = _speed.x.isNegative;
    bool isYNan = _speed.y.isNegative;
    int countZero = 0;
    if(_velocity.x == 0) {
      if (_speed.x > 0) {
        _speed.x -= PhysicsVals.athmosphereResistance * dt;
      } else if (_speed.x < 0) {
        _speed.x += PhysicsVals.athmosphereResistance * dt;
      } else {
        countZero++;
      }
    }
    if(_velocity.y == 0){
      if (_speed.y > 0) {
        _speed.y -= PhysicsVals.athmosphereResistance * dt;
      } else if (_speed.y < 0) {
        _speed.y += PhysicsVals.athmosphereResistance * dt;
      } else {
        countZero++;
      }
    }
    if(countZero == 2){
      animation = _idleAnimation;
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
      animation = _idleAnimation;
    }
    position += _speed * dt;
    if(_isPlayerRun){
      OrthoPLayerVals.energy.value -= dt;
      if(OrthoPLayerVals.energy.value < 0){
        OrthoPLayerVals.energy.value = 0;
      }
    }else{
      OrthoPLayerVals.energy.value += dt;
      if(OrthoPLayerVals.energy.value > 10){
        OrthoPLayerVals.energy.value = 10;
      }
    }
    super.update(dt);
  }
}