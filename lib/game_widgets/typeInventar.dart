import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_flame/game_widgets/LootInventar.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/game_styles.dart';

class TypeInventar extends StatelessWidget
{
  final KyrgyzGame game;
  final LootVariant lootVariant;
  final Size size;
  const TypeInventar(this.game,this.lootVariant,this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child:
        SizedBox(
          width: size.width - 15,
          height: size.height - 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              PlayerStats(game ,Size(size.width, size.height)),
              LootInventar(game, lootVariant,Size(size.width, size.height - 20)),
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
    double newWidth = (size.width / 3) / 5;
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
                centerSlice: const Rect.fromLTWH(15, 14, 2, 2),
                width: size.width / 3,
                height: size.height - 60,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    Image.asset('assets/images/inventar/warrior.png', fit: BoxFit.fill,width: newWidth*1.2,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          ValueListenableBuilder (
                              valueListenable: game.playerData.helmetDress,
                              builder: (BuildContext context, value, Widget? child) => Stack(
                                  fit: StackFit.passthrough,
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/inventar/UI-9-sliced object-58.png', fit: BoxFit.fill,width: newWidth,),
                                    Image.asset('assets/${value.source}', fit: BoxFit.fill,width: newWidth * 0.7,),
                                  ])
                          ),
                          ValueListenableBuilder (
                              valueListenable: game.playerData.armorDress,
                              builder: (BuildContext context, value, Widget? child) => Stack(
                                  fit: StackFit.passthrough,
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/inventar/UI-9-sliced object-59.png', fit: BoxFit.fill,width: newWidth,),
                                    Image.asset('assets/${value.source}', fit: BoxFit.fill,width: newWidth * 0.7,),
                                  ])
                          ),
                          ValueListenableBuilder (
                              valueListenable: game.playerData.glovesDress,
                              builder: (BuildContext context, value, Widget? child) => Stack(
                                  fit: StackFit.passthrough,
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/inventar/UI-9-sliced object-60.png', fit: BoxFit.fill,width: newWidth,),
                                    Image.asset('assets/${value.source}', fit: BoxFit.fill,width: newWidth * 0.7,),
                                  ])
                          ),
                        ]
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          ValueListenableBuilder (
                              valueListenable: game.playerData.swordDress,
                              builder: (BuildContext context, value, Widget? child) => Stack(
                                  fit: StackFit.passthrough,
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/inventar/UI-9-sliced object-61.png', fit: BoxFit.fill,width: newWidth,),
                                    Image.asset('assets/${value.source}', fit: BoxFit.fill,width: newWidth * 0.7,),
                                  ])
                          ),
                          ValueListenableBuilder (
                              valueListenable: game.playerData.ringDress,
                              builder: (BuildContext context, value, Widget? child) => Stack(
                                  fit: StackFit.passthrough,
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/inventar/UI-9-sliced object-63.png', fit: BoxFit.fill,width: newWidth,),
                                    Image.asset('assets/${value.source}', fit: BoxFit.fill,width: newWidth * 0.7,),
                                  ])
                          ),
                          ValueListenableBuilder (
                              valueListenable: game.playerData.bootsDress,
                              builder: (BuildContext context, value, Widget? child) => Stack(
                                  fit: StackFit.passthrough,
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/inventar/UI-9-sliced object-60.png', fit: BoxFit.fill,width: newWidth,),
                                    Image.asset('assets/${value.source}', fit: BoxFit.fill,width: newWidth * 0.7,),
                                  ])
                          ),
                        ]
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children:[
                          const Spacer(),
                          Expanded(child: Image.asset('assets/images/inventar/UI-9-sliced object-64.png', fit: BoxFit.fill,width: newWidth/1.1)),
                          Expanded(child: ValueListenableBuilder(valueListenable: game.playerData.health, builder: (context, value, __) => AutoSizeText(value.toInt().toString(), style: defaultTextStyle, minFontSize: 20,))),
                          // Expanded(child: const SizedBox(width: 20,),
                          Expanded(child: Image.asset('assets/images/inventar/UI-9-sliced object-67.png', fit: BoxFit.fill,width: newWidth/1.1,)),
                          Expanded(child: ValueListenableBuilder(valueListenable: game.playerData.hurtMiss, builder: (context, value, __) => AutoSizeText(value.toInt().toString(), style: defaultTextStyle, minFontSize: 20))),
                          const Spacer(),
                        ]
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children:[
                          const Spacer(),
                          Expanded(child: Image.asset('assets/images/inventar/UI-9-sliced object-66.png', fit: BoxFit.fill,width: newWidth/1.1,)),
                          Expanded(child: ValueListenableBuilder(valueListenable: game.playerData.armor, builder: (context, value, __) => AutoSizeText(value.toInt().toString(), style: defaultTextStyle, minFontSize: 20))),
                          // const SizedBox(width: 20,),
                          Expanded(child: Image.asset('assets/images/inventar/UI-9-sliced object-65.png', fit: BoxFit.fill,width: newWidth/1.1,)),
                          Expanded(child: ValueListenableBuilder(valueListenable: game.playerData.damage, builder: (context, value, __) => AutoSizeText(value.toInt().toString(), style: defaultTextStyle, minFontSize: 20))),
                          const Spacer(),
                        ]
                    )
                  ]
              ),
            ]
        ),
      );
  }
}