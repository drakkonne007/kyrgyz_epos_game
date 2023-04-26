import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/kyrgyz_game.dart';



class Chest extends SpriteComponent with HasGameRef<KyrgyzGame>
{
  Chest({this.nedeedKilledBosses, this.neededItems, required this.myItems
  ,Sprite? sprite,
    bool? autoResize,
    Paint? paint,
    required super.position,
    Vector2? size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor,
    super.children,
    super.priority,});
  Set<int>? nedeedKilledBosses;
  Set<int>? neededItems;
  List<Item> myItems;
  int _row = 10;
  int _column = 7;

  void checkIsIOpen()
  {
    if(nedeedKilledBosses != null){
      if(!gameRef.playerData.killedBosses.containsAll(nedeedKilledBosses!)){
        return;
      }
    }
    if(neededItems != null){
      for(final myNeeded in neededItems!) {
        bool isNeed = true;
        for(final playerHas in gameRef.playerData.inventoryItems){
          if(playerHas.id.index == myNeeded){
            isNeed = false;
            break;
          }
        }
        if(isNeed){
          return;
        }
      }
      // TODO makes some open animation
    }
  }

  @override
  Future<void>onLoad() async
  {
    final spriteImage = await Flame.images.load(
        'tiles/map/loot/loot.png');
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: Vector2.all(16));
    sprite = spriteSheet.getSprite(_row, _column);
    size = Vector2.all(16);
    var asd = ObjectHitbox(obstacleBehavoiur: checkIsIOpen);
    await add(asd);
  }
}