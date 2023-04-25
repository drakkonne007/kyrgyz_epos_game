
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/player.dart';
import 'package:game_flame/components/physic_vals.dart';

class SwordEnemy extends SpriteAnimationComponent with CollisionCallbacks implements KyrgyzEnemy
{
  SwordEnemy(this._startPos);

  late SpriteAnimation _leftMove, _idleAnimation;
  late EnemyHitbox _hitbox;
  late GroundHitBox _groundBox;
  final Vector2 _spriteSheetSize = Vector2(193.6, 232);
  Vector2 _startPos;
  Vector2 _speed = Vector2(0,20);

  @override
  double armor = 0;
  @override
  List<int> loots = [LootItems.pureHat.index];
  @override
  double health = 3;
  @override
  Future<void> onLoad() async
  {
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
    _hitbox = EnemyHitbox();
    await add(_hitbox);
    _hitbox.debugMode = true;
    _hitbox.debugColor = BasicPalette.black.color;
    _groundBox = GroundHitBox(obstacleBehavoiur: obstacleBehaviour);
    await add(_groundBox);
    EWBody _body = EWBody();
    _body.size = size;
    _body.collisionType = CollisionType.active;
    add(_body);
  }

  void obstacleBehaviour(Set<Vector2> intersectionPoints, PositionComponent other)
  {
    _speed *= -1;
  }

  @override
  void update(double dt)
  {
    position += _speed * dt;
    super.update(dt);
  }

  @override
  void doHurt({required double hurt, bool inArmor = true, double permanentDamage = 0, double secsOfPermDamage = 0})
  {
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
      for()
    }
  }
}