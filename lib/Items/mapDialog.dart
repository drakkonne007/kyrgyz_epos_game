import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/kyrgyz_game.dart';

class MapDialog extends PositionComponent with HasGameRef<KyrgyzGame> {

  MapDialog(this.targetPos, this.text, this.vectorSource, this.isLoop);

  Vector2 targetPos;
  String text;
  String vectorSource;
  bool isLoop;

  @override
  Future<void> onLoad() async
  {
    anchor = Anchor.center;
    position = targetPos;
    var pointsList = vectorSource.split(' ');
    List<Vector2> temp = [];
    for (final sources in pointsList) {
      if (sources == '') {
        continue;
      }
      temp.add(Vector2(double.parse(sources.split(',')[0]) - position.x,
          double.parse(sources.split(',')[1]) - position.y));
    }

    add(ObjectHitbox(temp,
        collisionType: DCollisionType.active,
        isSolid: false,
        isStatic: false,
        obstacleBehavoiur: doDialog,
        autoTrigger: true,
        isLoop: isLoop,
        game: gameRef));
  }

  void doDialog()
  {
    print(text);
  }
}