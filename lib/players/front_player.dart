
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/weapon/fireBall.dart';
import 'package:game_flame/weapon/player_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/player.dart';
import 'package:game_flame/weapon/weapon.dart';
import 'package:game_flame/liveObjects/grass_golem.dart';
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

class FrontPlayer extends SpriteAnimationComponent with KeyboardHandler,HasGameRef<KyrgyzGame>,ContactCallbacks implements MainPlayer
{
  FrontPlayer({required this.startPos});
  final double _spriteSheetWidth = 144, _spriteSheetHeight = 96;
  late SpriteAnimation animMove, animIdle, animHurt, animDeath, _animShort,_animLong;
  final Vector2 _speed = Vector2.all(0);
  final Vector2 _velocity = Vector2.all(0);
  PlayerHitbox? hitBox;
  Vector2 startPos;
  PlayerWeapon? _weapon;
  bool gameHide = false;
  bool _isLongAttack = false;
  bool _isMinusEnergy = false;
  bool _isRun = false;
  Ground? groundRigidBody;
  double dumping = 8;
  bool _onGround = false;
  int _groundCount = 0;

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
    Vector2 tPos = -Vector2(15,20);
    Vector2 tSize = Vector2(22,45);
    hitBox = PlayerHitbox(getPointsForActivs(tPos,tSize),
        collisionType: DCollisionType.passive,isSolid: false,
        isStatic: false, isLoop: true, game: gameRef);
    add(hitBox!);
    // hitBox?.collisionType = DCollisionType.inactive;
    tPos = -Vector2(11,-10);
    tSize = Vector2(20,16);
    tPos = -Vector2(10,10);
    tSize = Vector2(20,20);
    _weapon = DefaultPlayerWeapon(getPointsForActivs(tPos,tSize),collisionType: DCollisionType.inactive,isSolid: false,
        isStatic: false, isLoop: true,
        onStartWeaponHit: null, onEndWeaponHit: null, game: gameRef);
    add(_weapon!);
    gameRef.playerData.statChangeTrigger.addListener(setNewEnergyCostForWeapon);
    position = startPos;
    setGroundBody();
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

  void setGroundBody()
  {
    if(groundRigidBody != null){
      game.world.destroyBody(groundRigidBody!);
    }
    Vector2 tPos = -Vector2(15,20);
    Vector2 tSize = Vector2(22,45);
    FixtureDef fix = FixtureDef(PolygonShape()..set(getPointsForActivs(tPos,tSize, scale: PhysicVals.physicScale)));
    groundRigidBody = Ground(
        BodyDef(type: BodyType.dynamic, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false
                ,onBeginMyContact: (Object other, Contact contact){
                  if(contact.fixtureA.userData == "feet" || contact.fixtureB.userData == "feet"){
                    _groundCount++;
                    _onGround = true;
                  }
                },
                onEndMyContact: (Object other, Contact contact){
                  if(contact.fixtureA.userData == "feet" || contact.fixtureB.userData == "feet"){
                    _groundCount--;
                  }
                })),
        gameRef.world.physicsWorld,
        isPlayer: true
    );
    groundRigidBody?.createFixture(fix);
    groundRigidBody?.linearDamping = 0;
    groundRigidBody?.angularDamping = 0;
    position = groundRigidBody!.position / PhysicVals.physicScale;

    tPos = Vector2(-8,10);
    tSize = Vector2(16,17);
    FixtureDef fix2 = FixtureDef(PolygonShape()..set(getPointsForActivs(tPos,tSize, scale: PhysicVals.physicScale)),
        isSensor: true, userData: "feet");
    // fix2.userData = "feet";
    groundRigidBody?.createFixture(fix2);
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
      groundRigidBody?.linearVelocity = Vector2.zero();
      _speed.x = 0;
      _speed.y = 0;
      animation = null;
      animation = animHurt;
      animationTicker?.onComplete = setIdleAnimation;
    }
  }

  void refreshMoves()
  {
    _velocity.x = 0;
    _velocity.y = 0;
    _speed.x = 0;
    _speed.y = 0;
    groundRigidBody?.linearVelocity = Vector2.zero();
    if(animation != null){
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    }
  }

  void startMagic()
  {
    // if(isFlippedHorizontally){
    //   gameRef.gameMap.container.add(FireBall(FireBallType.blue, Vector2(-0.5,-0.5), position: position - Vector2(30,0)));
    //   gameRef.gameMap.container.add(FireBall(FireBallType.blue, Vector2(-1,0), position: position - Vector2(30,0)));
    //   gameRef.gameMap.container.add(FireBall(FireBallType.blue, Vector2(-0.5,0.5), position: position - Vector2(30,0)));
    // }else{
    //   gameRef.gameMap.container.add(FireBall(FireBallType.red, Vector2(0.5,-0.5), position: position - Vector2(30,0)));
    //   gameRef.gameMap.container.add(FireBall(FireBallType.red, Vector2(1,0), position: position - Vector2(30,0)));
    //   gameRef.gameMap.container.add(FireBall(FireBallType.red, Vector2(0.5,0.5), position: position - Vector2(30,0)));
    // }
  }

  void startHit(bool isLong)
  {
    if(animation != animIdle && animation != animMove){
      return;
    }
    _weapon?.energyCost = _isLongAttack ? SpriteAnimationTicker(_animLong).totalDuration() * 2.6 : SpriteAnimationTicker(_animShort).totalDuration() * 2.6;
    if(game.playerData.energy.value < _weapon!.energyCost){
      return;
    }
    game.playerData.energy.value -= _weapon!.energyCost;
    _isLongAttack = isLong;
    animation = _isLongAttack ? _animLong : _animShort;
    _velocity.x = 0;
    _speed.x = 0;
    _speed.y = 0;
    groundRigidBody?.linearVelocity = Vector2.zero();
    _weapon?.cleanHashes();
    animationTicker?.onFrame = onFrameWeapon;
    animationTicker?.onComplete = (){
      animation = animIdle;
    };
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
    if(animation != animIdle  && animation != animMove) {
      return;
    }
    if (isRun && gameRef.playerData.energy.value > PhysicVals.runMinimum) {
      _isRun = true;
    } else {
      _isRun = false;
    }
    // angle += math.pi/2;
    PlayerDirectionMove dir = PlayerDirectionMove.NoMove;
    if(angle >= PhysicVals.right1 && angle < PhysicVals.right2){
      dir = PlayerDirectionMove.Right;
    }else if(angle < PhysicVals.rightUp1 && angle >= PhysicVals.right2){
      dir = PlayerDirectionMove.RightUp;
    }else if(angle < -PhysicVals.rightUp1 || angle >= PhysicVals.rightUp1){
      dir = PlayerDirectionMove.Up;
    }else if(angle >= -PhysicVals.rightUp1 && angle < -PhysicVals.right2){
      dir = PlayerDirectionMove.LeftUp;
    }else if(angle >= -PhysicVals.right2 && angle < -PhysicVals.right1){
      dir = PlayerDirectionMove.Left;
    }else if(angle >= -PhysicVals.right1 && angle < -PhysicVals.left1){
      dir = PlayerDirectionMove.Left;
    }else if(angle >= -PhysicVals.left1 && angle < PhysicVals.left1){
      dir = PlayerDirectionMove.Down;
    }else if(angle > PhysicVals.left1 && angle < PhysicVals.right1){
      dir = PlayerDirectionMove.Right;
    }
    switch (dir) {
      case PlayerDirectionMove.Right:
      case PlayerDirectionMove.RightDown:
        _velocity.x = PhysicVals.startSpeed * PhysicVals.runCoef / 2;
        animation = animMove;
        break;
      case PlayerDirectionMove.RightUp:
        _velocity.x = PhysicVals.startSpeed * PhysicVals.runCoef / 2;
        animation = animMove;
        if (_onGround && _groundCount > 0) {
          groundRigidBody?.linearVelocity.y = 0;
          groundRigidBody?.applyLinearImpulse(Vector2(0,-PhysicVals.startSpeed * 3));
          _onGround = false;
          animation = animMove;
        }
        break;
      case PlayerDirectionMove.LeftUp:
        _velocity.x = -PhysicVals.startSpeed * PhysicVals.runCoef / 2;
        animation = animMove;
        if (_onGround && _groundCount > 0) {
          groundRigidBody?.linearVelocity.y = 0;
          groundRigidBody?.applyLinearImpulse(Vector2(0,-PhysicVals.startSpeed * 3));
          _onGround = false;
          animation = animMove;
        }
        break;
      case PlayerDirectionMove.Up:
        if (_onGround && _groundCount > 0) {
          groundRigidBody?.linearVelocity.y = 0;
          groundRigidBody?.applyLinearImpulse(Vector2(0,-PhysicVals.startSpeed * 3));
          _onGround = false;
          animation = animMove;
        }
        break;
      case PlayerDirectionMove.Left:
      case PlayerDirectionMove.LeftDown:
        _velocity.x = -PhysicVals.startSpeed * PhysicVals.runCoef / 2;
        animation = animMove;
        break;
      case PlayerDirectionMove.NoMove:
        stopMove();
        break;
      case PlayerDirectionMove.Down:
        break;
    }
    if(_velocity.x > 0 && isFlippedHorizontally){
      flipHorizontally();
    }else if (_velocity.x < 0 && !isFlippedHorizontally){
      flipHorizontally();
    }
  }

  void stopMove()
  {
    _velocity.x = 0;
    _velocity.y = 0;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed)
  {
    bool isRun = false;
    if(keysPressed.contains(LogicalKeyboardKey.keyO)){
      position=Vector2(0,0);
    }
    Vector2 velo = Vector2.zero();
    if(keysPressed.contains(LogicalKeyboardKey.keyE)){
      gameRef.gameMap.add(GrassGolem(position,GolemVariant.Water,-1));
    }
    if(keysPressed.contains(LogicalKeyboardKey.arrowUp) || keysPressed.contains(const LogicalKeyboardKey(0x00000057)) || keysPressed.contains(const LogicalKeyboardKey(0x00000077))) {
      velo.y = -PhysicVals.startSpeed;
    }
    if(keysPressed.contains(LogicalKeyboardKey.arrowDown) || keysPressed.contains(const LogicalKeyboardKey(0x00000073)) || keysPressed.contains(const LogicalKeyboardKey(0x00000053))) {
      velo.y = PhysicVals.startSpeed;
    }
    if(keysPressed.contains(LogicalKeyboardKey.arrowLeft)  || keysPressed.contains(const LogicalKeyboardKey(0x00000061)) || keysPressed.contains(const LogicalKeyboardKey(0x00000041))) {
      velo.x = -PhysicVals.startSpeed;
    }
    if(keysPressed.contains(LogicalKeyboardKey.arrowRight) || keysPressed.contains(const LogicalKeyboardKey(0x00000064)) || keysPressed.contains(const LogicalKeyboardKey(0x00000044))) {
      velo.x = PhysicVals.startSpeed;
    }
    if(velo.x == 0 && velo.y == 0){
      stopMove();
    }else{
      if(keysPressed.contains(LogicalKeyboardKey.shiftLeft) || keysPressed.contains(LogicalKeyboardKey.shiftRight)){
        isRun = true;
      }
      movePlayer(atan2(velo.x,velo.y), isRun);
    }
    return true;
  }


  @override
  void update(double dt)
  {
    if (gameHide) {
      return;
    }
    if(groundRigidBody != null){
      position = groundRigidBody!.position / PhysicVals.physicScale;
    }
    int pos = position.y.toInt();
    if(pos <= 0){
      pos = 1;
    }
    priority = pos;
    super.update(dt);
    if (gameRef.playerData.energy.value > 1) {
      _isMinusEnergy = false;
    }
    if(animation != animMove){
      gameRef.playerData.energy.value = max(gameRef.playerData.energy.value,0);
      gameRef.playerData.addEnergy(dt * 1.5);
      return;
    }
    bool isReallyRun = false;
    if(_isRun && !_isMinusEnergy){
      if(gameRef.playerData.energy.value <= 0){
        _isMinusEnergy = true;
        animation?.frames[0].stepTime == 0.1? animation?.stepTime = 0.12 : null;
      }else{
        animation?.frames[0].stepTime == 0.12? animation?.stepTime = 0.1 : null;
        isReallyRun = true;
      }
      gameRef.playerData.addEnergy(dt * -2);
    }else{
      if(!gameRef.playerData.isLockEnergy) {
        gameRef.playerData.addEnergy(dt);
      }
    }
    groundRigidBody?.applyLinearImpulse(Vector2(_velocity.x * dt * groundRigidBody!.mass * (isReallyRun ? PhysicVals.runCoef : 1),0));
    if(groundRigidBody!.linearVelocity.x.abs() > 30){
      groundRigidBody!.linearVelocity.x.isNegative ? groundRigidBody!.linearVelocity.x = -30 : groundRigidBody!.linearVelocity.x = 30;
    }
    Vector2 speed = groundRigidBody?.linearVelocity ?? Vector2.zero();
    if(speed.x.abs() < 6 && speed.y.abs() < 6 && _velocity.x == 0 && _velocity.y == 0){
      setIdleAnimation();
      if(!gameRef.playerData.isLockEnergy) {
        gameRef.playerData.addEnergy(dt);
      }
    }
  }
}