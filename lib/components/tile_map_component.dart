

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game_flame/components/ground_component.dart';

class CustomTileMap extends PositionComponent
{
  late TiledComponent tiledMap;

  @override
  Future<void> onLoad() async{
    tiledMap = await TiledComponent.load('tiles/map/firstMap2.tmx', Vector2(32, 32));
    tiledMap.scale = Vector2.all(2);
    size = tiledMap.absoluteScaledSize;
    tiledMap.position = Vector2.all(0);
    add(tiledMap);
    final objGroup = tiledMap.tileMap.getLayer<ObjectGroup>("ground");
    for(final obj in objGroup!.objects){
      add(Ground(Vector2(obj.width * 2, obj.height * 2), Vector2(obj.x * 2, obj.y * 2)));
    }
  }
}