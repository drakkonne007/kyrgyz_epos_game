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
      case InventarOverlayType.dress:
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

  @override
  Widget build(BuildContext context)
  {
    return ValueListenableBuilder (
        valueListenable: widget.game.currentStateInventar,
        builder: (BuildContext context, value, Widget? child) =>
      SizedBox(
          width: widget.mySize.width * 0.62,
          height: widget.mySize.height,
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 5,),
                Row(
                  children: [
                    Expanded(
                      child:ElevatedButton(
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
                                fit: BoxFit.fitHeight,
                                height: 50,);
                            }
                            return Image.asset('assets/images/inventar/leftPassiveButton.png',
                              fit: BoxFit.fitHeight,
                              height: 50,);
                          }),
                        ),
                        child:  null,
                      ),
                    ),
                    Expanded(flex: 10,
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              getLootInventar(getCurrentItems(value)),
                              const SizedBox(height: 3,),
                              getPageHolderOfInventar(getCurrentItems(value))
                            ]
                        )),
                    Expanded(
                      child: ElevatedButton(
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
                                fit: BoxFit.fitHeight,
                                height: 50,);
                            }
                            return Image.asset('assets/images/inventar/rightPassiveButton.png',
                              fit: BoxFit.fitHeight,
                              height: 50,);
                          }),
                        ),
                        child:  null,
                      ),
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
    double minSize = min(widget.mySize.height - 50, widget.mySize.width * 0.5) / 4.5;
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
                    item.getEffectFromInventar(widget.game);
                  });
                },
                style: defaultNoneButtonStyle.copyWith(
                  maximumSize: WidgetStateProperty.all<Size>(Size(minSize,minSize)),
                  backgroundBuilder: ((context, state, child){
                    return Stack(
                        fit: StackFit.passthrough,
                        alignment: Alignment.center,
                        children: [
                          Image.asset('assets/images/inventar/UI-9-sliced object-42.png',
                            centerSlice: const Rect.fromLTWH(23, 24, 8, 8),
                            fit: BoxFit.contain,
                          ),
                          Image.asset('assets/${item.source}',
                            fit: BoxFit.contain,
                            width: minSize/2,
                            height: minSize/2,),
                          Image.asset(checkIfIsEquipNow(item),fit: BoxFit.contain,
                          centerSlice: const Rect.fromLTWH(17, 17, 24, 26),),
                          AutoSizeText(hash[list[i]]!.toString(),style: defaultTextStyle)
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
                        fit: BoxFit.contain,);
                    })
                ),
                child: null
            )
        );
      }
    }
    return Table(
        children: [
          TableRow(
              children: [buttonsList[0],buttonsList[1],buttonsList[2],buttonsList[3]]
          ),
          TableRow(
              children: [buttonsList[4],buttonsList[5],buttonsList[6],buttonsList[7]]
          ),
          TableRow(
              children: [buttonsList[8],buttonsList[9],buttonsList[10],buttonsList[11]]
          ),
          TableRow(
              children: [buttonsList[12],buttonsList[13],buttonsList[14],buttonsList[15]]
          )
        ]
    );
  }

  String checkIfIsEquipNow(Item item)
  {
    if((item == widget.game.playerData.helmetDress.value || item == widget.game.playerData.armorDress.value || item == widget.game.playerData.bootsDress.value || item == widget.game.playerData.glovesDress.value
        || item == widget.game.playerData.swordDress.value || item == widget.game.playerData.ringDress.value) && item.id != 'nullItem'){
      return 'assets/images/inventar/UI-9-sliced object-14.png';
    }else{
      return 'assets/images/inventar/nullImage.png';
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

