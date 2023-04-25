
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';



class Chest extends SpriteComponent with HasGameRef<KyrgyzGame>
{
  Set<int>? nedeedKilledBosses;
  Set<int>? neededItems;
  List<Item> myItems;
  Chest({this.nedeedKilledBosses, this.neededItems, required this.myItems});

  void checkIsIOpen(Set<Vector2> intersectionPoints, ShapeHitbox other)
  {
    bool isOpen = true;
    if(nedeedKilledBosses != null){
      if(!gameRef.playerData.killedBosses.containsAll(nedeedKilledBosses!)){

        isOpen = false;
      }
    }
    if(neededItems != null){
      for(final a in neededItems!) {
        if (!gameRef.playerData.inventoryItems.contains(a)) {

        }
      }
    }
  }

  @override
  Future<void>onLoad() async
  {
    final spriteImage = await Flame.images.load(
        'tiles/map/loot/loot.png');
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: Vector2.all(16));
    sprite = spriteSheet.getSprite(10, 5);
    size = Vector2.all(16);
    var asd = ChestHitbox(obstacleBehavoiur: checkIsIOpen);
    add(RectangleHitbox(size: Vector2.all(16)));
  }
}