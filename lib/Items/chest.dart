
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/physic_vals.dart';



class Chest extends SpriteComponent
{
  List<int>? nedeedKilledBosses;
  List<int>? neededItems;
  Chest({this.nedeedKilledBosses, this.neededItems});

  void checkIsIOpen(Set<Vector2> intersectionPoints, ShapeHitbox other){
    bool isOpen = true;
    if(nedeedKilledBosses != null){
      for (var a in nedeedKilledBosses!){
        if(OrthoPlayerValsVals.)
      }
    }
    if()
  }

  @override
  Future<void>onLoad() async{
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