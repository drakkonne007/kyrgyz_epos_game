import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/game_widgets/LootInventar.dart';
import 'package:game_flame/game_widgets/typeInventar.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/game_styles.dart';

AutoSizeText getAnswer(String text)
{
  return AutoSizeText(
    text,
    style: dialogStyleFont,
    minFontSize: 5,
    maxFontSize: 10,
    maxLines:1,
    textAlign: TextAlign.center,
  );
}

class InventoryOverlay extends StatefulWidget
{
  static const String id = 'InventoryOverlay';
  final KyrgyzGame game;
  const InventoryOverlay(this.game, {super.key});

  @override
  State<StatefulWidget> createState() {
    return InventoryOverlayState();
  }
}

class InventoryOverlayState extends State<InventoryOverlay>
{

  int currentIndex = 0;

  @override
  Widget build(BuildContext context)
  {
    return LayoutBuilder(builder: (context,constraints){
      return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children:[
                const Spacer(),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: getUpTabs((constraints.maxWidth * 0.75)/11,(constraints.maxHeight * 0.75)/7)
                ),
                Stack(
                    alignment: Alignment.center,
                    fit: StackFit.passthrough,
                    clipBehavior: Clip.none,
                    children:[
                      Image.asset('assets/images/inventar/UI-9-sliced object-31.png',
                        fit: BoxFit.fill,
                        centerSlice: const Rect.fromLTWH(8,9,9,10),
                        isAntiAlias: true,
                        filterQuality: FilterQuality.high,
                        width: constraints.maxWidth * 0.75,
                        height: constraints.maxHeight * 0.75,
                      ),
                      TypeInventar(widget.game,getVariant(currentIndex), Size(constraints.maxWidth * 0.75,constraints.maxHeight * 0.75))
                    ]
                ),
                const Spacer()
              ]
      );
    })  ;
  }

  LootVariant getVariant(int index)
  {
    switch(index){
      case 0: return LootVariant.weapon;
      case 1: return LootVariant.armor;
      case 2: return LootVariant.flask;
      case 3: return LootVariant.item;
    }
    return LootVariant.weapon;
  }

  String getImage(int index)
  {
    String source = '';
    switch(index){
      case 0: index == currentIndex ? source = 'UI-9-sliced object-3.png' : source = 'UI-9-sliced object-18.png'; break;
      case 1: index == currentIndex ? source = 'shieldYark.png' : source = 'shield.png'; break;
      case 2: index == currentIndex ? source = 'manaBright.png' : source = 'manaDark.png'; break;
      case 3: index == currentIndex ? source = 'UI-9-sliced object-4.png' : source = 'UI-9-sliced object-19.png'; break;
      case 4: index == currentIndex ? source = 'UI-9-sliced object-1.png' : source = 'UI-9-sliced object-16.png'; break;
      case 5: index == currentIndex ? source = 'UI-9-sliced object-2.png' : source = 'UI-9-sliced object-17.png'; break;
    }
    return 'assets/images/inventar/$source';
  }

  List<Widget> getUpTabs(double width, double height)
  {
    List<Widget> temp = [SizedBox(width: width*2,)];
    for(int i=0;i<6;i++){
      String asset = 'assets/images/inventar/UI-9-sliced object-35.png';
      if(currentIndex == i) {
        asset = 'assets/images/inventar/UI-9-sliced object-34.png';
      }
      temp.add(
          ElevatedButton(
              onPressed: (){
                setState(() {
                  currentIndex = i;
                  if(i == 5){
                    widget.game.doGameHud();
                  }
                });
              },
              style: defaultNoneButtonStyle.copyWith(
                maximumSize: MaterialStateProperty.all<Size>(Size(width,height + 5)),
                minimumSize: MaterialStateProperty.all<Size>(Size(width,height + 5)),
                alignment: Alignment.bottomCenter
              ),
              child:
              Stack(
                  fit: StackFit.passthrough,
                  alignment: Alignment.center,
                  children:
                  [
                    Image.asset(asset,
                      fit: BoxFit.fill,
                      centerSlice: const Rect.fromLTWH(4,4,17,19),
                      isAntiAlias: true,
                      filterQuality: FilterQuality.high,
                      width: width,
                      height: i == currentIndex ? height + 5 : height,
                    ),
                    Image.asset(getImage(i),
                      width: width,
                      height: height,)
                  ]
              )
          )
      );
    }
    return temp;
  }
}
