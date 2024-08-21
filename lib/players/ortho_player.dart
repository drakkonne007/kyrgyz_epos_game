
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/weapon/builderMagicBalls.dart';
import 'package:game_flame/weapon/darkBall.dart';
import 'package:game_flame/weapon/darkBall.dart';
import 'package:game_flame/weapon/darkBall.dart';
import 'package:game_flame/weapon/circleMagicBall.dart';
import 'package:game_flame/weapon/fireBall.dart';
import 'package:game_flame/weapon/player_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/player.dart';
import 'package:game_flame/weapon/forwardMagicBall.dart';
import 'package:game_flame/weapon/forwardMagicBall.dart';
import 'package:game_flame/weapon/forwardMagicBall.dart';
import 'package:game_flame/weapon/weapon.dart';
import 'package:game_flame/liveObjects/grass_golem.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'dart:math' as math;

enum AnimationState
{
  idle,
  attack,
  move,
  death,
  hurt,
  slide,
  shield,
}

final List<Vector2> _hitboxPoint = [
  Vector2(-11.0858,-17.0421)
  ,Vector2(6.85155,-17.1332)
  ,Vector2(6.7605,25.8437)
  ,Vector2(-10.8127,25.7526)
  ,];

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


class OrthoPlayer extends SpriteAnimationComponent with KeyboardHandler,HasGameRef<KyrgyzGame>  implements MainPlayer
{
  OrthoPlayer({required this.startPos});
  final Vector2 sprSize = Vector2(144,96);
  late SpriteAnimation animMove, animIdle, animHurt, animDeath, _animShort,_animLong, _animShield, _animSlide;
  final Vector2 _speed = Vector2.all(0);
  final Vector2 _velocity = Vector2.all(0);
  PlayerHitbox? hitBox;
  Vector2 startPos;
  PlayerWeapon? _weapon;
  bool gameHide = false;
  final Vector2 _maxSpeeds = Vector2.all(0);
  bool _isLongAttack = false;
  bool _isMinusEnergy = false;
  bool _isRun = false;
  Ground? groundRigidBody;
  double dumping = 8;
  AnimationState _animState = AnimationState.idle;
  bool _canMagicSpell = true;
  bool _enableShieldLock = true;

  @override
  Future<void> onLoad() async
  {
    opacity = 0;
    Image? spriteImg;
    spriteImg = await Flame.images.load('tiles/sprites/players/warrior-144x96New.png');
    final spriteSheet = SpriteSheet(image: spriteImg, srcSize: sprSize);
    animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.07, from: 0,to: 16);
    animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.12, from: 0,to: 8);
    animHurt = spriteSheet.createAnimation(row: 5, stepTime: 0.07, from: 0,to: 6, loop: false);
    animDeath = spriteSheet.createAnimation(row: 6, stepTime: 0.1, from: 0,to: 19, loop: false);
    _animShort = spriteSheet.createAnimation(row: 3, stepTime: 0.07, from: 0,to: 11,loop: false); // 11
    _animLong = spriteSheet.createAnimation(row: 4, stepTime: 0.06, from: 0,to: 16,loop: false); // 16
    List<Sprite> sprites = [];
    List<double> times = [0.09,0.09,0.09,0.09,0.09,0.09,0.09,0.09,0.09,0.09,0.09,];
    sprites.add(spriteSheet.getSprite(7,0));
    sprites.add(spriteSheet.getSprite(7,1));
    sprites.add(spriteSheet.getSprite(7,2));
    sprites.add(spriteSheet.getSprite(7,3));
    sprites.add(spriteSheet.getSprite(7,3));
    sprites.add(spriteSheet.getSprite(7,3));
    sprites.add(spriteSheet.getSprite(7,3));
    sprites.add(spriteSheet.getSprite(7,3));
    sprites.add(spriteSheet.getSprite(7,2));
    sprites.add(spriteSheet.getSprite(7,1));
    sprites.add(spriteSheet.getSprite(7,0));
    _animShield = SpriteAnimation.variableSpriteList(sprites, stepTimes: times, loop: false);
    _animSlide = spriteSheet.createAnimation(row: 8, stepTime: 0.08, from: 0,to: 6,loop: false);
    animation = animIdle;
    _animState = AnimationState.idle;
    anchor = Anchor.center;
    Vector2 tPos = -Vector2(15,20);
    Vector2 tSize = Vector2(22,45);

    hitBox = PlayerHitbox(_hitboxPoint,
        collisionType: DCollisionType.passive,isSolid: true,
        isStatic: false, isLoop: true, game: gameRef);
    add(hitBox!);
    // hitBox?.collisionType = DCollisionType.inactive;
    tPos = -Vector2(10,10);
    tSize = Vector2(20,20);
    _weapon = DefaultPlayerWeapon(getPointsForActivs(tPos,tSize),collisionType: DCollisionType.inactive,isSolid: false,
        isStatic: false, isLoop: true,
        onStartWeaponHit: null, onEndWeaponHit: null, game: gameRef);
    add(_weapon!);
    gameRef.playerData.statChangeTrigger.addListener(setNewEnergyCostForWeapon);
    position = startPos;
    setGroundBody();
    setNewEnergyCostForWeapon();
    add(OpacityEffect.to(1, EffectController(duration: 0.7)));
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

  void setGroundBody({Vector2? targetPos, bool isEnemy = false, double? myDumping})
  {
    targetPos ??= position;
    groundRigidBody?.destroy();
    Vector2 tPos = -Vector2(11,-10);
    Vector2 tSize = Vector2(20,16);
    FixtureDef fix = FixtureDef(PolygonShape()..set(getPointsForActivs(tPos,tSize, scale: PhysicVals.physicScale)), friction: 0.1, density: 0.1);
    groundRigidBody = Ground(
        BodyDef(type: BodyType.dynamic, position: targetPos * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)), isEnemy: isEnemy,
        gameRef.world.physicsWorld,isPlayer: !isEnemy
    );
    groundRigidBody?.createFixture(fix);
    groundRigidBody?.linearDamping = myDumping ?? dumping;
    groundRigidBody?.angularDamping = myDumping ?? dumping;
    var massData = groundRigidBody!.getMassData();
    massData.mass = 70;
    groundRigidBody!.setMassData(massData);
    position = groundRigidBody!.position / PhysicVals.physicScale;
  }

  @override
  void doHurt({required double hurt, bool inArmor=true, double permanentDamage = 0, double secsOfPermDamage=0})
  {
    _weapon?.collisionType = DCollisionType.inactive;
    if(inArmor){
      if(_animState == AnimationState.shield){
        if(gameRef.playerData.energy.value > hurt * 1.5){
          gameRef.playerData.addEnergy(-hurt*1.5);
          if(_enableShieldLock) {
            _enableShieldLock = false;
            gameRef.gameMap.container.add(
                ShieldLock(position: position - Vector2(0, 17)));
            add(TimerComponent(period: 0.5,repeat: false,removeOnFinish: true, onTick: (){
              _enableShieldLock = true;
            }));
          }
          return;
        }else{
          var temp = hurt - (gameRef.playerData.energy.value / 2);
          gameRef.playerData.addEnergy(-hurt*1.5);
          hurt = temp;
        }
        hurt -= gameRef.playerData.armor.value;
        hurt = math.max(hurt, 0);
        gameRef.playerData.addHealth(-hurt);
        if(gameRef.playerData.health.value <1){
          animation = animDeath;
          animationTicker?.onComplete = gameRef.startDeathMenu;
          _animState = AnimationState.death;
        }else{
          final temp = ColorEffect(
            const Color(0xFFFFFFFF),
            EffectController(duration: 0.07, reverseDuration: 0.07),
            opacityFrom: 0.0,
            opacityTo: 0.9,
          );
          add(temp);
        }
        return;
      }else{
        hurt -= gameRef.playerData.armor.value;
        hurt = math.max(hurt, 0);
      }
    }
    gameRef.playerData.addHealth(-hurt);
    if(gameRef.playerData.health.value <1){
      animation = animDeath;
      animationTicker?.onComplete = gameRef.startDeathMenu;
      _animState = AnimationState.death;
    }else{
      if(_animState == AnimationState.hurt){
        return;
      }
      _velocity.x = 0;
      _velocity.y = 0;
      groundRigidBody?.linearVelocity = Vector2.zero();
      _speed.x = 0;
      _speed.y = 0;
      animation = null;
      animation = animHurt;
      _animState = AnimationState.hurt;
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
    if(gameRef.playerData.ringDress.value == NullItem()){
      return;
    }
    if(!_canMagicSpell){
      return;
    }
    if(animation != animIdle && animation != animMove){
      return;
    }
    if(game.playerData.energy.value < _weapon!.energyCost){
      return;
    }
    _canMagicSpell = false;
    add(TimerComponent(period: 2, removeOnFinish: true, onTick: (){
      _canMagicSpell = true;
    }));
    createPlayerMagicSpells(gameRef);
  }

  void startHit(bool isLong)
  {
    if(_animState != AnimationState.idle && _animState != AnimationState.move && _animState != AnimationState.shield){
      return;
    }
    _weapon?.energyCost = _isLongAttack ? SpriteAnimationTicker(_animLong).totalDuration() * 4.5 : SpriteAnimationTicker(_animShort).totalDuration() * 3;
    if(game.playerData.energy.value < _weapon!.energyCost){
      return;
    }
    FlameAudio.play('playerHit.mp3',volume: 2);
    game.playerData.energy.value -= _weapon!.energyCost;
    _isLongAttack = isLong;
    animation = _isLongAttack ? _animLong : _animShort;
    _animState = AnimationState.attack;
    _velocity.x = 0;
    _velocity.y = 0;
    _speed.x = 0;
    _speed.y = 0;
    groundRigidBody?.linearVelocity = Vector2.zero();
    _weapon?.cleanHashes();
    animationTicker?.onFrame = onFrameWeapon;
    animationTicker?.onComplete = (){
      chooseStaticAnimation();
    };
  }

  void chooseStaticAnimation()
  {
    Vector2 speed = groundRigidBody?.linearVelocity ?? Vector2.zero();
    if(speed.x.abs() < 6 && speed.y.abs() < 6 && _velocity.x == 0 && _velocity.y == 0){
      animation = animIdle;
      _animState = AnimationState.idle;
    }else{
      animation = animMove;
      _animState = AnimationState.move;
    }
  }

  void endHit()
  {
    _weapon?.collisionType = DCollisionType.inactive;
    int currAnim = animationTicker?.currentIndex ?? 0;
    animation = animation!.reversed();
    int temp = min(animation!.frames.length - 1,animation!.frames.length - currAnim - 1);
    animationTicker?.currentIndex = temp;
    animationTicker?.onComplete = (){
      chooseStaticAnimation();
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
      _animState = AnimationState.idle;
    }
  }

  void movePlayer(double angle, bool isRun)
  {
    if(gameRef.playerData.isLockMove){
      return;
    }
    if(_animState == AnimationState.move || _animState == AnimationState.idle){
      _isRun = isRun;
      _animState = AnimationState.move; // Тут может быть и анимация удара под конец ты тоже можешь бегать
      if(animation == animIdle){
        animation = animMove;
      }
      if(animation == animMove){
        if (isRun && gameRef.playerData.energy.value > 0 && !_isMinusEnergy) {
          animation?.frames[0].stepTime == 0.12? animation?.stepTime = 0.1 : null;
        }else{
          animation?.frames[0].stepTime == 0.1? animation?.stepTime = 0.12 : null;
        }
      }
      angle += math.pi/2;
      _velocity.x = -cos(angle) * PhysicVals.startSpeed;
      _velocity.y = sin(angle) * PhysicVals.startSpeed;
      _maxSpeeds.x = -cos(angle) * PhysicVals.maxSpeed;
      _maxSpeeds.y = sin(angle) * PhysicVals.maxSpeed;
      if (_velocity.x > 0 && isFlippedHorizontally) {
        flipHorizontally();
      } else if (_velocity.x < 0 && !isFlippedHorizontally) {
        flipHorizontally();
      }
    }
  }

  void doDash()
  {
    if(gameRef.playerData.isLockMove){
      return;
    }
    if(gameRef.playerData.energy.value < 10){
      return;
    }
    gameRef.playerData.addEnergy(-10);
    if(_animState == AnimationState.move || _animState == AnimationState.idle || _animState == AnimationState.shield || _animState == AnimationState.hurt){
      _animState = AnimationState.slide;
      groundRigidBody?.clearForces();
      groundRigidBody?.linearVelocity = Vector2.zero();
      setGroundBody(targetPos: position, isEnemy: true, myDumping: 0);
      hitBox!.collisionType = DCollisionType.inactive;
      animation = _animSlide;
      animationTicker?.onFrame = (frame){
        if(frame == 5){
          groundRigidBody?.linearDamping = dumping;
          groundRigidBody?.angularDamping = dumping;
        }
      };
      animationTicker?.onComplete = (){
        hitBox!.collisionType = DCollisionType.passive;
        setGroundBody(targetPos: position);
        chooseStaticAnimation();
      };
      isFlippedHorizontally ? groundRigidBody?.applyLinearImpulse(Vector2(-3000,0)) : groundRigidBody?.applyLinearImpulse(Vector2(3000,0));
    }
  }

  void doShield()
  {
    if(gameRef.playerData.isLockMove){
      return;
    }
    if(_animState == AnimationState.move || _animState == AnimationState.idle){
      _animState = AnimationState.shield;
      animation = _animShield;
      animationTicker?.onComplete = (){
        chooseStaticAnimation();
      };
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed)
  {
    bool isRun = false;

    if(keysPressed.contains(LogicalKeyboardKey.keyJ)){
      startHit(false);
    }
    if(keysPressed.contains(LogicalKeyboardKey.keyK)){
      startHit(true);
    }
    if(keysPressed.contains(LogicalKeyboardKey.keyL)){
      makeAction();
    }
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

  void stopMove()
  {
    _velocity.x = 0;
    _velocity.y = 0;
  }

  void onFrameWeapon(int index)
  {
    if(_isLongAttack){
      if(index == 6){
        _weapon?.changeVertices(_attack2ind1,isLoop: true);
        _weapon?.collisionType = DCollisionType.active;
      }
      else if(index == 7){
        _weapon?.changeVertices(_attack2ind2,isLoop: true);
      }else if(index == 11){
        _weapon?.collisionType = DCollisionType.inactive;
        _animState = AnimationState.idle;
      }
    }else{
      if(index == 2){
        _weapon?.changeVertices(_attack1ind1);
        _weapon?.collisionType = DCollisionType.active;
      }else if(index == 5){
        _weapon?.collisionType = DCollisionType.inactive;
        _animState = AnimationState.idle;
      }
    }
  }

  @override
  void update(double dt) {
    // _groundBox?.doDebug(color: BasicPalette.red.color);
    if (gameHide) {
      return;
    }
    if(groundRigidBody != null){
      position = groundRigidBody!.position / PhysicVals.physicScale;
    }
    int pos = position.y.toInt() + 25;
    if(pos <= 0){
      pos = 1;
    }
    priority = pos;
    super.update(dt);
    if (gameRef.playerData.energy.value > 1) {
      _isMinusEnergy = false;
    }
    if(_animState != AnimationState.move && _animState != AnimationState.shield && _animState != AnimationState.slide){
      gameRef.playerData.energy.value = max(gameRef.playerData.energy.value,0);
      gameRef.playerData.addEnergy(dt * 4);
      return;
    }
    if(_animState != AnimationState.move){
      return;
    }
    bool isReallyRun = false;
    if(_isRun && !_isMinusEnergy){
      if(gameRef.playerData.energy.value <= 0){
        _isMinusEnergy = true;
        if(animation == animMove) {
          animation?.frames[0].stepTime == 0.1 ? animation?.stepTime = 0.12 : null;
        }
      }else{
        if(animation == animMove) {
          animation?.frames[0].stepTime == 0.12 ? animation?.stepTime = 0.1 : null;
        }
        isReallyRun = true;
      }
      gameRef.playerData.addEnergy(dt * -3);
    }else{
      if(!gameRef.playerData.isLockEnergy) {
        gameRef.playerData.addEnergy(dt * 2);
      }
    }
    groundRigidBody?.applyLinearImpulse(_velocity * dt * groundRigidBody!.mass * (isReallyRun ? PhysicVals.runCoef : 1));
    Vector2 speed = groundRigidBody?.linearVelocity ?? Vector2.zero();
    if(speed.x.abs() < 6 && speed.y.abs() < 6 && _velocity.x == 0 && _velocity.y == 0){
      setIdleAnimation();
      if(!gameRef.playerData.isLockEnergy) {
        gameRef.playerData.addEnergy(dt);
      }
    }
  }

// @override
// void render(Canvas canvas)
// {
//   var shader = gameRef.telepShader;
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