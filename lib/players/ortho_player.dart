
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/weapon/player_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/player.dart';
import 'package:game_flame/weapon/weapon.dart';
import 'package:game_flame/enemies/grass_golem.dart';
import 'package:game_flame/overlays/death_menu.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'dart:math' as math;

class OrthoPlayer extends SpriteAnimationComponent with KeyboardHandler,HasGameRef<KyrgyzGame> implements MainPlayer
{
  PlayerDirectionMove _direction = PlayerDirectionMove.Down;
  final double _spriteSheetWidth = 144, _spriteSheetHeight = 96;
  late SpriteAnimation _animMove, _animIdle, _animAttack1, _animAttack2, _animHurt, _animDeath;
  Vector2 _speed = Vector2.all(0);
  Vector2 _velocity = Vector2.all(0);
  late PlayerHitbox _hitBox;
  late GroundHitBox _groundBox;
  bool _isPlayerRun = false;
  late PlayerWeapon _weapon;

  @override
  void doHurt({required double hurt, bool inArmor=true, double permanentDamage = 0, double secsOfPermDamage=0})async
  {
    if(inArmor){
      hurt -= gameRef.playerData.armor.value;
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
    if(animation != null){
      SpriteAnimationTicker tick = SpriteAnimationTicker(animation!);
      tick.reset();
    }
  }

  @override
  Future<void> onLoad() async
  {
    Image? spriteImg;
    try{
      spriteImg = Flame.images.fromCache('tiles/sprites/players/warrior-144x96.png');
    }catch(e){
      spriteImg = await Flame.images.load('tiles/sprites/players/warrior-144x96.png');
    }
    final spriteSheet = SpriteSheet(image: spriteImg, srcSize: Vector2(_spriteSheetWidth,_spriteSheetHeight));
    _animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.07, from: 0,to: 16);
    _animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.15, from: 0,to: 8);
    _animHurt = spriteSheet.createAnimation(row: 5, stepTime: 0.15, from: 0,to: 8);
    _animDeath = spriteSheet.createAnimation(row: 6, stepTime: 0.07, from: 0,to: 19);
    animation = _animIdle;
    size = Vector2(_spriteSheetWidth, _spriteSheetHeight);
    _hitBox = PlayerHitbox(size:Vector2(47,47),position: Vector2(49,27));
    await add(_hitBox);
    _groundBox = GroundHitBox(obstacleBehavoiurStart: groundCalcLines, obstacleBehavoiurContinue: groundCalcLines,anchor:Anchor.center,size: Vector2(30,30),position: Vector2(_spriteSheetWidth/2, _spriteSheetHeight - 30));
    // _groundBox.debugMode = true;
    await add(_groundBox);
    anchor = Anchor(_groundBox.center.x / width, _groundBox.center.y / height);
    _weapon = WSword(position: Vector2(width/2,height/2), onStartWeaponHit: onStartHit, onEndWeaponHit: (){animation = _animIdle;});
    await add(_weapon);
  }

  void onStartHit()
  {
    _velocity = Vector2.all(0);
  }

  void startHit()
  {
    if(gameRef.gameMap.currentObject != null){
      gameRef.gameMap.currentObject?.obstacleBehavoiur.call();
    }else {
      _weapon.hit();
    }
  }

  void setIdleAnimation()
  {
    if(animation == _animMove){
      animation = _animIdle;
    }
  }

  void movePlayer(PlayerDirectionMove direct, bool isRun)
  {
    if(animation == _animIdle  || animation == _animMove) {
      switch (direct) {
        case PlayerDirectionMove.Right:
          {
            _velocity.x = PhysicVals.startSpeed;
            _velocity.y = 0;
            animation = _animMove;
          }
          break;
        case PlayerDirectionMove.Up:
          {
            _velocity.y = -PhysicVals.startSpeed;
            _velocity.x = 0;
            animation = _animMove;
          }
          break;
        case PlayerDirectionMove.Left:
          {
            _velocity.x = -PhysicVals.startSpeed;
            _velocity.y = 0;
            animation = _animMove;
          }
          break;
        case PlayerDirectionMove.Down:
          {
            _velocity.y = PhysicVals.startSpeed;
            _velocity.x = 0;
            animation = _animMove;
          }
          break;
        case PlayerDirectionMove.RightUp:
          {
            _velocity.y = -PhysicVals.startSpeed / 2;
            _velocity.x = PhysicVals.startSpeed / 2;
            animation = _animMove;
          }
          break;
        case PlayerDirectionMove.RightDown:
          {
            _velocity.y = PhysicVals.startSpeed / 2;
            _velocity.x = PhysicVals.startSpeed / 2;
            animation = _animMove;
          }
          break;
        case PlayerDirectionMove.LeftUp:
          {
            _velocity.y = -PhysicVals.startSpeed / 2;
            _velocity.x = -PhysicVals.startSpeed / 2;
            animation = _animMove;
          }
          break;
        case PlayerDirectionMove.LeftDown:
          {
            _velocity.y = PhysicVals.startSpeed / 2;
            _velocity.x = -PhysicVals.startSpeed / 2;
            animation = _animMove;
          }
          break;
        case PlayerDirectionMove.NoMove:
          {
            _velocity *= 0;
          }
          break;
      }
      if(_velocity.x > 0 && isFlippedHorizontally){
        flipHorizontally();
      }else if (_velocity.x < 0 && !isFlippedHorizontally){
        flipHorizontally();
      }
      if (direct != PlayerDirectionMove.NoMove) {
        _direction = direct;
      }
      if (isRun && gameRef.playerData.energy.value > PhysicVals.runMinimum) {
        PhysicVals.runCoef = 1.3;
        _isPlayerRun = true;
      } else {
        PhysicVals.runCoef = 1;
        _isPlayerRun = false;
      }
      _velocity *= PhysicVals.runCoef;
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed)
  {
    bool isRun = false;
    Vector2 velo = Vector2.all(0);
    if(event.isKeyPressed(LogicalKeyboardKey.keyO)){
      position=Vector2(0,0);
    }
    if(event.isKeyPressed(LogicalKeyboardKey.keyE)){
      gameRef.gameMap.add(GrassGolem(position,GolemVariant.Water));
    }
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
    if((df.angle.abs() - math.pi).abs() < (df.angle.abs() - math.pi/2).abs()){
      _speed.y = 0;
      if(_groundBox.absoluteCenter.y < other.absoluteCenter.y){
        position.y = other.absolutePosition.y - _groundBox.height/2 - 1;
      }else{
        position.y = other.absolutePosition.y + other.height - (_groundBox.height/2-_groundBox.height) + 1;
      }
    }else{
      _speed.x = 0;
      if(_groundBox.absoluteCenter.x > other.absoluteCenter.x){
        position.x=other.absolutePosition.x + other.width + _groundBox.width/2 + 1;
      }else{
        position.x=other.absolutePosition.x - _groundBox.width/2 - 1;
      }
    }
  }

  @override
  void update(double dt)
  {
    if(_isPlayerRun){
      gameRef.playerData.energy.value -= dt * 2;
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