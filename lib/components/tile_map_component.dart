

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game_flame/components/ground_component.dart';

class CustomTileMap extends PositionComponent
{
  late TiledComponent tiledMap;

  @override
  Future<void> onLoad() async{
    tiledMap = await TiledComponent.load('map/firstMap.tmx', Vector2(32, 32));
    size = tiledMap.size;
    tiledMap.position = Vector2.all(0);
    add(tiledMap);
    final objGroup = tiledMap.tileMap.getLayer<ObjectGroup>("ground");
    for(final obj in objGroup!.objects){
      add(Ground(Vector2(obj.width, obj.height), Vector2(obj.x, obj.y)));
    }
  }
}