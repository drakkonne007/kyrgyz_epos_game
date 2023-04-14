import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/overlays/death_menu.dart';
import 'package:game_flame/overlays/game_pause.dart';
import 'package:game_flame/overlays/joysticks.dart';
import 'package:game_flame/abstract_game.dart';
import 'package:game_flame/overlays/main_menu.dart';
import 'package:game_flame/overlays/save_dialog.dart';
import 'overlays/health_bar.dart';

main()
{
  WidgetsFlutterBinding.ensureInitialized();
  //
  // const List<String> overlays = [
  //   DeathMenu.id,
  //   GamePause.id,
  //   HealthBar.id,
  //   OrthoJoystick.id,
  //   MainMenu.id,
  //   SaveDialog.id,
  // ];

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: Scaffold(
        body: GameWidget(
          game: AbstractGame(),
          overlayBuilderMap:  {
            DeathMenu.id: (context, AbstractGame game) => DeathMenu(game),
            GamePause.id: (context, AbstractGame game) => GamePause(),
            HealthBar.id: (context, AbstractGame game) => HealthBar(),
            OrthoJoystick.id: (context, AbstractGame game) => OrthoJoystick(game,80),
            MainMenu.id: (context, AbstractGame game) => MainMenu(game),
            SaveDialog.id: (context, AbstractGame game) => SaveDialog(),
          },
          initialActiveOverlays: const [MainMenu.id],
        )
      ),
    )
  );
}
