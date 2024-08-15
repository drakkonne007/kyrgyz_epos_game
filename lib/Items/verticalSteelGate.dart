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

final List<Vector2> _leftP = [
  Vector2(-9.54347,-109.687) * PhysicVals.physicScale
  ,Vector2(-9.1539,99.1214) * PhysicVals.physicScale
  ,Vector2(2.53315,99.1214) * PhysicVals.physicScale
  ,Vector2(1.36445,-117.868) * PhysicVals.physicScale
  ,];

class VerticalSteelGate extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  VerticalSteelGate(this._startPosition,this._id);
  final int _id;
  final Vector2 _startPosition;
  late SpriteAnimation closed, opened, toClosed;
  bool isClosed = false;
  late Ground _ground;
  late Fixture leftF;

  @override
  void onRemove()
  {
    _ground.destroy();
    gameRef.dbHandler.dbStateChanger.removeListener(changeState);
  }

  @override
  Future onLoad() async
  {
    Image spriteImg = await Flame.images.load('tiles/map/mountainLand/Props/Animated props/boss gate-going down-vertical.png');
    var spriteSheet = SpriteSheet(image: spriteImg,
        srcSize: Vector2(spriteImg.width / 18, spriteImg.height.toDouble()));
    toClosed = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false).reversed();
    closed = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 1, loop: false);
    opened = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 17, loop: false);
    anchor = Anchor.center;
    position = _startPosition;
    DBItemState ans = await gameRef.dbHandler.getItemStateFromDb(_id,gameRef.gameMap.currentGameWorldData!.nameForGame);
    isClosed = !ans.opened;
    animation = isClosed ? closed : opened;
    priority = GamePriority.backgroundTileAnim;
    FixtureDef fix = FixtureDef(PolygonShape()..set(_leftP));
    _ground = Ground(
        BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );
    leftF = _ground.createFixture(fix);
    if(!isClosed){
      leftF.setSensor(true);
    }
    gameRef.dbHandler.dbStateChanger.addListener(changeState);
  }

  void changeState() async
  {
    DBItemState ans = await gameRef.dbHandler.getItemStateFromDb(_id,gameRef.gameMap.currentGameWorldData!.nameForGame);
    bool toOpen = ans.opened;
    if(toOpen && isClosed){
      animation = toClosed.reversed();
      TimerComponent timer = TimerComponent(period: animationTicker!.totalDuration(),
          removeOnFinish: true,
          onTick: () {
            leftF.setSensor(true);
          }
      );
      gameRef.gameMap.add(timer);
    }else if(!toOpen && !isClosed){
      animation = toClosed;
      leftF.setSensor(false);
    }
  }
}