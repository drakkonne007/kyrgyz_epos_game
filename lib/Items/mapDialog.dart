import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/RenderText.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

class MapDialog extends PositionComponent with HasGameRef<KyrgyzGame> {

  MapDialog(this._targetPos, this._text,this._size, this._vectorSource, this._isLoop);

  Vector2 _targetPos;
  String _text;
  String? _vectorSource;
  bool _isLoop;
  int _countOfVariants = 0;
  List<String> _texts = [];
  Vector2 _size;
  RenderText? _renderText;
  late PositionComponent _player;

  @override
  Future<void> onLoad() async
  {
    _texts = _text.split(';');
    if(_texts.last == ''){
      _texts.removeLast();
    }
    anchor = Anchor.center;
    position = _targetPos;
    List<Vector2> temp = [];
    if(_vectorSource != null){
      var pointsList = _vectorSource!.split(' ');
      for (final sources in pointsList) {
        if (sources == '') {
          continue;
        }
        temp.add(Vector2(double.parse(sources.split(',')[0]) - position.x,
            double.parse(sources.split(',')[1]) - position.y));
      }
    }else{
       temp.add(Vector2(-_size.x/2, -_size.y/2));
       temp.add(Vector2(_size.x/2, -_size.y/2));
       temp.add(Vector2(_size.x/2, _size.y/2));
       temp.add(Vector2(-_size.x/2, _size.y/2));
    }
    add(ObjectHitbox(temp,
        collisionType: DCollisionType.active,
        isSolid: false,
        isStatic: false,
        obstacleBehavoiur: doDialog,
        autoTrigger: true,
        isLoop: _isLoop,
        game: gameRef));
    _player = gameRef.gameMap.orthoPlayer ?? gameRef.gameMap.frontPlayer!;
  }

  void doDialog()
  {
    int curs = min(_countOfVariants, _texts.length - 1);
    if(gameRef.gameMap.openSmallDialogs.contains(_texts[curs])){
      return;
    }
    _renderText ??= RenderText(_player.position, Vector2(150,75), _texts[curs]);
    _renderText?.priority = GamePriority.maxPriority;
    gameRef.gameMap.container.add(_renderText!);
    gameRef.gameMap.openSmallDialogs.add(_texts[curs]);
    _countOfVariants++;
    TimerComponent timer1 = TimerComponent(
      period: _texts[curs].length * 0.05 + 2,
      removeOnFinish: true,
      onTick: () {
        _renderText?.removeFromParent();
        _renderText = null;
      },
    );
    TimerComponent timer2 = TimerComponent(
      period: _texts[curs].length * 0.05 + 6,
      removeOnFinish: true,
      onTick: () {
        gameRef.gameMap.openSmallDialogs.remove(_texts[curs]);
      },
    );
    gameRef.gameMap.add(timer1);
    gameRef.gameMap.add(timer2);
  }
}