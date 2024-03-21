import 'dart:ui';
import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';

final List<Vector2> _hitBoxPoints = [ //вторая колонка
  Vector2(110 - 110 ,35 - 48) * 1.4,
  Vector2(100 - 110 ,46 - 48) * 1.4,
  Vector2(102 - 110 ,74 - 48) * 1.4,
  Vector2(118 - 110 ,74 - 48) * 1.4,
  Vector2(123 - 110 ,48 - 48) * 1.4,
  Vector2(117 - 110 ,44 - 48) * 1.4,
  Vector2(117 - 110 ,36 - 48) * 1.4,
];

final List<Vector2> _groundBoxPoints = [ //вторая колонка
  Vector2(103 - 110,65 - 48) * 1.4,
  Vector2(117 - 110,65 - 48) * 1.4,
  Vector2(117 - 110,75 - 48) * 1.4,
  Vector2(103 - 110,75 - 48) * 1.4,
];

final List<Vector2> _weaponPoints = [ //вторая колонка
  Vector2(746 - 110 - 220 * 3,350 - 48 - 96 * 3) * 1.4,
  Vector2(755 - 110 - 220 * 3,355 - 48 - 96 * 3) * 1.4,
  Vector2(770 - 110 - 220 * 3,361 - 48 - 96 * 3) * 1.4,
  Vector2(789 - 110 - 220 * 3,362 - 48 - 96 * 3) * 1.4,
  Vector2(798 - 110 - 220 * 3,358 - 48 - 96 * 3) * 1.4,
  Vector2(804 - 110 - 220 * 3,352 - 48 - 96 * 3) * 1.4,
  Vector2(804 - 110 - 220 * 3,348 - 48 - 96 * 3) * 1.4,
  Vector2(803 - 110 - 220 * 3,346 - 48 - 96 * 3) * 1.4,
  Vector2(796 - 110 - 220 * 3,341 - 48 - 96 * 3) * 1.4,
  Vector2(787 - 110 - 220 * 3,341 - 48 - 96 * 3) * 1.4,
];

class PrisonAssassin extends SpriteAnimationComponent with HasGameRef<KyrgyzGame> implements KyrgyzEnemy
{
  PrisonAssassin(this._startPos);
  late SpriteAnimation _animMove, _animIdle,_animIdle2, _animAttack,_animAttack2, _animHurt, _animDeath;
  late EnemyHitbox _hitbox;
  late GroundHitBox _groundBox;
  late Ground _ground;
  final Vector2 _spriteSheetSize = Vector2(220,96);
  final Vector2 _startPos;
  final Vector2 _speed = Vector2(0,0);
  final double _maxSpeed = 70;
  double _rigidSec = math.Random().nextDouble();
  late DefaultEnemyWeapon _weapon;
  ObstacleWhere _whereObstacle = ObstacleWhere.none;
  bool _wasHit = false;
  bool _isRefresh = true;

  @override
  double armor = 3;
  @override
  double chanceOfLoot = 0.02;
  @override
  int column = 0;
  @override
  double health = 1;
  @override
  List<Item> loots = [];
  @override
  Map<MagicDamage, int> magicDamages = {};
  @override
  int maxLoots = 3;
  @override
  int row = 0;

  @override
  Future<void> onLoad() async
  {
    Image spriteImage = await Flame.images.load(
        'tiles/map/prisonSet/Characters/Assassin like enemy/Assassin like enemy - all animations.png');
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _spriteSheetSize);
    _animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 7);
    _animIdle2 = spriteSheet.createAnimation(row: 1, stepTime: 0.08, from: 0, to: 10);
    _animMove = spriteSheet.createAnimation(row: 2, stepTime: 0.08, from: 0, to: 6);
    _animAttack = spriteSheet.createAnimation(row: 3, stepTime: 0.08, from: 0,to: 9, loop: false);
    _animAttack2 = spriteSheet.createAnimation(row: 5, stepTime: 0.08, from: 0,to: 11, loop: false);
    _animHurt = spriteSheet.createAnimation(row: 6, stepTime: 0.05, from: 0, to: 7,loop: false);
    _animDeath = spriteSheet.createAnimation(row: 7, stepTime: 0.1, from: 0,loop: false);
    anchor = Anchor.center;
    animation = _animIdle;
    size = _spriteSheetSize * 1.4;
    position = _startPos;
    _hitbox = EnemyHitbox(_hitBoxPoints,
        collisionType: DCollisionType.passive,isSolid: false,isStatic: false, isLoop: true, game: gameRef);
    add(_hitbox);
    _groundBox = GroundHitBox(_groundBoxPoints,obstacleBehavoiurStart: obstacleBehaviour,
        collisionType: DCollisionType.active,isSolid: true,isStatic: false, isLoop: true, game: gameRef);
    add(_groundBox);
    _weapon = DefaultEnemyWeapon(
        _weaponPoints,collisionType: DCollisionType.inactive, onStartWeaponHit: onStartHit, onEndWeaponHit: onEndHit, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    add(_weapon);
    _weapon.damage = 3;
    _ground = Ground(_groundBoxPoints,collisionType: DCollisionType.passive, isSolid: false, isStatic: false, isLoop: true, game: gameRef);
    _ground.onlyForPlayer = true;
    add(_ground);
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
      if(chance <= chanceOfLoot){
        var item = Gold();
        loots.add(item);
      }
    }
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
    // if(_wasHit) {
    //   selectBehaviour();
    // }
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
        shift = -20;
      }else{
        shift = 20;
      }
      double posX = gameRef.gameMap.orthoPlayer!.position.x - position.x + shift;
      double posY = gameRef.gameMap.orthoPlayer!.position.y - position.y;
      if(_whereObstacle == ObstacleWhere.side){
        posX = 0;
      }
      if(_whereObstacle == ObstacleWhere.upDown && posY < 0){
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
      if(animation != _animIdle && animation != _animIdle2){
        _speed.x = 0;
        _speed.y = 0;
        int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
        animation = rand.isOdd ? _animIdle : _animIdle2;
      }
    }
  }

  void onStartHit()
  {
    _weapon.currentCoolDown = _weapon.coolDown;
    _speed.x = 0;
    _speed.y = 0;
    animation = null;
    math.Random().nextInt(2) == 0 ? animation = _animAttack : animation = _animAttack2;
    animationTicker?.onFrame = changeAttackVerts;
    animationTicker?.onComplete = onEndHit;
    _wasHit = true;
  }

  void changeAttackVerts(int index)
  {
    if(animation == _animAttack){
      if(index == 3){
        _weapon.collisionType = DCollisionType.active;
      }else if(index == 5){
        _weapon.collisionType = DCollisionType.inactive;
      }
    }else{
      if(index == 4){
        _weapon.collisionType = DCollisionType.active;
      }else if(index == 6){
        _weapon.collisionType = DCollisionType.inactive;
      }
    }
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
      int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
      animation = rand.isOdd ? _animIdle : _animIdle2;
      _isRefresh = false;
    }else{
      _isRefresh = true;
    }
  }

  @override
  void doHurt({required double hurt, bool inArmor = true})
  {
    if(animation == _animDeath){
      return;
    }
    animation = null;
    _weapon.collisionType = DCollisionType.inactive;
    if(inArmor){
      health -= math.max(hurt - armor, 0);
    }else{
      health -= hurt;
    }
    if(health <1){
      death();
    }else{
      animation = _animHurt;
      animationTicker!.onComplete = selectBehaviour;
    }
  }

  void death()
  {
    _speed.x = 0;
    _speed.y = 0;
    if(loots.isNotEmpty) {
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
  }

  @override
  void doMagicHurt({required double hurt, required MagicDamage magicDamage})
  {
    health -= hurt;
    if(health < 1){
      death();
    }
  }

  bool isNearPlayer()
  {
    var pl = gameRef.gameMap.orthoPlayer!;
    if(pl.hitBox == null){
      return false;
    }
    if(position.distanceToSquared(pl.position) > 60*60){
      return false;
    }
    if(pl.hitBox!.getMinVector().y > _hitbox.getMaxVector().y || pl.hitBox!.getMaxVector().y < _hitbox.getMinVector().y){
      return false;
    }
    return true;
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
    if(_rigidSec <= 0){
      _rigidSec = math.Random().nextDouble();
      if(isNearPlayer()){
        var pl = gameRef.gameMap.orthoPlayer!;
        if(pl.position.x > position.x){
          if(isFlippedHorizontally){
            flipHorizontally();
          }
        }
        if(pl.position.x < position.x){
          if(!isFlippedHorizontally){
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

  @override
  void render(Canvas canvas)
  {
    super.render(canvas);
    if(magicDamages.isNotEmpty){
      var shader = gameRef.iceShader;
      shader.setFloat(0,gameRef.gameMap.shaderTime);
      shader.setFloat(1, 0.2); //scalse
      shader.setFloat(2, 0); //offsetX
      shader.setFloat(3, 0);
      shader.setFloat(4,math.max(size.x,30)); //size
      shader.setFloat(5,math.max(size.y,30));
      final paint = Paint()..shader = shader;
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          0,
          math.max(size.x,30),
          math.max(size.y,30),
        ),
        paint,
      );
    }
  }
}