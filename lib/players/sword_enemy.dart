
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_flame/components/ground_component.dart';
import 'package:game_flame/players/ortho_player.dart';
import 'package:game_flame/components/physic_vals.dart';

class SwordEnemy extends SpriteAnimationComponent with CollisionCallbacks
{
  SwordEnemy(this._startPos);

  late SpriteAnimation _leftMove, _idleAnimation;
  final Vector2 _spriteSheetSize = Vector2(193.6, 232);
  Vector2 _startPos;
  Vector2 _speed = Vector2(0,20);

  @override
  Future<void> onLoad() async{
    debugMode = true;
    final spriteImage = await Flame.images.load(
        'tiles/sprites/players/arrowman.png');
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _spriteSheetSize);
    _leftMove =
        spriteSheet.createAnimation(row: 0, stepTime: 0.3, from: 0, to: 5);
    _idleAnimation = spriteSheet.createAnimation(row: 0, stepTime: 0.3, from: 2, to: 3);
    animation = _idleAnimation;
    size = _spriteSheetSize * GameConsts.gameScale / 7;
    topLeftPosition = _startPos;
    //_groundBox.anchor = Anchor.center;
    add(RectangleHitbox(size: this.size));
  }


  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is Ground){
      _speed *= -1;
    }else if(other is OrthoPlayer){
      other.doHurt(hurt: 1);
      _speed *= -1;
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void update(double dt){
    position += _speed * dt;
    super.update(dt);
  }
}