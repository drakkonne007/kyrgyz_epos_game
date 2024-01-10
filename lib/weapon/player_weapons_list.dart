import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/weapon/weapon.dart';
import 'dart:math' as math;

class WSword extends PlayerWeapon
{
  WSword(super._vertices, {required super.collisionType, required super.isSolid, required super.isStatic, required super.onStartWeaponHit, required super.onEndWeaponHit, required super.isLoop, required super.game, super.isCircle, super.radius});

  double _activeSecs = 0;
  final double _maxLength = 9;
  int _hitVariant = 0;
  late SpriteAnimation _animShort, _animLong;
  bool _isGrow = true;
  final double _startAngle = tau - tau/6;
  double activeSecs = 0;
  double _diffAngle = 0;

  @override
  Future<void> onLoad() async
  {
    damage = 1;
    energyCost = 1;
    debugMode = true;
    final spriteImage = await Flame.images.load('tiles/sprites/players/warrior-144x96.png');
    final spriteSheet = SpriteSheet(image: spriteImage, srcSize: Vector2(144,96));
    _animShort = spriteSheet.createAnimation(row: 3, stepTime: 0.07, from: 0,to: 11,loop: false);
    _animLong = spriteSheet.createAnimation(row: 4, stepTime: 0.07, from: 0,to: 16,loop: false);
    collisionType = DCollisionType.inactive;
    coolDown = 1;
  }

  @override
  Future<void> hit() async
  {
    if(game.playerData.energy.value < energyCost || game.gameMap.orthoPlayer!.animation == game.gameMap.orthoPlayer!.animHurt
        || game.gameMap.orthoPlayer!.animation == game.gameMap.orthoPlayer!.animDeath){
      return;
    }
    if(collisionType == DCollisionType.inactive){
      transformPoint = vertices[0];
      currentCoolDown = coolDown;
      onStartWeaponHit.call();
      int rand = math.Random().nextInt(2);
      late SpriteAnimationTicker tick;
      if(rand == 0){
        latencyBefore = -0.14;
        _diffAngle = 0;
        angle = _startAngle;
        scale = Vector2(3.5,0.2);
        tick = SpriteAnimationTicker(_animShort);
        game.gameMap.orthoPlayer?.animation = _animShort;
      }else{
        latencyBefore = -0.3;
        tick = SpriteAnimationTicker(_animLong);
        game.gameMap.orthoPlayer?.animation = _animLong;
        scale = Vector2(1,1);
        angle = 0;
      }
      game.playerData.energy.value -= energyCost;
      _activeSecs = tick.totalDuration() + latencyBefore;
      _hitVariant = rand;
      game.playerData.isLockEnergy = true;
      collisionType = DCollisionType.active;
      // print('start hit');
      await Future.delayed(Duration(milliseconds: (_activeSecs * 1000).toInt()),(){
        collisionType = DCollisionType.inactive;
        _isGrow = true;
        game.playerData.isLockEnergy = false;
        onEndWeaponHit.call();
        // transformPoint = rawCenter;
        // print('end hit');
      });
    }
  }

  @override
  void update(double dt)
  {
    // doDebug();
    if(latencyBefore < 0){
      latencyBefore += dt;
    }
    if(latencyBefore >= 0 && collisionType == DCollisionType.active){
      if(_hitVariant == 0){
        if(angle < 8.360913459421951*15) {
          _diffAngle += (_activeSecs / 2) * sectorInRadian * 4 * dt * 900;
          angle = _startAngle + _diffAngle;
        }
      }else{
        if(_isGrow && scale.x > _maxLength / 2){
          _isGrow = false;
        }
        _isGrow ? scale = Vector2(scale.x + dt/_activeSecs * _maxLength, scale.y) : scale = Vector2(scale.x - dt/_activeSecs * _maxLength, scale.y);
      }
    }
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, DCollisionEntity other) {
    // TODO: implement onCollision
  }

  @override
  void onCollisionEnd(DCollisionEntity other) {
    // TODO: implement onCollisionEnd
  }
}