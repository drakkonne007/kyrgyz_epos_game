import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/RenderText.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

final List<Vector2> _groundPhy = [
  Vector2(-10.8705,2.58669) * PhysicVals.physicScale
  ,Vector2(-11.9761,33.7896) * PhysicVals.physicScale
  ,Vector2(-6.0795,37.2293) * PhysicVals.physicScale
  ,Vector2(7.67925,37.3521) * PhysicVals.physicScale
  ,Vector2(13.5759,33.6667) * PhysicVals.physicScale
  ,Vector2(11.3646,2.341) * PhysicVals.physicScale
  ,];

final List<Vector2> _objPoints = [
  Vector2(-24.4927,-7.86886)
  ,Vector2(-24.7657,47.1388)
  ,Vector2(26.1471,47.1388)
  ,Vector2(26.0106,-8.14186)
  ,];


class CupOfBloodDungeon extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  CupOfBloodDungeon(this._id, {this.isOpened,required super.position, super.anchor = Anchor.center});
  late SpriteAnimation _animAvialable, _animGetBuff, _animOpened;
  bool? isOpened;
  ObjectHitbox? _objectHitbox;
  late Ground _ground;
  int _id;
  final String _nonUsed = 'Это творение орков, я не знаю как это использовать';

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
    priority = position.y.toInt() + 37;
    FixtureDef fix = FixtureDef(PolygonShape()..set(_groundPhy));
    _ground = Ground(
        BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );//c:\kyrgyz_epos_game\assets\tiles\map\grassLand\Props\shrine3-available-no grass.png
    _ground.createFixture(fix);
    var spriteImg = await Flame.images.load('tiles/map/grassLand/Props/shrine3-activating-no grass.png');
    var spriteSheet = SpriteSheet(image: spriteImg,
        srcSize: Vector2(spriteImg.width.toDouble() / 14, spriteImg.height.toDouble()));
    _animOpened = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 13, loop: false);
    _animGetBuff = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    if(isOpened!){
      animation = _animOpened;
      return;
    }
    spriteImg = await Flame.images.load('tiles/map/grassLand/Props/shrine3-available-no grass.png');
    spriteSheet = SpriteSheet(image: spriteImg,
        srcSize: Vector2(spriteImg.width.toDouble() / 14, spriteImg.height.toDouble()));
    _animAvialable = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: true);
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
    if(!gameRef.playerData.canShrines){
      createText(text: _nonUsed, gameRef: gameRef);
      return;
    }
    _objectHitbox?.removeFromParent();
    isOpened = true;
    gameRef.dbHandler.changeItemState(id: _id, worldName: gameRef.gameMap.currentGameWorldData!.nameForGame,opened: true);
    animation = _animGetBuff;
    itemFromName('BloodShrine').getEffectFromInventar(gameRef);
  }
}