import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

final List<Vector2> _groundPhy = [
  Vector2(-33.4966,23.4379) * PhysicVals.physicScale
  ,Vector2(-22.0472,37.8314) * PhysicVals.physicScale
  ,Vector2(10.6654,37.995) * PhysicVals.physicScale
  ,Vector2(21.6241,32.2703) * PhysicVals.physicScale
  ,Vector2(25.386,22.62) * PhysicVals.physicScale
  ,Vector2(15.5723,12.152) * PhysicVals.physicScale
  ,Vector2(9.68399,-14.9994) * PhysicVals.physicScale
  ,Vector2(-16.6496,-14.8359) * PhysicVals.physicScale
  ,Vector2(-22.2108,12.6427) * PhysicVals.physicScale
  ,];

final List<Vector2> _objPoints = [
  Vector2(-47.2083,-26.7138)
  ,Vector2(-47.6571,52.4874)
  ,Vector2(40.9676,52.7118)
  ,Vector2(40.7432,-28.7331)
  ,];


class ShrineExperience extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  ShrineExperience(this._id, {required this.onGrass, this.isOpened,required super.position, super.anchor = Anchor.center});
  late SpriteAnimation _animAvialable, _animGetBuff, _animOpened;
  bool? isOpened;
  bool onGrass;
  ObjectHitbox? _objectHitbox;
  late Ground _ground;
  int _id;

  @override
  void onRemove()
  {
    _ground.destroy();
  }

  @override
  Future onLoad() async
  {
    if(isOpened == null) {
      var res = await gameRef.dbHandler.getItemStateFromDb(
          _id, gameRef.gameMap.currentGameWorldData!.nameForGame);
      isOpened = res.opened;
    }
    priority = position.y.toInt() + 38;
    FixtureDef fix = FixtureDef(PolygonShape()..set(_groundPhy));
    _ground = Ground(
        BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );
    _ground.createFixture(fix);
    var spriteImg = await Flame.images.load(onGrass ? 'tiles/map/grassLand2/Props/Animated props/shrine-getting buff animation-295x311.png'
        : 'tiles/map/grassLand2/Props/Animated props/shrine-getting buff animation-no grass-295x311.png');
    var spriteSheet = SpriteSheet(image: spriteImg,
        srcSize: Vector2(spriteImg.width.toDouble() / 8, spriteImg.height.toDouble()));
    _animOpened = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 7, loop: false);
    if(isOpened!){
      animation = _animOpened;
      return;
    }
    _animGetBuff = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    spriteImg = await Flame.images.load(onGrass ? 'tiles/map/grassLand2/Props/Animated props/shrine-buff available animation-295x311.png'
        : 'tiles/map/grassLand2/Props/Animated props/shrine-buff available animation-no grass-295x311.png');
    spriteSheet = SpriteSheet(image: spriteImg,
        srcSize: Vector2(spriteImg.width.toDouble() / 11, spriteImg.height.toDouble()));
    _animAvialable = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: true);
    // var asd = ObjectHitbox(obstacleBehavoiur: checkIsIOpen);
    _objectHitbox = ObjectHitbox(_objPoints,
        collisionType: DCollisionType.active, isSolid: true, isStatic: false, isLoop: true,
        autoTrigger: false, obstacleBehavoiur: checkIsIOpen, game: gameRef);
    add(_objectHitbox!);
    animation = _animAvialable;
  }

  void checkIsIOpen()
  {
    if(isOpened!){
      return;
    }
    _objectHitbox?.removeFromParent();
    isOpened = true;
    gameRef.dbHandler.changeItemState(id: _id, worldName: gameRef.gameMap.currentGameWorldData!.nameForGame,opened: true);
    animation = _animGetBuff;
    gameRef.playerData.addLevel(gameRef.gameMap.currentGameWorldData!.level * 1000);
  }
}