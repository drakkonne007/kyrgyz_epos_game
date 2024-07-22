import 'package:auto_size_text/auto_size_text.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/abstracts/quest.dart';
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

class _DialogOverlayState extends State<DialogOverlay>
{
  Quest? currQuest;

  @override
  void initState()
  {
    currQuest ??= widget._game.currentQuest!;
    widget._game.currentQuest = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    AnswerForDialog answer = currQuest!.getAnswer();
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
                          Image.asset(answer.image,
                              isAntiAlias: true,
                              width: constraints.maxWidth/5*2-25,
                              height: constraints.maxHeight/2-25,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high),
                        ]
                    ),
                    const Spacer(),
                    chooseVariants(currQuest!,Vector2(constraints.maxWidth/5*3,constraints.maxHeight/2),widget._game),
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
                                child: AutoSizeText(answer.text,
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

  Widget chooseVariants(Quest quest,Vector2 size, KyrgyzGame game)
  {
    return Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children:[
          getImg(size.x - 5,size.y - 5),
          SizedBox(
              width: size.x - 15,
              height: size.y - 15,
              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start ,
                  children: questAnswers(size, quest, game))
          ),
        ]
    );
  }

  List<Widget> questAnswers(Vector2 size, Quest quest, KyrgyzGame game)
  {
    AnswerForDialog answer = quest.getAnswer();
    List<Widget> tempContainer = [];
    for(int i = 0; i < answer.answers.length; i++) {
      tempContainer.add(Container(
        width: (size.x - 30),
        height: (size.y - 30) / 3,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color(0x30FF0000),
            Colors.transparent,
            Colors.transparent,
          ],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: Border.all(color: Colors.black, width: 3),
          // borderRadius: BorderRadius.zero,
        ),
        child: TextButton(onPressed: () {
          quest.changeState(answer.answerNumbers[i]);
          answer.onAnswer?.call(answer.answerNumbers[i]);
          if(answer.isEnd){
            game.doGameHud();
          }else{
            setState(() {
            });
          }
        },
          style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              )
          ),
          child: getPrettyAnswer(
              '\u261B ${answer.answers[i]}'),
        ),
      ));
    }
    return tempContainer;
  }
}

AutoSizeText getPrettyAnswer(String text)
{
  return AutoSizeText(
    text,
    style: dialogStyleFont,
    minFontSize: 10,
    maxFontSize: 25,
    maxLines:2,
    textAlign: TextAlign.center,
  );
}



