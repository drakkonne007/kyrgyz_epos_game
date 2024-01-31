// import 'package:flame/components.dart';
// import 'package:flame/effects.dart';
// import 'package:flame/extensions.dart';
// import 'package:flame/flame.dart';
// import 'package:flame/sprite.dart';
// import 'package:game_flame/Items/chest.dart';
// import 'package:game_flame/Items/loot_on_map.dart';
// import 'package:game_flame/Obstacles/ground.dart';
// import 'package:game_flame/abstracts/enemy.dart';
// import 'package:game_flame/abstracts/utils.dart';
// import 'package:game_flame/weapon/enemy_weapons_list.dart';
// import 'package:game_flame/abstracts/hitboxes.dart';
// import 'package:game_flame/abstracts/item.dart';
// import 'dart:math' as math;
// import 'package:game_flame/kyrgyz_game.dart';
//
// class Skeleton extends SpriteAnimationComponent with HasGameRef<KyrgyzGame> implements KyrgyzEnemy
// {
//   Skeleton(this._startPos);
//   late SpriteAnimation _animMove, _animIdle, _animAttack,_animAttack2, _animHurt, _animDeath;
//   late EnemyHitbox _hitbox;
//   late GroundHitBox _groundBox;
//   late Ground _ground;
//   final Vector2 _spriteSheetSize = Vector2(220,220);
//   final Vector2 _startPos;
//   final Vector2 _speed = Vector2(0,0);
//   final double _maxSpeed = 70;
//   double _rigidSec = 1;
//   bool _wasHit = false;
//   late DefaultEnemyWeapon _defWeapon;
//   int _variantOfHit = 0;
//   ObstacleWhere _whereObstacle = ObstacleWhere.none;
//
//   @override
//   int column=0;
//   @override
//   int row=0;
//   @override
//   int maxLoots = 2;
//   @override
//   double chanceOfLoot = 0.8;
//   @override
//   double armor = 0;
//   @override
//   List<Item> loots = [];
//   @override
//   double health = 3;
//   bool _isRefresh = true;
//
//   final List<Vector2> _hitBox = [
//     Vector2(115-115,100-110),
//     Vector2(109-115,104-110),
//     Vector2(110-115,112-110),
//     Vector2(103-115,116-110),
//     Vector2(101-115,148-110),
//     Vector2(122-115,148-110),
//     Vector2(124-115,106-110)
//   ];
//
//   final List<Vector2> _attack1PointsOnStart = [
//     Vector2(501 - 555,573 - 550),
//     Vector2(532 - 555,581 - 550),
//     Vector2(771 - 775,551 - 550),
//     Vector2(748 - 775,527 - 550),
//   ];
//
//   final List<Vector2> _attack1PointsOnEnd = [
//     Vector2(995  - 995,531 - 550),
//     Vector2(1032 - 995,581 - 550),
//     Vector2(1059 - 995,585 - 550),
//     Vector2(1053 - 995,561 - 550),
//     Vector2(1033 - 995,541 - 550),
//   ];
//
//   final List<Vector2> _attack2PointsOnStart = [
//     Vector2(500 - 555,794 - 770),
//     Vector2(729 - 775,759 - 770),
//     Vector2(754 - 775,785 - 770),
//     Vector2(748 - 775,527 - 770),
//   ];
//
//   final List<Vector2> _attack2PointsOnEnd = [
//     Vector2(965  - 220 * 4 - 115,777 - 770),
//     Vector2(987  - 220 * 4 - 115,797 - 770),
//     Vector2(1004 - 220 * 4 - 115,800 - 770),
//     Vector2(1042 - 220 * 4 - 115,785 - 770),
//     Vector2(1028 - 220 * 4 - 115,804 - 770),
//     Vector2(1016 - 220 * 4 - 115,809 - 770),
//     Vector2(994  - 220 * 4 - 115,808 - 770),
//     Vector2(977  - 220 * 4 - 115,801 - 770),
//     Vector2(967  - 220 * 4 - 115,787 - 770),
//   ];
//
//   @override
//   Future<void> onLoad() async
//   {
//     anchor = const Anchor(115/220,0.5);
//     Image? spriteImage;
//     int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
//     if(rand == 0){
//       spriteImage = await Flame.images.load('tiles/map/prisonSet/Characters/Skeleton 1/no shield/Skeleton 1 - all animations.png');
//     }else{
//       spriteImage = await Flame.images.load(
//           'tiles/map/prisonSet/Characters/Skeleton 1/no shield/rusty sword/Skeleton - all animations-with rusty sword.png');
//     }
//     final spriteSheet = SpriteSheet(image: spriteImage,
//         srcSize: _spriteSheetSize);
//     _animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8);
//     _animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 8);
//     _animAttack = spriteSheet.createAnimation(row: 2, stepTime: 0.08, from: 0,loop: false);
//     _animAttack2 = spriteSheet.createAnimation(row: 3, stepTime: 0.08, from: 0, to: 13, loop: false);
//     _animHurt = spriteSheet.createAnimation(row: 4, stepTime: 0.07, from: 0, to: 8,loop: false);
//     _animDeath = spriteSheet.createAnimation(row: 5, stepTime: 0.1, from: 0, to: 13,loop: false);
//     animation = _animIdle;
//     size = _spriteSheetSize;
//     position = _startPos;
//     _hitbox = EnemyHitbox(_hitBox,
//         collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
//     add(_hitbox);
//     _groundBox = GroundHitBox(getPointsForActivs(Vector2(101-115,127-110), Vector2(22,21)) ,obstacleBehavoiurStart: obstacleBehaviour,
//         collisionType: DCollisionType.active,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
//     add(_groundBox);
//     // _groundBox.debugColor = BasicPalette.red.color;
//     _ground = Ground(getPointsForActivs(Vector2(101-115,127-110), Vector2(22,21))
//         , collisionType: DCollisionType.passive, isSolid: true, isStatic: false, isLoop: true, game: gameRef);
//     _ground.onlyForPlayer = true;
//     add(_ground);
//     TimerComponent timer = TimerComponent(onTick: checkIsNeedSelfRemove,repeat: true,autoStart: true, period: 1);
//     add(timer);
//     _defWeapon = DefaultEnemyWeapon(_attack1PointsOnStart,collisionType: DCollisionType.inactive,isStatic: false,isLoop:true,game: gameRef
//         ,isSolid: false,onStartWeaponHit: onStartHit,onEndWeaponHit: onEndHit);
//     add(_defWeapon);
//     selectBehaviour();
//   }
//
//   void chooseHit()
//   {
//     _wasHit = true;
//     animation = null;
//     _speed.x = 0;
//     _speed.y = 0;
//     _variantOfHit = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
//     if(_variantOfHit == 0){
//       animation = _animAttack;
//     }else{
//       animation = _animAttack2;
//     }
//     animationTicker?.onComplete = selectBehaviour;
//     animationTicker?.onFrame = changeVertsInWeapon;
//   }
//
//   void changeVertsInWeapon(int index)
//   {
//     if(_variantOfHit == 0){
//       if(index == 2 || index == 3){
//         _defWeapon.changeVertices(_attack1PointsOnStart,isLoop: true);
//         _defWeapon.collisionType = DCollisionType.active;
//       }else if(index == 4 || index == 5){
//         _defWeapon.changeVertices(_attack1PointsOnEnd,isLoop: true);
//       }else{
//         _defWeapon.collisionType = DCollisionType.inactive;
//       }
//     }else{
//       if(index == 2){
//         _defWeapon.changeVertices(_attack2PointsOnStart,isLoop: true);
//         _defWeapon.collisionType = DCollisionType.active;
//       }else if(index == 4){
//         _defWeapon.changeVertices(_attack2PointsOnEnd,isLoop: true);
//       }else if(index == 7){
//         _defWeapon.collisionType = DCollisionType.inactive;
//       }
//     }
//   }
//
//   void selectBehaviour()
//   {
//     if(gameRef.gameMap.orthoPlayer == null){
//       return;
//     }
//     int random = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
//     if(random != 0 || _wasHit){
//       int shift = 0;
//       if(position.x < gameRef.gameMap.orthoPlayer!.position.x){
//         shift = -50;
//       }else{
//         shift = 50;
//       }
//       double posX = gameRef.gameMap.orthoPlayer!.position.x - position.x + shift;
//       double posY = gameRef.gameMap.orthoPlayer!.position.y - position.y;
//       if(_whereObstacle == ObstacleWhere.side){
//         posX = 0;
//       }
//       if(_whereObstacle == ObstacleWhere.upDown){
//         posY = 0;
//       }
//       _whereObstacle = ObstacleWhere.none;
//       double angle = math.atan2(posY,posX);
//       _speed.x = math.cos(angle) * _maxSpeed;
//       _speed.y = math.sin(angle) * _maxSpeed;
//       if(_speed.x < 0 && !isFlippedHorizontally){
//         flipHorizontally();
//       }else if(_speed.x > 0 && isFlippedHorizontally){
//         flipHorizontally();
//       }
//       animation = _animMove;
//     }else{
//       if(animation != _animIdle){
//         _speed.x = 0;
//         _speed.y = 0;
//         animation = _animIdle;
//       }
//     }
//   }
//
//   void onStartHit()
//   {
//     _wasHit = true;
//     animation = _animAttack;
//   }
//
//   void onEndHit()
//   {
//     selectBehaviour();
//   }
//
//   void checkIsNeedSelfRemove()
//   {
//     column = position.x ~/ gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x;
//     row =    position.y ~/ gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y;
//     int diffCol = (column - gameRef.gameMap.column()).abs();
//     int diffRow = (row - gameRef.gameMap.row()).abs();
//     if(diffCol > 2 || diffRow > 2){
//       gameRef.gameMap.loadedLivesObjs.remove(_startPos);
//       removeFromParent();
//     }
//     if(diffCol > 1 || diffRow > 1){
//       _isRefresh = false;
//     }else{
//       _isRefresh = true;
//     }
//   }
//
//   bool isNearPlayer()
//   {
//     var pl = gameRef.gameMap.orthoPlayer!;
//     if(pl.hitBox == null){
//       return false;
//     }
//     if(_hitbox.getCenter().distanceToSquared(pl.hitBox!.getCenter()) > math.pow(_hitbox.width * 0.5 + 60,2)){
//       return false;
//     }
//     if(pl.hitBox!.getMinVector().y > _hitbox.getMaxVector().y || pl.hitBox!.getMaxVector().y < _hitbox.getMinVector().y){
//       return false;
//     }
//     return true;
//   }
//
//   void obstacleBehaviour(Set<Vector2> intersectionPoints, DCollisionEntity other)
//   {
//     Map<Vector2,AxesDiff> diffs = {};
//     bool isUp = false;
//     bool isDown = false;
//     bool isLeft = false;
//     bool isRight = false;
//     double maxLeft = 0;
//     double maxRight = 0;
//     double maxUp = 0;
//     double maxDown = 0;
//
//     for(final point in intersectionPoints){
//       double leftDiffX  = point.x - _groundBox.getMinVector().x;
//       double rightDiffX = point.x - _groundBox.getMaxVector().x;
//       double upDiffY = point.y - _groundBox.getMinVector().y;
//       double downDiffY = point.y - _groundBox.getMaxVector().y;
//
//       // print('diffs: $leftDiffX $rightDiffX $upDiffY $downDiffY');
//
//       diffs.putIfAbsent(point, () => AxesDiff(leftDiffX,rightDiffX,upDiffY,downDiffY));
//       double minDiff = math.min(leftDiffX.abs(),rightDiffX.abs());
//       minDiff = math.min(minDiff,upDiffY.abs());
//       minDiff = math.min(minDiff,downDiffY.abs());
//       if(minDiff == leftDiffX.abs()){
//         isLeft = true;
//         maxLeft = math.max(maxLeft,minDiff);
//       }
//       if(minDiff == rightDiffX.abs()){
//         isRight = true;
//         maxRight = math.max(maxRight,minDiff);
//       }
//       if(minDiff == upDiffY.abs()){
//         isUp = true;
//         maxUp = math.max(maxUp,minDiff);
//       }
//       if(minDiff == downDiffY.abs()){
//         isDown = true;
//         maxDown = math.max(maxDown,minDiff);
//       }
//     }
//
//     if(isDown && isUp && isLeft && isRight){
//       print('What is??');
//       return;
//     }
//
//     if(isDown && isUp){
//       double maxLeft = 1000000000;
//       double maxRight = 1000000000;
//       for(final diff in diffs.values){
//         maxLeft = math.min(maxLeft,diff.leftDiff.abs());
//         maxRight = math.min(maxRight,diff.rightDiff.abs());
//       }
//       if(maxLeft > maxRight){
//         position -= Vector2(maxRight,0);
//       }else{
//         position += Vector2(maxLeft,0);
//       }
//       return;
//     }
//     if(isLeft && isRight){
//       double maxUp = 100000000;
//       double maxDown = 100000000;
//       for(final diff in diffs.values){
//         maxUp = math.min(maxUp,diff.upDiff.abs());
//         maxDown = math.min(maxDown,diff.downDiff.abs());
//       }
//       if(maxUp > maxDown){
//         position -= Vector2(0,maxDown);
//       }else{
//         position += Vector2(0,maxUp);
//       }
//       return;
//     }
//     // print('maxs: $maxLeft $maxRight $maxUp $maxDown');
//
//     if(isLeft){
//       _whereObstacle = ObstacleWhere.side;
//       position +=  Vector2(maxLeft,0);
//     }
//     if(isRight){
//       _whereObstacle = ObstacleWhere.side;
//       position -=  Vector2(maxRight,0);
//     }
//     if(isUp){
//       _whereObstacle = ObstacleWhere.upDown;
//       position +=  Vector2(0,maxUp);
//     }
//     if(isDown){
//       _whereObstacle = ObstacleWhere.upDown;
//       position -=  Vector2(0,maxDown);
//     }
//   }
//
//   @override
//   void doHurt({required double hurt, bool inArmor = true, double permanentDamage = 0, double secsOfPermDamage = 0})
//   {
//     animation = null;
//     _defWeapon.collisionType = DCollisionType.inactive;
//     if(inArmor){
//       health -= math.max(hurt - armor, 0);
//     }else{
//       health -= hurt;
//     }
//     if(health <1){
//       _isRefresh = false;
//       _speed.x = 0;
//       _speed.y = 0;
//       if(loots.isNotEmpty) {
//         if(loots.length > 1){
//           var temp = Chest(0, myItems: loots, position: positionOfAnchor(Anchor.center));
//           gameRef.gameMap.add(temp);
//         }else{
//           var temp = LootOnMap(loots.first, position: positionOfAnchor(Anchor.center));
//           gameRef.gameMap.add(temp);
//         }
//       }
//       animation = _animDeath;
//       removeAll(children);
//       add(OpacityEffect.by(-0.95,EffectController(duration: _animDeath.ticker().totalDuration()),onComplete: (){
//         gameRef.gameMap.loadedLivesObjs.remove(_startPos);
//         removeFromParent();
//       }));
//     }else{
//       animation = null;
//       animation = _animHurt;
//       animationTicker!.onComplete = selectBehaviour;
//     }
//   }
//
//   @override
//   void update(double dt)
//   {
//     super.update(dt);
//     _rigidSec -= dt;
//     if(!_isRefresh){
//       return;
//     }
//     if(animation == _animHurt || animation == _animAttack || animation == _animDeath || animation == null || animation == _animAttack2){
//       return;
//     }
//     if(_rigidSec <= 0){
//       _rigidSec = 1;
//       if(isNearPlayer()){
//         _defWeapon.currentCoolDown = _defWeapon.coolDown;
//         var pl = gameRef.gameMap.orthoPlayer!;
//         if(pl.position.x > position.x){
//           if(isFlippedHorizontally){
//             flipHorizontally();
//           }
//         }
//         if(pl.position.x < position.x){
//           if(!isFlippedHorizontally){
//             flipHorizontally();
//           }
//         }
//         chooseHit();
//       }else{
//         selectBehaviour();
//       }
//     }
//     position += _speed * dt;
//   }
// }