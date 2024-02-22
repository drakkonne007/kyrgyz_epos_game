import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/game_styles.dart';

enum LootVariant
{
  weapon,
  armor,
  flask,
  item,
}

class LootInventar extends StatefulWidget
{
  const LootInventar(this.game, this.lootVariant, this.mySize);
  final Size mySize;
  final KyrgyzGame game;
  final LootVariant lootVariant;

  @override
  State<StatefulWidget> createState() => _LootInvantarState();
}

class _LootInvantarState extends State<LootInventar>
{
  int _curPage = 0;

  @override
  void initState() {
    _curPage = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    Map<String,int> temp = {};
    switch(widget.lootVariant){
      case LootVariant.weapon:
        temp = widget.game.playerData.weaponInventar;
        break;
      case LootVariant.armor:
        temp = widget.game.playerData.armorInventar;
        break;
      case LootVariant.flask:
        temp = widget.game.playerData.flaskInventar;
        break;
      case LootVariant.item:
        temp = widget.game.playerData.itemInventar;
        break;
    }

    return
      SizedBox(
          width: widget.mySize.width * 0.62,
          height: widget.mySize.height - 40,
          child: Row(
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
                      if(state.contains(MaterialState.focused)
                          || state.contains(MaterialState.hovered)
                          || state.contains(MaterialState.pressed)){
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
                        getLootInventar(temp),
                        const SizedBox(height: 4,),
                        getPageHolderOfInventar(temp)
                      ]
                  )),
              Expanded(
                child: ElevatedButton(
                  onPressed: (){
                    if(_curPage * 16 + 16 < temp.length){
                      setState(() {
                        _curPage++;
                      });
                    }
                  },
                  style: defaultNoneButtonStyle.copyWith(
                    foregroundBuilder: ((context, state, child)
                    {
                      if(state.contains(MaterialState.focused)
                          || state.contains(MaterialState.hovered)
                          || state.contains(MaterialState.pressed)){
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
      );
  }

  Widget getLootInventar(Map<String,int> hash)
  {
    var list = hash.keys.toList(growable: false);
    double minSize = min(widget.mySize.height - 40, widget.mySize.width * 0.5) / 4.5;
    List<Widget> buttonsList = [];
    for(int i = _curPage * 16;i<_curPage * 16 + 16;i++){
      if(i < list.length){
        Item item = itemFromName(list[i]);
        buttonsList.add(
            ElevatedButton(
                onPressed: (){
                  setState(() {
                    item.getEffectFromInventar(widget.game);
                  });
                },
                style: defaultNoneButtonStyle.copyWith(
                  maximumSize: MaterialStateProperty.all<Size>(Size(minSize,minSize)),
                  backgroundBuilder: ((context, state, child){
                    return Stack(
                        fit: StackFit.passthrough,
                        alignment: Alignment.center,
                        children: [
                          Image.asset('assets/images/inventar/UI-9-sliced object-32.png',
                            // centerSlice: const Rect.fromLTWH(6, 6, 20, 20),
                            fit: BoxFit.contain,
                          ),
                          Image.asset('assets/${item.source}',
                            fit: BoxFit.contain,
                            width: minSize/2,
                            height: minSize/2,),
                          Image.asset(checkIfIsEquipNow(item),fit: BoxFit.contain,),
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
                    maximumSize: MaterialStateProperty.all<Size>(Size(minSize,minSize)),
                    backgroundBuilder: ((context, state, child){
                      return Image.asset('assets/images/inventar/UI-9-sliced object-32.png',
                        // centerSlice: const Rect.fromLTWH(6, 6, 20, 20),
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
      return 'assets/images/inventar/UI-9-sliced object-12.png';
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
          width: 17,
          height: 17,
          fit: BoxFit.contain,);

      }else{
        img = Image.asset('assets/images/inventar/passivePageBall.png',
          width: 17,
          height: 17,
          fit: BoxFit.contain,);
      }
      list.add(img);
    }
    if(list.isEmpty){
      list.add(Image.asset('assets/images/inventar/activePageBall.png',
        width: 17,
        height: 17,
        fit: BoxFit.contain,));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }
}

