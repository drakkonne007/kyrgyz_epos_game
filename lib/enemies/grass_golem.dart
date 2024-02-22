import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'dart:math' as math;
import 'package:game_flame/kyrgyz_game.dart';

enum GolemVariant
{
  Water,
  Grass
}

final List<Vector2> _ind1 = [ //вторая колонка
  Vector2(309 - 224 - 112,503 - 192 * 2 - 192 * 0.5),
  Vector2(304 - 224 - 112,498 - 192 * 2 - 192 * 0.5),
  Vector2(299 - 224 - 112,477 - 192 * 2 - 192 * 0.5),
  Vector2(364 - 224 - 112,469 - 192 * 2 - 192 * 0.5),
  Vector2(370 - 224 - 112,484 - 192 * 2 - 192 * 0.5),
  Vector2(374 - 224 - 112,489 - 192 * 2 - 192 * 0.5),
  Vector2(369 - 224 - 112,498 - 192 * 2 - 192 * 0.5),
  Vector2(359 - 224 - 112,498 - 192 * 2 - 192 * 0.5),
  Vector2(356 - 224 - 112,485 - 192 * 2 - 192 * 0.5)
];

final List<Vector2> _ind2 = [ //пятая
  Vector2(972  - 224 * 4 - 112,493 - 192 * 2 - 192 * 0.5),
  Vector2(968  - 224 * 4 - 112,483 - 192 * 2 - 192 * 0.5),
  Vector2(971  - 224 * 4 - 112,468 - 192 * 2 - 192 * 0.5),
  Vector2(1032 - 224 * 4 - 112,466 - 192 * 2 - 192 * 0.5),
  Vector2(1043 - 224 * 4 - 112,477 - 192 * 2 - 192 * 0.5),
  Vector2(1042 - 224 * 4 - 112,489 - 192 * 2 - 192 * 0.5)
];

final List<Vector2> _ind3 = [ //восьмая
  Vector2(2135 - 224 * 9 - 112, 530 - 192 * 2 - 96),
  Vector2(2107 - 224 * 9 - 112, 505 - 192 * 2 - 96),
  Vector2(2103 - 224 * 9 - 112, 487 - 192 * 2 - 96),
  Vector2(2158 - 224 * 9 - 112, 442 - 192 * 2 - 96),
  Vector2(2174 - 224 * 9 - 112, 448 - 192 * 2 - 96),
  Vector2(2196 - 224 * 9 - 112, 480 - 192 * 2 - 96),
  Vector2(2196 - 224 * 9 - 112, 487 - 192 * 2 - 96),
  Vector2(2146 - 224 * 9 - 112, 530 - 192 * 2 - 96),
];

final List<Vector2> _hitBoxPoint = [
  Vector2(96  - 112,57  - 96),
  Vector2(88  - 112,66  - 96),
  Vector2(94  - 112,125 - 96),
  Vector2(125 - 112,124 - 96),
  Vector2(133 - 112,76  - 96),
  Vector2(101 - 112,56  - 96),
];

class GrassGolem extends SpriteAnimationComponent with HasGameRef<KyrgyzGame> implements KyrgyzEnemy
{
  GrassGolem(this._startPos,this.spriteVariant);
  late SpriteAnimation _animMove, _animIdle, _animAttack, _animHurt, _animDeath;
  late EnemyHitbox _hitbox;
  late GroundHitBox _groundBox;
  late Ground _ground;
  final Vector2 _spriteSheetSize = Vector2(224,192);
  final Vector2 _startPos;
  final Vector2 _speed = Vector2(0,0);
  final double _maxSpeed = 30;
  final GolemVariant spriteVariant;
  double _rigidSec = 2;
  late DefaultEnemyWeapon _weapon;
  ObstacleWhere _whereObstacle = ObstacleWhere.none;
  bool _wasHit = false;

  @override
  int column=0;
  @override
  int row=0;
  @override
  int maxLoots = 4;
  @override
  double chanceOfLoot = 0;
  @override
  double armor = 0;
  @override
  List<Item> loots = [];
  @override
  double health = 3;
  bool _isRefresh = true;

  @override
  Future<void> onLoad() async
  {
    Image? spriteImage;
    if(spriteVariant == GolemVariant.Water){
      spriteImage = await Flame.images.load(
          'tiles/sprites/players/Stone-224x192.png');
    }else{
      spriteImage = await Flame.images.load(
          'tiles/sprites/players/Stone2-224x192.png');
    }
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _spriteSheetSize);
    _animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 8);
    _animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 8);
    _animAttack = spriteSheet.createAnimation(row: 2, stepTime: 0.08, from: 0,loop: false);
    _animHurt = spriteSheet.createAnimation(row: 3, stepTime: 0.07, from: 0, to: 12,loop: false);
    _animDeath = spriteSheet.createAnimation(row: 4, stepTime: 0.1, from: 0, to: 13,loop: false);
    anchor = Anchor.center;
    animation = _animIdle;
    size = _spriteSheetSize;
    position = _startPos;
    _hitbox = EnemyHitbox(_hitBoxPoint,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(_hitbox);
    _groundBox = GroundHitBox(getPointsForActivs(Vector2(90 - 112,87 - 96), Vector2(41,38)),obstacleBehavoiurStart: obstacleBehaviour,
        collisionType: DCollisionType.active,isSolid: true,isStatic: false, isLoop: true, game: gameRef);
    add(_groundBox);
    _weapon = DefaultEnemyWeapon(
        _ind1,collisionType: DCollisionType.inactive, onStartWeaponHit: onStartHit, onEndWeaponHit: onEndHit, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(_weapon);
    _weapon.damage = 3;
    _ground = Ground(getPointsForActivs(Vector2(90 - 112,87 - 96), Vector2(41,38))
        , collisionType: DCollisionType.passive, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    _ground.onlyForPlayer = true;
    add(_ground);
    var defWep = DefaultEnemyWeapon(_hitBoxPoint, collisionType: DCollisionType.active, isSolid: false, isStatic: false
        , onStartWeaponHit: null, onEndWeaponHit: null, isLoop: true, game: game);
    add(defWep);
    defWep.damage = 3;
    TimerComponent timer = TimerComponent(onTick: checkIsNeedSelfRemove,repeat: true,autoStart: true, period: 1);
    add(timer);
    int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(rand == 0){
      flipHorizontally();
    }
    selectBehaviour();
    math.Random rand2 = math.Random(DateTime.now().microsecondsSinceEpoch);
    for(int i=0;i<maxLoots;i++){
      double chance = rand2.nextDouble();
      if(chance >= chanceOfLoot){
        var item = Gold();
        loots.add(item);
      }
    }
  }

  void changeAttackVerts(int index)
  {
    if(index == 1){
      _weapon.changeVertices(_ind1);
      _weapon.collisionType = DCollisionType.active;
    }else if(index == 2){
      _weapon.changeVertices(_ind2,isLoop: true);
    }else if(index == 8){
      _weapon.changeVertices(_ind3,isLoop: true);
    }else if(index == 12){
      _weapon.collisionType = DCollisionType.inactive;
      _weapon.changeVertices(_ind1,isLoop: true);
    }
  }

  void selectBehaviour()
  {
    if(gameRef.gameMap.orthoPlayer == null){
      return;
    }
    int random = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(random != 0 || _wasHit){
      int shift = 0;
      if(position.x < gameRef.gameMap.orthoPlayer!.position.x){
        shift = -65;
      }else{
        shift = 65;
      }
      double posX = gameRef.gameMap.orthoPlayer!.position.x - position.x + shift;
      double posY = gameRef.gameMap.orthoPlayer!.position.y - position.y;
      if(_whereObstacle == ObstacleWhere.side){
        posX = 0;
      }
      if(_whereObstacle == ObstacleWhere.upDown){
        posY = 0;
      }
      _whereObstacle = ObstacleWhere.none;
      double angle = math.atan2(posY,posX);
      _speed.x = math.cos(angle) * _maxSpeed;
      _speed.y = math.sin(angle) * _maxSpeed;
      if(_speed.x < 0 && !isFlippedHorizontally){
        flipHorizontally();
      }else if(_speed.x > 0 && isFlippedHorizontally){
        flipHorizontally();
      }
      animation = _animMove;
    }else{
      if(animation != _animIdle){
        _speed.x = 0;
        _speed.y = 0;
        animation = _animIdle;
      }
    }
  }

  void onStartHit()
  {
    _speed.x = 0;
    _speed.y = 0;
    animation = null;
    animation = _animAttack;
    animationTicker?.onFrame = changeAttackVerts;
    animationTicker?.onComplete = onEndHit;
    _wasHit = true;
  }

  void onEndHit()
  {
    selectBehaviour();
  }

  void checkIsNeedSelfRemove()
  {
    column = position.x ~/ gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x;
    row =    position.y ~/ gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y;
    int diffCol = (column - gameRef.gameMap.column()).abs();
    int diffRow = (row - gameRef.gameMap.row()).abs();
    if(diffCol > 2 || diffRow > 2){
      gameRef.gameMap.loadedLivesObjs.remove(_startPos);
      removeFromParent();
    }
    if(diffCol > 1 || diffRow > 1){
      animation = _animIdle;
      _isRefresh = false;
    }else{
      _isRefresh = true;
    }
  }

  bool isNearPlayer()
  {
    var pl = gameRef.gameMap.orthoPlayer!;
    if(pl.hitBox == null){
      return false;
    }
    if(pl.hitBox!.getMinVector().y > _weapon.getMaxVector().y || pl.hitBox!.getMaxVector().y < _weapon.getMinVector().y){
      return false;
    }
    if(position.distanceToSquared(pl.position) > 75 * 75){
      return false;
    }
    return true;
  }

  void obstacleBehaviour(Set<Vector2> intersectionPoints, DCollisionEntity other)
  {
    Map<Vector2,AxesDiff> diffs = {};
    bool isUp = false;
    bool isDown = false;
    bool isLeft = false;
    bool isRight = false;
    double maxLeft = 0;
    double maxRight = 0;
    double maxUp = 0;
    double maxDown = 0;

    for(final point in intersectionPoints){
      double leftDiffX  = point.x - _groundBox.getMinVector().x;
      double rightDiffX = point.x - _groundBox.getMaxVector().x;
      double upDiffY = point.y - _groundBox.getMinVector().y;
      double downDiffY = point.y - _groundBox.getMaxVector().y;

      // print('diffs: $leftDiffX $rightDiffX $upDiffY $downDiffY');

      diffs.putIfAbsent(point, () => AxesDiff(leftDiffX,rightDiffX,upDiffY,downDiffY));
      double minDiff = math.min(leftDiffX.abs(),rightDiffX.abs());
      minDiff = math.min(minDiff,upDiffY.abs());
      minDiff = math.min(minDiff,downDiffY.abs());
      if(minDiff == leftDiffX.abs()){
        isLeft = true;
        maxLeft = math.max(maxLeft,minDiff);
      }
      if(minDiff == rightDiffX.abs()){
        isRight = true;
        maxRight = math.max(maxRight,minDiff);
      }
      if(minDiff == upDiffY.abs()){
        isUp = true;
        maxUp = math.max(maxUp,minDiff);
      }
      if(minDiff == downDiffY.abs()){
        isDown = true;
        maxDown = math.max(maxDown,minDiff);
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
        maxLeft = math.min(maxLeft,diff.leftDiff.abs());
        maxRight = math.min(maxRight,diff.rightDiff.abs());
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
        maxUp = math.min(maxUp,diff.upDiff.abs());
        maxDown = math.min(maxDown,diff.downDiff.abs());
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
      _whereObstacle = ObstacleWhere.side;
      position +=  Vector2(maxLeft,0);
    }
    if(isRight){
      _whereObstacle = ObstacleWhere.side;
      position -=  Vector2(maxRight,0);
    }
    if(isUp){
      _whereObstacle = ObstacleWhere.upDown;
      position +=  Vector2(0,maxUp);
    }
    if(isDown){
      _whereObstacle = ObstacleWhere.upDown;
      position -=  Vector2(0,maxDown);
    }
  }

  @override
  void doHurt({required double hurt, bool inArmor = true, double permanentDamage = 0, double secsOfPermDamage = 0})
  {
    if(animation == _animDeath){
      return;
    }
    _weapon.collisionType = DCollisionType.inactive;
    animation = null;
    if(inArmor){
      health -= math.max(hurt - armor, 0);
    }else{
      health -= hurt;
    }
    if(health <1){
      _speed.x = 0;
      _speed.y = 0;
      if(loots.isNotEmpty) {
        print(loots.length);
        if(loots.length > 1){
          var temp = Chest(0, myItems: loots, position: positionOfAnchor(Anchor.center));
          gameRef.gameMap.enemyComponent.add(temp);
        }else{
          var temp = LootOnMap(loots.first, position: positionOfAnchor(Anchor.center));
          gameRef.gameMap.enemyComponent.add(temp);
        }
      }
      animation = _animDeath;
      _hitbox.removeFromParent();
      _groundBox.collisionType = DCollisionType.inactive;
      _ground.collisionType = DCollisionType.inactive;
      // removeAll(children);
      animationTicker?.onComplete = () {
        add(OpacityEffect.by(-0.95,EffectController(duration: animationTicker?.totalDuration()),onComplete: (){
          gameRef.gameMap.loadedLivesObjs.remove(_startPos);
          removeFromParent();
        }));
      };
    }else{
      animation = _animHurt;
      animationTicker!.onComplete = selectBehaviour;
    }
  }

  @override
  void update(double dt)
  {
    if(!_isRefresh){
      return;
    }
    super.update(dt);
    if(_groundBox.getMaxVector().y > gameRef.gameMap.orthoPlayer!.groundBox!.getMaxVector().y){
      parent = gameRef.gameMap.enemyOnPlayer;
    }else{
      parent = gameRef.gameMap.enemyComponent;
    }
    _rigidSec -= dt;
    if(animation == _animHurt || animation == _animAttack || animation == _animDeath || animation == null){
      return;
    }
    if(_rigidSec <= 0) {
      _rigidSec = 1;
      if (isNearPlayer()) {
        _weapon.currentCoolDown = _weapon.coolDown ?? 0;
        var pl = gameRef.gameMap.orthoPlayer!;
        if (pl.position.x > position.x) {
          if (isFlippedHorizontally) {
            flipHorizontally();
          }
        }
        if (pl.position.x < position.x) {
          if (!isFlippedHorizontally) {
            flipHorizontally();
          }
        }
        _weapon.hit();
      }else{
        selectBehaviour();
      }
    }
    position += _speed * dt;
  }
}