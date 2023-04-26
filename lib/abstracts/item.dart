
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Items/loot.dart';
import 'package:game_flame/abstracts/hitboxes.dart';

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

class LootOnMap extends SpriteComponent with CollisionCallbacks
{
  Item _item;
  LootOnMap(this._item);

  @override
  Future<void> onLoad() async
  {
    final spriteImage = await Flame.images.load(
        _item.source);
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _item.srcSize);
    sprite = spriteSheet.getSprite(_item.row, _item.column);
    size = Vector2(16,16);
    await add(ObjectHitbox(autoTrigger: true, obstacleBehavoiur: getItemToPlayer));
  }

  void getItemToPlayer()
  {
    removeAll(children);
    removeFromParent();
  }
}