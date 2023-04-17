
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/player.dart';
import 'package:game_flame/abstracts/weapon.dart';
import 'package:game_flame/components/physic_vals.dart';

class SwordEnemy extends SpriteAnimationComponent with CollisionCallbacks implements KyrgyzEnemy, Weapon
{
  SwordEnemy(this._startPos);

  late SpriteAnimation _leftMove, _idleAnimation;
  final Vector2 _spriteSheetSize = Vector2(193.6, 232);
  Vector2 _startPos;
  Vector2 _speed = Vector2(0,20);

  @override
  double health = 3;

  @override
  Future<void> onLoad() async{
    // debugMode = true;
    final spriteImage = await Flame.images.load(
        'tiles/sprites/players/arrowman.png');
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _spriteSheetSize);
    _leftMove =
        spriteSheet.createAnimation(row: 0, stepTime: 0.3, from: 0, to: 5);
    _idleAnimation = spriteSheet.createAnimation(row: 0, stepTime: 0.3, from: 2, to: 3);
    animation = _idleAnimation;
    size = _spriteSheetSize * GameConsts.gameScale / 3.5;
    topLeftPosition = _startPos;
    //_groundBox.anchor = Anchor.center;
    add(RectangleHitbox(size: this.size));
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is MapObstacle || other is MainPlayer){
      _speed *= -1;
    }else if(other is PlayerWeapon){

    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void update(double dt){
    position += _speed * dt;
    super.update(dt);
  }

  @override
  double damage = 1;

  @override
  bool inArmor = true;

  @override
  double permanentDamage = 0;

  @override
  double secsOfPermDamage = 0;

  @override
  void doHurt({required double hurt, bool inArmor = true, double permanentDamage = 0, double secsOfPermDamage = 0}) {
    if(inArmor){
      if(armor < hurt){
        health -= (hurt - armor);
        armor = 0;
      }
    }else{
      health -= hurt - armor;
    }
    if(health <1){
      removeFromParent();
    }
  }

  @override
  double armor = 0;
}