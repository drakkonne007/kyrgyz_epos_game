import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';

class VerticaBigRollingWood extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  VerticaBigRollingWood(this._startPos, this._endPos);
  final Vector2 _startPos;
  final Vector2 _endPos;
  final Vector2 _speed = Vector2.all(0);
  final double _maxSpeed = 85;
  bool isDeleted = false;

  @override
  void onLoad() async
  {
    anchor = const Anchor(47/96, 68/160);
    position = _startPos;
    int rand = Random().nextInt(2);
    String name = '';
    if(rand == 0){
      name = 'wood-color scheme 2/vertical-rolling wood trunk with metal skewers-style2-bumpy.png';
    }else{
      name = 'wood-color scheme 1/vertical-rolling wood trunk with metal skewers-style1-bumpy.png';
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

    DefaultEnemyWeapon weapon = DefaultEnemyWeapon([Vector2(47,14)-positionOfAnchor(anchor)
      ,Vector2(32,35)-positionOfAnchor(anchor)
      ,Vector2(32,96)-positionOfAnchor(anchor)
      ,Vector2(48,123)-positionOfAnchor(anchor)
      ,Vector2(63,96)-positionOfAnchor(anchor)
      ,Vector2(63,37)-positionOfAnchor(anchor)],collisionType: DCollisionType.active,isSolid: true,isStatic: false, isLoop: false
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



