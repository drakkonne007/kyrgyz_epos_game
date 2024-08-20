import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/tile_map_component.dart';
import 'dart:math' as math;
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/weapon/weapon.dart';

enum ArrowDirection
{
  up,
  down,
  left,
  right
}

class ArrowSpawn extends Component with HasGameRef<KyrgyzGame>
{
  ArrowSpawn(this._startPos, this._direct, this._id);
  final int _id;
  final Vector2 _startPos;
  final String _direct;
  late LoadedColumnRow _loadedColumnRow;
  ArrowDirection _arrowDir = ArrowDirection.up;

  @override onLoad() async
  {
    switch(_direct){
      case 'up': _arrowDir = ArrowDirection.up; break;
      case 'down': _arrowDir = ArrowDirection.down; break;
      case 'left': _arrowDir = ArrowDirection.left; break;
      case 'right': _arrowDir = ArrowDirection.right; break;
    }
    _loadedColumnRow = LoadedColumnRow(_startPos.x ~/ GameConsts.lengthOfTileSquare.x,_startPos.y ~/ GameConsts.lengthOfTileSquare.y);
    add(TimerComponent(period: 1.2,onTick: spawnArrow,repeat: true));
    gameRef.gameMap.checkRemoveItself.addListener(checkInRemoveItself);
  }

  void spawnArrow()
  {
    gameRef.gameMap.container.add(Arrow(_startPos,direction: _arrowDir));
  }

  void checkInRemoveItself()
  {
    int diffCol = (_loadedColumnRow.column - gameRef.gameMap.column()).abs();
    int diffRow = (_loadedColumnRow.row - gameRef.gameMap.row()).abs();
    if(diffCol > 2 || diffRow > 2){
      gameRef.gameMap.loadedLivesObjs.remove(_id);
      gameRef.gameMap.checkRemoveItself.removeListener(checkInRemoveItself);
      removeFromParent();
    }
  }

}

final List<Vector2> _groundP = [
  Vector2(-1.0222,-21.9047) * PhysicVals.physicScale
  ,Vector2(-3.05331,-11.5183) * PhysicVals.physicScale
  ,Vector2(2.97964,-11.4713) * PhysicVals.physicScale
  ,Vector2(1.31221,-21.7142) * PhysicVals.physicScale
  ,];

class Arrow extends SpriteComponent with HasGameRef<KyrgyzGame>
{
  ArrowDirection? direction;
  final Vector2 _startPos;
  Arrow(this._startPos, {this.direction});
  late Ground _grBox;
  late EnemyWeapon _weapon;
  final Vector2 _speed = Vector2(0,0);

  @override
  onLoad() async
  {
    anchor = Anchor.center;
    sprite = Sprite(await Flame.images.load('tiles/arrow.png'));
    position = _startPos;
    switch(direction){
      case ArrowDirection.left:
        position.x -= size.x/2;
        angle = -math.pi/2;
        // _grBox = GroundHitBox(getPointsForActivs(Vector2.zero() - Vector2(size.y,size.x)/2, Vector2(size.y,size.x)), collisionType: DCollisionType.active, isQuadOptimizaion: false,isLoop: true, obstacleBehavoiurStart: obstacleBehavoiurStart, game: game);
        _weapon = DefaultEnemyWeapon(getPointsForActivs(Vector2.zero() - Vector2(size.y,size.x)/2, Vector2(size.y,size.x)), collisionType: DCollisionType.active, isStatic: false,isLoop: true, game: game,onObstacle: startCollisionPlayer);
        _speed.x = -PhysicVals.maxSpeed;
        break;
      case ArrowDirection.right:
        position.x += size.x/2;
        angle = math.pi/2;
        // _grBox = GroundHitBox(getPointsForActivs(Vector2.zero() - Vector2(size.y,size.x)/2, Vector2(size.y,size.x)), collisionType: DCollisionType.active, isQuadOptimizaion: false,isLoop: true, obstacleBehavoiurStart: obstacleBehavoiurStart, game: game);
        _weapon = DefaultEnemyWeapon(getPointsForActivs(Vector2.zero() - Vector2(size.y,size.x)/2, Vector2(size.y,size.x)), collisionType: DCollisionType.active, isStatic: false,isLoop: true, game: game,onObstacle: startCollisionPlayer);
        _speed.x = PhysicVals.maxSpeed;
        break;
      case ArrowDirection.down:
        position.y += size.y/2;
        flipVertically();
        // _grBox = GroundHitBox(getPointsForActivs(Vector2.zero() - size/2, size), collisionType: DCollisionType.active, isQuadOptimizaion: false,isLoop: true, obstacleBehavoiurStart: obstacleBehavoiurStart, game: game);
        _weapon = DefaultEnemyWeapon(getPointsForActivs(Vector2.zero() - size/2, size), collisionType: DCollisionType.active, isStatic: false,isLoop: true, game: game,onObstacle: startCollisionPlayer);
        _speed.y = PhysicVals.maxSpeed;
        break;
      default:
        position.y -= size.y/2;
        // _grBox = GroundHitBox(getPointsForActivs(Vector2.zero() - size/2, size), collisionType: DCollisionType.active, isQuadOptimizaion: false,isLoop: true, obstacleBehavoiurStart: obstacleBehavoiurStart, game: game);
        _weapon = DefaultEnemyWeapon(getPointsForActivs(Vector2.zero() - size/2, size), collisionType: DCollisionType.active, isStatic: false,isLoop: true, game: game,onObstacle: startCollisionPlayer);
        _speed.y = -PhysicVals.maxSpeed;
        break;
    }
    BodyDef bd = BodyDef(type: BodyType.dynamic, position: _startPos * PhysicVals.physicScale, fixedRotation: true, userData: BodyUserData(isQuadOptimizaion: false,
    onBeginMyContact: (Object other, Contact contact){
      startFadeout();
    }));
    List<Vector2> newPoints = [];
    for(final vec in _groundP){
      newPoints.add(Vector2(vec.x * cos(angle) - vec.y * sin(angle), vec.x * sin(angle) + vec.y * cos(angle)));
    }
    FixtureDef fx = FixtureDef(PolygonShape()..set(newPoints), isSensor: true);
    _grBox = Ground(bd, gameRef.world.physicsWorld);
    _grBox.createFixture(fx);
    _grBox.applyLinearImpulse(_speed / 4);
    add(_weapon);
    _weapon.damage = 5;
  }

  void obstacleBehavoiurStart(Set<Vector2> intersectionPoints, DCollisionEntity other)
  {
    startFadeout();
  }

  void startCollisionPlayer()
  {
    startFadeout();
  }

  void startFadeout()
  {
    _weapon.collisionType = DCollisionType.inactive;
    _grBox.linearVelocity = Vector2.zero();
    add(OpacityEffect.by(-1,EffectController(duration: 0.5),onComplete: (){
      _grBox.destroy();
      removeFromParent();
    }));
  }

  @override
  update(double dt)
  {
    position = _grBox.position / PhysicVals.physicScale;
  }
}