
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/liveObjects/moose.dart';
import 'package:game_flame/weapon/weapon.dart';
import 'dart:math' as math;

class DefaultEnemyWeapon extends EnemyWeapon
{
  DefaultEnemyWeapon(super._vertices, {super.onObstacle,required super.collisionType,super.isSolid,required super.isStatic,
    super.onStartWeaponHit,super.onEndWeaponHit,super.isLoop,required super.game,super.radius, super.isOnlyForStatic, });

  @override
  Future<void> hit() async {
    onStartWeaponHit?.call();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, DCollisionEntity other) {

  }

  @override
  void onCollisionEnd(DCollisionEntity other){

  }

  @override
  void update(double dt)
  {
    // doDebug();
    super.update(dt);
  }
}

// class EWBody extends EnemyWeapon
// {
//   bool _isActive = false;
//   bool _isGrow = true;
//   final double _maxLength = 3;
//
//   EWBody(super._vertices, {required super.collisionType, super.isSolid, required super.isStatic
//     , required super.onStartWeaponHit, required super.onEndWeaponHit, super.isLoop, required super.game, super.radius, super.isOnlyForStatic, });
//
//   @override
//   Future onLoad() async
//   {
//     damage = 1;
//     // transformPoint = vertices[0];
//   }
//
//   @override
//   Future<void> hit() async
//   {
//     transformPoint = vertices[0];
//     currentCoolDown = coolDown;
//     onStartWeaponHit?.call();
//     _isActive = true;
//     latencyBefore = -activeSecs/3;
//     scale = Vector2(1,1);
//     TimerComponent timer = TimerComponent(period: activeSecs,
//         removeOnFinish: true,
//         onTick: (){
//           transformPoint = rawCenter;
//           _isGrow = true;
//           onEndWeaponHit?.call();
//           _isActive = false;
//           scale = Vector2(1,1);
//         }
//     );
//     game.gameMap.add(timer);
//   }
//
//   @override
//   void update(double dt)
//   {
//     if(latencyBefore < 0){
//       latencyBefore += dt;
//     }
//     if(latencyBefore >= 0 && _isActive){
//       if(_isGrow && scale.x > _maxLength/2){
//         _isGrow = false;
//       }
//       _isGrow ? scale = Vector2(math.max(1,(scale.x + dt/activeSecs * _maxLength)), scale.y) : scale = Vector2(math.max(1, scale.x - dt/activeSecs * _maxLength), scale.y);
//     }else{
//       scale = Vector2(1,1);
//     }
//     super.update(dt);
//   }
//
//   @override
//   void onCollision(Set<Vector2> intersectionPoints, DCollisionEntity other) {
//     // TODO: implement onCollision
//   }
//
//   @override
//   void onCollisionEnd(DCollisionEntity other) {
//     // TODO: implement onCollisionEnd
//   }
// }
//
// class EWMooseHummer extends EnemyWeapon //ось - середина муса
// {
//   double _diffAngle = 0;
//   double _activeSecs = 0;
//
//   EWMooseHummer(super._vertices, {required super.collisionType, super.isSolid, required super.isStatic, required super.onStartWeaponHit
//     , required super.onEndWeaponHit, super.isLoop, required super.game, super.radius, super.isOnlyForStatic, })
//   {
//     transformPoint = Vector2(15,0);
//   }
//
//   @override
//   Future onLoad() async
//   {
//     damage = 3;
//     coolDown = 2;
//     // transformPoint = vertices[0];
//   }
//
//   @override
//   Future<void> hit() async
//   {
//     if(collisionType == DCollisionType.inactive){
//       currentCoolDown = coolDown;
//       onStartWeaponHit?.call();
//       late SpriteAnimationTicker tick;
//       latencyBefore = -0.28;
//       _diffAngle = 0;
//       angle = -10;
//       var temp = parent as Moose;
//       temp.animation = temp.animAttack;
//       _activeSecs = temp.animationTicker!.totalDuration() + latencyBefore;
//       collisionType = DCollisionType.active;
//       temp.animationTicker?.onFrame = (index){
//         if(index == 15){
//           collisionType = DCollisionType.inactive;
//         }
//       };
//       TimerComponent timer = TimerComponent(period: _activeSecs,
//       removeOnFinish: true,
//       onTick: (){
//         collisionType = DCollisionType.inactive;
//         onEndWeaponHit?.call();
//       }
//       );
//       game.gameMap.add(timer);
//     }
//   }
//
//   @override
//   void update(double dt)
//   {
//     // doDebug();
//     if(latencyBefore < 0){
//       latencyBefore += dt;
//     }
//     if(latencyBefore >= 0 && collisionType == DCollisionType.active) {
//       if (angle < 8.360913459421951 * 16) {
//         _diffAngle += (_activeSecs / 2) * sectorInRadian * 4 * dt * 100;
//         angle = 0 + _diffAngle;
//       }
//     }
//     super.update(dt);
//   }
//
//   @override
//   void onCollision(Set<Vector2> intersectionPoints, DCollisionEntity other) {
//     // TODO: implement onCollision
//   }
//
//   @override
//   void onCollisionEnd(DCollisionEntity other) {
//     // TODO: implement onCollisionEnd
//   }
// }