

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game_flame/components/ground_component.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/sword_enemy.dart';

class CustomTileMap extends PositionComponent
{
  late TiledComponent tiledMap;
  late Vector2 playerPos;
  late List<SpriteAnimationComponent> _moveParticals = [];

  @override
  Future<void> onLoad() async{
    tiledMap = await TiledComponent.load('tiles/map/firstMap2.tmx', Vector2(32, 32));
    tiledMap.scale = Vector2.all(GameConsts.gameScale);
    size = tiledMap.absoluteScaledSize;
    tiledMap.position = Vector2.all(0);
    add(tiledMap);
    final groundObj = tiledMap.tileMap.getLayer<ObjectGroup>("ground");
    final playerSpawn = tiledMap.tileMap.getLayer<ObjectGroup>("playerSpawn");
    final enemySpawn = tiledMap.tileMap.getLayer<ObjectGroup>("enemySpawn");
    playerPos = Vector2(playerSpawn!.objects.first.x * GameConsts.gameScale,playerSpawn!.objects.first.y * GameConsts.gameScale);
    for(final obj in groundObj!.objects){
      add(Ground(Vector2(obj.width * GameConsts.gameScale, obj.height * GameConsts.gameScale), Vector2(obj.x * GameConsts.gameScale, obj.y * GameConsts.gameScale)));
    }
    for(final obj in enemySpawn!.objects){
      var sword = SwordEnemy(Vector2(obj.x * GameConsts.gameScale, obj.y * GameConsts.gameScale));
      add(sword);
      _moveParticals.add(sword);
    }
  }

  void smallRestart(){
      removeAll(_moveParticals);
      _moveParticals.clear();
      final enemySpawn = tiledMap.tileMap.getLayer<ObjectGroup>("enemySpawn");
      for(final obj in enemySpawn!.objects){
        var sword = SwordEnemy(Vector2(obj.x * GameConsts.gameScale, obj.y * GameConsts.gameScale));
        add(sword);
        _moveParticals.add(sword);
      }
  }
}