import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/weapon/weapon.dart';
import 'dart:math' as math;

class WSword extends PlayerWeapon
{
  WSword({
    super.position,
    super.angle,
    super.anchor,
    super.priority,
    bool isSolid = true,
    required super.onStartWeaponHit,
    required super.onEndWeaponHit,
  });

  double _activeSecs = 0;
  double _maxLength = 150;
  int _hitVariant = 0;
  late SpriteAnimation _animShort, _animLong;
  bool _isGrow = true;
  final double _startAngle = tau - tau/6;
  double activeSecs = 0;
  double _diffAngle = 0;

  @override
  void onMount()
  {
    super.onMount();
    size = Vector2(1,10);
    anchor = Anchor.centerLeft;
  }

  @override
  Future<void> onLoad() async
  {
    damage = 1;
    anchor = Anchor.bottomCenter;
    energyCost = 1;
    debugMode = true;
    final spriteImage = await Flame.images.load('tiles/sprites/players/warrior-144x96.png');
    final spriteSheet = SpriteSheet(image: spriteImage, srcSize: Vector2(144,96));
    _animShort = spriteSheet.createAnimation(row: 3, stepTime: 0.07, from: 0,to: 11);
    _animLong = spriteSheet.createAnimation(row: 4, stepTime: 0.07, from: 0,to: 16);
  }

  @override
  Future<void> hit() async
  {
    if(gameRef.playerData.energy.value < energyCost) {
      return;
    }
    if(collisionType == CollisionType.inactive) {
      onStartWeaponHit.call();
      int rand = math.Random().nextInt(2);
      late SpriteAnimationTicker tick;
      if(rand == 0){
        _diffAngle = 0;
        angle = _startAngle;
        size = Vector2(42,10);
        tick = SpriteAnimationTicker(_animShort);
        gameRef.gameMap.orthoPlayer?.animation = _animShort;
      }else{
        tick = SpriteAnimationTicker(_animLong);
        gameRef.gameMap.orthoPlayer?.animation = _animLong;
        size = Vector2(1,10);
        angle = 0;
      }
      debugMode = true;
      gameRef.playerData.energy.value -= energyCost;
      _activeSecs = tick.totalDuration();
      _hitVariant = rand;
      gameRef.playerData.isLockEnergy = true;
      collisionType = CollisionType.active;
      // print('start hit');
      await Future.delayed(Duration(milliseconds: (_activeSecs * 1000).toInt()),(){
        collisionType = CollisionType.inactive;
        _isGrow = true;
        debugMode = false;
        gameRef.playerData.isLockEnergy = false;
        onEndWeaponHit.call();
        // print('end hit');
      });
    }
  }

  @override
  void update(double dt)
  {
    if(collisionType == CollisionType.active){
      if(_hitVariant == 0){
        if(angle < 8.360913459421951) {
          _diffAngle += dt / (_activeSecs / 2) * sectorInRadian * 4;
          angle = _startAngle + _diffAngle;
        }
      }else{
        if(_isGrow && size.x > _maxLength/2){
          _isGrow = false;
        }
        _isGrow ? size = Vector2(size.x + dt/_activeSecs * _maxLength, size.y) : size = Vector2(size.x - dt/_activeSecs * _maxLength, size.y);
      }
    }
    super.update(dt);
  }
}