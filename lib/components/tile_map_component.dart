

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game_flame/abstract_game.dart';
import 'package:game_flame/components/ground_component.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/overlays/health_bar.dart';
import 'package:game_flame/overlays/joysticks.dart';
import 'package:game_flame/players/sword_enemy.dart';

class CustomTileMap extends PositionComponent with HasGameRef<AbstractGame>
{
  late TiledComponent tiledMap;
  late Vector2 playerPos;
  late List<SpriteAnimationComponent> _moveParticals = [];

  Future<void> init(fileName) async{
    tiledMap = await TiledComponent.load(fileName, Vector2(32, 32));
    tiledMap.scale = Vector2.all(GameConsts.gameScale);
    size = tiledMap.absoluteScaledSize;
    tiledMap.position = Vector2.all(0);
    add(tiledMap);
    // final groundObj = tiledMap.tileMap.getLayer<ObjectGroup>("ground");
    // final playerSpawn = tiledMap.tileMap.getLayer<ObjectGroup>("playerSpawn");
    // final enemySpawn = tiledMap.tileMap.getLayer<ObjectGroup>("enemySpawn");
    // playerPos = Vector2(playerSpawn!.objects.first.x * GameConsts.gameScale,playerSpawn!.objects.first.y * GameConsts.gameScale);
    // for(final obj in groundObj!.objects){
    //   add(Ground(Vector2(obj.width * GameConsts.gameScale, obj.height * GameConsts.gameScale), Vector2(obj.x * GameConsts.gameScale, obj.y * GameConsts.gameScale)));
    // }
    // for(final obj in enemySpawn!.objects){
    //   var sword = SwordEnemy(Vector2(obj.x * GameConsts.gameScale, obj.y * GameConsts.gameScale));
    //   add(sword);
    //   _moveParticals.add(sword);
    // }
    add(gameRef.orthoPlayer);
    gameRef.orthoPlayer.position = playerPos;
    add(ScreenHitbox());
    add(FpsTextComponent());
    gameRef.showOverlay(overlayName: OrthoJoystick.id,isHideOther: true);
    gameRef.showOverlay(overlayName: HealthBar.id);
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
      gameRef.orthoPlayer.position = playerPos;
  }
}