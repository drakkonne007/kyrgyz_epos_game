import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/DBHandler.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

import '../ForgeOverrides/DPhysicWorld.dart';

final List<Vector2> _groundP = [
  Vector2(-17.8956,11.1651) * PhysicVals.physicScale
  ,Vector2(-21.1141,15.4248) * PhysicVals.physicScale
  ,Vector2(-21.2087,24.7962) * PhysicVals.physicScale
  ,Vector2(22.335,25.0802) * PhysicVals.physicScale
  ,Vector2(22.4297,14.3835) * PhysicVals.physicScale
  ,Vector2(19.1166,10.6918) * PhysicVals.physicScale
  ,];

final List<Vector2> _groundObj = [
  Vector2(-31.1965,-7.29131)
  ,Vector2(-30.9956,31.6801)
  ,Vector2(31.0775,31.2783)
  ,Vector2(30.8766,-7.69308)
  ,];

class GearSwitch extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  GearSwitch(this._startPosition,this._targetId,this.isClosed);
  final int _targetId;
  final Vector2 _startPosition;
  ObjectHitbox? _objectHitbox;
  late SpriteAnimation closed, opened, toOpen;
  bool isClosed;
  late Ground _ground;

  @override
  void onRemove()
  {
    _ground.destroy();
  }

  @override
  Future onLoad() async
  {
    Image spriteImg = await Flame.images.load('tiles/map/prisonSet/Props/gear switch - animation.png');
    var spriteSheet = SpriteSheet(image: spriteImg,
        srcSize: Vector2(spriteImg.width / 12, spriteImg.height.toDouble()));
    toOpen = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    closed = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 1, loop: false);
    opened = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 11, loop: false);
    anchor = Anchor.center;
    position = _startPosition;
    DBAnswer ans = await gameRef.dbHandler.stateFromDb(_targetId);
    isClosed = !ans.opened;
    animation = isClosed ? closed : opened;
    _objectHitbox = ObjectHitbox(_groundObj,
        collisionType: DCollisionType.active, isSolid: true, isStatic: false, isLoop: true,
        autoTrigger: false, obstacleBehavoiur: changeState, game: gameRef);
    // var asd = ObjectHitbox(obstacleBehavoiur: checkIsIOpen);
    add(_objectHitbox!);
    priority = position.y.toInt() + 25;
    FixtureDef fix = FixtureDef(PolygonShape()..set(_groundP));
    _ground = Ground(
        BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );
    _ground.createFixture(fix);
  }


  void changeState() {
    if (isClosed) {
      animation = toOpen;
      gameRef.dbHandler.changeState(id: _targetId, openedAsInt: '1');
    } else {
      animation = toOpen.reversed();
      gameRef.dbHandler.changeState(id: _targetId, openedAsInt: '0');
    }
    isClosed = !isClosed;
  }
}