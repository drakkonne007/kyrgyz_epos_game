
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Items/loot.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

enum LootItems
{
  noItem,
  pureHat,
  strongHat,
}

Item getDescriptOfItems(LootItems id)
{
  switch(id){
    case LootItems.noItem:    return Item();
    case LootItems.pureHat:   return PureHat();
    case LootItems.strongHat: return StrongHat();
  }
}

class Item
{
  LootItems id = LootItems.noItem;
  double hp = -1;
  double energy = -1;
  double armor = -1;
  bool enabled = false;
  bool isDress = false;
  bool isAnimated = false;
  String source = '';
  int cost = -1;
  int column = -1;
  int row = -1;
  Vector2 srcSize = Vector2.all(0);
  int countOfUses = 0;
}

class LootOnMap extends SpriteComponent with HasGameRef<KyrgyzGame>
{
  LootOnMap(this._item,
      {bool? autoResize,
        Paint? paint,
        required super.position,
        Vector2? size,
        super.scale,
        super.angle,
        super.nativeAngle,
        super.anchor,
        super.children,
        super.priority,});
  Item _item;
  late ObjectHitbox _objectHitbox;

  @override
  Future<void> onLoad() async
  {
    priority = GamePriority.loot;
    final spriteImage = await Flame.images.load(
        _item.source);
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _item.srcSize);
    sprite = spriteSheet.getSprite(_item.row, _item.column);
    size = Vector2.all(30);
    _objectHitbox = ObjectHitbox(autoTrigger: true, obstacleBehavoiur: getItemToPlayer);
    await add(_objectHitbox);
  }

  void getItemToPlayer()
  {
    print('getItemToPlayer');
    remove(_objectHitbox);
    double dur = 0.5;
    priority = GamePriority.maxPriority;
    add(ScaleEffect.to(Vector2.all(2.3), EffectController(duration: dur)));
    add(OpacityEffect.by(-0.95,EffectController(duration: dur),onComplete: (){
      removeFromParent();
    }));
  }

}