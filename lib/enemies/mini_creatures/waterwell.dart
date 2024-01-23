// import 'package:flame/components.dart';
// import 'package:flame/effects.dart';
// import 'package:flame/extensions.dart';
// import 'package:flame/flame.dart';
// import 'package:flame/geometry.dart';
// import 'package:flame/sprite.dart';
// import 'package:game_flame/abstracts/hitboxes.dart';
// import 'package:game_flame/abstracts/item.dart';
// import 'package:game_flame/components/physic_vals.dart';
// import 'package:game_flame/kyrgyz_game.dart';
//
//
//
// class Waterwell extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
// {
//   Waterwell(this._startPosition);
//   final Vector2 _startPosition;
//   ObjectHitbox? _objectHitbox;
//   SpriteAnimation? _animationDown, _animationUp;
//   bool _isDown = true;
//
//   @override
//   Future<void> onLoad() async
//   {
//     var spriteSheet = SpriteSheet(
//       image: await Flame.images.load('tiles/map/grassLand2/Props/Animated props/water well- water bucket-going down.png'),
//       srcSize: Vector2(158,187),);
//     animation = spriteSheet.createAnimation(row: 0, stepTime: 1, from: 0, to: 1, loop: false);
//     _animationDown = spriteSheet.createAnimation(row: 0, stepTime: 0.16, from: 0, loop: false);
//     var spriteSheetUp = SpriteSheet(
//       image: await Flame.images.load('tiles/map/grassLand2/Props/Animated props/water well- water bucket-going up.png'),
//       srcSize: Vector2(158,187),);
//     _animationUp = spriteSheetUp.createAnimation(row: 0, stepTime: 0.16, from: 1, loop: false);
//
//     size = Vector2.all(70);
//     anchor = Anchor.center;
//     _objectHitbox = ObjectHitbox(getPointsForActivs(Vector2.all(-35), size),
//         collisionType: DCollisionType.active, isSolid: true, isStatic: false, isLoop: true,
//         autoTrigger: false, obstacleBehavoiur: getMove, game: gameRef);
//     // var asd = ObjectHitbox(obstacleBehavoiur: checkIsIOpen);
//     await add(_objectHitbox!);
//   }
//
//   void getMove()
//   {
//     if(nedeedKilledBosses != null){
//       if(!gameRef.playerData.killedBosses.containsAll(nedeedKilledBosses!)){
//         print('not kill needed boss');
//         return;
//       }
//     }
//     if(neededItems != null){
//       for(final myNeeded in neededItems!) {
//         bool isNeed = true;
//         for(final playerHas in gameRef.playerData.inventoryItems){
//           if(playerHas.id == myNeeded){
//             isNeed = false;
//             break;
//           }
//         }
//         if(isNeed){
//           print('not has nedeed item');
//           return;
//         }
//       }
//     }
//     remove(_objectHitbox!);
//     game.gameMap.currentObject.value = null;
//     animation = _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 15, loop: false);
//     double dur = animation!.ticker().totalDuration();
//     for(final myItem in myItems){
//       myItem.getEffect(gameRef);
//     }
//     add(OpacityEffect.by(-0.95,EffectController(duration: dur + 0.3),onComplete: (){
//       gameRef.gameMap.loadedLivesObjs.remove(_startPosition);
//       removeFromParent();
//     }));
//   }
//
//
// }