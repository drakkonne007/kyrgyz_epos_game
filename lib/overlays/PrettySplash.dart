




import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/main_menu.dart';

class SplashScreenGame extends StatefulWidget {
  const SplashScreenGame(this._game,{super.key});
  static const String id = 'prettySplash';
  final KyrgyzGame _game;

  @override
  SplashScreenGameState createState() => SplashScreenGameState();
}

class SplashScreenGameState extends State<SplashScreenGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlameSplashScreen(
        // showBefore: (BuildContext context) {
        //   return const Text('Кыргыз Гейм');
        // },
        theme: FlameSplashTheme.dark,
        onFinish: (context){
            widget._game.overlays.remove(SplashScreenGame.id);
            widget._game.overlays.add(MainMenu.id);
          }),
    );
  }
}