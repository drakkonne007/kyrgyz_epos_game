import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/components/physic_vals.dart';
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
        super.priority = GamePriority.items}){
    _startPosition = position;
  }
  Vector2? _startPosition;
  final Item _item;
  late ObjectHitbox _objectHitbox;

  @override
  Future<void> onLoad() async
  {
    Image spriteImage = await Flame.images.load(
          _item.source);
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _item.srcSize);
    sprite = spriteSheet.getSprite(_item.row, _item.column);
    size = Vector2.all(30);
    _objectHitbox = ObjectHitbox([absolutePosition, absolutePosition + Vector2(size.x,0), absolutePosition + Vector2(size.x,size.y), absolutePosition + Vector2(0,size.y)]
        , collisionType: DCollisionType.passive, isSolid: true, isStatic: true, obstacleBehavoiur: getItemToPlayer, autoTrigger: true, isLoop: true);//ObjectHitbox(autoTrigger: true, obstacleBehavoiur: getItemToPlayer);
    await add(_objectHitbox);
    Component sd = Component();
  }

  void getItemToPlayer()
  {
    remove(_objectHitbox);
    double dur = 0.5;
    add(ScaleEffect.to(Vector2.all(2.3), EffectController(duration: dur)));
    add(OpacityEffect.by(-0.95,EffectController(duration: dur),onComplete: (){
      if(_item.hideAfterUse) {
        gameRef.gameMap.loadedLivesObjs.remove(_startPosition);
        removeFromParent();
      }
      _item.getEffect(gameRef);
    }));
  }

}