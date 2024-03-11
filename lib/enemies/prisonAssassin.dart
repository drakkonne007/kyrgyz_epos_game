import 'dart:ui';
import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';

final List<Vector2> _hitBoxPoints = [ //вторая колонка
  Vector2(110 - 110,35 - 48),
  Vector2(100 - 110,46 - 48),
  Vector2(102 - 110,74 - 48),
  Vector2(118 - 110,74 - 48),
  Vector2(123 - 110,48 - 48),
  Vector2(117 - 110,44 - 48),
  Vector2(117 - 110,36 - 48),
];

final List<Vector2> _groundBoxPoints = [ //вторая колонка
  Vector2(103 - 110,65 - 48),
  Vector2(117 - 110,65 - 48),
  Vector2(117 - 110,75 - 48),
  Vector2(103 - 110,75 - 48),
];

class PrisonAssassin extends SpriteAnimationComponent with HasGameRef<KyrgyzGame> implements KyrgyzEnemy
{
  PrisonAssassin(this._startPos);
  late SpriteAnimation _animMove, _animIdle, _animAttack, _animHurt, _animDeath;
  late EnemyHitbox _hitbox;
  late GroundHitBox _groundBox;
  late Ground _ground;
  final Vector2 _spriteSheetSize = Vector2(220,96);
  final Vector2 _startPos;
  final Vector2 _speed = Vector2(0,0);
  final double _maxSpeed = 50;
  double _rigidSec = math.Random().nextDouble() + 1;
  late DefaultEnemyWeapon _weapon;
  ObstacleWhere _whereObstacle = ObstacleWhere.none;
  bool _wasHit = false;

  @override
  double armor = 2;
  @override
  double chanceOfLoot = 0.02;
  @override
  int column = 0;
  @override
  double health = 0;
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
      if(chance <= chanceOfLoot){
        var item = Gold();
        loots.add(item);
      }
    }
  }

  @override
  void doHurt({required double hurt, bool inArmor = true})
  {
    if(animation == _animDeath){
      return;
    }
    animation = null;
    _weapon?.collisionType = DCollisionType.inactive;
    if(inArmor){
      health -= math.max(hurt - armor, 0);
    }else{
      health -= hurt;
    }
    if(health <1){
      death();
    }else{
      animation = _animHurt;
      animationTicker?.onComplete = selectBehaviour;
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
    _hitBox.removeFromParent();
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