import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/weapon/builderMagicBalls.dart';
import 'package:game_flame/weapon/player_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/player.dart';
import 'package:game_flame/weapon/weapon.dart';
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
  Vector2(-14.8301,30.8012)
  ,Vector2(7.03378,31.9642)
  ,Vector2(21.9198,26.8471)
  ,Vector2(34.4799,13.3566)
  ,Vector2(32.8517,-1.29683)
  ,Vector2(21.6872,-13.1591)
  ,Vector2(4.94043,-17.1132)
  ,Vector2(-10.6434,-13.6243)
  ,Vector2(-25.2968,1.26171)
  ,Vector2(-9.24782,-11.531)
  ,Vector2(5.17302,-10.8332)
  ,Vector2(28.8976,2.88987)
  ,Vector2(8.89453,2.65728)
  ,Vector2(23.3154,18.9389)
  ,Vector2(0.986327,13.124)
  ,Vector2(9.82491,27.0797)
  ,Vector2(-6.45669,21.4974)
  ,];

final List<Vector2> _attack2ind2 = [
  Vector2(20, -1),
  Vector2(69,-1),
  Vector2(69,2),
  Vector2(20,2),
];

final List<Vector2> _attackCombo = [
  Vector2(-36.0233,17.943)
  ,Vector2(-14.6649,27.0966)
  ,Vector2(10.9181,26.8619)
  ,Vector2(27.3476,23.3413)
  ,Vector2(47.063,19.3512)
  ,Vector2(55.2778,12.5447)
  ,Vector2(55.0431,5.03411)
  ,Vector2(38.6136,0.809383)
  ,Vector2(15.3776,-1.06827)
  ,Vector2(45.6548,9.96296)
  ,Vector2(8.33636,7.14647)
  ,Vector2(27.1129,18.4124)
  ,Vector2(0.825739,15.1265)
  ,Vector2(2.23398,23.1065)
  ,];


class OrthoPlayer extends SpriteAnimationComponent with KeyboardHandler,HasGameRef<KyrgyzGame>, MainPlayer
{
  OrthoPlayer({required this.startPos});
  final Vector2 _speed = Vector2.all(0);
  final Vector2 _velocity = Vector2.all(0);
  PlayerWeapon? _weapon;
  Vector2 startPos;
  double dumping = 8;


  @override
  Future<void> onLoad() async
  {
    opacity = 0;
    Image? spriteImg;
    spriteImg = await Flame.images.load('tiles/sprites/players/warrior-144x96New.png');
    final spriteSheet = SpriteSheet(image: spriteImg, srcSize: sprSize);
    animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.07, from: 0,to: 16);
    animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.1, from: 0,to: 8);
    animHurt = spriteSheet.createAnimation(row: 5, stepTime: 0.07, from: 0,to: 6, loop: false);
    animDeath = spriteSheet.createAnimation(row: 6, stepTime: 0.1, from: 0,to: 19, loop: false);
    animCombo = spriteSheet.createAnimation(row: 2, stepTime: 0.07, from: 5,loop: false);
    animShort = spriteSheet.createAnimation(row: 3, stepTime: 0.07, from: 0,to: 11,loop: false); // 11
    animLong = spriteSheet.createAnimation(row: 4, stepTime: 0.07, from: 0,to: 16,loop: false); // 16
    List<Sprite> sprites = [];
    List<double> times = [0.09,0.09,0.09,0.9,0.09,0.09,0.09];
    sprites.add(spriteSheet.getSprite(7,0));
    sprites.add(spriteSheet.getSprite(7,1));
    sprites.add(spriteSheet.getSprite(7,2));
    sprites.add(spriteSheet.getSprite(7,3));
    sprites.add(spriteSheet.getSprite(7,2));
    sprites.add(spriteSheet.getSprite(7,1));
    sprites.add(spriteSheet.getSprite(7,0));
    animShield = SpriteAnimation.variableSpriteList(sprites, stepTimes: times, loop: false);
    animSlide = spriteSheet.createAnimation(row: 8, stepTime: 0.08, from: 0,to: 6,loop: false);
    animation = animIdle;
    animState = AnimationState.idle;
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
        isStatic: false, isLoop: true, game: gameRef);
    _weapon?.isMainPlayer = true;
    add(_weapon!);
    gameRef.playerData.statChangeTrigger.addListener(setNewEnergyCostForWeapon);
    position = startPos;
    setGroundBody();
    setNewEnergyCostForWeapon();
    add(OpacityEffect.to(1, EffectController(duration: 0.7)));
    add(TimerComponent(period: 0.3, onTick: rePriority, repeat: true));
  }

  void setNewEnergyCostForWeapon()
  {
    _weapon?.magicDamage = gameRef.playerData.magicDamage.value;
    _weapon?.permanentDamage = gameRef.playerData.permanentDamage.value;
    _weapon?.secsOfPermDamage = gameRef.playerData.secsOfPermanentDamage.value;
    _weapon?.damage = gameRef.playerData.damage.value;
    animShort?.stepTime = 0.06 + gameRef.playerData.attackSpeed.value;
    animLong?.stepTime = 0.06 + gameRef.playerData.attackSpeed.value;
    animCombo?.stepTime = 0.06 + gameRef.playerData.attackSpeed.value;
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
    if(animation == animSlide){
      return;
    }
    if(inArmor){
      if(animState == AnimationState.shield){
        // if(gameRef.playerData.energy.value > hurt / 2){
        //   gameRef.playerData.addEnergy(-hurt / 2);
        //   if(enableShieldLock) {
        //     enableShieldLock = false;
        //     gameRef.gameMap.container.add(
        //         ShieldLock(position: position - Vector2(0, 17)));
        //     add(TimerComponent(period: 0.5,repeat: false,removeOnFinish: true, onTick: (){
        //       enableShieldLock = true;
        //     }));
        //   }
        //   return;
        // }else{
        //   var temp = hurt - (gameRef.playerData.energy.value * 2);
        //   gameRef.playerData.addEnergy(-hurt / 2);
        //   hurt = temp;
        // }
        double tempDamage = hurt / 8;
        double totalDamage = 0;

        totalDamage += (1 - gameRef.playerData.armorDress.value.armor / 100 - gameRef.playerData.extraArmor.value / 100
            - gameRef.playerData.ringDress.value.armor / 100 - gameRef.playerData.swordDress.value.armor / 100) * tempDamage;
        totalDamage += (1 - gameRef.playerData.helmetDress.value.armor / 100) * tempDamage;
        totalDamage += (1 - gameRef.playerData.glovesDress.value.armor / 100) * tempDamage;
        totalDamage += (1 - gameRef.playerData.bootsDress.value.armor / 100) * tempDamage;
        totalDamage -= gameRef.playerData.shieldBlock.value;

        // if(totalDamage < gameRef.playerData.maxHealth.value / 4){
        //   totalDamage = 0;
        // }
        totalDamage = math.max(0, totalDamage);
        if(totalDamage == 0){
          if(enableShieldLock) {
            enableShieldLock = false;
            gameRef.gameMap.container.add(
                ShieldLock(position: position - Vector2(0, 17)));
            add(TimerComponent(period: 0.5,repeat: false,removeOnFinish: true, onTick: (){
              enableShieldLock = true;
            }));
          }
          return;
        }
        gameRef.playerData.addHealth(-totalDamage);
        if(gameRef.playerData.health.value < 1){
          animation = animDeath;
          animationTicker?.onComplete = gameRef.startDeathMenu;
          animState = AnimationState.death;
        }else{
          add(ColorEffect(
            const Color(0xFFFFFFFF),
            EffectController(duration: 0.07, reverseDuration: 0.07),
            opacityFrom: 0.0,
            opacityTo: 0.9,
          ));
        }
        return;
      }else{
        double tempDamage = hurt / 8;
        double totalDamage = 0;
        totalDamage += (1 - gameRef.playerData.armorDress.value.armor / 100 - gameRef.playerData.extraArmor.value / 100
            - gameRef.playerData.ringDress.value.armor / 100 - gameRef.playerData.swordDress.value.armor / 100) * tempDamage;
        totalDamage += (1 - gameRef.playerData.helmetDress.value.armor / 100) * tempDamage;
        totalDamage += (1 - gameRef.playerData.glovesDress.value.armor / 100) * tempDamage;
        totalDamage += (1 - gameRef.playerData.bootsDress.value.armor / 100) * tempDamage;
        hurt = totalDamage;
      }
    }
    gameRef.playerData.addHealth(-hurt);
    if(gameRef.playerData.health.value <1){
      animation = animDeath;
      animationTicker?.onComplete = gameRef.startDeathMenu;
      animState = AnimationState.death;
    }else{
      if(animState == AnimationState.hurt){
        return;
      }
      double hurtMiss = math.Random().nextDouble();
      if(hurtMiss < gameRef.playerData.hurtMiss.value){
        add(ColorEffect(
          const Color(0xFFFFFFFF),
          EffectController(duration: 0.07, reverseDuration: 0.07),
          opacityFrom: 0.0,
          opacityTo: 0.9,
        ));
        return;
      }
      _weapon?.collisionType = DCollisionType.inactive;
      _velocity.x = 0;
      _velocity.y = 0;
      groundRigidBody?.linearVelocity = Vector2.zero();
      _speed.x = 0;
      _speed.y = 0;
      animation = null;
      animation = animHurt;
      animState = AnimationState.hurt;
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

  @override
  void startMagic()
  {
    if(gameRef.playerData.ringDress.value == NullItem()){
      return;
    }
    if(!canMagicSpell || game.playerData.mana.value < gameRef.playerData.ringDress.value.manaCost){
      return;
    }
    if(animation != animIdle && animation != animMove){
      return;
    }
    if(game.playerData.energy.value < _weapon!.energyCost){
      return;
    }
    game.playerData.addMana(-gameRef.playerData.ringDress.value.manaCost);
    canMagicSpell = false;
    add(TimerComponent(period: 1, removeOnFinish: true, onTick: (){
      canMagicSpell = true;
    }));
    createPlayerMagicSpells(gameRef);
  }

  @override
  void startHit(bool isLong)
  {
    if(animation == animShort && animationTicker!.currentIndex > 1 && animationTicker!.currentIndex < 5 && !makeComboHit){
      if(game.playerData.energy.value < _weapon!.energyCost){
        return;
      }
      makeComboHit = true;
      return;
    }
    if(animation != animIdle && animation != animMove && animation != animShield){
      return;
    }
    _weapon?.energyCost = isLongAttack ? SpriteAnimationTicker(animLong!).totalDuration() * 4.5 : SpriteAnimationTicker(animShort!).totalDuration() * 3;
    makeComboHit = false;
    if(game.playerData.energy.value < _weapon!.energyCost){
      return;
    }
    wasMagicSwordHit = false;
    FlameAudio.play('playerHit.mp3',volume: 2);
    game.playerData.addEnergy(-_weapon!.energyCost);
    isLongAttack = isLong;
    animation = isLongAttack ? animLong : animShort;
    animState = AnimationState.attack;
    _velocity.x = 0;
    _velocity.y = 0;
    _speed.x = 0;
    _speed.y = 0;
    groundRigidBody?.linearVelocity = Vector2.zero();
    _weapon?.cleanHashes();
    animationTicker?.onFrame = onFrameWeapon;
    animationTicker?.onComplete = chooseStaticAnimation;
  }

  void chooseStaticAnimation()
  {
    Vector2 speed = groundRigidBody?.linearVelocity ?? Vector2.zero();
    if(speed.x.abs() < 6 && speed.y.abs() < 6 && _velocity.x == 0 && _velocity.y == 0){
      animation = animIdle;
      animState = AnimationState.idle;
    }else{
      animation = animMove;
      animState = AnimationState.move;
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
      animation = animIdle;
      animState = AnimationState.idle;
  }

  void movePlayer(double angle, bool isRunRun)
  {
    if(gameRef.playerData.isLockMove){
      return;
    }
    if(animState == AnimationState.move || animState == AnimationState.idle || animState == AnimationState.shield){
      if(animState == AnimationState.shield && animationTicker!.currentIndex < 3){
        return;
      }
      isRun = false;
      animState = AnimationState.move; // Тут может быть и анимация удара под конец ты тоже можешь бегать
      if(animation != animMove){
        animation = animMove;
      }
      // if(animation == animMove){
      //   if (isRun && gameRef.playerData.energy.value > 0 && !isMinusEnergy) {
      //     animation?.frames[0].stepTime == 0.12? animation?.stepTime = 0.1 : null;
      //   }else{
      //     animation?.frames[0].stepTime == 0.1? animation?.stepTime = 0.12 : null;
      //   }
      // }
      angle += math.pi/2;
      _velocity.x = -cos(angle) * PhysicVals.startSpeed;
      _velocity.y = sin(angle) * PhysicVals.startSpeed;
      maxSpeeds.x = -cos(angle) * PhysicVals.maxSpeed;
      maxSpeeds.y = sin(angle) * PhysicVals.maxSpeed;
      if (_velocity.x > 0 && isFlippedHorizontally) {
        flipHorizontally();
      } else if (_velocity.x < 0 && !isFlippedHorizontally) {
        flipHorizontally();
      }
    }
  }

  @override
  void doDash(bool left)
  {
    if(gameRef.playerData.isLockMove){
      return;
    }
    if(gameRef.playerData.mana.value < 10){
      return;
    }
    if(animState == AnimationState.move || animState == AnimationState.idle || animState == AnimationState.shield || animState == AnimationState.hurt){
      gameRef.playerData.addMana(-10);
      animState = AnimationState.slide;
      groundRigidBody?.clearForces();
      groundRigidBody?.linearVelocity = Vector2.zero();
      setGroundBody(targetPos: position, isEnemy: true, myDumping: 0);
      animation = animSlide;
      add(TimerComponent(period: animationTicker!.totalDuration(), repeat: false, removeOnFinish: true, onTick: (){setGroundBody(targetPos: position);}));
      animationTicker?.onFrame = (frame){
        if(frame == 5){
          animState = AnimationState.idle;
          groundRigidBody?.linearDamping = dumping;
          groundRigidBody?.angularDamping = dumping;
        }
      };
      animationTicker?.onComplete = (){
        chooseStaticAnimation();
      };
      if(left && !isFlippedHorizontally){
        flipHorizontally();
      }else if(!left && isFlippedHorizontally){
        flipHorizontally();
      }
      left ? groundRigidBody?.applyLinearImpulse(Vector2(-3000,0)) : groundRigidBody?.applyLinearImpulse(Vector2(3000,0));
    }
  }

  @override
  void doShield()
  {
    if(gameRef.playerData.isLockMove){
      return;
    }
    if(gameRef.playerData.energy.value < gameRef.playerData.shieldBlockEnergy.value){
      return;
    }
    if(animState == AnimationState.move || animState == AnimationState.idle || animState == AnimationState.attack){
      animState = AnimationState.shield;
      groundRigidBody?.clearForces();
      _weapon?.collisionType = DCollisionType.inactive;
      gameRef.playerData.addEnergy(-gameRef.playerData.shieldBlockEnergy.value);
      animation = animShield;
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
    if(animation == animCombo){
      if(index == 2) {
        _weapon?.changeVertices(_attackCombo, isLoop: true);
        _weapon?.collisionType = DCollisionType.active;
        game.playerData.addEnergy(-_weapon!.energyCost);
      }else if(index == 4){
        _weapon?.collisionType = DCollisionType.inactive;
        _weapon?.cleanHashes();
      }else if(index == 8){
        _weapon?.changeVertices(_attack2ind2,isLoop: true);
        _weapon?.collisionType = DCollisionType.active;
      }else if(index == 12){
        _weapon?.collisionType = DCollisionType.inactive;
        animState = AnimationState.idle;
      }
      return;
    }
    if(isLongAttack){
      if(index == 7){
        _weapon?.changeVertices(_attack2ind2,isLoop: true);
        _weapon?.collisionType = DCollisionType.active;
      }else if(index == 11){
        _weapon?.collisionType = DCollisionType.inactive;
        animState = AnimationState.idle;
      }
    }else{
      if(index == 2){
        _weapon?.changeVertices(_attack1ind1);
        _weapon?.collisionType = DCollisionType.active;
      }else if(index == 5){
        _weapon?.collisionType = DCollisionType.inactive;
        if(makeComboHit){
          _weapon?.cleanHashes();
          animation = animCombo;
          animationTicker?.onComplete = chooseStaticAnimation;
          animationTicker?.onFrame = onFrameWeapon;
        }else {
          animState = AnimationState.idle;
        }
      }
    }
  }

  void rePriority()
  {
    int pos = position.y.toInt() + 25;
    if(pos <= 0){
      pos = 1;
    }
    priority = pos;
  }

  @override
  void update(double dt) {
    if (gameHide) {
      return;
    }
    game.playerData.addMana((gameRef.playerData.maxMana.value / 28) * dt);
    game.playerData.addHealth((gameRef.playerData.maxHealth.value / 240) * dt);
    if(groundRigidBody != null){
      position = groundRigidBody!.position / PhysicVals.physicScale;
    }
    super.update(dt);
    if (gameRef.playerData.energy.value > 1) {
      isMinusEnergy = false;
    }
    if(animState != AnimationState.move && animState != AnimationState.shield && animState != AnimationState.slide && animation != animLong && animation != animShort && animation != animCombo){
      gameRef.playerData.addEnergy((gameRef.playerData.maxEnergy.value / 10) * dt );
      return;
    }
    if(animState != AnimationState.move){
      return;
    }
    bool isReallyRun = false;
    // if(isRun && !isMinusEnergy){
    //   if(gameRef.playerData.energy.value <= 0){
    //     isMinusEnergy = true;
    //     if(animation == animMove) {
    //       animation?.frames[0].stepTime == 0.1 ? animation?.stepTime = 0.12 : null;
    //     }
    //   }else{
    //     if(animation == animMove) {
    //       animation?.frames[0].stepTime == 0.12 ? animation?.stepTime = 0.1 : null;
    //     }
    //     isReallyRun = true;
    //   }
    //   gameRef.playerData.addEnergy(dt * -4);
    // }else{
    //
    // }
    if(!gameRef.playerData.isLockEnergy) {
      gameRef.playerData.addEnergy((gameRef.playerData.maxEnergy.value / 15) * dt );
    }
    groundRigidBody?.applyLinearImpulse(_velocity * dt * groundRigidBody!.mass * (isReallyRun ? PhysicVals.runCoef : 1));
    Vector2 speed = groundRigidBody?.linearVelocity ?? Vector2.zero();
    if(speed.x.abs() < 6 && speed.y.abs() < 6 && _velocity.x == 0 && _velocity.y == 0){
      setIdleAnimation();
    }
  }
}