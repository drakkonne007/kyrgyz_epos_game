import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'dart:math' as math;
import 'package:game_flame/kyrgyz_game.dart';

class SwordEnemy extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef<KyrgyzGame> implements KyrgyzEnemy
{
  SwordEnemy(this._startPos);

  late SpriteAnimation _leftMove, _idleAnimation;
  late EnemyHitbox _hitbox;
  late GroundHitBox _groundBox;
  final Vector2 _spriteSheetSize = Vector2(193.6, 232);
  Vector2 _startPos;
  Vector2 _speed = Vector2(0,20);

  @override
  int maxLoots = 2;
  @override
  double chanceOfLoot = 0.8;
  @override
  double armor = 0;
  @override
  List<Item> loots = [];
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
    EWBody body = EWBody();
    body.size = size;
    body.collisionType = CollisionType.active;
    await add(body);
    priority = GamePriority.player - 1;
    math.Random rand = math.Random();
    for(int i=0;i<maxLoots;i++){
      double chance = rand.nextDouble();
      if(chance >= chanceOfLoot){
        var item = itemFromId(2);
        loots.add(item);
      }
    }
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
      health -= math.max(hurt - armor, 0);
    }else{
      health -= hurt;
    }
    if(health <1){
      if(loots.isNotEmpty) {
        if(loots.length > 1){
          gameRef.gameMap?.add(Chest(myItems: loots, position: positionOfAnchor(Anchor.center)));
        }else{
          gameRef.gameMap?.add(LootOnMap(loots.first, position: positionOfAnchor(Anchor.center)));
        }
      }
      removeAll(children);
      add(OpacityEffect.by(-0.95,EffectController(duration: 0.2),onComplete: (){
        removeFromParent();
      }));
    }
  }
}