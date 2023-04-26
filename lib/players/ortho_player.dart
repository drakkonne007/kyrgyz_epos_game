
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/abstracts/player_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/player.dart';
import 'package:game_flame/abstracts/weapon.dart';
import 'package:game_flame/overlays/death_menu.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'dart:math' as math;

class OrthoPlayer extends SpriteAnimationComponent with KeyboardHandler, CollisionCallbacks, HasGameRef<KyrgyzGame> implements MainPlayer
{
  static final OrthoPlayer _orthoPlayer = OrthoPlayer._internal();
  factory OrthoPlayer()
  {
    return _orthoPlayer;
  }
  OrthoPlayer._internal();

  PlayerDirectionMove _direction = PlayerDirectionMove.Down;
  final double _spriteSheetWidth = 112.5, _spriteSheetHeight = 112.5;
  late SpriteAnimation _leftMove, _rightMove, _upMove, _downMove, _rightUpMove, _rightDownMove, _leftUpMove, _leftDownMove,
      _leftIdle, _rightIdle, _upIdle, _downIdle, _rightUpIdle, _rightDownIdle, _leftUpIdle, _leftDownIdle;
  Vector2 _speed = Vector2.all(0);
  Vector2 _velocity = Vector2.all(0);
  late PlayerHitbox _hitBox;
  late GroundHitBox _groundBox;
  bool _isPlayerRun = false;
  late PlayerWeapon _weapon;

  @override
  void doHurt({required double hurt, bool inArmor=true, double permanentDamage = 0, double secsOfPermDamage=0})
  {
    if(inArmor){
      hurt -= gameRef.playerData.armor;
      gameRef.playerData.health.value -= math.max(hurt, 0);
    }else{
      gameRef.playerData.health.value -= hurt;
    }
    if(gameRef.playerData.health.value <1){
      gameRef.pauseEngine();
      _isPlayerRun = false;
      _velocity *= 0;
      _speed *= 0;
      gameRef.showOverlay(overlayName: DeathMenu.id,isHideOther: true);
    }
  }

  void refreshMoves()
  {
    _velocity *= 0;
    _speed *= 0;
    animation?.reset();
  }

  @override
  Future<void> onLoad() async
  {
    // debugMode = true;
    final spriteImage = await Flame.images.load('tiles/sprites/players/dubina.png');
    // final spriteImage = await Flame.images.load('tiles/map/loot/loot.png');
    final spriteSheet = SpriteSheet(image: spriteImage, srcSize: Vector2(_spriteSheetWidth,_spriteSheetHeight));
    _leftMove = spriteSheet.createAnimation(row: 0, stepTime: 0.3, from: 0,to: 4);
    _leftIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.3, from: 6,to: 7);
    _rightMove = spriteSheet.createAnimation(row: 4, stepTime: 0.3, from: 0,to: 4);
    _rightIdle = spriteSheet.createAnimation(row: 4, stepTime: 0.3, from: 6,to: 7);
    _upMove = spriteSheet.createAnimation(row: 2, stepTime: 0.3, from: 0,to: 4);
    _upIdle = spriteSheet.createAnimation(row: 2, stepTime: 0.3, from: 6,to: 7);
    _downMove = spriteSheet.createAnimation (row: 6, stepTime: 0.3, from: 0,to: 4);
    _downIdle = spriteSheet.createAnimation(row: 6, stepTime: 0.3, from: 6,to: 7);
    _rightUpMove = spriteSheet.createAnimation(row: 3, stepTime: 0.3, from: 0,to: 4);
    _rightUpIdle = spriteSheet.createAnimation(row: 3, stepTime: 0.3, from: 6,to: 7);
    _rightDownMove = spriteSheet.createAnimation(row: 5, stepTime: 0.3, from: 0,to: 4);
    _rightDownIdle = spriteSheet.createAnimation(row: 5, stepTime: 0.3, from: 6,to: 7);
    _leftUpMove = spriteSheet.createAnimation(row: 1, stepTime: 0.3, from: 0,to: 4);
    _leftUpIdle = spriteSheet.createAnimation(row: 1, stepTime: 0.3, from: 6,to: 7);
    _leftDownMove = spriteSheet.createAnimation(row: 7, stepTime: 0.3, from: 0,to: 4);
    _leftDownIdle = spriteSheet.createAnimation(row: 7, stepTime: 0.3, from: 6,to: 7);
    animation = _downIdle;
    size = Vector2(_spriteSheetWidth/PhysicVals.orthoPlayerScale * GameConsts.gameScale, _spriteSheetHeight/PhysicVals.orthoPlayerScale * GameConsts.gameScale);
    _hitBox = PlayerHitbox(size:Vector2(width/2,height*0.6),position: Vector2(width/4,15));
    await add(_hitBox);
    // _hitBox.debugMode=true;
    anchor = Anchor(_hitBox.center.x / width, _hitBox.center.y / height);
    _groundBox = GroundHitBox(obstacleBehavoiur: groundCalcLines,size: Vector2(width/2,20),position: Vector2(width/4,height*0.6 - 5));
    await add(_groundBox);
    // _groundBox.position = Vector2(width/4,height*0.6 - 5);
    // _groundBox.size = Vector2(width/2,20);
    // _groundBox.debugMode = true;
    _weapon = WDubina(position: Vector2(width/2,height/2));
    await add(_weapon);
  }

  void startHit()
  {
    _weapon.hit(_direction);
  }

  void setIdleAnimation()
  {
    switch(_direction){
      case PlayerDirectionMove.Right:     animation = _rightIdle; break;
      case PlayerDirectionMove.Left:      animation = _leftIdle; break;
      case PlayerDirectionMove.Up:        animation = _upIdle; break;
      case PlayerDirectionMove.Down:      animation = _downIdle; break;
      case PlayerDirectionMove.RightUp:   animation = _rightUpIdle; break;
      case PlayerDirectionMove.RightDown: animation = _rightDownIdle; break;
      case PlayerDirectionMove.LeftUp:    animation = _leftUpIdle; break;
      case PlayerDirectionMove.LeftDown:  animation = _leftDownIdle; break;
      case PlayerDirectionMove.NoMove:    throw 'Unknown idle Ortho Player animation';
    }
  }

  void movePlayer(PlayerDirectionMove direct, bool isRun)
  {
    switch(direct){
      case PlayerDirectionMove.Right: {
        _velocity.x = PhysicVals.startSpeed;
        _velocity.y = 0;
        animation = _rightMove;
      }
      break;
      case PlayerDirectionMove.Up: {
        _velocity.y = -PhysicVals.startSpeed;
        _velocity.x = 0;
        animation = _upMove;
      }
      break;
      case PlayerDirectionMove.Left: {
        _velocity.x = -PhysicVals.startSpeed;
        _velocity.y = 0;
        animation = _leftMove;
      }
      break;
      case PlayerDirectionMove.Down:{
        _velocity.y = PhysicVals.startSpeed;
        _velocity.x = 0;
        animation = _downMove;
      }
      break;
      case PlayerDirectionMove.RightUp:{
        _velocity.y = -PhysicVals.startSpeed/2;
        _velocity.x =  PhysicVals.startSpeed/2;
        animation = _rightUpMove;
      }
      break;
      case PlayerDirectionMove.RightDown:{
        _velocity.y = PhysicVals.startSpeed/2;
        _velocity.x = PhysicVals.startSpeed/2;
        animation = _rightDownMove;
      }
      break;
      case PlayerDirectionMove.LeftUp:{
        _velocity.y = -PhysicVals.startSpeed/2;
        _velocity.x = -PhysicVals.startSpeed/2;
        animation = _leftUpMove;
      }
      break;
      case PlayerDirectionMove.LeftDown:{
        _velocity.y =  PhysicVals.startSpeed/2;
        _velocity.x = -PhysicVals.startSpeed/2;
        animation = _leftDownMove;
      }
      break;
      case PlayerDirectionMove.NoMove:{
        _velocity *= 0;
      }
      break;
    }
    if(direct != PlayerDirectionMove.NoMove) {
      _direction = direct;
    }
    if(isRun && gameRef.playerData.energy.value > PhysicVals.runMinimum){
      PhysicVals.runCoef = 1.3;
      _isPlayerRun = true;
    }else{
      PhysicVals.runCoef = 1;
      _isPlayerRun = false;
    }
    _velocity *= PhysicVals.runCoef;
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed)
  {
    bool isRun = false;
    Vector2 velo = Vector2.all(0);
    if(event.isKeyPressed(LogicalKeyboardKey.arrowUp) || event.isKeyPressed(const LogicalKeyboardKey(0x00000057)) || event.isKeyPressed(const LogicalKeyboardKey(0x00000077))) {
      velo.y = -PhysicVals.startSpeed;
    }
    if(event.isKeyPressed(LogicalKeyboardKey.arrowDown) || event.isKeyPressed(const LogicalKeyboardKey(0x00000073)) || event.isKeyPressed(const LogicalKeyboardKey(0x00000053))) {
      velo.y = PhysicVals.startSpeed;
    }
    if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)  || event.isKeyPressed(const LogicalKeyboardKey(0x00000061)) || event.isKeyPressed(const LogicalKeyboardKey(0x00000041))) {
      velo.x = -PhysicVals.startSpeed;
    }
    if(event.isKeyPressed(LogicalKeyboardKey.arrowRight) || event.isKeyPressed(const LogicalKeyboardKey(0x00000064)) || event.isKeyPressed(const LogicalKeyboardKey(0x00000044))) {
      velo.x = PhysicVals.startSpeed;
    }
    if(velo.x == 0 && velo.y == 0){
      _velocity *= 0;
      PhysicVals.runCoef = 1;
    }else{
      if(event.isKeyPressed(LogicalKeyboardKey.shiftLeft) || event.isKeyPressed(LogicalKeyboardKey.shiftRight)){
        isRun = true;
      }
      doMoveFromVector2(velo, isRun);
    }
    return true;
  }

  void doMoveFromVector2(Vector2 vel, bool isRun)
  {
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

  void groundCalcLines(Set<Vector2> points, PositionComponent other)
  {
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
  void update(double dt)
  {
    if(_isPlayerRun){
      gameRef.playerData.energy.value -= dt;
      if(gameRef.playerData.energy.value < 0){
        PhysicVals.runCoef = 1;
        gameRef.playerData.energy.value = 0;
      }else{
        PhysicVals.runCoef = 1.3;
      }
    }else{
      if(!gameRef.playerData.isLockEnergy) {
        gameRef.playerData.energy.value += dt;
      }
      if(gameRef.playerData.energy.value > gameRef.playerData.maxEnergy.value){
        gameRef.playerData.energy.value = gameRef.playerData.maxEnergy.value;
      }
    }
    _speed.x = math.max(-PhysicVals.maxSpeed * PhysicVals.runCoef,math.min(_speed.x + dt * _velocity.x,PhysicVals.maxSpeed * PhysicVals.runCoef));
    _speed.y = math.max(-PhysicVals.maxSpeed * PhysicVals.runCoef,math.min(_speed.y + dt * _velocity.y,PhysicVals.maxSpeed * PhysicVals.runCoef));
    bool isXNan = _speed.x.isNegative;
    bool isYNan = _speed.y.isNegative;
    int countZero = 0;
    if(_velocity.x == 0) {
      if (_speed.x > 0) {
        _speed.x -= PhysicVals.stopSpeed * dt;
      } else if (_speed.x < 0) {
        _speed.x += PhysicVals.stopSpeed * dt;
      } else {
        countZero++;
      }
    }
    if(_velocity.y == 0){
      if (_speed.y > 0) {
        _speed.y -= PhysicVals.stopSpeed * dt;
      } else if (_speed.y < 0) {
        _speed.y += PhysicVals.stopSpeed * dt;
      } else {
        countZero++;
      }
    }
    if(countZero == 2){
      setIdleAnimation();
      _isPlayerRun = false;
      if(!gameRef.playerData.isLockEnergy) {
        gameRef.playerData.energy.value += dt;
      }
      if(gameRef.playerData.energy.value > gameRef.playerData.maxEnergy.value){
        gameRef.playerData.energy.value = gameRef.playerData.maxEnergy.value;
      }
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
      setIdleAnimation();
      _isPlayerRun = false;
    }
    position += _speed * dt;
    super.update(dt);
  }
}