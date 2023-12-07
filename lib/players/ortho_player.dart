
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
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

class AxesDiff
{
  AxesDiff(this.leftDiff, this.rightDiff, this.upDiff, this.downDiff);
  double leftDiff = 0;
  double rightDiff = 0;
  double upDiff = 0;
  double downDiff = 0;
}

class OrthoPlayer extends SpriteAnimationComponent with KeyboardHandler,HasGameRef<KyrgyzGame> implements MainPlayer
{
  PlayerDirectionMove _direction = PlayerDirectionMove.Down;
  final double _spriteSheetWidth = 144, _spriteSheetHeight = 96;
  late SpriteAnimation animMove, animIdle, animHurt, animDeath;
  Vector2 _speed = Vector2.all(0);
  Vector2 _velocity = Vector2.all(0);
  PlayerHitbox? hitBox;
  GroundHitBox? _groundBox;
  bool _isPlayerRun = false;
  PlayerWeapon? _weapon;
  Timer? _timerHurt;

  @override
  void doHurt({required double hurt, bool inArmor=true, double permanentDamage = 0, double secsOfPermDamage=0})
  {
    _weapon?.stopHit();
    _velocity *= 0;
    _speed *= 0;
    if(inArmor){
      hurt -= gameRef.playerData.armor.value;
      gameRef.playerData.health.value -= math.max(hurt, 0);
    }else{
      gameRef.playerData.health.value -= hurt;
    }
    if(gameRef.playerData.health.value <1){
      gameRef.pauseEngine();
      _isPlayerRun = false;
      gameRef.startDeathMenu();
    }else{
      animation = null;
      animation = animHurt;
      animation!.ticker().reset();
      _timerHurt!.stop();
      _timerHurt!.start();
    }
  }

  void refreshMoves()
  {
    _velocity *= 0;
    _speed *= 0;
    if(animation != null){
      animation!.ticker().reset();
    }
  }

  @override
  Future<void> onLoad() async
  {
    Image? spriteImg;
    spriteImg = await Flame.images.load('tiles/sprites/players/warrior-144x96.png');
    final spriteSheet = SpriteSheet(image: spriteImg, srcSize: Vector2(_spriteSheetWidth,_spriteSheetHeight));
    animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.07, from: 0,to: 16);
    animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.15, from: 0,to: 8);
    animHurt = spriteSheet.createAnimation(row: 5, stepTime: 0.1, from: 0,to: 6);
    animHurt.loop = false;
    animDeath = spriteSheet.createAnimation(row: 6, stepTime: 0.15, from: 0,to: 19);
    animDeath.loop = false;
    animation = animIdle;
    _timerHurt = Timer(animHurt.ticker().totalDuration(),autoStart: false,onTick: setIdleAnimation,repeat: false);
    size = Vector2(_spriteSheetWidth, _spriteSheetHeight);
    anchor = const Anchor(0.5, 0.5);

    Vector2 tPos = positionOfAnchor(anchor) - Vector2(25,25); Vector2(49,27);
    Vector2 tSize = Vector2(50,50);
    hitBox = PlayerHitbox(getPointsForActivs(tPos,tSize),
        collisionType: DCollisionType.passive,isSolid: true,
        isStatic: false, isLoop: true, game: gameRef);
    await add(hitBox!);

    tPos = positionOfAnchor(anchor) - Vector2(15,-10);
    tSize = Vector2(30,20);
    _groundBox = GroundHitBox(getPointsForActivs(tPos,tSize),
        obstacleBehavoiurStart: groundCalcLines,
        collisionType: DCollisionType.active, isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    await add(_groundBox!);
    tPos = positionOfAnchor(anchor) - Vector2(10,10);
    tSize = Vector2(20,20);
    _weapon = WSword(getPointsForActivs(tPos,tSize),collisionType: DCollisionType.inactive,isSolid: true,
        isStatic: false, isLoop: true,
        onStartWeaponHit: onStartHit, onEndWeaponHit: (){animation = animIdle;}, game: gameRef);
    //_weapon = WSword(position: Vector2(width/2,height/2), onStartWeaponHit: onStartHit, onEndWeaponHit: (){animation = _animIdle;});
    await add(_weapon!);
  }

  void onStartHit()
  {
    _velocity = Vector2.all(0);
    _speed = Vector2.all(0);
  }

  void startHit()
  {
    gameRef.doDialogHud();
    return;
    if(animation == animHurt || animation == animDeath){
      return;
    }
    _weapon?.hit();
  }

  void makeAction()
  {
    if(animation == animHurt || animation == animDeath){
      return;
    }
    gameRef.gameMap.currentObject.value?.obstacleBehavoiur.call();
  }

  void setIdleAnimation()
  {
    if(animation == animMove || animation == animHurt){
      animation = animIdle;
    }
  }

  void movePlayer(PlayerDirectionMove direct, bool isRun)
  {
    if(animation == animIdle  || animation == animMove) {
      switch (direct) {
        case PlayerDirectionMove.Right:
          {
            _velocity.x = PhysicVals.startSpeed;
            _velocity.y = 0;
            animation = animMove;
          }
          break;
        case PlayerDirectionMove.Up:
          {
            _velocity.y = -PhysicVals.startSpeed;
            _velocity.x = 0;
            animation = animMove;
          }
          break;
        case PlayerDirectionMove.Left:
          {
            _velocity.x = -PhysicVals.startSpeed;
            _velocity.y = 0;
            animation = animMove;
          }
          break;
        case PlayerDirectionMove.Down:
          {
            _velocity.y = PhysicVals.startSpeed;
            _velocity.x = 0;
            animation = animMove;
          }
          break;
        case PlayerDirectionMove.RightUp:
          {
            _velocity.y = -PhysicVals.startSpeed / 2;
            _velocity.x = PhysicVals.startSpeed / 2;
            animation = animMove;
          }
          break;
        case PlayerDirectionMove.RightDown:
          {
            _velocity.y = PhysicVals.startSpeed / 2;
            _velocity.x = PhysicVals.startSpeed / 2;
            animation = animMove;
          }
          break;
        case PlayerDirectionMove.LeftUp:
          {
            _velocity.y = -PhysicVals.startSpeed / 2;
            _velocity.x = -PhysicVals.startSpeed / 2;
            animation = animMove;
          }
          break;
        case PlayerDirectionMove.LeftDown:
          {
            _velocity.y = PhysicVals.startSpeed / 2;
            _velocity.x = -PhysicVals.startSpeed / 2;
            animation = animMove;
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

  void groundCalcLines(Set<Vector2> points, DCollisionEntity other)
  {
    if(_groundBox == null){
      return;
    }
    Map<Vector2,AxesDiff> diffs = {};
    bool isUp = false;
    bool isDown = false;
    bool isLeft = false;
    bool isRight = false;
    double maxLeft = 0;
    double maxRight = 0;
    double maxUp = 0;
    double maxDown = 0;

    for(final point in points){
      // gameRef.add(PointCust(position: point));
      double leftDiffX  = point.x - (_groundBox!.getPoint(0)).x;
      double rightDiffX = point.x - (_groundBox!.getPoint(3)).x;
      double upDiffY = point.y - (_groundBox!.getPoint(0)).y;
      double downDiffY = point.y - (_groundBox!.getPoint(1)).y;

      // print('diffs: $leftDiffX $rightDiffX $upDiffY $downDiffY');

      diffs.putIfAbsent(point, () => AxesDiff(leftDiffX,rightDiffX,upDiffY,downDiffY));
      double minDiff = min(leftDiffX.abs(),rightDiffX.abs());
      minDiff = min(minDiff,upDiffY.abs());
      minDiff = min(minDiff,downDiffY.abs());
      if(minDiff == leftDiffX.abs()){
        isLeft = true;
        maxLeft = max(maxLeft,minDiff);
      }
      if(minDiff == rightDiffX.abs()){
        isRight = true;
        maxRight = max(maxRight,minDiff);
      }
      if(minDiff == upDiffY.abs()){
        isUp = true;
        maxUp = max(maxUp,minDiff);
      }
      if(minDiff == downDiffY.abs()){
        isDown = true;
        maxDown = max(maxDown,minDiff);
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
        maxLeft = min(maxLeft,diff.leftDiff.abs());
        maxRight = min(maxRight,diff.rightDiff.abs());
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
        maxUp = min(maxUp,diff.upDiff.abs());
        maxDown = min(maxDown,diff.downDiff.abs());
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

  @override
  void update(double dt)
  {
    // _groundBox?.doDebug();
    super.update(dt);
    _timerHurt!.update(dt);
    if(animation != animMove){
      return;
    }
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
  }
}