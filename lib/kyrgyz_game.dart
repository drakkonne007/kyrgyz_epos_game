import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:game_flame/abstract_game.dart';
import 'package:game_flame/components/tile_map_component.dart';

class KyrgyzGame extends World with HasGameRef<AbstractGame>
{
  late CustomTileMap _bground;
  // late CameraComponent camera;

  @override
  Future <void> onLoad() async{
    _bground = CustomTileMap();
    _bground.loaded.then((value){
      _bground.init('tiles/map/firstMap2.tmx');}
    );
    add(_bground);
    gameRef.camera.followComponent(gameRef.orthoPlayer);
    // camera.followComponent(gameRef.player,worldBounds: Rect.fromLTWH(0, 0, _bground.width, _bground.height));
    // add(camera);
  }

  Future <void> loadNewMap(String filePath) async{
    _bground.removeFromParent();
    _bground = CustomTileMap();
    _bground.init(filePath);
    add(_bground);
    gameRef.camera.followComponent(gameRef.orthoPlayer,worldBounds: Rect.fromLTWH(0, 0, _bground.width, _bground.height));
  }
}