// verticalSteelGate

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/DBHandler.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

final List<Vector2> _closedP = [
  Vector2(-47.7286,-58.7286) * PhysicVals.physicScale
  ,Vector2(-47.7286,26.7598) * PhysicVals.physicScale
  ,Vector2(47.5299,27.574) * PhysicVals.physicScale
  ,Vector2(47.2585,-58.1858) * PhysicVals.physicScale
  ,];

final List<Vector2> _opendPLeft = [
  Vector2(-22.8816,49.0521) * PhysicVals.physicScale
  ,Vector2(-30.2126,49.0521) * PhysicVals.physicScale
  ,Vector2(-33.7187,27.6967) * PhysicVals.physicScale
  ,Vector2(-47.1057,27.378) * PhysicVals.physicScale
  ,Vector2(-47.4245,-58.3625) * PhysicVals.physicScale
  ,Vector2(-23.2004,-58.3625) * PhysicVals.physicScale
  ,];

final List<Vector2> _opendPRight = [
  Vector2(21.8016,48.4147) * PhysicVals.physicScale
  ,Vector2(21.8016,-59) * PhysicVals.physicScale
  ,Vector2(46.9818,-58.6813) * PhysicVals.physicScale
  ,Vector2(47.3006,26.7405) * PhysicVals.physicScale
  ,Vector2(33.2761,26.7405) * PhysicVals.physicScale
  ,Vector2(28.495,48.0959) * PhysicVals.physicScale
  ,];

class GateBossPrison extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  GateBossPrison(this._id,{required super.position, this.isClosed});
  final int _id;
  late SpriteAnimation closed, opened, toOpen;
  bool? isClosed;
  late Ground _ground;
  late Fixture closedF, openedLeftF, openedRightF;

  @override
  void onRemove()
  {
    _ground.destroy();
    gameRef.dbHandler.dbStateChanger.removeListener(changeState);
  }

  @override
  Future onLoad() async
  {
    priority = position.y.toInt() - 4;
    Image spriteImg = await Flame.images.load('tiles/map/prisonSet/Props/Prison Gate-with wall.png');
    var spriteSheet = SpriteSheet(image: spriteImg,
        srcSize: Vector2(spriteImg.width / 18, spriteImg.height.toDouble()));
    toOpen = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    closed = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 1, loop: false);
    opened = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 17, loop: false);
    anchor = Anchor.center;
    if(isClosed == null){
      DBItemState ans = await gameRef.dbHandler.getItemStateFromDb(_id,gameRef.gameMap.currentGameWorldData!.nameForGame);
      isClosed = !ans.opened;
    }
    animation = isClosed! ? closed : opened;
    FixtureDef fix = FixtureDef(PolygonShape()..set(_closedP));
    _ground = Ground(
        BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );
    closedF = _ground.createFixture(fix);
    fix = FixtureDef(PolygonShape()..set(_opendPLeft));
    openedLeftF = _ground.createFixture(fix);
    fix = FixtureDef(PolygonShape()..set(_opendPRight));
    openedRightF = _ground.createFixture(fix);
    if(!isClosed!){
      closedF.setSensor(true);
    }else{
      openedLeftF.setSensor(true);
      openedRightF.setSensor(true);
    }
    gameRef.dbHandler.dbStateChanger.addListener(changeState);
  }

  void changeState() async
  {
    DBItemState ans = await gameRef.dbHandler.getItemStateFromDb(_id,gameRef.gameMap.currentGameWorldData!.nameForGame);
    bool openNow = ans.opened;
    print(openNow);
    if(openNow && isClosed!){
      animation = toOpen;
      animationTicker?.onComplete = (){
        closedF.setSensor(true);
        openedLeftF.setSensor(false);
        openedRightF.setSensor(false);
        isClosed = false;
      };
    }else if(!openNow && !isClosed!){
      animation = toOpen.reversed();
      animationTicker?.onComplete = () {
        closedF.setSensor(false);
        openedLeftF.setSensor(true);
        openedRightF.setSensor(true);
        isClosed = true;
      };
    }
  }
}