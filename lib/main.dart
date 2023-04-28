import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/gen/strings.g.dart';
import 'package:game_flame/overlays/death_menu.dart';
import 'package:game_flame/overlays/game_pause.dart';
import 'package:game_flame/overlays/joysticks.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/main_menu.dart';
import 'package:game_flame/overlays/save_dialog.dart';
import 'overlays/health_bar.dart';

main()
{
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.setLocale(AppLocale.kg);
  runApp(
      TranslationProvider(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            debugShowMaterialGrid: false,
            home: Scaffold(
                body: GameWidget(
                  game: KyrgyzGame(),
                  overlayBuilderMap:  {
                    DeathMenu.id: (context, KyrgyzGame game) => DeathMenu(game),
                    GamePause.id: (context, KyrgyzGame game) => GamePause(game),
                    HealthBar.id: (context, KyrgyzGame game) => HealthBar(game),
                    OrthoJoystick.id: (context, KyrgyzGame game) => OrthoJoystick(120),
                    MainMenu.id: (context, KyrgyzGame game) => MainMenu(game),
                    SaveDialog.id: (context, KyrgyzGame game) => SaveDialog(game),
                  },
                  initialActiveOverlays: const [MainMenu.id],
                )
            ),
          )
      )
  );
}
