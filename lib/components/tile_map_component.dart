import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
import 'package:flutter/scheduler.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/abstracts/enemy.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/overlays/health_bar.dart';
import 'package:game_flame/overlays/joysticks.dart';
import 'package:game_flame/players/ortho_player.dart';
import 'package:game_flame/players/sword_enemy.dart';

class CustomTileMap extends PositionComponent with HasGameRef<KyrgyzGame>
{
  CustomTileMap(this.fileName);
  String fileName;
  late TiledComponent tiledMap;
  late Vector2 playerPos;
  late ObjectHitbox? currentObject;
  int countId=0;

  int getNewId(){
    return countId++;
  }

  clearGameMap()
  {
    removeAll(children);
  }

  @override
  Future<void> onLoad() async
  {
    final imageCompiler = ImageBatchCompiler();
    tiledMap = await TiledComponent.load(fileName, Vector2(32, 32));
    size = tiledMap.size * GameConsts.gameScale;

    final ground = imageCompiler.compileMapLayer(
        tileMap: tiledMap.tileMap, layerNames: ['bground']);
    ground.priority = GamePriority.ground;
    ground.scale = Vector2.all(GameConsts.gameScale);
    await add(ground);

    final road = imageCompiler.compileMapLayer(
        tileMap: tiledMap.tileMap, layerNames: ['road']);
    road.priority = GamePriority.road;
    road.scale = Vector2.all(GameConsts.gameScale);
    await add(road);

    final woods = imageCompiler.compileMapLayer(
        tileMap: tiledMap.tileMap, layerNames: ['woods']);
    woods.priority = GamePriority.woods;
    woods.scale = Vector2.all(GameConsts.gameScale);
    await add(woods);

    final objs = tiledMap.tileMap.getLayer<ObjectGroup>("objects");
    for(final obj in objs!.objects){
      switch(obj.class_){
        case 'enemy': await add(SwordEnemy(Vector2(obj.x * GameConsts.gameScale, obj.y * GameConsts.gameScale)));
        break;
        case 'ground': await add(Ground(size: Vector2(obj.width * GameConsts.gameScale, obj.height * GameConsts.gameScale),position: Vector2(obj.x * GameConsts.gameScale, obj.y * GameConsts.gameScale)));
        break;
        case 'player': playerPos = Vector2(obj.x * GameConsts.gameScale, obj.y * GameConsts.gameScale);
      }
    }
    if(OrthoPlayer().parent != null){
      OrthoPlayer().parent = this;
      OrthoPlayer().refreshMoves();
    }else {
      await add(OrthoPlayer());
      OrthoPlayer().priority = GamePriority.player;
    }
    OrthoPlayer().position = playerPos;
    await gameRef.add(FpsTextComponent());
    await add(ScreenHitbox());
    gameRef.showOverlay(overlayName: OrthoJoystick.id,isHideOther: true);
    gameRef.showOverlay(overlayName: HealthBar.id);
    gameRef.camera.followComponent(OrthoPlayer(),worldBounds: Rect.fromLTWH(0, 0, width, height));
  }

  Future<void> smallRestart() async
  {
    removeWhere((component) => component is KyrgyzEnemy);
    final enemySpawn = tiledMap.tileMap.getLayer<ObjectGroup>("objects");
    for(final obj in enemySpawn!.objects){
      if(obj.class_ == 'enemy') {
        await add(SwordEnemy(Vector2(
            obj.x * GameConsts.gameScale, obj.y * GameConsts.gameScale)));
      }
    }
  }
}