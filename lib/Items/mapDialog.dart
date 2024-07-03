import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/RenderText.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/game_styles.dart';



class MapDialog extends PositionComponent with HasGameRef<KyrgyzGame> {

  MapDialog(this._targetPos, this._text, this._vectorSource, this._isLoop);

  Vector2 _targetPos;
  String _text;
  String _vectorSource;
  bool _isLoop;
  bool _isActive = false;

  RenderText? _renderText;



  @override
  Future<void> onLoad() async
  {

    anchor = Anchor.center;
    position = _targetPos;
    var pointsList = _vectorSource.split(' ');
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
        isLoop: _isLoop,
        game: gameRef));
  }

  void doDialog()
  {
    if(_isActive){
      return;
    }
    _renderText ??= RenderText(position, Vector2(150,75), _text);
    _isActive = true;
    gameRef.gameMap.container.add(_renderText!);
    Future.delayed(const Duration(seconds: 3),(){
      _isActive = false;
      if(_renderText != null) {
        _renderText!.removeFromParent();
        _renderText = null;
      }
    });    // print(text);
  }
}