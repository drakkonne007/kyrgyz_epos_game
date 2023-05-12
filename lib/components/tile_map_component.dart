import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
import 'package:flutter/scheduler.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/overlays/health_bar.dart';
import 'package:game_flame/overlays/joysticks.dart';
import 'package:game_flame/players/front_player.dart';
import 'package:game_flame/players/ortho_player.dart';
import 'package:game_flame/players/sword_enemy.dart';

class CustomTileMap extends PositionComponent with HasGameRef<KyrgyzGame>
{
  late TiledComponent tiledMap;
  late Vector2 playerPos;
  ObjectHitbox? currentObject;
  int countId=0;
  late PositionComponent bground;
  late PositionComponent upperPlayer;
  OrthoPlayer? orthoPlayer;
  late FrontPlayer frontPlayer = FrontPlayer(Vector2.all(1));

  int getNewId(){
    return countId++;
  }

  clearGameMap()
  {
    removeWhere((component) => component is! OrthoPlayer || component is! FrontPlayer);
  }

  Future<void> loadNewMap(String fileName) async
  {
    var imageCompiler = ImageBatchCompiler();
    tiledMap = await TiledComponent.load(fileName, Vector2(32, 32));
    bground = imageCompiler.compileMapLayer(
        tileMap: tiledMap.tileMap, layerNames: ['bground','road','items']);
    size = tiledMap.size * GameConsts.gameScale;
    // bground.priority = GamePriority.ground;
    bground.scale = Vector2.all(GameConsts.gameScale);
    await add(bground);
    upperPlayer = imageCompiler.compileMapLayer(
        tileMap: tiledMap.tileMap, layerNames: ['high']);
    upperPlayer.priority = GamePriority.high;
    upperPlayer.scale = Vector2.all(GameConsts.gameScale);
    await add(upperPlayer);
    orthoPlayer?.position = Vector2.all(-150);
    final objs = tiledMap.tileMap.getLayer<ObjectGroup>("objects");
    for(final obj in objs!.objects){
      switch(obj.class_){
        case 'enemy': await bground.add(SwordEnemy(Vector2(obj.x, obj.y)));
        break;
        case 'ground': await add(Ground(size: Vector2(obj.width, obj.height) * GameConsts.gameScale,position: Vector2(obj.x, obj.y) * GameConsts.gameScale));
        break;
        case 'mapWarp': await add(MapWarp(to: fileName == 'tiles/map/test.tmx' ? 'tiles/map/test2.tmx' : 'tiles/map/test.tmx',size: Vector2(obj.width, obj.height) * GameConsts.gameScale,position: Vector2(obj.x, obj.y) * GameConsts.gameScale));
        break;
        case 'player': playerPos = Vector2(obj.x, obj.y);
      }
    }
    orthoPlayer = null;
    orthoPlayer = OrthoPlayer();
    await add(orthoPlayer!);
    orthoPlayer?.priority = GamePriority.player;
    orthoPlayer?.position = playerPos * GameConsts.gameScale;
    // orthoPlayer?.priority = GamePriority.player;
    // await add(ScreenHitbox());
    gameRef.showOverlay(overlayName: OrthoJoystick.id,isHideOther: true);
    gameRef.showOverlay(overlayName: HealthBar.id);
    // gameRef.camera.scaleVector(Vector2.all(0.2));
    gameRef.camera.followComponent(orthoPlayer!,worldBounds: Rect.fromLTWH(0, 0, width, height));
    print('end load new map');
  }

  Future<void> smallRestart() async
  {
    removeWhere((component) => component is KyrgyzEnemy);
    final enemySpawn = tiledMap.tileMap.getLayer<ObjectGroup>("objects");
    for(final obj in enemySpawn!.objects){
      if(obj.class_ == 'enemy') {
        bground.add(SwordEnemy(Vector2(
            obj.x, obj.y)));
      }
    }
  }
}