


import 'package:auto_size_text/auto_size_text.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/components/quests.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/game_styles.dart';

//Лучше всего 12 картинка
const String imgPath = 'assets/images/12.png';
double border = 23;

Image getImg(double width,double height)
{
  return Image.asset(imgPath,
      fit: BoxFit.fill,
      centerSlice: Rect.fromPoints(const Offset(15,15),const Offset(45, 45)),
      width: width,
      height: height,
      isAntiAlias: true,
      filterQuality: FilterQuality.high
  );
}

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
              const Spacer(),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  children:[
                    const Spacer(),
                    Stack(
                        alignment: Alignment.center,
                        fit: StackFit.passthrough,
                        children:[
                          getImg(constraints.maxWidth/5*2 - 5,constraints.maxHeight/2 - 5),
                          Image.asset('assets/tiles/sprites/dialogIcons/azura.png',
                              isAntiAlias: true,
                              width: constraints.maxWidth/5*2-25,
                              height: constraints.maxHeight/2-25,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high),
                        ]
                    ),
                    const Spacer(),
                    DialogAnswers(widget._game,Vector2(constraints.maxWidth/5*3,constraints.maxHeight/2)),
                    const Spacer()
                  ]
              ),
              const Spacer(),
              SizedBox(
                  width: constraints.maxWidth - 5,
                  height: constraints.maxHeight/2 - 20,
                  child:
                  Stack(
                      alignment: Alignment.center,
                      fit: StackFit.passthrough,
                      children:[
                        getImg(constraints.maxWidth/2 - 10,constraints.maxHeight/2 - 50),
                        Center(
                            child: SizedBox(
                                width: constraints.maxWidth - 40,
                                height: constraints.maxHeight/2 - 40,
                                child: AutoSizeText(
                                  'Привет, путник. Купи у меня мои штаны и мою блузку, '
                                      'чтобы я походила в нижнем белье на этом чистом и приятном солнце. '
                                      'Здесь так хорошо, щас прочитаю тебе свои стихи, малыш шаупшга уцагшцуапуцгш апуцгшапцугшапшг апуцшгапуцшап пагшуцпагшуцпашг',
                                  // overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: dialogStyleFont,
                                )
                            )
                        ),
                      ]
                  )
              ),
              const Spacer()
            ]
        );
    });
  }
}


class DialogAnswers extends StatefulWidget
{
  final KyrgyzGame _game;
  const DialogAnswers(this._game, this.size, {super.key});
  final Vector2 size;

  @override
  State<DialogAnswers> createState() => _DialogAnswersState();
}

class _DialogAnswersState extends State<DialogAnswers> {
  @override
  Widget build(BuildContext context){
    return Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children:[
          getImg(widget.size.x - 5,widget.size.y - 5),
          SizedBox(
              width: widget.size.x - 15,
              height: widget.size.y - 15,
              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Container(
                      width:(widget.size.x - 30),
                      height: (widget.size.y - 30)/3,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0x30FF0000),Colors.transparent,Colors.transparent,],
                        begin: Alignment.topLeft, end: Alignment.bottomRight),
                        border: Border.all(color: Colors.black,width: 3),
                        // borderRadius: BorderRadius.zero,
                      ),
                      child: TextButton(onPressed: widget._game.doGameHud,
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            )
                        ),
                        child: getPrettyAnswer('\u261B Вот такие вот письмена ха ха ха1232131  dwqdqwd'),
                      ),
                    ),
                    Container(
                        width:(widget.size.x - 30),
                        height: (widget.size.y - 30)/3,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0x30FF0000),Colors.transparent,Colors.transparent,],
                              begin: Alignment.topLeft, end: Alignment.bottomRight),
                          border: Border.all(color: Colors.black,width: 3),
                          // borderRadius: BorderRadius.zero,
                        ),
                        child: TextButton(onPressed: widget._game.doGameHud,
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              )
                          ),
                          child: getPrettyAnswer('\u261B Вот такие вот письмена ха ха ха1232131  dwqdqwd'),
                        )
                    ),
                    Container(
                        width:(widget.size.x - 30),
                        height: (widget.size.y - 30)/3,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0x30FF0000),Colors.transparent,Colors.transparent,],
                              begin: Alignment.topLeft, end: Alignment.bottomRight),
                          border: Border.all(color: Colors.black,width: 3),
                          // borderRadius: BorderRadius.zero,
                        ),
                        child: TextButton(onPressed: widget._game.doGameHud,
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              )
                          ),
                          child: getPrettyAnswer('\u261B Вот такие вот письмена ха ха ха1232131  dwqdqwd'),
                        )
                    ),
                  ])
          ),
        ]
    );
  }
}

AutoSizeText getPrettyAnswer(String text)
{
  return AutoSizeText(
    text,
    style: dialogStyleFont,
    minFontSize: 10,
    maxLines:2,
    textAlign: TextAlign.center,
  );
}



