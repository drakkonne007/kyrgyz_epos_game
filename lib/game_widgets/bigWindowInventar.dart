import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/components/physic_vals.dart';
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
              LootInInventar(game, Size(size.width, size.height)),
            ],),
        )
    );
  }
}


String getSignedDiff<T>(T first, T second, {bool withBrace = true})
{
  String answer = '';
  if (first is int && second is int){
    int diff = first - second;
    if(diff < 0){
      answer = diff.toString();
    }else if(diff > 0){
      answer = '+${diff.toString()}';
    }
    if(withBrace){
      return ' ( $answer)';
    }else{
      return answer;
    }
  }else if(first is double && second is double){
    double diff = first - second;
    if(diff < 0){
      answer = diff.toStringAsFixed(2);
    }else if(diff > 0){
      answer = '+${diff.toStringAsFixed(2)}';
    }
    if(withBrace){
      return ' ( $answer)';
    }else{
      return answer;
    }
  }
  return '';
}

class PlayerStats extends StatelessWidget
{
  final KyrgyzGame game;
  final Size size;
  const PlayerStats(this.game, this.size, {super.key});
  final String _chooseEquip = 'assets/images/inventar/UI-9-sliced object-13.png';

  @override
  Widget build(BuildContext context) {
    double newWidth = min((size.width / 3 - 25) / 3, (size.height - 65) / 6);
    double newStrokeHeight = (size.height - newWidth * 2 - 25 - 40) / 7;
    return
      ValueListenableBuilder(
          valueListenable: game.currentItemInInventar, builder: (context, value, __)
      {
        MetaDataForNewItem? metaDataForNewItem = game.playerData.calcNewChoice(value);
        return SizedBox(
          width: size.width * 0.35,
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
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/inventar/gold.png', height: 25,),
                                ValueListenableBuilder(
                                    valueListenable: game.playerData.money,
                                    builder: (context, value, __) =>
                                        SizedBox(height: 25, child: AutoSizeText(
                                          value.toString(),
                                          style: defaultTextStyle,
                                          minFontSize: 15,))),
                              ],
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ValueListenableBuilder(
                                      valueListenable: game.playerData
                                          .helmetDress,
                                      builder: (BuildContext context, value,
                                          Widget? child) =>
                                          ElevatedButton(
                                              onPressed: () {
                                                if(game.currentStateInventar.value !=
                                                    InventarOverlayType.helmet){
                                                  game.currentItemInInventar.value = null;
                                                  game.currentStateInventar.value =
                                                      InventarOverlayType.helmet;
                                                }
                                              },
                                              style: defaultNoneButtonStyle
                                                  .copyWith(
                                                maximumSize: WidgetStateProperty
                                                    .all<Size>(
                                                    Size(newWidth, newWidth)),
                                                backgroundBuilder: ((context,
                                                    state, child) {
                                                  return Stack(
                                                      fit: StackFit.passthrough,
                                                      alignment: Alignment.center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/inventar/UI-9-sliced object-58.png',
                                                          fit: BoxFit.fill,
                                                          width: newWidth,),
                                                        Image.asset(
                                                          'assets/${value
                                                              .source}',
                                                          fit: BoxFit.fill,
                                                          width: newWidth * 0.6,),
                                                        ValueListenableBuilder(
                                                          valueListenable: game
                                                              .currentStateInventar,
                                                          builder: (
                                                              BuildContext context,
                                                              value,
                                                              Widget? child) =>
                                                              Image.asset(value ==
                                                                  InventarOverlayType
                                                                      .helmet
                                                                  ? _chooseEquip
                                                                  : 'assets/images/inventar/nullImage.png',
                                                                  centerSlice: const Rect
                                                                      .fromLTWH(
                                                                      17, 17, 24,
                                                                      26),
                                                                  width: newWidth),
                                                        )
                                                      ]);
                                                }),
                                              ),
                                              child: null
                                          )
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: game.playerData.armorDress,
                                      builder: (BuildContext context, value,
                                          Widget? child) =>
                                          ElevatedButton(
                                              onPressed: () {
                                                if(game.currentStateInventar.value !=
                                                    InventarOverlayType.armor){
                                                  game.currentItemInInventar.value = null;
                                                  game.currentStateInventar.value =
                                                      InventarOverlayType.armor;
                                                }
                                              },
                                              style: defaultNoneButtonStyle
                                                  .copyWith(
                                                maximumSize: WidgetStateProperty
                                                    .all<Size>(
                                                    Size(newWidth, newWidth)),
                                                backgroundBuilder: ((context,
                                                    state, child) {
                                                  return Stack(
                                                      fit: StackFit.passthrough,
                                                      alignment: Alignment.center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/inventar/UI-9-sliced object-59.png',
                                                          fit: BoxFit.fill,
                                                          width: newWidth,),
                                                        Image.asset(
                                                          'assets/${value
                                                              .source}',
                                                          fit: BoxFit.fill,
                                                          width: newWidth * 0.6,),
                                                        ValueListenableBuilder(
                                                          valueListenable: game
                                                              .currentStateInventar,
                                                          builder: (
                                                              BuildContext context,
                                                              value,
                                                              Widget? child) =>
                                                              Image.asset(value ==
                                                                  InventarOverlayType
                                                                      .armor
                                                                  ? _chooseEquip
                                                                  : 'assets/images/inventar/nullImage.png',
                                                                  centerSlice: const Rect
                                                                      .fromLTWH(
                                                                      17, 17, 24,
                                                                      26),
                                                                  width: newWidth),
                                                        )
                                                      ]
                                                  );
                                                }),
                                              ),
                                              child: null
                                          )
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: game.playerData
                                          .glovesDress,
                                      builder: (BuildContext context, value,
                                          Widget? child) =>
                                          ElevatedButton(
                                              onPressed: () {
                                                if(game.currentStateInventar.value !=
                                                    InventarOverlayType.gloves){
                                                  game.currentItemInInventar.value = null;
                                                  game.currentStateInventar.value =
                                                      InventarOverlayType.gloves;
                                                }
                                              },
                                              style: defaultNoneButtonStyle
                                                  .copyWith(
                                                maximumSize: WidgetStateProperty
                                                    .all<Size>(
                                                    Size(newWidth, newWidth)),
                                                backgroundBuilder: ((context,
                                                    state, child) {
                                                  return Stack(
                                                      fit: StackFit.passthrough,
                                                      alignment: Alignment.center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/inventar/UI-9-sliced object-60.png',
                                                          fit: BoxFit.fill,
                                                          width: newWidth,),
                                                        Image.asset(
                                                          'assets/${value
                                                              .source}',
                                                          fit: BoxFit.fill,
                                                          width: newWidth * 0.6,),
                                                        ValueListenableBuilder(
                                                          valueListenable: game
                                                              .currentStateInventar,
                                                          builder: (
                                                              BuildContext context,
                                                              value,
                                                              Widget? child) =>
                                                              Image.asset(value ==
                                                                  InventarOverlayType
                                                                      .gloves
                                                                  ? _chooseEquip
                                                                  : 'assets/images/inventar/nullImage.png',
                                                                  centerSlice: const Rect
                                                                      .fromLTWH(
                                                                      17, 17, 24,
                                                                      26),
                                                                  width: newWidth),
                                                        )
                                                      ]
                                                  );
                                                }),
                                              ),
                                              child: null
                                          )
                                  ),
                                ]
                            ),
                            SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ValueListenableBuilder(
                                      valueListenable: game.playerData.swordDress,
                                      builder: (BuildContext context, value,
                                          Widget? child) =>
                                          ElevatedButton(
                                              onPressed: () {
                                                if(game.currentStateInventar.value !=
                                                    InventarOverlayType.sword){
                                                  game.currentItemInInventar.value = null;
                                                  game.currentStateInventar.value =
                                                      InventarOverlayType.sword;
                                                }
                                              },
                                              style: defaultNoneButtonStyle
                                                  .copyWith(
                                                maximumSize: WidgetStateProperty
                                                    .all<Size>(
                                                    Size(newWidth, newWidth)),
                                                backgroundBuilder: ((context,
                                                    state, child) {
                                                  return Stack(
                                                      fit: StackFit.passthrough,
                                                      alignment: Alignment.center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/inventar/UI-9-sliced object-61.png',
                                                          fit: BoxFit.fill,
                                                          width: newWidth,),
                                                        Image.asset(
                                                          'assets/${value
                                                              .source}',
                                                          fit: BoxFit.fill,
                                                          width: newWidth * 0.6,),
                                                        ValueListenableBuilder(
                                                          valueListenable: game
                                                              .currentStateInventar,
                                                          builder: (
                                                              BuildContext context,
                                                              value,
                                                              Widget? child) =>
                                                              Image.asset(value ==
                                                                  InventarOverlayType
                                                                      .sword
                                                                  ? _chooseEquip
                                                                  : 'assets/images/inventar/nullImage.png',
                                                                  centerSlice: const Rect
                                                                      .fromLTWH(
                                                                      17, 17, 24,
                                                                      26),
                                                                  width: newWidth),
                                                        )
                                                      ]
                                                  );
                                                }),
                                              ),
                                              child: null
                                          )
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: game.playerData.ringDress,
                                      builder: (BuildContext context, value,
                                          Widget? child) =>
                                          ElevatedButton(
                                              onPressed: () {
                                                if(game.currentStateInventar.value !=
                                                    InventarOverlayType.ring){
                                                  game.currentItemInInventar.value = null;
                                                  game.currentStateInventar.value =
                                                      InventarOverlayType.ring;
                                                }
                                              },
                                              style: defaultNoneButtonStyle
                                                  .copyWith(
                                                maximumSize: WidgetStateProperty
                                                    .all<Size>(
                                                    Size(newWidth, newWidth)),
                                                backgroundBuilder: ((context,
                                                    state, child) {
                                                  return Stack(
                                                      fit: StackFit.passthrough,
                                                      alignment: Alignment.center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/inventar/UI-9-sliced object-62.png',
                                                          fit: BoxFit.fill,
                                                          width: newWidth,),
                                                        Image.asset(
                                                          'assets/${value
                                                              .source}',
                                                          fit: BoxFit.fill,
                                                          width: newWidth * 0.6,),
                                                        ValueListenableBuilder(
                                                          valueListenable: game
                                                              .currentStateInventar,
                                                          builder: (
                                                              BuildContext context,
                                                              value,
                                                              Widget? child) =>
                                                              Image.asset(value ==
                                                                  InventarOverlayType
                                                                      .ring
                                                                  ? _chooseEquip
                                                                  : 'assets/images/inventar/nullImage.png',
                                                                  centerSlice: const Rect
                                                                      .fromLTWH(
                                                                      17, 17, 24,
                                                                      26),
                                                                  width: newWidth),
                                                        )
                                                      ]
                                                  );
                                                }),
                                              ),
                                              child: null
                                          )
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: game.playerData.bootsDress,
                                      builder: (BuildContext context, value,
                                          Widget? child) =>
                                          ElevatedButton(
                                              onPressed: () {
                                                if(game.currentStateInventar.value !=
                                                    InventarOverlayType.boots){
                                                  game.currentItemInInventar.value = null;
                                                  game.currentStateInventar.value =
                                                      InventarOverlayType.boots;
                                                }
                                              },
                                              style: defaultNoneButtonStyle
                                                  .copyWith(
                                                maximumSize: WidgetStateProperty
                                                    .all<Size>(
                                                    Size(newWidth, newWidth)),
                                                backgroundBuilder: ((context,
                                                    state, child) {
                                                  return Stack(
                                                      fit: StackFit.passthrough,
                                                      alignment: Alignment.center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/inventar/UI-9-sliced object-63.png',
                                                          fit: BoxFit.fill,
                                                          width: newWidth,),
                                                        Image.asset(
                                                          'assets/${value
                                                              .source}',
                                                          fit: BoxFit.fill,
                                                          width: newWidth * 0.6,),
                                                        ValueListenableBuilder(
                                                          valueListenable: game
                                                              .currentStateInventar,
                                                          builder: (
                                                              BuildContext context,
                                                              value,
                                                              Widget? child) =>
                                                              Image.asset(value ==
                                                                  InventarOverlayType
                                                                      .boots
                                                                  ? _chooseEquip
                                                                  : 'assets/images/inventar/nullImage.png',
                                                                  centerSlice: const Rect
                                                                      .fromLTWH(
                                                                      17, 17, 24,
                                                                      26),
                                                                  width: newWidth),
                                                        )
                                                      ]
                                                  );
                                                }),
                                              ),
                                              child: null
                                          )
                                  ),
                                ]
                            ),
                            ),
                            SizedBox(
                              height: newStrokeHeight,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image.asset(
                                      'assets/images/inventar/healthInInventar.png',
                                      width: size.width / 17,
                                      height: newStrokeHeight,
                                      fit: BoxFit.contain,
                                      alignment: Alignment.centerLeft,),
                                    const SizedBox(width: 3,),
                                    ValueListenableBuilder(
                                        valueListenable: game.playerData.health,
                                        builder: (context, value, __) =>
                                            Expanded(child: Align(
                                                alignment: Alignment.centerRight,
                                                child: SizedBox(
                                                    child: AutoSizeText('${value.toInt().toString()} / ${game.playerData.maxHealth.value.toInt().toString()}'
                                                        + (metaDataForNewItem != null ? (metaDataForNewItem.health != value || metaDataForNewItem.maxHealth != game.playerData.maxHealth.value
                                                            ? ' (' + getSignedDiff(metaDataForNewItem.health, game.playerData.health.value, withBrace: false) + ' / ' + getSignedDiff(metaDataForNewItem.maxHealth, game.playerData.maxHealth.value, withBrace: false) + ')' : '') : ''),
                                                      style: (metaDataForNewItem != null) ? metaDataForNewItem.health > value ? defaultInventarTextStyleGood : metaDataForNewItem.health < value ? defaultInventarTextStyleBad : defaultInventarTextStyle : defaultInventarTextStyle,
                                                      minFontSize: 10,
                                                      maxLines: 1,))))),
                                  ]
                              ),
                            ),
                            SizedBox(
                              height: newStrokeHeight,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image.asset(
                                      'assets/images/inventar/manaInInventar.png',
                                      width: size.width / 17,
                                      height: newStrokeHeight,
                                      fit: BoxFit.contain,
                                      alignment: Alignment.centerLeft,),
                                    const SizedBox(width: 3,),
                                    ValueListenableBuilder(
                                        valueListenable: game.playerData.mana,
                                        builder: (context, value, __) =>
                                            Expanded(child: Align(
                                                alignment: Alignment.centerRight,
                                                child: SizedBox(
                                                    child: AutoSizeText('${value.toInt().toString()} / ${game.playerData.maxMana.value.toInt().toString()}'
                                                        + (metaDataForNewItem != null ? (metaDataForNewItem.mana != value || metaDataForNewItem.maxMana != game.playerData.maxMana.value
                                                            ? ' (' + getSignedDiff(metaDataForNewItem.mana, game.playerData.mana.value, withBrace: false) +
                                                            ' / ' + getSignedDiff(metaDataForNewItem.maxMana, game.playerData.maxMana.value, withBrace: false) + ')' : '') : ''),
                                                      style: (metaDataForNewItem != null) ? metaDataForNewItem.mana > value ? defaultInventarTextStyleGood : metaDataForNewItem.mana < value ? defaultInventarTextStyleBad : defaultInventarTextStyle : defaultInventarTextStyle,
                                                      minFontSize: 10,
                                                      maxLines: 1,))))),
                                  ]
                              ),
                            ),
                            SizedBox(
                              height: newStrokeHeight,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image.asset(
                                      'assets/images/inventar/staminaInInventar.png',
                                      width: size.width / 17,
                                      height: newStrokeHeight,
                                      fit: BoxFit.contain,
                                      alignment: Alignment.centerLeft,),
                                    const SizedBox(width: 3,),
                                    ValueListenableBuilder(
                                        valueListenable: game.playerData.energy,
                                        builder: (context, value, __) =>
                                            Expanded(child: Align(
                                                alignment: Alignment.centerRight,
                                                child: SizedBox(
                                                    child: AutoSizeText('${value.toInt().toString()} / ${game.playerData.maxEnergy.value.toInt().toString()}'
                                                        + (metaDataForNewItem != null ? (metaDataForNewItem.energy != value || metaDataForNewItem.maxEnergy != game.playerData.maxEnergy.value
                                                            ? ' (' + getSignedDiff(metaDataForNewItem.energy, game.playerData.energy.value, withBrace: false) + ' / ' + getSignedDiff(metaDataForNewItem.maxEnergy, game.playerData.maxEnergy.value, withBrace: false) + ')' : '') : ''),
                                                      style: (metaDataForNewItem != null) ? metaDataForNewItem.energy > value ? defaultInventarTextStyleGood : metaDataForNewItem.energy < value ? defaultInventarTextStyleBad : defaultInventarTextStyle : defaultInventarTextStyle,
                                                      minFontSize: 10,
                                                      maxLines: 1,))))),
                                  ]
                              ),
                            ),
                            SizedBox(
                              height: newStrokeHeight,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image.asset(
                                      'assets/images/inventar/UI-9-sliced object-66Less.png',
                                      width: size.width / 17,
                                      height: newStrokeHeight,
                                      fit: BoxFit.contain,
                                      alignment: Alignment.centerLeft,),
                                    const SizedBox(width: 3,),
                                    Expanded(flex: 1, child: SizedBox(
                                        child: AutoSizeText('Броня',
                                            style: defaultInventarTextStyle,
                                            minFontSize: 10,
                                            maxLines: 1))),
                                    ValueListenableBuilder(
                                        valueListenable: game.playerData.armor,
                                        builder: (context, value, __) =>
                                            Expanded(child: Align(
                                                alignment: Alignment.centerRight,
                                                child: SizedBox(child:
                                                AutoSizeText(
                                                    '${value.toStringAsFixed(
                                                        2)}' + (metaDataForNewItem != null ? (metaDataForNewItem.armor != value ? getSignedDiff(metaDataForNewItem.armor, value) : '') : ''),
                                                    style: (metaDataForNewItem != null) ? metaDataForNewItem.armor > value ? defaultInventarTextStyleGood : metaDataForNewItem.armor < value ? defaultInventarTextStyleBad : defaultInventarTextStyle : defaultInventarTextStyle,
                                                    minFontSize: 10,
                                                    maxLines: 1
                                                )
                                                )))),
                                  ]
                              ),
                            ),
                            SizedBox(
                              height: newStrokeHeight,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image.asset(
                                      'assets/images/inventar/UI-9-sliced object-65Less.png',
                                      width: size.width / 17,
                                      height: newStrokeHeight,
                                      fit: BoxFit.contain,
                                      alignment: Alignment.centerLeft,),
                                    const SizedBox(width: 3,),
                                    Expanded(flex: 1, child: SizedBox(
                                        child: AutoSizeText('Урон',
                                            style: defaultInventarTextStyle,
                                            minFontSize: 10,
                                            maxLines: 1))),
                                    ValueListenableBuilder(
                                        valueListenable: game.playerData
                                            .swordDress,
                                        builder: (context, value, __) =>
                                            Expanded(child: Align(
                                                alignment: Alignment.centerRight,
                                                child: SizedBox(
                                                    child: AutoSizeText(
                                                        '${value.damage.toStringAsFixed(
                                                            2)}' + (metaDataForNewItem != null ? (metaDataForNewItem.damage != value.damage ? getSignedDiff(metaDataForNewItem.damage, value.damage) : '') : ''),
                                                        style: (metaDataForNewItem != null) ? metaDataForNewItem.damage > value.damage ? defaultInventarTextStyleGood : metaDataForNewItem.damage < value.damage ? defaultInventarTextStyleBad : defaultInventarTextStyle : defaultInventarTextStyle,
                                                        minFontSize: 10,
                                                        maxLines: 1
                                                    ))))),
                                  ]
                              ),
                            ),

                            SizedBox(
                              height: newStrokeHeight,
                              child: ValueListenableBuilder(
                                valueListenable: game.playerData
                                    .swordDress,
                                builder: (context, value, __) =>
                                    Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image.asset(
                                      'assets/${getMagicStateString(value.magicDamage)}',
                                      // 'assets/images/inventar/magicSword.png',
                                      width: size.width / 17,
                                      height: newStrokeHeight,
                                      fit: BoxFit.contain,
                                      alignment: Alignment.centerLeft,),
                                    const SizedBox(width: 3,),
                                    Expanded(flex: 1, child: SizedBox(
                                        child: AutoSizeText('Магический урон',
                                          style: defaultInventarTextStyle,
                                          minFontSize: 10,
                                          maxLines: 2,))),

                                            Expanded(child: Align(
                                                alignment: Alignment.centerRight,
                                                child: SizedBox(
                                                    child: AutoSizeText(
                                                      (value.permanentDamage *
                                                          value.secsOfPermDamage)
                                                          .toStringAsFixed(2) + (metaDataForNewItem != null ? (metaDataForNewItem.permanentDamage * metaDataForNewItem.secsOfPermanentDamage != value.permanentDamage * value.secsOfPermDamage
                                                          ? getSignedDiff(metaDataForNewItem.permanentDamage * metaDataForNewItem.secsOfPermanentDamage, value.permanentDamage * value.secsOfPermDamage)
                                                          : '') : ''),
                                                      style: (metaDataForNewItem != null) ? metaDataForNewItem.permanentDamage *
                                                          metaDataForNewItem.secsOfPermanentDamage > value.permanentDamage *
                                                          value.secsOfPermDamage ? defaultInventarTextStyleGood : metaDataForNewItem.permanentDamage *
                                                          metaDataForNewItem.secsOfPermanentDamage < value.permanentDamage *
                                                          value.secsOfPermDamage ? defaultInventarTextStyleBad : defaultInventarTextStyle : defaultInventarTextStyle,
                                                      minFontSize: 10,
                                                      maxLines: 1,)))),
                                  ])
                              ),
                            ),
                            SizedBox(
                              height: newStrokeHeight,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image.asset(
                                      'assets/images/inventar/UI-9-sliced object-65Speed.png',
                                      width: size.width / 17,
                                      height: newStrokeHeight,
                                      fit: BoxFit.contain,
                                      alignment: Alignment.centerLeft,),
                                    const SizedBox(width: 3,),
                                    Expanded(flex: 1, child: SizedBox(
                                        child: AutoSizeText('Скорость атаки',
                                          style: defaultInventarTextStyle,
                                          minFontSize: 10,
                                          maxLines: 2,))),
                                    ValueListenableBuilder(
                                        valueListenable: game.playerData
                                            .swordDress,
                                        builder: (context, value, __) =>
                                            Expanded(child: Align(
                                                alignment: Alignment.centerRight,
                                                child: SizedBox(
                                                    child: AutoSizeText(
                                                      (0.7 + value.attackSpeed)
                                                          .toStringAsFixed(2)
                                                          + (metaDataForNewItem != null ? (metaDataForNewItem.attackSpeed != value.attackSpeed
                                                          ? getSignedDiff(0.7 + metaDataForNewItem.attackSpeed,0.7 + value.attackSpeed)
                                                          : '') : ''),
                                                      style: (metaDataForNewItem != null) ? metaDataForNewItem.attackSpeed < value.attackSpeed ? defaultInventarTextStyleGood : metaDataForNewItem.attackSpeed > value.attackSpeed ? defaultInventarTextStyleBad : defaultInventarTextStyle : defaultInventarTextStyle,
                                                      minFontSize: 10,
                                                      maxLines: 1,))))),
                                  ]
                              ),
                            )
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
      });
  }
}