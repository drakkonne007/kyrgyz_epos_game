


import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:photo_view/photo_view.dart';

class MapOverlay extends StatefulWidget
{
  static const id = 'MapOverlay';
  final KyrgyzGame _game;
  const MapOverlay(this._game, {super.key});

  @override
  State<MapOverlay> createState() => _MapOverlayState();
}

class _MapOverlayState extends State<MapOverlay> {

  @override
  Widget build(BuildContext context) {
    return
      SafeArea(child:
      Stack(
          children: [
            PhotoView(
                initialScale: 5.0,
                maxScale: 15.0,
                minScale: 1.0,
                basePosition: Alignment((widget._game.playerPosition().x / (widget._game.gameMap.currentGameWorldData!.gameConsts.maxColumn * GameConsts.lengthOfTileSquare.x) * 2 - 1)
                    , (widget._game.playerPosition().y / (widget._game.gameMap.currentGameWorldData!.gameConsts.maxRow * GameConsts.lengthOfTileSquare.y)) * 2 - 1),
                imageProvider: widget._game.imageForMap!.image),
            // PhotoView(
            //   imageProvider: widget._game.imageForMap?.image ?? const AssetImage('assets/NULL.png'),),
            FloatingActionButton(onPressed: widget._game.doGameHud),
          ]
      )
      );
  }
}
