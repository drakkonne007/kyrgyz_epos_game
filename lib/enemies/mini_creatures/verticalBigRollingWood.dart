import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/dVector2.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/weapon/weapon.dart';

class VerticaBigRollingWood extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  VerticaBigRollingWood(this._startPos, this._endPos);
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
    anchor = const Anchor(47/96, 68/160);
    position = _startPos;
    int rand = Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    String name = '';
    if(rand == 0){
      name = 'wood-color scheme 2/vertical-rolling wood trunk with metal skewers-style1-bumpy.png';
    }else{
      name = 'wood-color scheme 1/vertical-rolling wood trunk with metal skewers-style1-bumpy.png';
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

    _defWeapon = DefaultEnemyWeapon([dVector2(47-47,14-68)
      ,dVector2(32-47,35-68)
      ,dVector2(32-47,96-68)
      ,dVector2(48-47,123-68)
      ,dVector2(63-47,96-68)
      ,dVector2(63-47,37-68)],collisionType: DCollisionType.active,isSolid: false,isStatic: false, isLoop: true
        , game: gameRef,onStartWeaponHit: () {}, onEndWeaponHit: () {});
    _defWeapon.coolDown = 0.5;
    _defWeapon.damage = 5;
    add(_defWeapon);

    _player = gameRef.gameMap.orthoPlayer?? gameRef.gameMap.frontPlayer!;
  }

  void perfectRemove()
  {
    _defWeapon.collisionType = DCollisionType.inactive;
    animation?.loop = false;
    add(OpacityEffect.by(-1,EffectController(duration: 0.7),onComplete: (){
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
          && _player.absolutePositionOfAnchor(_player.anchor).y > absoluteTopLeftPosition.y && ((_endPos < _startPos.x && _player.absolutePositionOfAnchor(_player.anchor).x < _startPos.x)
          || (_endPos > _startPos.x && _player.absolutePositionOfAnchor(_player.anchor).x > _startPos.x))){
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



