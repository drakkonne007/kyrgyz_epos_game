import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_flame/game_widgets/LootInventar.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/game_styles.dart';

class BigWindowInventar extends StatelessWidget
{
  final KyrgyzGame game;
  final Size size;
  const BigWindowInventar(this.game,this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child:
        SizedBox(
          width: size.width - 15,
          height: size.height - 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              PlayerStats(game ,Size(size.width, size.height)),
              LootInInventar(game, Size(size.width, size.height - 20)),
            ],),
        )
    );
  }
}

class PlayerStats extends StatelessWidget
{
  final KyrgyzGame game;
  final Size size;
  const PlayerStats(this.game, this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    double newWidth = (size.width / 3) / 4.5;
    return
      SizedBox(
        width: size.width / 3,
        height: size.height - 20,
        child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            fit: StackFit.passthrough,
            children:
            [
              Image.asset('assets/images/inventar/UI-9-sliced object-5.png',
                centerSlice: const Rect.fromLTWH(30, 28, 4, 4),
                width: size.width / 3,
                height: size.height - 60,
              ),
              Center(
                child:
                SizedBox(
                    width: size.width / 3 - 25,
                  height: size.height - 40,
                  child:Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/inventar/gold.png',height: 27,),
                            ValueListenableBuilder(valueListenable: game.playerData.money, builder: (context, value, __) => AutoSizeText(value.toString(), style: defaultTextStyle, minFontSize: 18,)),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              ValueListenableBuilder (
                                  valueListenable: game.playerData.helmetDress,
                                  builder: (BuildContext context, value, Widget? child) =>
                                      ElevatedButton(
                                          onPressed: (){
                                            game.currentStateInventar.value = InventarOverlayType.helmet;
                                          },
                                          style: defaultNoneButtonStyle.copyWith(
                                            maximumSize: WidgetStateProperty.all<Size>(Size(newWidth,newWidth)),
                                            backgroundBuilder: ((context, state, child){
                                              return Stack(
                                                  fit: StackFit.passthrough,
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Image.asset('assets/images/inventar/UI-9-sliced object-58.png', fit: BoxFit.fill,width: newWidth,),
                                                    Image.asset('assets/${value.source}', fit: BoxFit.fill,width: newWidth * 0.6,),
                                                  ]
                                              );
                                            }),
                                          ),
                                          child: null
                                      )
                              ),
                              ValueListenableBuilder (
                                  valueListenable: game.playerData.armorDress,
                                  builder: (BuildContext context, value, Widget? child) =>
                                      ElevatedButton(
                                          onPressed: (){
                                            game.currentStateInventar.value = InventarOverlayType.armor;
                                          },
                                          style: defaultNoneButtonStyle.copyWith(
                                            maximumSize: WidgetStateProperty.all<Size>(Size(newWidth,newWidth)),
                                            backgroundBuilder: ((context, state, child){
                                              return Stack(
                                                  fit: StackFit.passthrough,
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Image.asset('assets/images/inventar/UI-9-sliced object-59.png', fit: BoxFit.fill,width: newWidth,),
                                                    Image.asset('assets/${value.source}', fit: BoxFit.fill,width: newWidth * 0.6,),
                                                  ]
                                              );
                                            }),
                                          ),
                                          child: null
                                      )
                              ),
                              ValueListenableBuilder (
                                  valueListenable: game.playerData.glovesDress,
                                  builder: (BuildContext context, value, Widget? child) =>
                                      ElevatedButton(
                                          onPressed: (){
                                            game.currentStateInventar.value = InventarOverlayType.gloves;
                                          },
                                          style: defaultNoneButtonStyle.copyWith(
                                            maximumSize: WidgetStateProperty.all<Size>(Size(newWidth,newWidth)),
                                            backgroundBuilder: ((context, state, child){
                                              return Stack(
                                                  fit: StackFit.passthrough,
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Image.asset('assets/images/inventar/UI-9-sliced object-60.png', fit: BoxFit.fill,width: newWidth,),
                                                    Image.asset('assets/${value.source}', fit: BoxFit.fill,width: newWidth * 0.6,),
                                                  ]
                                              );
                                            }),
                                          ),
                                          child: null
                                      )
                              ),
                            ]
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              ValueListenableBuilder (
                                  valueListenable: game.playerData.swordDress,
                                  builder: (BuildContext context, value, Widget? child) =>
                                      ElevatedButton(
                                          onPressed: (){
                                            game.currentStateInventar.value = InventarOverlayType.sword;
                                          },
                                          style: defaultNoneButtonStyle.copyWith(
                                            maximumSize: WidgetStateProperty.all<Size>(Size(newWidth,newWidth)),
                                            backgroundBuilder: ((context, state, child){
                                              return Stack(
                                                  fit: StackFit.passthrough,
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Image.asset('assets/images/inventar/UI-9-sliced object-61.png', fit: BoxFit.fill,width: newWidth,),
                                                    Image.asset('assets/${value.source}', fit: BoxFit.fill,width: newWidth * 0.6,),
                                                  ]
                                              );
                                            }),
                                          ),
                                          child: null
                                      )
                              ),
                              ValueListenableBuilder (
                                  valueListenable: game.playerData.ringDress,
                                  builder: (BuildContext context, value, Widget? child) =>
                                      ElevatedButton(
                                          onPressed: (){
                                            game.currentStateInventar.value = InventarOverlayType.ring;
                                          },
                                          style: defaultNoneButtonStyle.copyWith(
                                            maximumSize: WidgetStateProperty.all<Size>(Size(newWidth,newWidth)),
                                            backgroundBuilder: ((context, state, child){
                                              return Stack(
                                                  fit: StackFit.passthrough,
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Image.asset('assets/images/inventar/UI-9-sliced object-62.png', fit: BoxFit.fill,width: newWidth,),
                                                    Image.asset('assets/${value.source}', fit: BoxFit.fill,width: newWidth * 0.6,),
                                                  ]
                                              );
                                            }),
                                          ),
                                          child: null
                                      )
                              ),
                              ValueListenableBuilder (
                                  valueListenable: game.playerData.bootsDress,
                                  builder: (BuildContext context, value, Widget? child) =>
                                      ElevatedButton(
                                          onPressed: (){
                                            game.currentStateInventar.value = InventarOverlayType.boots;
                                          },
                                          style: defaultNoneButtonStyle.copyWith(
                                            maximumSize: WidgetStateProperty.all<Size>(Size(newWidth,newWidth)),
                                            backgroundBuilder: ((context, state, child){
                                              return Stack(
                                                  fit: StackFit.passthrough,
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Image.asset('assets/images/inventar/UI-9-sliced object-63.png', fit: BoxFit.fill,width: newWidth,),
                                                    Image.asset('assets/${value.source}', fit: BoxFit.fill,width: newWidth * 0.6,),
                                                  ]
                                              );
                                            }),
                                          ),
                                          child: null
                                      )
                              ),
                            ]
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children:[
                              Image.asset('assets/images/inventar/UI-9-sliced object-55.png', height: 21,),
                              ValueListenableBuilder(valueListenable: game.playerData.health, builder: (context, value, __) => AutoSizeText('${value.toInt().toString()} / ${game.playerData.maxHealth.value.toInt().toString()}', style: defaultTextStyle, minFontSize: 10,)),
                            ]
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children:[
                              Image.asset('assets/images/inventar/UI-9-sliced object-56.png', height: 21,),
                              ValueListenableBuilder(valueListenable: game.playerData.energy, builder: (context, value, __) => AutoSizeText('${value.toInt().toString()} / ${game.playerData.maxEnergy.value.toInt().toString()}', style: defaultTextStyle, minFontSize: 10)),
                            ]
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children:[
                              Image.asset('assets/images/inventar/UI-9-sliced object-66Less.png', ),//height: (size.height - 40 - 27 - ((size.width / 3) / 4.5) * 2 - 42) / 4,fit: BoxFit.fill),
                              ValueListenableBuilder(valueListenable: game.playerData.armor, builder: (context, value, __) => AutoSizeText(value.toStringAsPrecision(2), style: defaultTextStyle, minFontSize: 10)),
                            ]
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children:[
                              Image.asset('assets/images/inventar/UI-9-sliced object-65Less.png', ),// height: (size.height - 40 - 27 - ((size.width / 3) / 4.5) * 2 - 42) / 4,fit: BoxFit.fill),
                              ValueListenableBuilder(valueListenable: game.playerData.swordDress, builder: (context, value, __) => AutoSizeText(value.damage.toStringAsPrecision(2), style: defaultTextStyle, minFontSize: 10)),
                            ]
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children:[
                              Image.asset('assets/images/inventar/magicSword.png', ),//height: (size.height - 40 - 27 - ((size.width / 3) / 4.5) * 2 - 42) / 4,fit: BoxFit.fill),
                              AutoSizeText('Магический урон ', style: defaultTextStyle, minFontSize: 10),
                              ValueListenableBuilder(valueListenable: game.playerData.swordDress, builder: (context, value, __) => AutoSizeText((value.permanentDamage * value.secsOfPermDamage).toStringAsPrecision(2), style: defaultTextStyle, minFontSize: 10)),
                            ]
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children:[
                              Image.asset('assets/images/inventar/UI-9-sliced object-65Speed.png', ),//height: (size.height - 40 - 27 - ((size.width / 3) / 4.5) * 2 - 42) / 4,fit: BoxFit.fill),
                              AutoSizeText('Скорость атаки ', style: defaultTextStyle, minFontSize: 10),
                              ValueListenableBuilder(valueListenable: game.playerData.swordDress, builder: (context, value, __) => AutoSizeText((0.7 + value.attackSpeed).toStringAsPrecision(2), style: defaultTextStyle, minFontSize: 10)),
                            ]
                        ),
                        // Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisSize: MainAxisSize.min,
                        //     children:[
                        //       Image.asset('assets/images/inventar/UI-9-sliced object-56.png'),
                        //       ValueListenableBuilder(valueListenable: game.playerData.energy, builder: (context, value, __) => AutoSizeText('${value.toInt().toString()} / ${game.playerData.maxEnergy.value.toInt().toString()}', style: defaultTextStyle, minFontSize: 10)),
                        //     ]
                        // ),
                        // Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisSize: MainAxisSize.min,
                        //     children:[
                        //       const Spacer(),
                        //       Expanded(child: Image.asset('assets/images/inventar/UI-9-sliced object-66.png', fit: BoxFit.fill,width: newWidth/1.1,)),
                        //       Expanded(child: ValueListenableBuilder(valueListenable: game.playerData.armor, builder: (context, value, __) => AutoSizeText(value.toInt().toString(), style: defaultTextStyle, minFontSize: 20))),
                        //       // const SizedBox(width: 20,),
                        //       Expanded(child: Image.asset('assets/images/inventar/UI-9-sliced object-65.png', fit: BoxFit.fill,width: newWidth/1.1,)),
                        //       Expanded(child: ValueListenableBuilder(valueListenable: game.playerData.damage, builder: (context, value, __) => AutoSizeText(value.toInt().toString(), style: defaultTextStyle, minFontSize: 20))),
                        //       const Spacer(),
                        //     ]
                        // )
                      ]
                  ),
              )
              )


            ]
        ),
      );
  }
}