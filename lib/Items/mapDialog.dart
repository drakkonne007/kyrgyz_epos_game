import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/RenderText.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/game_styles.dart';



class MapDialog extends PositionComponent with HasGameRef<KyrgyzGame> {

  MapDialog(this._targetPos, this._text,this._size, this._vectorSource, this._isLoop);

  Vector2 _targetPos;
  String _text;
  String? _vectorSource;
  bool _isLoop;
  bool _isActive = false;
  int _countOfVariants = 0;
  List<String> _texts = [];
  Vector2 _size;
  double currentSecs = 0;

  RenderText? _renderText;



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
  }

  void doDialog()
  {
    if(_isActive){
      return;
    }
    int curs = min(_countOfVariants, _texts.length - 1);
    _renderText ??= RenderText(position, Vector2(150,75), _texts[curs]);
    _isActive = true;
    gameRef.gameMap.container.add(_renderText!);
    _countOfVariants++;
  }

  @override
  void update(double dt)
  {
    if(!_isActive){
      return;
    }
    currentSecs += dt;
    if(currentSecs >= 3){
      if(_renderText != null) {
        _renderText!.removeFromParent();
        _renderText = null;
      }
    }
    if(currentSecs >= 6){
      _isActive = false;
    }
    super.update(dt);
  }
}