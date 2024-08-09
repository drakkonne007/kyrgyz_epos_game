import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/game_styles.dart';

class LootInInventar extends StatefulWidget
{
  const LootInInventar(this.game, this.mySize, {super.key});
  final Size mySize;
  final KyrgyzGame game;
  final String asset = 'assets/images/inventar/UI-9-sliced object-14.png';
  final String assetRed = 'assets/images/inventar/UI-9-sliced object-12.png';

  @override
  State<StatefulWidget> createState() => _LootInvantarState();
}

class _LootInvantarState extends State<LootInInventar>
{
  int _curPage = 0;

  @override
  void initState() {
    _curPage = 0;
    super.initState();
  }

  Map<String,int> getCurrentItems(InventarOverlayType type)
  {
    Map<String,int> temp = {};
    // temp = widget.game.playerData.weaponInventar;
    switch(type){
      case InventarOverlayType.armor:
        temp = widget.game.playerData.bodyArmorInventar;
        break;
      case InventarOverlayType.helmet:
        temp = widget.game.playerData.helmetInventar;
        break;
      case InventarOverlayType.gloves:
        temp = widget.game.playerData.glovesInventar;
        break;
      case InventarOverlayType.boots:
        temp = widget.game.playerData.bootsInventar;
        break;
      case InventarOverlayType.sword:
        temp = widget.game.playerData.swordInventar;
        break;
      case InventarOverlayType.ring:
        temp = widget.game.playerData.ringInventar;
        break;
      case InventarOverlayType.flask:
        temp = widget.game.playerData.flaskInventar;
        break;
      case InventarOverlayType.item:
        temp = widget.game.playerData.itemInventar;
        break;
      case InventarOverlayType.quests:
      // TODO: Handle this case.
      // TODO: Handle this case.
      case InventarOverlayType.map:
      // TODO: Handle this case.
    }
    return temp;
  }

  List<Widget> infoAboutChoosen()
  {
    if(widget.game.currentItemInInventar.value == null){
      return [];
    }
    List<Widget> myList = [];
    Item temp = widget.game.currentItemInInventar.value!;
    double rowHeight = widget.mySize.height / 10;
    double rowWidth = widget.mySize.width * 0.62 - 10 - 40 - min(widget.mySize.height - 50, widget.mySize.width * 0.5 - widget.mySize.width * 0.1);
    myList.add(Container(constraints: BoxConstraints.expand(width: rowWidth, height: 30),child:
    Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
        children:[Image.asset('assets/images/inventar/gold.png'),AutoSizeText(temp.cost.toString(),
          style: defaultInventarTextStyle,
          minFontSize: 10,
          maxLines: 1,)])
    ));
    if(temp.dressType == DressType.none){
      double secs = temp.secsOfPermDamage == 0 ? 1 : temp.secsOfPermDamage;
      if(temp.hp != 0) {
        myList.add(Container(constraints: BoxConstraints.expand(
            width: rowWidth, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/inventar/UI-9-sliced object-55.png',
                fit: BoxFit.contain, alignment: Alignment.centerLeft,)
              ,const Spacer(),
              AutoSizeText(temp.hp * secs > widget.game.playerData.maxHealth.value
                  ? 'Full'
                  : (temp.hp * secs).toStringAsFixed(1),style: defaultInventarTextStyle,
                minFontSize: 10,
                maxLines: 1,),
              const Spacer()
            ])));
      }
      if(temp.energy != 0) {
        myList.add(Container(constraints: BoxConstraints.expand(
            width: rowWidth, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/inventar/UI-9-sliced object-56.png',
                fit: BoxFit.contain, alignment: Alignment.centerLeft,)
              ,
              const Spacer(),
              AutoSizeText(
                temp.energy * secs > widget.game.playerData.maxEnergy.value
                    ? 'Full'
                    : (temp.energy * secs).toStringAsFixed(1),style: defaultInventarTextStyle,
                minFontSize: 10,
                maxLines: 1,)
              ,const Spacer()
            ])));
      }
      myList.add(Container(constraints: BoxConstraints.expand(
          width: rowWidth, height: rowHeight), child:
      Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/inventar/clock.png',
              fit: BoxFit.contain, alignment: Alignment.centerLeft,)
            ,
            const Spacer(),
            AutoSizeText(temp.secsOfPermDamage.toString(),style: defaultInventarTextStyle,
              minFontSize: 10,
              maxLines: 1,)
            ,const Spacer()
          ])));
      myList.add(Container(constraints: BoxConstraints.expand(width: rowWidth, height: rowHeight),child:
      ElevatedButton(onPressed: (){
        setState(() {
          temp.getEffectFromInventar(
              widget.game);
        });},
          child: const Text('Использовать'))));
    }else{
      if(temp.hp != 0) {
        myList.add(Container(constraints: BoxConstraints.expand(
            width: rowWidth, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/inventar/healthInInventar.png',
                fit: BoxFit.contain, alignment: Alignment.centerLeft,)
              ,
              const Spacer()
              ,
              AutoSizeText(
                temp.hp.toStringAsFixed(2), style: defaultInventarTextStyle,
                minFontSize: 10,
                maxLines: 1,),
              const Spacer()
            ])));
      }
      if(temp.energy != 0) {
        myList.add(Container(constraints: BoxConstraints.expand(
            width: rowWidth, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/inventar/staminaInInventar.png',
                fit: BoxFit.contain, alignment: Alignment.centerLeft,)
              ,
              const Spacer()
              ,
              AutoSizeText(
                temp.energy.toStringAsFixed(2), style: defaultInventarTextStyle,
                minFontSize: 10,
                maxLines: 1,),
              const Spacer()
            ])));
      }
      if(temp.armor != 0) {
        myList.add(Container(constraints: BoxConstraints.expand(width: rowWidth, height: rowHeight),child:
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/inventar/UI-9-sliced object-66Less.png',fit: BoxFit.contain, alignment: Alignment.centerLeft,)
              ,const Spacer()
              ,AutoSizeText(temp.armor.toStringAsFixed(2),style: defaultInventarTextStyle,
                minFontSize: 10,
                maxLines: 1,),
              const Spacer()])));
      }
      if(temp.damage != 0) {
        myList.add(Container(constraints: BoxConstraints.expand(
            width: rowWidth, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/inventar/UI-9-sliced object-65Less.png',
                fit: BoxFit.contain, alignment: Alignment.centerLeft,)
              ,
              const Spacer()
              ,
              AutoSizeText(
                temp.damage.toStringAsFixed(2), style: defaultInventarTextStyle,
                minFontSize: 10,
                maxLines: 1,)
              ,
              const Spacer()
            ])));
      }

      if(temp.permanentDamage != 0) {
        myList.add(Container(constraints: BoxConstraints.expand(
            width: rowWidth, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/inventar/magicSword.png', fit: BoxFit.contain,
                alignment: Alignment.centerLeft,)
              ,
              const Spacer(),
              AutoSizeText((temp.permanentDamage * temp.secsOfPermDamage).toStringAsFixed(1),style: defaultInventarTextStyle,
                minFontSize: 10,
                maxLines: 1,)
              ,const Spacer()
            ])));
        myList.add(Container(constraints: BoxConstraints.expand(
            width: rowWidth, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/inventar/clock.png',
                fit: BoxFit.contain, alignment: Alignment.centerLeft,)
              ,
              const Spacer(),
              AutoSizeText(temp.secsOfPermDamage.toString(),style: defaultInventarTextStyle,
                minFontSize: 10,
                maxLines: 1,)
              ,const Spacer()
            ])));

      }
      bool isEquip = false;
      switch(temp.dressType){
        case DressType.none:
          break;
        case DressType.helmet:
          isEquip = temp == widget.game.playerData.helmetDress.value;
        case DressType.armor:
          isEquip = temp == widget.game.playerData.armorDress.value;
        case DressType.gloves:
          isEquip = temp == widget.game.playerData.glovesDress.value;
        case DressType.sword:
          isEquip = temp == widget.game.playerData.swordDress.value;
        case DressType.ring:
          isEquip = temp == widget.game.playerData.ringDress.value;
        case DressType.boots:
          isEquip = temp == widget.game.playerData.bootsDress.value;
      }
      myList.add(Container(constraints: BoxConstraints.expand(
          width: rowWidth, height: rowHeight),
          child: ElevatedButton(onPressed: () {
            setState(() {
              temp.getEffectFromInventar(
                  widget.game);
            });
          }, child: Text(isEquip ? 'Снять' :  'Надеть'))));
    }
    return myList;
  }

  @override
  Widget build(BuildContext context)
  {
    return ValueListenableBuilder (
        valueListenable: widget.game.currentStateInventar,
        builder: (BuildContext context, value, Widget? child) =>
            SizedBox(
                width: widget.mySize.width * 0.62 - 10,
                height: widget.mySize.height,
                child:
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: infoAboutChoosen()
                          ),

                          ElevatedButton(
                            onPressed: (){
                              if(_curPage > 0){
                                setState(() {
                                  _curPage--;
                                });
                              }
                            },
                            style: defaultNoneButtonStyle.copyWith(
                              foregroundBuilder: ((context, state, child)
                              {
                                if(state.contains(WidgetState.focused)
                                    || state.contains(WidgetState.hovered)
                                    || state.contains(WidgetState.pressed)){
                                  return Image.asset('assets/images/inventar/leftActiveButton.png',
                                    width: 20,
                                    fit: BoxFit.fitWidth,);
                                }
                                return Image.asset('assets/images/inventar/leftPassiveButton.png',
                                  width: 20,
                                  fit: BoxFit.fitWidth,);
                              }),
                            ),
                            child:  null,
                          ),
                          Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:[
                                getLootInventar(getCurrentItems(value)),
                                const SizedBox(height: 3,),
                                getPageHolderOfInventar(getCurrentItems(value))
                              ]
                          ),
                          ElevatedButton(
                            onPressed: (){
                              if(_curPage * 16 + 16 < getCurrentItems(value).length){
                                setState(() {
                                  _curPage++;
                                });
                              }
                            },
                            style: defaultNoneButtonStyle.copyWith(
                              foregroundBuilder: ((context, state, child)
                              {
                                if(state.contains(WidgetState.focused)
                                    || state.contains(WidgetState.hovered)
                                    || state.contains(WidgetState.pressed)){
                                  return Image.asset('assets/images/inventar/rightActiveButton.png',
                                      width: 20,
                                      fit: BoxFit.fitWidth);
                                }
                                return Image.asset('assets/images/inventar/rightPassiveButton.png',
                                  width: 20,
                                  fit: BoxFit.fitWidth,);
                              }),
                            ),
                            child:  null,
                          ),
                        ],
                      )
                    ])
            )
    );
  }

  Widget getLootInventar(Map<String,int> hash)
  {
    var list = hash.keys.toList(growable: false);
    double minSize = min(widget.mySize.height - 50, widget.mySize.width * 0.5 - widget.mySize.width * 0.1);
    List<Widget> buttonsList = [];
    for(int i = _curPage * 16;i<_curPage * 16 + 16;i++){
      if(i < list.length){
        Item item = itemFromName(list[i]);
        buttonsList.add(
            ElevatedButton(
                onPressed: (){
                  if(!item.enabled){
                    return;
                  }
                  setState(() {
                    widget.game.currentItemInInventar.value = item;
                    // item.getEffectFromInventar(widget.game);
                  });
                },
                style: defaultNoneButtonStyle.copyWith(
                  maximumSize: WidgetStateProperty.all<Size>(Size(minSize,minSize)),
                  backgroundBuilder: ((context, state, child){
                    return Stack(
                        fit: StackFit.loose,
                        alignment: Alignment.center,
                        children: [
                          Image.asset('assets/images/inventar/UI-9-sliced object-42.png',
                            width: minSize/4,
                            height: minSize/4,
                            centerSlice: const Rect.fromLTWH(23, 24, 8, 8),
                            fit: BoxFit.contain,
                          ),
                          Image.asset('assets/${item.source}',
                            fit: BoxFit.contain,
                            width: minSize/8,
                            height: minSize/8,),
                          checkIfIsEquipNow(item) ? Image.asset(item == widget.game.currentItemInInventar.value ? widget.assetRed : widget.asset,fit: BoxFit.contain,
                            width: minSize/4,
                            height: minSize/4,
                            centerSlice: const Rect.fromLTWH(17, 17, 24, 26),) : const SizedBox(width: 0,height: 0,),
                          (item == widget.game.currentItemInInventar.value && !checkIfIsEquipNow(item) ? Image.asset('assets/images/inventar/UI-9-sliced object-13.png',fit: BoxFit.contain,
                            width: minSize/4,
                            height: minSize/4,
                            centerSlice: const Rect.fromLTWH(17, 17, 24, 26),) : const SizedBox(width: 0,height: 0,)),
                          SizedBox(
                              width: minSize/4,
                              height: minSize/4,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    alignment: Alignment.center,
                                    height: minSize/15,
                                    margin: const EdgeInsets.only(bottom: 3),
                                    child: AutoSizeText('x${hash[list[i]]!.toString()}',style: defaultInventarTextStyleGood.copyWith(shadows: [const Shadow(color: Colors.black, blurRadius: 7)])
                                      ,

                                    )             ),
                              )
                          ),

                        ]
                    );
                  }),
                ),
                child: null
            )
        );
      }else{
        buttonsList.add(
            ElevatedButton(
                onPressed: null,
                style: defaultNoneButtonStyle.copyWith(
                    maximumSize: WidgetStateProperty.all<Size>(Size(minSize,minSize)),
                    backgroundBuilder: ((context, state, child){
                      return Image.asset('assets/images/inventar/UI-9-sliced object-42.png',
                        centerSlice: const Rect.fromLTWH(23, 24, 8, 8),
                        width: minSize/4,
                        height: minSize/4,
                        fit: BoxFit.contain,);
                    })
                ),
                child: null
            )
        );
      }
    }
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [buttonsList[0],buttonsList[1],buttonsList[2],buttonsList[3]]
          ),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [buttonsList[4],buttonsList[5],buttonsList[6],buttonsList[7]]
          ),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [buttonsList[8],buttonsList[9],buttonsList[10],buttonsList[11]]
          ),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [buttonsList[12],buttonsList[13],buttonsList[14],buttonsList[15]]
          )
        ]
    );
  }

  bool checkIfIsEquipNow(Item item)
  {
    if((item == widget.game.playerData.helmetDress.value || item == widget.game.playerData.armorDress.value || item == widget.game.playerData.bootsDress.value || item == widget.game.playerData.glovesDress.value
        || item == widget.game.playerData.swordDress.value || item == widget.game.playerData.ringDress.value) && item.id != 'nullItem'){
      return true;
    }else{
      return false;
    }
  }

  Widget getPageHolderOfInventar(Map<String,int> hash)
  {
    List<Widget> list = [];
    for(int i=0;i<hash.length / 16;i++){
      Image? img;
      if(i == _curPage){
        img = Image.asset('assets/images/inventar/activePageBall.png',
          width: 14,
          height: 14,
          fit: BoxFit.contain,);

      }else{
        img = Image.asset('assets/images/inventar/passivePageBall.png',
          width: 14,
          height: 14,
          fit: BoxFit.contain,);
      }
      list.add(img);
    }
    if(list.isEmpty){
      list.add(Image.asset('assets/images/inventar/activePageBall.png',
        width: 14,
        height: 14,
        fit: BoxFit.contain,));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }
}

