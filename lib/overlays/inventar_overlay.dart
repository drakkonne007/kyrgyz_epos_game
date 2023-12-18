import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  InventoryOverlay(this.game, {super.key});


  @override
  State<StatefulWidget> createState() {
    return InventoryOverlayState();
  }
}

List<Widget> getCells(KyrgyzGame game,double width,int rowNumber)
{
  List<Widget> list = [];
  String? temp;
  switch(rowNumber){
    case 1:
      temp = 'assets/images/dressIcon.png'; break;
    case 2: temp = 'assets/images/swordIcon.png'; break;
    case 3: temp = 'assets/images/poisonIcon.png'; break;
    case 4: temp = 'assets/images/bagIcon.png'; break;
    case 5: temp = 'assets/images/settingsIcon.png'; break;
  }
  for(int i = 0; i < 9; i++){
    if(i == 0){
      list.add(cellForTable(game,width,imgPath: temp));
    }else{
      list.add(cellForTable(game,width));
    }
  }
  return list;
}

Widget firstRow(double height, KyrgyzGame game)
{
  return Stack(
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      children:[
        Image.asset('assets/images/inventar3.png',
          fit: BoxFit.fill,
          centerSlice: Rect.fromPoints(const Offset(15,15),const Offset(45, 45)),
          isAntiAlias: true,
          filterQuality: FilterQuality.high,
          height: height,
          width: height * 9,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Icon(Icons.heart_broken, color: Colors.red,size: 35,
              shadows: [
                BoxShadow(color: Colors.black,blurRadius: 5,offset: Offset(-1,1), blurStyle: BlurStyle.normal)
              ],),
            getAnswer(game.playerData.health.value.toString()),
            const Icon(Icons.shield_sharp, color: Colors.green,size: 35,
              shadows: [
                BoxShadow(color: Colors.black,blurRadius: 5,offset: Offset(-1,1),spreadRadius: 1, blurStyle: BlurStyle.normal)
              ],),
            getAnswer(game.playerData.armor.value.toString()),
            const Icon(Icons.attach_money, color: Colors.yellow,size: 35,
              shadows: [
                BoxShadow(color: Colors.black,blurRadius: 5,offset: Offset(-1,1),blurStyle: BlurStyle.normal)
              ]
            ),
            getAnswer(game.playerData.money.toString()),
            Image.asset('assets/images/dressIcon.png',),
            getAnswer(game.playerData.money.toString()),
          ]
        )
      ]
  );
}

class InventoryOverlayState extends State<InventoryOverlay>
{
  @override
  Widget build(BuildContext context)
  {
    return LayoutBuilder(builder: (context,constraints){
      return Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                firstRow(min(constraints.maxWidth/10, constraints.maxHeight/7),widget.game),
                Row(mainAxisAlignment: MainAxisAlignment.center, children:getCells(widget.game,min(constraints.maxWidth/10, constraints.maxHeight/7),1)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children:getCells(widget.game,min(constraints.maxWidth/10, constraints.maxHeight/7),2)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children:getCells(widget.game,min(constraints.maxWidth/10, constraints.maxHeight/7),3)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children:getCells(widget.game,min(constraints.maxWidth/10, constraints.maxHeight/7),4)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children:getCells(widget.game,min(constraints.maxWidth/10, constraints.maxHeight/7),5)),
              ]
          )
      );
    })  ;
  }
}
//
// Image getImg(int row)
// {
//   return Image.asset(imgPath,
//       fit: BoxFit.fill,
//       centerSlice: Rect.fromPoints(const Offset(15,15),const Offset(45, 45)),
//       width: width,
//       height: height,
//       isAntiAlias: true,
//       filterQuality: FilterQuality.high
//   );
// }

Widget cellForTable(KyrgyzGame game, double width, {String? imgPath})
{
  return Stack(
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      children:[
        Image.asset('assets/images/inventar3.png',
          fit: BoxFit.fill,
          centerSlice: Rect.fromPoints(const Offset(15,15),const Offset(45, 45)),
          isAntiAlias: true,
          filterQuality: FilterQuality.high,
          width: width,
          height: width,
        ),
        imgPath == null ? Container() :
        IconButton(onPressed: game.doGameHud, icon: Image.asset(imgPath))// (Image.asset(imgPath ?? 'assets/images/inventar2.png',)),
      ]
  );
}

