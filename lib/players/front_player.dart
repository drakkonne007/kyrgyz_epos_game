
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/weapon/player_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/player.dart';
import 'package:game_flame/weapon/weapon.dart';
import 'package:game_flame/enemies/grass_golem.dart';
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

class FrontPlayer extends SpriteAnimationComponent with KeyboardHandler,HasGameRef<KyrgyzGame> implements MainPlayer
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
  bool gameHide = false;
  double _groundTimer = 0;
  bool _onGround = false;

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

  void reInsertFullActiveHitBoxes()
  {
    hitBox!.reInsertIntoCollisionProcessor();
    _groundBox!.reInsertIntoCollisionProcessor();
    _weapon!.reInsertIntoCollisionProcessor();
  }

  void refreshMoves()
  {
    _velocity *= 0;
    _speed *= 0;
    if(animation != null){
      animation!.ticker().reset();
    }
  }

  void onStartHit()
  {
    _velocity.x = 0;
    _speed.x = 0;
  }

  void startHit()
  {
    // gameRef.doDialogHud();
    // return;
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

  void movePlayer(List<PlayerDirectionMove> directs, bool isRun)
  {
    if(gameRef.playerData.isLockMove){
      return;
    }
    if(animation == animIdle  || animation == animMove) {
      Vector2 velocity = Vector2.zero();
      for(var direct in directs){
        switch (direct) {
          case PlayerDirectionMove.Right:
            {
              velocity.x = PhysicVals.startSpeed;
              animation = animMove;
            }
            break;
          case PlayerDirectionMove.Up:
            {
              if (_onGround) {
                // velocity.y = -PhysicFrontVals.maxSpeeds.y/2;
                _speed.y = -400;
              }
              animation = animMove;
            }
            break;
          case PlayerDirectionMove.Left:
            {
              velocity.x = -PhysicVals.startSpeed;
              animation = animMove;
            }
            break;
          default: break;
        }
      }
      if(velocity.x > 0 && isFlippedHorizontally){
        flipHorizontally();
      }else if (velocity.x < 0 && !isFlippedHorizontally){
        flipHorizontally();
      }
      // if (direct != PlayerDirectionMove.NoMove) {
        // _direction = direct;
      // }
      if (isRun && gameRef.playerData.energy.value > PhysicVals.runMinimum) {
        PhysicVals.runCoef = 1.3;
        _isPlayerRun = true;
      } else {
        PhysicVals.runCoef = 1;
        _isPlayerRun = false;
      }
      velocity.x *= PhysicVals.runCoef;
      _velocity = velocity;
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed)
  {
    bool isRun = false;
    List<PlayerDirectionMove> list = [];
    if(event.isKeyPressed(LogicalKeyboardKey.keyO)){
      position=Vector2(0,0);
    }
    if(event.isKeyPressed(LogicalKeyboardKey.keyE)){
      gameRef.gameMap.add(GrassGolem(position,GolemVariant.Water));
    }
    if(event.isKeyPressed(LogicalKeyboardKey.arrowUp) || event.isKeyPressed(const LogicalKeyboardKey(0x00000057)) || event.isKeyPressed(const LogicalKeyboardKey(0x00000077))) {
      list.add(PlayerDirectionMove.Up);
    }
    if(event.isKeyPressed(LogicalKeyboardKey.arrowDown) || event.isKeyPressed(const LogicalKeyboardKey(0x00000073)) || event.isKeyPressed(const LogicalKeyboardKey(0x00000053))) {
      list.add(PlayerDirectionMove.Down);
    }
    if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)  || event.isKeyPressed(const LogicalKeyboardKey(0x00000061)) || event.isKeyPressed(const LogicalKeyboardKey(0x00000041))) {
      list.add(PlayerDirectionMove.Left);
    }
    if(event.isKeyPressed(LogicalKeyboardKey.arrowRight) || event.isKeyPressed(const LogicalKeyboardKey(0x00000064)) || event.isKeyPressed(const LogicalKeyboardKey(0x00000044))) {
      list.add(PlayerDirectionMove.Right);
    }
    if(event.isKeyPressed(LogicalKeyboardKey.shiftLeft) || event.isKeyPressed(LogicalKeyboardKey.shiftRight)){
      isRun = true;
    }
    movePlayer(list, isRun);
    return true;
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

      if(Vector2(_groundBox!.getMinVector().x,_groundBox!.getMinVector().y).distanceTo(point) < 2){
        continue;
      }
      if(Vector2(_groundBox!.getMinVector().x,_groundBox!.getMaxVector().y).distanceTo(point) < 2){
        continue;
      }
      if(Vector2(_groundBox!.getMaxVector().x,_groundBox!.getMaxVector().y).distanceTo(point) < 2){
        continue;
      }
      if(Vector2(_groundBox!.getMaxVector().x,_groundBox!.getMinVector().y).distanceTo(point) < 2){
        continue;
      }

      double leftDiffX  = point.x - _groundBox!.getMinVector().x;
      double rightDiffX = point.x - _groundBox!.getMaxVector().x;
      double upDiffY = point.y - _groundBox!.getPoint(0).y;
      double downDiffY = point.y - _groundBox!.getPoint(1).y;

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
        _onGround = true;
        _groundTimer = 0;
        _speed.y = min(0,_speed.y);
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
    super.update(dt);
    if(_groundTimer < 1000) {
      _groundTimer += dt;
    }
    if(_groundTimer > 0.010){
      _onGround = false;
    }
    if(gameHide){
      return;
    }
    _timerHurt!.update(dt);
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
    _speed.x = math.max(-PhysicFrontVals.maxSpeeds.x * PhysicVals.runCoef,math.min(_speed.x + dt * _velocity.x,PhysicFrontVals.maxSpeeds.x * PhysicVals.runCoef));
    // _speed.y = math.max(-PhysicFrontVals.maxSpeeds.y * PhysicVals.runCoef,math.min(_speed.y + dt * _velocity.y,PhysicFrontVals.maxSpeeds.y * PhysicVals.runCoef));
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
    // if(_velocity.y == 0){
    //   if (_speed.y > 0) {
    //     _speed.y -= PhysicVals.stopSpeed * dt;
    //   } else if (_speed.y < 0) {
    //     _speed.y += PhysicVals.stopSpeed * dt;
    //   } else {
    //     countZero++;
    //   }
    // }
    if(countZero == 2){
      setIdleAnimation();
      _isPlayerRun = false;
      if(!gameRef.playerData.isLockEnergy) {
        gameRef.playerData.energy.value += dt;
      }
      if(gameRef.playerData.energy.value > gameRef.playerData.maxEnergy.value){
        gameRef.playerData.energy.value = gameRef.playerData.maxEnergy.value;
      }
    }
    if(!_onGround){
      _speed.y += 1000*dt;
    }
    if(countZero != 2) {
      if (_speed.y.isNegative != isYNan) {
        _speed.y = 0;
        countZero++;
      }
      if (_speed.x.isNegative != isXNan) {
        _speed.x = 0;
        countZero++;
      }
      if (countZero == 2) {
        setIdleAnimation();
        _isPlayerRun = false;
      }
    }
    position += _speed * dt;
  }
}