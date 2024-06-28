import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/kyrgyz_game.dart';

class LootOnMap extends SpriteComponent with HasGameRef<KyrgyzGame>
{
  LootOnMap(this._item,
      {bool? autoResize,
        required super.position,
        Vector2? size,
        super.scale,
        super.angle,
        super.nativeAngle,
        super.anchor = Anchor.center,
        super.children,
        super.priority,
      this.id = -1});

  final Item _item;
  late ObjectHitbox _objectHitbox;
  int id;

  @override
  Future<void> onLoad() async
  {
    priority = position.y.toInt();
    Image spriteImage = await Flame.images.load(
          _item.source);
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: spriteImage.size);
    sprite = spriteSheet.getSprite(0, 0);
    size = Vector2.all(30);
    anchor = Anchor.center;
    _objectHitbox = ObjectHitbox(getPointsForActivs(Vector2(-15,-15), Vector2.all(30)),
        collisionType: DCollisionType.active, isSolid: true,
        isStatic: false, obstacleBehavoiur: getItemToPlayer,
        autoTrigger: true, isLoop: true, game: gameRef);//ObjectHitbox(autoTrigger: true, obstacleBehavoiur: getItemToPlayer);
    add(_objectHitbox);
  }

  void getItemToPlayer()
  {
    print('getItemToPlayer');
    remove(_objectHitbox);
    double dur = 0.5;
    add(ScaleEffect.to(Vector2.all(2.3), EffectController(duration: dur)));
    add(OpacityEffect.by(-1,EffectController(duration: dur),onComplete: (){
      if(_item.isStaticObject) {
        gameRef.gameMap.loadedLivesObjs.remove(id);
      }
      _item.getEffect(gameRef);
      removeFromParent();
    }));
  }

}