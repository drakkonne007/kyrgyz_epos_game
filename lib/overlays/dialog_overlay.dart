

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/kyrgyz_game.dart';

class DialogOverlay extends StatefulWidget
{
  static const id = 'DialogOverlay';
  final KyrgyzGame _game;
  const DialogOverlay(this._game, {super.key});

  @override
  State<DialogOverlay> createState() => _DialogOverlayState();
}

class _DialogOverlayState extends State<DialogOverlay> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      return
        Column(
            mainAxisSize: MainAxisSize.max,
            children:[
              Row(
                  mainAxisSize: MainAxisSize.max,
                  children:[
                    Image.asset('assets/tiles/sprites/dialogIcons/azura.png',isAntiAlias: true,width: constraints.maxWidth/2,height: constraints.maxHeight/2,fit: BoxFit.contain,),
                    DialogAnswers(widget._game,Vector2(constraints.maxWidth/2,constraints.maxHeight/2)),
                  ]
              ),
              SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight/2,
                  child: const Text('Вопрос',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  )
              )
            ]
        );
    });
  }
}


class DialogAnswers extends StatefulWidget
{
  final KyrgyzGame _game;
  DialogAnswers(this._game, this.size, {super.key});
  Vector2 size;

  @override
  State<DialogAnswers> createState() => _DialogAnswersState();
}

class _DialogAnswersState extends State<DialogAnswers> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.size.x,
        height: widget.size.y,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          TextButton(onPressed: widget._game.doGameHud, child: Text('Первый вариант')),
          TextButton(onPressed: widget._game.doGameHud, child: Text('Второй вариант')),
          TextButton(onPressed: widget._game.doGameHud, child: Text('Третий вариант')),
        ])
    );
    // return
  }
}