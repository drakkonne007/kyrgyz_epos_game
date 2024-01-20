import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';

class VerticalSmallRollingWood extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  VerticalSmallRollingWood(this._startPos, this._endPos);
  final Vector2 _startPos;
  final Vector2 _endPos;
  final Vector2 _speed = Vector2.all(0);
  final double _maxSpeed = 85;
  bool isDeleted = false;

  @override
  void onLoad() async
  {
    anchor = const Anchor(46/96, 68/160);
    position = _startPos;
    int rand = Random().nextInt(2);
    String name = '';
    if(rand == 0){
      name = 'wood-color scheme 2/vertical-rolling wood trunk with metal skewers-style2-bumpy.png';
    }else{
      name = 'wood-color scheme 1/vertical-rolling wood trunk with metal skewers-style2-bumpy.png';
    }
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load(
          'tiles/map/prisonSet/Props/trap - rolling trunk/$name'),
      srcSize: Vector2(96, 160),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0);
    if(_endPos.x < _startPos.x){
      _speed.x = -_maxSpeed;
    }else{
      _speed.x = _maxSpeed;
    }

    DefaultEnemyWeapon weapon = DefaultEnemyWeapon(getPointsForActivs(Vector2(-31/2,-87/2), Vector2(31,87)),collisionType: DCollisionType.active,isSolid: true,isStatic: false, isLoop: false
        , game: gameRef,onStartWeaponHit: () {}, onEndWeaponHit: () {});
    weapon.coolDown = 0.5;
    add(weapon);
  }

  void perfectRemove()
  {
    add(OpacityEffect.by(-0.95,EffectController(duration: 0.7),onComplete: (){
      gameRef.gameMap.loadedLivesObjs.remove(_startPos);
      removeFromParent();
    }));
  }

  @override
  void update(double dt)
  {
    position = position + _speed * dt;
    if((_speed.x < 0 && position.x < _endPos.x || _speed.x > 0 && position.x > _endPos.x) && !isDeleted){
      perfectRemove();
      isDeleted = true;
      _speed.x = 0;
    }
    super.update(dt);
  }
}



