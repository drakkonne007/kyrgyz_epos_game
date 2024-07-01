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

final List<Vector2> _leftP = [
  Vector2(-53.9972,69.5286) * PhysicVals.physicScale
  ,Vector2(-53.694,135.911) * PhysicVals.physicScale
  ,];

final List<Vector2> _rightP = [
  Vector2(55.731,73.166) * PhysicVals.physicScale
  ,Vector2(56.3373,135.608) * PhysicVals.physicScale
  ,];

class HorizontalWoodBridge extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  HorizontalWoodBridge(this._startPosition,this._id,this.isClosed);
  final int _id;
  final Vector2 _startPosition;
  late SpriteAnimation closed, opened, toClosed;
  bool isClosed;
  late Ground _ground;
  late Fixture leftF, rightF;

  @override
  void onRemove()
  {
    _ground.destroy();
    gameRef.dbHandler.dbStateChanger.removeListener(changeState);
  }

  @override
  Future onLoad() async
  {
    Image spriteImg = await Flame.images.load('tiles/map/prisonSet/Props/hanging bridge-lifting animation-horizontal.png');
    var spriteSheet = SpriteSheet(image: spriteImg,
        srcSize: Vector2(spriteImg.width / 15, spriteImg.height.toDouble()));
    toClosed = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    closed = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 14, loop: false);
    opened = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 1, loop: false);
    anchor = Anchor.center;
    position = _startPosition;
    DBAnswer ans = await gameRef.dbHandler.stateFromDb(_id,gameRef.gameMap.currentGameWorldData!.nameForGame);
    isClosed = !ans.opened;
    animation = isClosed ? closed : opened;
    priority = GamePriority.backgroundTileAnim;
    FixtureDef fix = FixtureDef(EdgeShape()..set(_leftP.first,_leftP.last));
    FixtureDef fixRight = FixtureDef(EdgeShape()..set(_rightP.first,_rightP.last));
    _ground = Ground(
        BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );
    leftF = _ground.createFixture(fix);
    rightF = _ground.createFixture(fixRight);
    if(!isClosed){
      leftF.setSensor(true);
      rightF.setSensor(true);
    }
    gameRef.dbHandler.dbStateChanger.addListener(changeState);
  }

  void changeState() async
  {
    DBAnswer ans = await gameRef.dbHandler.stateFromDb(_id,gameRef.gameMap.currentGameWorldData!.nameForGame);
    bool toOpen = ans.opened;
    if(toOpen){
      animation = toClosed.reversed();
      Future.delayed(Duration(milliseconds:  (animationTicker!.totalDuration() * 1000).toInt()), (){
          leftF.setSensor(true);
          rightF.setSensor(true);
      });
    }else{
      animation = toClosed;
      leftF.setSensor(false);
      rightF.setSensor(false);
    }
  }
}