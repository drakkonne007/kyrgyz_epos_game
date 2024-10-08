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
  Vector2(-17.9789,-5.58048) * PhysicVals.physicScale
  ,Vector2(-18.6093,18.796) * PhysicVals.physicScale
  ,Vector2(-1.79792,28.0423) * PhysicVals.physicScale
  ,Vector2(17.5352,18.5859) * PhysicVals.physicScale
  ,Vector2(16.6946,-6.21091) * PhysicVals.physicScale
  ,Vector2(9.33961,-15.4572) * PhysicVals.physicScale
  ,Vector2(-0.537069,-18.3992) * PhysicVals.physicScale
  ,Vector2(-12.9355,-13.5659) * PhysicVals.physicScale
  ,];

final List<Vector2> _objPoints = [
  Vector2(-31.2178,-27.6454)
  ,Vector2(29.5133,-27.6454)
  ,Vector2(29.5133,38.9697)
  ,Vector2(-29.957,39.1798)
  ,];


class CupOfBuff extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  CupOfBuff(this._id, {required this.blood, this.isOpened,required super.position, super.anchor = Anchor.center});
  late SpriteAnimation _animAvialable, _animGetBuff, _animOpened;
  bool? isOpened;
  bool blood;
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
    priority = position.y.toInt() + 28;
    FixtureDef fix = FixtureDef(PolygonShape()..set(_groundPhy));
    _ground = Ground(
        BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
            userData: BodyUserData(isQuadOptimizaion: false)),
        gameRef.world.physicsWorld
    );
    _ground.createFixture(fix);
    var spriteImg = await Flame.images.load(blood ? 'tiles/map/grassLand2/Props/Animated props/shrine2-1getting buff-blood.png'
        : 'tiles/map/grassLand2/Props/Animated props/shrine2-1getting buff-gray scale.png');
    var spriteSheet = SpriteSheet(image: spriteImg,
        srcSize: Vector2(spriteImg.width.toDouble() / 7, spriteImg.height.toDouble()));
    _animOpened = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 6, loop: false);
    if(isOpened!){
      animation = _animOpened;
      return;
    }
    _animGetBuff = spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    spriteImg = await Flame.images.load(blood ? 'tiles/map/grassLand2/Props/Animated props/shrine2-1available-blood.png'
        : 'tiles/map/grassLand2/Props/Animated props/shrine2-1available-gray scale.png');
    spriteSheet = SpriteSheet(image: spriteImg,
        srcSize: Vector2(spriteImg.width.toDouble() / 6, spriteImg.height.toDouble()));
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
    if(!gameRef.playerData.canShrines){
      createText(text: _nonUsed, gameRef: gameRef);
      return;
    }
    _objectHitbox?.removeFromParent();
    isOpened = true;
    gameRef.dbHandler.changeItemState(id: _id, worldName: gameRef.gameMap.currentGameWorldData!.nameForGame,opened: true);
    animation = _animGetBuff;
    Item item;
    if(blood){
      item = itemFromName('BloodShrine');
    }else{
      item = itemFromName('SilverShrine');
    }
    item.getEffectFromInventar(gameRef);
  }
}