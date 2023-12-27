import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/gen/strings.g.dart';
import 'package:game_flame/overlays/death_menu.dart';
import 'package:game_flame/overlays/dialog_overlay.dart';
import 'package:game_flame/overlays/game_hud.dart';
import 'package:game_flame/overlays/game_pause.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/inventar_overlay.dart';
import 'package:game_flame/overlays/language.dart';
import 'package:game_flame/overlays/main_menu.dart';
import 'package:game_flame/overlays/save_dialog.dart';

bool isMapCompile = true; //Надо ли компилить просто карту
bool isNeedCopyInternal = false;

main()
{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      TranslationProvider(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            debugShowMaterialGrid: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
                useMaterial3: true,
            ),
            home: Scaffold(
                body: GameWidget(
                  game: KyrgyzGame(),
                  overlayBuilderMap:  {
                    DeathMenu.id: (context, KyrgyzGame game) => DeathMenu(game),
                    GamePause.id: (context, KyrgyzGame game) => GamePause(game),
                    MainMenu.id: (context, KyrgyzGame game) => MainMenu(game),
                    SaveDialog.id: (context, KyrgyzGame game) => SaveDialog(game),
                    LanguageChooser.id: (context, KyrgyzGame game) => LanguageChooser(game),
                    GameHud.id: (context, KyrgyzGame game) => GameHud(game),
                    DialogOverlay.id: (context, KyrgyzGame game) => DialogOverlay(game),
                    InventoryOverlay.id: (context, KyrgyzGame game) => InventoryOverlay(game),
                  },
                )
            ),
          )
      )
  );
}
