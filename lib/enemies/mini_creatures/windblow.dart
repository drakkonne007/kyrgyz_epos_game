import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/kyrgyz_game.dart';

class Windblow extends SpriteAnimationComponent with HasGameRef<KyrgyzGame> {
  Windblow(this._startPos, {super.priority});

  Vector2 _startPos;
  @override onLoad() async
  {
    anchor = const Anchor(0.5, 0.5);
    position = _startPos;
    String name = 'wind cartoonish fx-288X64- 48frames.png';
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load(
          'tiles/map/grassLand2/Props/Animated props/$name'),
      srcSize: Vector2(288, 64),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0);
  }

  @override
  void update(double dt)
  {
    int column = _startPos.x ~/ gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x;
    int row =    _startPos.y ~/ gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y;
    int column2 = (_startPos.x + 288) ~/ gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x;
    int diffCol = (column - gameRef.gameMap.column()).abs();
    int diffRow = (row - gameRef.gameMap.row()).abs();
    int diffCol2 = (column2 - gameRef.gameMap.column()).abs();
    if((diffCol > 2 && diffCol2 > 2) || diffRow > 2){
      gameRef.gameMap.loadedLivesObjs.remove(_startPos);
      removeFromParent();
    }
    super.update(dt);
  }
}
