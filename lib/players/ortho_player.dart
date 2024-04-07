
import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/weapon/player_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/player.dart';
import 'package:game_flame/weapon/weapon.dart';
import 'package:game_flame/enemies/grass_golem.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'dart:math' as math;

final List<Vector2> _attack1ind1 = [
  Vector2(336,242) - Vector2(144*2 + 77,96*2 + 48),
  Vector2(361,224) - Vector2(144*2 + 77,96*2 + 48),
  Vector2(381,227) - Vector2(144*2 + 77,96*2 + 48),
  Vector2(402,234) - Vector2(144*2 + 77,96*2 + 48),
  Vector2(409,246) - Vector2(144*2 + 77,96*2 + 48),
  Vector2(401,262) - Vector2(144*2 + 77,96*2 + 48),
  Vector2(377,272) - Vector2(144*2 + 77,96*2 + 48),
  Vector2(343,272) - Vector2(144*2 + 77,96*2 + 48),
];

final List<Vector2> _attack2ind1 = [
  Vector2(0, -1),
  Vector2(19,-1),
  Vector2(19,2),
  Vector2(0,2),
];

final List<Vector2> _attack2ind2 = [
  Vector2(20, -1),
  Vector2(69,-1),
  Vector2(69,2),
  Vector2(20,2),
];

class OrthoPlayer extends SpriteAnimationComponent with KeyboardHandler,HasGameRef<KyrgyzGame> implements MainPlayer
{
  final double _spriteSheetWidth = 144, _spriteSheetHeight = 96;
  late SpriteAnimation animMove, animIdle, animHurt, animDeath, _animShort,_animLong;
  final Vector2 _speed = Vector2.all(0);
  final Vector2 _velocity = Vector2.all(0);
  PlayerHitbox? hitBox;
  GroundHitBox? groundBox;
  PlayerWeapon? _weapon;
  bool gameHide = false;
  final Vector2 _maxSpeeds = Vector2.all(0);
  bool _isLongAttack = false;
  bool _isMinusEnergy = false;
  bool _isRun = false;

  @override
  Future<void> onLoad() async
  {
    Image? spriteImg;
    spriteImg = await Flame.images.load('tiles/sprites/players/warrior-144x96.png');
    final spriteSheet = SpriteSheet(image: spriteImg, srcSize: Vector2(_spriteSheetWidth,_spriteSheetHeight));
    animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.07, from: 0,to: 16);
    animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.12, from: 0,to: 8);
    animHurt = spriteSheet.createAnimation(row: 5, stepTime: 0.07, from: 0,to: 6, loop: false);
    animDeath = spriteSheet.createAnimation(row: 6, stepTime: 0.1, from: 0,to: 19, loop: false);
    _animShort = spriteSheet.createAnimation(row: 3, stepTime: 0.06, from: 0,to: 11,loop: false);
    _animLong = spriteSheet.createAnimation(row: 4, stepTime: 0.06, from: 0,to: 16,loop: false);
    animation = animIdle;
    size = Vector2(_spriteSheetWidth, _spriteSheetHeight);
    anchor = const Anchor(0.5, 0.5);

    Vector2 tPos = positionOfAnchor(anchor) - Vector2(15,20);
    Vector2 tSize = Vector2(22,45);
    hitBox = PlayerHitbox(getPointsForActivs(tPos,tSize),
        collisionType: DCollisionType.passive,isSolid: false,
        isStatic: false, isLoop: true, game: gameRef);
    add(hitBox!);

    tPos = positionOfAnchor(anchor) - Vector2(11,-10);
    tSize = Vector2(20,16);
    groundBox = GroundHitBox(getPointsForActivs(tPos,tSize),
        obstacleBehavoiurStart: groundCalcLines,
        collisionType: DCollisionType.active, isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(groundBox!);
    add(Ground(getPointsForActivs(tPos,tSize),
        collisionType: DCollisionType.passive, isSolid: false,isStatic: false, isLoop: true, game: gameRef));
    tPos = positionOfAnchor(anchor) - Vector2(10,10);
    tSize = Vector2(20,20);
    _weapon = DefaultPlayerWeapon(getPointsForActivs(tPos,tSize),collisionType: DCollisionType.inactive,isSolid: false,
        isStatic: false, isLoop: true,
        onStartWeaponHit: null, onEndWeaponHit: null, game: gameRef);
    add(_weapon!);
    gameRef.playerData.statChangeTrigger.addListener(setNewEnergyCostForWeapon);
  }

  void setNewEnergyCostForWeapon()
  {
    _weapon?.magicDamage = gameRef.playerData.magicDamage.value;
    _weapon?.permanentDamage = gameRef.playerData.permanentDamage.value;
    _weapon?.secsOfPermDamage = gameRef.playerData.secsOfPermanentDamage.value;
    _weapon?.damage = gameRef.playerData.damage.value;
    _animShort.stepTime = 0.06 + gameRef.playerData.attackSpeed.value;
    _animLong.stepTime = 0.06 + gameRef.playerData.attackSpeed.value;
  }

  @override
  void doHurt({required double hurt, bool inArmor=true, double permanentDamage = 0, double secsOfPermDamage=0})
  {
    _weapon?.collisionType = DCollisionType.inactive;
    if(inArmor){
      hurt -= gameRef.playerData.armor.value;
      hurt = math.max(hurt, 0);
    }
    gameRef.playerData.health.value -= hurt;
    if(gameRef.playerData.health.value <1){
      animation = animDeath;
      animationTicker?.onComplete = gameRef.startDeathMenu;
    }else{
      if(animation == animHurt){
        return;
      }
      _velocity.x = 0;
      _velocity.y = 0;
      _speed.x = 0;
      _speed.y = 0;
      animation = null;
      animation = animHurt;
      animationTicker?.onComplete = setIdleAnimation;
    }
  }

  void reInsertFullActiveHitBoxes()
  {
    hitBox!.reInsertIntoCollisionProcessor();
    groundBox!.reInsertIntoCollisionProcessor();
    _weapon!.reInsertIntoCollisionProcessor();
    _velocity.x = 0;
    _velocity.y = 0;
    _speed.x = 0;
    _speed.y = 0;
    animation = animIdle;
  }

  void refreshMoves()
  {
    _velocity.x = 0;
    _velocity.y = 0;
    _speed.x = 0;
    _speed.y = 0;
    if(animation != null){
      animationTicker?.reset();
    }
  }

  void startHit(bool isLong)
  {
    if(animation != animIdle && animation != animMove){
      return;
    }
    _weapon?.energyCost = _isLongAttack ? _animLong.ticker().totalDuration() * 2.6 : _animShort.ticker().totalDuration() * 2.6;
    if(game.playerData.energy.value < _weapon!.energyCost){
      return;
    }
    game.playerData.energy.value -= _weapon!.energyCost;
    _isLongAttack = isLong;
    animation = _isLongAttack ? _animLong : _animShort;
    _velocity.x = 0;
    _velocity.y = 0;
    _speed.x = 0;
    _speed.y = 0;
    _weapon?.cleanHashes();
    animationTicker?.onFrame = onFrameWeapon;
    animationTicker?.onComplete = (){
      animation = animIdle;
    };
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

  void movePlayer(double angle, bool isRun)
  {
    if(gameRef.playerData.isLockMove){
      return;
    }
    if(animation == animIdle  || animation == animMove) {
      _isRun = isRun;
      if (isRun && gameRef.playerData.energy.value > 0 && !_isMinusEnergy) {
        PhysicVals.runCoef = 1.3;
        animation = animMove;
        animation?.frames[0].stepTime == 0.12? animation?.stepTime = 0.1 : null;
      } else {
        PhysicVals.runCoef = 1;
        animMove.stepTime = 0.12;
        animation = animMove;
        animation?.frames[0].stepTime == 0.1? animation?.stepTime = 0.12 : null;
      }
      angle += math.pi/2;
      _velocity.x = -cos(angle) * PhysicVals.startSpeed * PhysicVals.runCoef;
      _velocity.y = sin(angle) * PhysicVals.startSpeed * PhysicVals.runCoef;
      _maxSpeeds.x = -cos(angle) * PhysicVals.maxSpeed;
      _maxSpeeds.y = sin(angle) * PhysicVals.maxSpeed;
      if (_velocity.x > 0 && isFlippedHorizontally) {
        flipHorizontally();
      } else if (_velocity.x < 0 && !isFlippedHorizontally) {
        flipHorizontally();
      }
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed)
  {
    bool isRun = false;
    if(event.isKeyPressed(LogicalKeyboardKey.keyO)){
      position=Vector2(0,0);
    }
    Vector2 velo = Vector2.zero();
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
      stopMove();
    }else{
      if(event.isKeyPressed(LogicalKeyboardKey.shiftLeft) || event.isKeyPressed(LogicalKeyboardKey.shiftRight)){
        isRun = true;
      }
      movePlayer(atan2(velo.x,velo.y), isRun);
    }
    return true;
  }

  void stopMove()
  {
    _velocity.x = 0;
    _velocity.y = 0;
    PhysicVals.runCoef = 1;
  }

  void onFrameWeapon(int index)
  {
    if(_isLongAttack){
      if(index == 6){
        _weapon?.collisionType = DCollisionType.active;
        _weapon?.changeVertices(_attack2ind1,isLoop: true);
      }
      else if(index == 7){
        _weapon?.changeVertices(_attack2ind2,isLoop: true);
      }else if(index == 11){
        _weapon?.collisionType = DCollisionType.inactive;
      }
    }else{
      if(index == 2){
        _weapon?.collisionType = DCollisionType.active;
        _weapon?.changeVertices(_attack1ind1);
      }else if(index == 5){
        _weapon?.collisionType = DCollisionType.inactive;
      }
    }
  }

  void groundCalcLines(Set<Vector2> points, DCollisionEntity other)
  {
    if(groundBox == null){
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

      if(Vector2(groundBox!.getMinVector().x,groundBox!.getMinVector().y).distanceToSquared(point) < 4){
        continue;
      }
      if(Vector2(groundBox!.getMinVector().x,groundBox!.getMaxVector().y).distanceToSquared(point) < 4){
        continue;
      }
      if(Vector2(groundBox!.getMaxVector().x,groundBox!.getMaxVector().y).distanceToSquared(point) < 4){
        continue;
      }
      if(Vector2(groundBox!.getMaxVector().x,groundBox!.getMinVector().y).distanceToSquared(point) < 4){
        continue;
      }

      double leftDiffX  = point.x - groundBox!.getMinVector().x;
      double rightDiffX = point.x - groundBox!.getMaxVector().x;
      double upDiffY = point.y - groundBox!.getMinVector().y;
      double downDiffY = point.y - groundBox!.getMaxVector().y;

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
    // _groundBox?.doDebug(color: BasicPalette.red.color);
    super.update(dt);
    if(gameHide){
      return;
    }
    if(gameRef.playerData.energy.value > 1){
      _isMinusEnergy = false;
    }
    // _weapon?.doDebug();
    if(animation != animMove){
      gameRef.playerData.energy.value = max(gameRef.playerData.energy.value,0);
      gameRef.playerData.addEnergy(dt * 1.5);
      return;
    }
    if(_isRun && !_isMinusEnergy){
      if(gameRef.playerData.energy.value <= 0){
        _isMinusEnergy = true;
        animation?.frames[0].stepTime == 0.1? animation?.stepTime = 0.12 : null;
        PhysicVals.runCoef = 1;
      }else{
        animation?.frames[0].stepTime == 0.12? animation?.stepTime = 0.1 : null;
        PhysicVals.runCoef = 1.3;
      }
      gameRef.playerData.addEnergy(dt * -2);
    }else{
      PhysicVals.runCoef = 1;
      if(!gameRef.playerData.isLockEnergy) {
        gameRef.playerData.addEnergy(dt);
      }
    }
    _speed.x = math.max(-_maxSpeeds.x.abs() * PhysicVals.runCoef,math.min(_speed.x + dt * _velocity.x,_maxSpeeds.x.abs() * PhysicVals.runCoef));
    _speed.y = math.max(-_maxSpeeds.y.abs() * PhysicVals.runCoef,math.min(_speed.y + dt * _velocity.y,_maxSpeeds.y.abs() * PhysicVals.runCoef));
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
      if(!gameRef.playerData.isLockEnergy) {
        gameRef.playerData.addEnergy(dt);
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
    }
    position += _speed * dt;
  }
//
// @override
// void render(Canvas canvas)
// {
//   var shader = gameRef.telepShaderProgramm.fragmentShader();
//   shader.setFloat(0,0);
//   shader.setFloat(1,max(size.x,30));
//   shader.setFloat(2,max(size.y,30));
//   final paint = Paint()..shader = shader;
//   canvas.drawRect(
//     Rect.fromLTWH(
//       0,
//       0,
//       max(size.x,30),
//       max(size.y,30),
//     ),
//     paint,
//   );
//   super.render(canvas);
// }
}