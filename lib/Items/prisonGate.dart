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
  Vector2(-44.2155,49.3904) * PhysicVals.physicScale
  ,Vector2(-44.2155,69.7684) * PhysicVals.physicScale
  ,Vector2(47.9801,69.1749) * PhysicVals.physicScale
  ,Vector2(47.9801,48.4012) * PhysicVals.physicScale
  ,];

class PrisonGate extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  PrisonGate(this._id,{required super.position, this.isClosed, required this.circle});
  final int _id;
  late SpriteAnimation closed, opened, toOpen;
  bool? isClosed;
  bool circle;
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
    priority = position.y.toInt() + 70;
    Image spriteImg = await Flame.images.load(circle ? 'tiles/map/prisonSet/Props/cell gate2 - openning1.png'
    : 'tiles/map/prisonSet/Props/cell gate1 - openning1.png');
    var spriteSheet = SpriteSheet(image: spriteImg,
        srcSize: Vector2(spriteImg.width / 23, spriteImg.height.toDouble()));
    toOpen = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    closed = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 1, loop: false);
    opened = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 22, loop: false);
    anchor = Anchor.center;
    if(isClosed == null){
      DBItemState ans = await gameRef.dbHandler.getItemStateFromDb(_id,gameRef.gameMap.currentGameWorldData!.nameForGame);
      isClosed = !ans.opened;
    }
    animation = isClosed! ? closed : opened;
    FixtureDef fix = FixtureDef(PolygonShape()..set(_leftP));
    _ground = Ground(
        BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );
    leftF = _ground.createFixture(fix);
    if(!isClosed!){
      leftF.setSensor(true);
    }
    gameRef.dbHandler.dbStateChanger.addListener(changeState);
  }

  void changeState() async
  {
    DBItemState ans = await gameRef.dbHandler.getItemStateFromDb(_id,gameRef.gameMap.currentGameWorldData!.nameForGame);
    bool openNow = ans.opened;
    if(openNow && isClosed!){
      animation = toOpen;
      TimerComponent timer = TimerComponent(period: animationTicker!.totalDuration(),
          removeOnFinish: true,
          onTick: () {
            leftF.setSensor(true);
          }
      );
      gameRef.gameMap.add(timer);
    }else if(!openNow && !isClosed!){
      animation = toOpen.reversed();
      leftF.setSensor(false);
    }
  }
}