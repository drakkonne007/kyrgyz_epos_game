import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

class Windblow extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  Windblow(this._startPos,this._id);

  final Vector2 _startPos;
  final int _id;

  @override
  void onLoad() async
  {
    anchor = const Anchor(0.5, 0.5);
    priority = GamePriority.maxPriority;
    position = _startPos;
    String name = 'wind cartoonish fx-288X64- 48frames.png';
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load(
          'tiles/map/grassLand2/Props/Animated props/$name'),
      srcSize: Vector2(288, 64),
    );
    List<double> steps = [];
    for(int i=0;i<51;i++){
      steps.add(0.1);
    }
    steps.add(4);
    animation = spriteSheet.createAnimationWithVariableStepTimes(row: 0, stepTimes: steps, from: 0);
    TimerComponent timer = TimerComponent(onTick: checkIsNeedSelfRemove,repeat: true,autoStart: true, period: 1);
    add(timer);
  }

  void checkIsNeedSelfRemove()
  {
    int column = _startPos.x ~/ GameConsts.lengthOfTileSquare.x;
    int row =    _startPos.y ~/ GameConsts.lengthOfTileSquare.y;
    int column2 = (_startPos.x + 288) ~/ GameConsts.lengthOfTileSquare.x;
    int diffCol = (column - gameRef.gameMap.column()).abs();
    int diffRow = (row - gameRef.gameMap.row()).abs();
    int diffCol2 = (column2 - gameRef.gameMap.column()).abs();
    if((diffCol > 1 && diffCol2 > 1) || diffRow > 1){
      gameRef.gameMap.loadedLivesObjs.remove(_id);
      removeFromParent();
    }
  }
}
