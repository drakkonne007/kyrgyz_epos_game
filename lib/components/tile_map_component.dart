

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game_flame/Obstacles/ground_component.dart';
import 'package:game_flame/abstracts/enemy.dart';
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

  clearGameMap(){
    removeAll(children);
  }

  @override
  Future<void> onLoad() async
  {
    tiledMap = await TiledComponent.load(fileName, Vector2(32, 32));
    tiledMap.scale = Vector2.all(GameConsts.gameScale);
    size = tiledMap.absoluteScaledSize;
    tiledMap.position = Vector2.all(0);
    add(tiledMap);
    final objs = tiledMap.tileMap.getLayer<ObjectGroup>("objects");
    for(final obj in objs!.objects){
      switch(obj.class_){
        case 'enemy': add(SwordEnemy(Vector2(obj.x * GameConsts.gameScale, obj.y * GameConsts.gameScale)));
        break;
        case 'ground':  add(Ground(Vector2(obj.width * GameConsts.gameScale, obj.height * GameConsts.gameScale), Vector2(obj.x * GameConsts.gameScale, obj.y * GameConsts.gameScale)));
        break;
        case 'player': playerPos = Vector2(obj.x * GameConsts.gameScale, obj.y * GameConsts.gameScale);
      }
    }
    if(OrthoPlayer().parent != null){
      OrthoPlayer().parent = this;
      OrthoPlayer().refreshMoves();
    }else {
      add(OrthoPlayer());
      OrthoPlayer().priority = 99999;
    }
    OrthoPlayer().position = playerPos;
    add(ScreenHitbox());
    add(FpsTextComponent());
    gameRef.showOverlay(overlayName: OrthoJoystick.id,isHideOther: true);
    gameRef.showOverlay(overlayName: HealthBar.id);
    gameRef.camera.followComponent(OrthoPlayer(),worldBounds: Rect.fromLTWH(0, 0, width, height));
  }


  void smallRestart(){
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