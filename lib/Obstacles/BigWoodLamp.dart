import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

final List<Vector2> _lamp1 = [
  Vector2(-19.4327,20.03242) * PhysicVals.physicScale
  ,Vector2(-19.9676,43.646) * PhysicVals.physicScale
  ,Vector2(23.1809,43.2894) * PhysicVals.physicScale
  ,Vector2(23.7158,20.81541) * PhysicVals.physicScale
  ,];

final List<Vector2> _lamp2 = [
  Vector2(-19.0538,20.8089) * PhysicVals.physicScale
  ,Vector2(-19.0538,43.3966) * PhysicVals.physicScale
  ,Vector2(22.2969,43.2034) * PhysicVals.physicScale
  ,Vector2(22.2969,20.19535) * PhysicVals.physicScale
  ,];

final List<Vector2> _lamp3 = [
  Vector2(-27.2182,18.13657) * PhysicVals.physicScale
  ,Vector2(25.0726,18.67382) * PhysicVals.physicScale
  ,Vector2(27.6948,38.5344) * PhysicVals.physicScale
  ,Vector2(-26.6012,38.8429) * PhysicVals.physicScale
  ,];

final List<Vector2> _lamp4 = [
Vector2(-20.852,20.26255) * PhysicVals.physicScale
,Vector2(22.1616,20.12012) * PhysicVals.physicScale
,Vector2(17.319,37.4575) * PhysicVals.physicScale
,Vector2(-19.855,37.6) * PhysicVals.physicScale
,];

final List<Vector2> _lamp5 = [
Vector2(-29.3955,20.6836) * PhysicVals.physicScale
,Vector2(13.1796,20.4232) * PhysicVals.physicScale
,Vector2(16.5648,35.3274) * PhysicVals.physicScale
,Vector2(-29.0049,35.3274) * PhysicVals.physicScale
,];

class BigWoodLamp extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  BigWoodLamp(this._startPos,this._version);
  final int _version;
  late Ground _ground;
  final Vector2 _startPos;


  @override
  void onRemove()
  {
    _ground.destroy();
  }

  @override
  Future onLoad() async
  {
    anchor = Anchor.center;
    position = _startPos;
    final img = await Flame.images.load('tiles/map/grassLand2/Props/Animated props/animated lamp posts-$_version.png');
    final sheet = SpriteSheet(image: img,
        srcSize: Vector2(64,96));
    animation = sheet.createAnimation(row: 0, stepTime: 0.12, from: 0, loop: true);
    final List<Vector2> curVec;
    int plusPrior;
    switch(_version){
      case 1: curVec = _lamp1;  plusPrior = 39;break;
      case 2: curVec = _lamp2;  plusPrior = 43;break;
      case 3: curVec = _lamp3;  plusPrior = 38;break;
      case 4: curVec = _lamp4;  plusPrior = 37;break;
      case 5: curVec = _lamp5;  plusPrior = 35;break;
      default: curVec = _lamp1; plusPrior = 39; break;
    }
    priority = position.y.toInt() + plusPrior;
    FixtureDef fix = FixtureDef(PolygonShape()..set(curVec));
    _ground = Ground(
        BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );
    _ground.createFixture(fix);
  }
}

