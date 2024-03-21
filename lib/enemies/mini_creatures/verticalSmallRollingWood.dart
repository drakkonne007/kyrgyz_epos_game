import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/weapon/weapon.dart';

class VerticalSmallRollingWood extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  VerticalSmallRollingWood(this._startPos, this._endPos);
  final Vector2 _startPos;
  final double _endPos;
  final Vector2 _speed = Vector2.all(0);
  final double _maxSpeed = 160;
  bool _isDeleted = false;
  bool _isStarted = false;
  late SpriteAnimationComponent _player;
  late EnemyWeapon _defWeapon;
  SpriteAnimation? _moveAnim, _stopAnim;

  @override
  void onLoad() async
  {
    anchor = const Anchor(46/96, 68/160);
    position = _startPos;
    int rand = Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
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
    _moveAnim = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0);
    _stopAnim = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, to: 1);
    animation = _stopAnim;
    if(_endPos < _startPos.x){
      _speed.x = -_maxSpeed;
    }else{
      _speed.x = _maxSpeed;
      flipHorizontally();
    }

    _defWeapon = DefaultEnemyWeapon(getPointsForActivs(Vector2(-31/2,-87/2), Vector2(31,87)),collisionType: DCollisionType.active,isSolid: false,isStatic: false, isLoop: true
        , game: gameRef,onStartWeaponHit: null, onEndWeaponHit: null);
    _defWeapon.coolDown = 0.5;
    _defWeapon.damage = 5;
    add(_defWeapon);
    _player = gameRef.gameMap.orthoPlayer?? gameRef.gameMap.frontPlayer!;
  }

  void perfectRemove()
  {
    _defWeapon.collisionType = DCollisionType.inactive;
    animation?.loop = false;
    add(OpacityEffect.by(-0.95,EffectController(duration: 0.7),onComplete: (){
      gameRef.gameMap.loadedLivesObjs.remove(_startPos);
      removeFromParent();
    }));
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    if(!_isStarted){
      if(_player.absolutePositionOfAnchor(_player.anchor).y < absoluteTopLeftPosition.y + height
          && _player.absolutePositionOfAnchor(_player.anchor).y > absoluteTopLeftPosition.y){
        _isStarted = true;
        animation = _moveAnim;
      }
    }
    if(!_isStarted){
      return;
    }
    position = position + _speed * dt;
    if((_speed.x < 0 && position.x < _endPos || _speed.x > 0 && position.x > _endPos) && !_isDeleted){
      animation = _stopAnim;
      perfectRemove();
      _isDeleted = true;
      _speed.x = 0;
    }
  }
}



