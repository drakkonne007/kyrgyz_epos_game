

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
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
  String fileName;
  CustomTileMap(this.fileName);
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
    // add(tiledMap);


    // Adding separate ground layer
    final ground = await imageCompiler.compileMapLayer(
        tileMap: tiledMap.tileMap, layerNames: ['bground']);
    ground.priority = 0;
    ground.scale = Vector2.all(GameConsts.gameScale);
    await add(ground);

    final road = await imageCompiler.compileMapLayer(
        tileMap: tiledMap.tileMap, layerNames: ['road']);
    road.priority = 0;
    road.scale = Vector2.all(GameConsts.gameScale);
    await add(road);

    // Adding separate tree layer
    final woods = await imageCompiler.compileMapLayer(
        tileMap: tiledMap.tileMap, layerNames: ['woods']);
    woods.priority = 0;
    woods.scale = Vector2.all(GameConsts.gameScale);
    await add(woods);

    final objs = tiledMap.tileMap.getLayer<ObjectGroup>("objects");
    for(final obj in objs!.objects){
      switch(obj.class_){
        case 'enemy': add(SwordEnemy(Vector2(obj.x * GameConsts.gameScale, obj.y * GameConsts.gameScale)));
        break;
        case 'ground':  add(Ground(size: Vector2(obj.width * GameConsts.gameScale, obj.height * GameConsts.gameScale),position: Vector2(obj.x * GameConsts.gameScale, obj.y * GameConsts.gameScale)));
        break;
        case 'player': playerPos = Vector2(obj.x * GameConsts.gameScale, obj.y * GameConsts.gameScale);
      }
    }
    if(OrthoPlayer().parent != null){
      OrthoPlayer().parent = this;
      OrthoPlayer().refreshMoves();
    }else {
      add(OrthoPlayer());
      OrthoPlayer().priority = 10;
    }
    OrthoPlayer().position = playerPos;
    gameRef.add(FpsTextComponent());
    add(ScreenHitbox());
    gameRef.showOverlay(overlayName: OrthoJoystick.id,isHideOther: true);
    gameRef.showOverlay(overlayName: HealthBar.id);
    gameRef.camera.followComponent(OrthoPlayer(),worldBounds: Rect.fromLTWH(0, 0, width, height));
  }

  void smallRestart()
  {
    removeWhere((component) => component is KyrgyzEnemy);
    final enemySpawn = tiledMap.tileMap.getLayer<ObjectGroup>("objects");
    for(final obj in enemySpawn!.objects){
      if(obj.class_ == 'enemy') {
        add(SwordEnemy(Vector2(
            obj.x * GameConsts.gameScale, obj.y * GameConsts.gameScale)));
      }
    }
    //OrthoPlayer().position = playerPos;
  }
}