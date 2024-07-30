import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/weapon/player_weapons_list.dart';
import 'package:game_flame/weapon/weapon.dart';

final List<Vector2> _groundPoints = [
  Vector2(-0.482212,-67.3514)
  ,Vector2(-15.5238,-45.4727)
  ,Vector2(-16.2075,15.7193)
  ,Vector2(-0.482212,42.0421)
  ,Vector2(14.5594,16.0611)
  ,Vector2(14.5594,-43.7634)
  ,];

final List<Vector2> _groundPhy = [
  Vector2(-0.482212,-67.3514) * PhysicVals.physicScale
  ,Vector2(-15.5238,-45.4727) * PhysicVals.physicScale
  ,Vector2(-16.2075,15.7193) * PhysicVals.physicScale
  ,Vector2(-0.482212,42.0421) * PhysicVals.physicScale
  ,Vector2(14.5594,16.0611) * PhysicVals.physicScale
  ,Vector2(14.5594,-43.7634) * PhysicVals.physicScale
  ,];

final List<Vector2> _groundSmallPoints = [
  Vector2(-5.95744,-55.7087)
  ,Vector2(-13.8988,-48.7017)
  ,Vector2(-13.9246,21.6318)
  ,Vector2(-0.551995,30.745)
  ,Vector2(12.7216,21.83)
  ,Vector2(11.8392,-50.6509)
  ,Vector2(3.66198,-55.6587)
  ,];

final List<Vector2> _groundSmallPhy = [
  Vector2(-5.95744,-55.7087) * PhysicVals.physicScale
  ,Vector2(-13.8988,-48.7017) * PhysicVals.physicScale
  ,Vector2(-13.9246,21.6318) * PhysicVals.physicScale
  ,Vector2(-0.551995,30.745) * PhysicVals.physicScale
  ,Vector2(12.7216,21.83) * PhysicVals.physicScale
  ,Vector2(11.8392,-50.6509) * PhysicVals.physicScale
  ,Vector2(3.66198,-55.6587) * PhysicVals.physicScale
  ,];

class VerticaBigRollingWood extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  VerticaBigRollingWood(this._startPos, this._direct,this._isBigRoll,this._id);
  final int _id;
  final Vector2 _startPos;
  final bool _isBigRoll;
  final String _direct;
  final Vector2 _speed = Vector2.all(0);
  final double _maxSpeed = 160;
  bool _isDeleted = false;
  bool _isStarted = false;
  late SpriteAnimationComponent _player;
  late EnemyWeapon _defWeapon;
  SpriteAnimation? _moveAnim, _stopAnim;
  late Ground _ground;

  @override
  void onLoad() async
  {
    anchor = Anchor.center;
    FixtureDef fix = FixtureDef(PolygonShape()..set(_isBigRoll ? _groundPhy : _groundSmallPhy),isSensor: true);
    _ground = Ground(
      BodyDef(type: BodyType.dynamic, position: _startPos * PhysicVals.physicScale, fixedRotation: true,
          userData: BodyUserData(isQuadOptimizaion: false,onBeginMyContact: (Object other, Contact contact){
            if(contact.fixtureA.body.bodyType != BodyType.static && contact.fixtureB.body.bodyType != BodyType.static){
              return;
            }
            if(contact.fixtureA.isSensor && contact.fixtureB.isSensor){
              return;
            }
            animation = _stopAnim;
            perfectRemove();
            _isDeleted = true;
          })),
      gameRef.world.physicsWorld,
    );
    _ground.createFixture(fix);
    position = _ground.position / PhysicVals.physicScale;
    switch(_direct){
      case 'left': _speed.x = -_maxSpeed; break;
      case 'right': _speed.x = _maxSpeed; flipHorizontally(); break;
    }
    int rand = Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    String name = '';
    if(_isBigRoll) {
      if (rand == 0) {
        name =
        'wood-color scheme 2/vertical-rolling wood trunk with metal skewers-style1-bumpy.png';
      } else {
        name =
        'wood-color scheme 1/vertical-rolling wood trunk with metal skewers-style1-bumpy.png';
      }
    }else{
      if (rand == 0) {
        name =
        'wood-color scheme 2/vertical-rolling wood trunk with metal skewers-style2-bumpy.png';
      } else {
        name =
        'wood-color scheme 1/vertical-rolling wood trunk with metal skewers-style2-bumpy.png';
      }
    }
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load(
          'tiles/map/prisonSet/Props/trap - rolling trunk/$name'),
      srcSize: Vector2(96, 160),
    );
    _moveAnim = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0);
    _stopAnim = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, to: 1);
    animation = _stopAnim;
    _defWeapon = DefaultEnemyWeapon(_isBigRoll ? _groundPoints : _groundSmallPoints,collisionType: DCollisionType.active,isSolid: false,isStatic: false, isLoop: true
        , game: gameRef,onStartWeaponHit: () {}, onEndWeaponHit: () {});
    _defWeapon.coolDown = 0.5;
    _defWeapon.damage = 5;
    add(_defWeapon);

    var temp = DefaultPlayerWeapon(_isBigRoll ? _groundPoints : _groundSmallPoints,collisionType: DCollisionType.active,isSolid: false,isStatic: false, isLoop: true
        , game: gameRef,onStartWeaponHit: () {}, onEndWeaponHit: () {});
    temp.coolDown = 0.5;
    temp.damage = 2;
    add(temp);
    _player = gameRef.gameMap.orthoPlayer?? gameRef.gameMap.frontPlayer!;
  }

  void perfectRemove()
  {
    _defWeapon.collisionType = DCollisionType.inactive;
    animation?.loop = false;
    add(OpacityEffect.by(-1,EffectController(duration: 0.7),onComplete: (){
      gameRef.gameMap.loadedLivesObjs.remove(_id);
      removeFromParent();
      _ground.destroy();
    }));
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    if(_isDeleted){
      return;
    }
    position = _ground.position / PhysicVals.physicScale;
    if(!_isStarted){
      if(_player.absolutePositionOfAnchor(_player.anchor).y < absoluteTopLeftPosition.y + height
          && _player.absolutePositionOfAnchor(_player.anchor).y > absoluteTopLeftPosition.y && ((_direct == 'left' && _player.absolutePositionOfAnchor(_player.anchor).x < _startPos.x)
          || (_direct == 'right' && _player.absolutePositionOfAnchor(_player.anchor).x > _startPos.x))){
        _isStarted = true;
        animation = _moveAnim;
        _ground.applyLinearImpulse(Vector2(_speed.x * 3, 0));
      }
    }
  }
}



