import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

enum ColorState
{
  blue,
  yellow
}

class BigFlicker extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  BigFlicker(this._startPos,this._state, this._id);
  final ColorState _state;
  final Vector2 _startPos;
  int _id;

  @override
  void onLoad() async
  {
    opacity = 0;
    anchor = Anchor.center;
    priority = GamePriority.maxPriority;
    position = _startPos;
    String name = _state == ColorState.yellow ? 'magic flame-white-bigger.png' : 'magic flame-flickering light- bigger.png';
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load(
          'tiles/map/prisonSet/Props/$name'),
      srcSize: Vector2(160, 160),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.15, from: 0);
    size = size * 1.2;
    TimerComponent timer = TimerComponent(onTick: _checkIsNeedSelfRemove,repeat: true,autoStart: true, period: 1);
    add(timer);
    add(OpacityEffect.to(1, EffectController(duration: 0.9)));
  }

  void _checkIsNeedSelfRemove()
  {
    int column = position.x ~/ GameConsts.lengthOfTileSquare.x;
    int row =    position.y ~/ GameConsts.lengthOfTileSquare.y;
    int diffCol = (column - gameRef.gameMap.column()).abs();
    int diffRow = (row - gameRef.gameMap.row()).abs();
    if(diffCol > 2 || diffRow > 2){
      gameRef.gameMap.loadedLivesObjs.remove(_id);
      removeFromParent();
    }
  }
}
