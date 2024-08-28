import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/game_styles.dart';

class BuyOverlay extends StatefulWidget
{
  static const id = 'BuyOverlay';
  final KyrgyzGame game;

  const BuyOverlay(this.game, {super.key});

  @override
  State<BuyOverlay> createState() => _BuyOverlayState();
}

class PlaceInOrder
{
  PlaceInOrder(this.item, this.isPlayer);
  Item item;
  bool isPlayer;

  @override
  String toString() {
    return 'PlaceInOrder{item: $item, isPlayer: $isPlayer}';
  }

  @override
  operator ==(Object other) {
    if(other is PlaceInOrder){
      return item.id == other.item.id && isPlayer == other.isPlayer;
    };
    return false;
  }

  @override
  int get hashCode => item.id.hashCode ^ isPlayer.hashCode;

}

class _BuyOverlayState extends State<BuyOverlay> {
  late Size _size;
  int gold = 0; //Оно будет прибавляться к твоему золоту
  Map<String, int> helmets = {};
  Map<String, int> armors = {};
  Map<String, int> gloves = {};
  Map<String, int> swords = {};
  Map<String, int> rings = {};
  Map<String, int> boots = {};
  Map<String, int> flasks = {};
  Map<String, int> items = {};

  Map<String, int> playerHelmets = {};
  Map<String, int> playerArmors = {};
  Map<String, int> playerGloves = {};
  Map<String, int> playerSwords = {};
  Map<String, int> playerRings = {};
  Map<String, int> playerBoots = {};
  Map<String, int> playerFlasks = {};
  Map<String, int> playerItems = {};

  int _myInventarPage = 0;
  int _shopInventarPage = 0;

  int _money = 0;

  Map<PlaceInOrder, int> _dealList = {};

  @override
  void dispose() {
    helmets = {};
    armors = {};
    gloves = {};
    swords = {};
    rings = {};
    boots = {};
    flasks = {};
    items = {};

    playerHelmets = {};
    playerArmors = {};
    playerGloves = {};
    playerSwords = {};
    playerRings = {};
    playerBoots = {};
    playerFlasks = {};
    playerItems = {};

    _money = 0;

    super.dispose();
  }


  @override
  void initState() {
    _money = 0;

    helmets = {};
    armors = {};
    gloves = {};
    swords = {};
    rings = {};
    boots = {};
    flasks = {};
    items = {};

    playerHelmets = widget.game.playerData.helmetInventar;
    playerArmors = widget.game.playerData.bodyArmorInventar;
    playerGloves = widget.game.playerData.glovesInventar;
    playerSwords = widget.game.playerData.swordInventar;
    playerRings = widget.game.playerData.ringInventar;
    playerBoots = widget.game.playerData.bootsInventar;
    playerFlasks = widget.game.playerData.flaskInventar;
    playerItems = widget.game.playerData.itemInventar;

    _myInventarPage = 0;
    _shopInventarPage = 0;


    for (final str in widget.game.currentShopItems.keys) {
      Item item = itemFromName(str);
      switch (item.dressType) {
        case InventarType.helmet:
          helmets[item.id] = widget.game.currentShopItems[str]!;
          break;
        case InventarType.bodyArmor:
          armors[item.id] = widget.game.currentShopItems[str]!;
          break;
        case InventarType.gloves:
          gloves[item.id] = widget.game.currentShopItems[str]!;
          break;
        case InventarType.sword:
          swords[item.id] = widget.game.currentShopItems[str]!;
          break;
        case InventarType.ring:
          rings[item.id] = widget.game.currentShopItems[str]!;
          break;
        case InventarType.boots:
          boots[item.id] = widget.game.currentShopItems[str]!;
          break;
        case InventarType.flask:
          flasks[item.id] = widget.game.currentShopItems[str]!;
          break;
        case InventarType.item:
          items[item.id] = widget.game.currentShopItems[str]!;
          break;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery
        .of(context)
        .size;
    final shopList = getItems(true);
    final playerList = getItems(false);
    return
      Center(
          child:
          Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
              [
                SizedBox(
                    width: _size.width * 0.8,
                    height: 60,
                    child:
                    Stack(
                      fit: StackFit.passthrough,
                        children:
                        [
                          Positioned.fill(
                            child:
                            Image.asset('assets/images/inventar/UI-9-sliced object-35.png',
                              fit: BoxFit.fill,
                              centerSlice: const Rect.fromLTWH(8, 8, 34 , 38),
                              alignment: Alignment.center,
                            ),
                          ),
                          Row(
                              children:
                              [
                                const SizedBox(width: 50,),
                                AutoSizeText('До', textAlign: TextAlign.left,
                                    style: defaultInventarTextStyle,
                                    minFontSize: 10,
                                    maxLines: 1),
                                Image.asset('assets/images/inventar/gold.png',
                                  width: 40, fit: BoxFit.fitWidth,),
                                AutoSizeText(widget.game.playerData.money.value.toString(), textAlign: TextAlign.left,
                                    style: defaultInventarTextStyleGold,
                                    minFontSize: 10,
                                    maxLines: 1),
                                const Spacer(),
                                AutoSizeText('После', textAlign: TextAlign.left,
                                    style: defaultInventarTextStyle,
                                    minFontSize: 10,
                                    maxLines: 1),
                                Image.asset('assets/images/inventar/gold.png',
                                  width: 40, fit: BoxFit.fitWidth,),
                                AutoSizeText((widget.game.playerData.money.value + _money).toString(), textAlign: TextAlign.left,
                                    style: widget.game.playerData.money.value + _money > 0 ? defaultInventarTextStyleGold : defaultInventarTextStyleBad,
                                    minFontSize: 10,
                                    maxLines: 1),
                                const SizedBox(width: 50,),
                              ]
                          ),
                        ]
                    )
                ),
                Stack(
                    alignment: Alignment.center,
                    fit: StackFit.passthrough,
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset('assets/images/inventar/UI-9-sliced object-31.png',
                        fit: BoxFit.fill,
                        centerSlice: const Rect.fromLTWH(18, 18, 14, 20),
                        isAntiAlias: true,
                        filterQuality: FilterQuality.high,
                        width: _size.width * 0.95,
                        height: _size.height * 0.8,
                      ),
                      SizedBox(
                          width: _size.width * 0.9,
                          height: _size.height * 0.78,
                          child:
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                              [
                                SizedBox(
                                  width: _size.width * 0.3,
                                  height: _size.height * 0.75,
                                  child: CustomScrollView(
                                    slivers: <Widget>[
                                      SliverAppBar(
                                        backgroundColor: const Color(0xFFdfc08e),
                                        shadowColor: const Color(0xFF739461),
                                        pinned: true,
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.arrow_circle_left),
                                            onPressed: () {
                                              setState(() {
                                                _myInventarPage++;
                                                _myInventarPage = _myInventarPage < 0
                                                    ? 7
                                                    : _myInventarPage > 7
                                                    ? 0
                                                    : _myInventarPage;
                                              });
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.arrow_circle_right),
                                            onPressed: () {
                                              setState(() {
                                                _myInventarPage--;
                                                _myInventarPage = _myInventarPage < 0
                                                    ? 7
                                                    : _myInventarPage > 7
                                                    ? 0
                                                    : _myInventarPage;
                                              });
                                            },
                                          ),
                                        ],
                                        expandedHeight: 70.0,
                                        flexibleSpace: FlexibleSpaceBar(
                                          centerTitle: true,
                                          title: Text(getName(false)),
                                        ),
                                      ),
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                            childCount: playerList.length,
                                                (BuildContext context, int index) {
                                              Item curItem = itemFromName(
                                                  playerList.keys.toList(
                                                      growable: false)[index]);
                                              int count = playerList[curItem.id]!;
                                              return ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _money += (curItem.cost / 10).ceil();
                                                      count--;
                                                      if(count == 0){
                                                        playerList.remove(curItem.id);
                                                      }else{
                                                        playerList[curItem.id] = count;
                                                      }
                                                      PlaceInOrder newOrder = PlaceInOrder(curItem, true);
                                                      if(_dealList.containsKey(newOrder)){
                                                        _dealList.update(newOrder, (value) => value+1);
                                                      }else {
                                                        _dealList.putIfAbsent(newOrder, () => 1);
                                                      }
                                                    });
                                                  },
                                                  child: null,
                                                  style: defaultNoneButtonStyle
                                                      .copyWith(
                                                    backgroundBuilder: ((context, state,
                                                        child) {
                                                      return Stack(
                                                          alignment: Alignment.center,
                                                          fit: StackFit.passthrough,
                                                          children:
                                                          [
                                                            Container(
                                                              width: _size.width * 0.3,
                                                              alignment: Alignment.center,
                                                              margin: const EdgeInsets.all(3),
                                                              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: const Color(0xFF739461)
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(15),
                                                                  boxShadow: const [BoxShadow(color: Color(0xFF705c4d), spreadRadius: 1, blurRadius: 1)]
                                                              ),
                                                              child:Column(
                                                                  children: infoAboutChoosen(curItem,false,count,false)
                                                              ),
                                                            ),
                                                            isNowDress(curItem) ?  Positioned.fill(
                                                                child:  Padding(
                                                                    padding: const EdgeInsets.all(2),
                                                                    child: Image.asset('assets/images/inventar/UI-9-sliced object-12.png',
                                                                      centerSlice: const Rect
                                                                          .fromLTWH(
                                                                          17, 17, 24,
                                                                          26),
                                                                    ))) : Container()
                                                            // Image.asset('assets/images/inventar/UI-9-sliced object-13.png',
                                                            //   centerSlice: const Rect
                                                            //       .fromLTWH(
                                                            //       17, 17, 24,
                                                            //       26),
                                                            // )
                                                          ]
                                                      );
                                                    }),
                                                  ));
                                            }
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  width: _size.width * 0.3,
                                  height: _size.height * 0.75,
                                  child: CustomScrollView(
                                    slivers: <Widget>[
                                      SliverAppBar(
                                        pinned: true,
                                        expandedHeight: 70,
                                        backgroundColor: const Color(0xFFdfc08e),
                                        shadowColor: const Color(0xFF739461),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.cancel),
                                            onPressed: widget.game.doGameHud,
                                          ),
                                        ],
                                        flexibleSpace: const FlexibleSpaceBar(
                                          centerTitle: true,
                                          title: Text('Обмен'),
                                        ),
                                      ),
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          childCount: _dealList.length,
                                              (BuildContext context, int index) {
                                            var orderPlace = _dealList.keys.toList(growable: false)[index];
                                            int count = _dealList[orderPlace]!;
                                            return ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    count--;
                                                    if(count == 0){
                                                      _dealList.remove(orderPlace);
                                                    }else{
                                                      _dealList[orderPlace] = count;
                                                    }
                                                    if(orderPlace.isPlayer){
                                                      _money -= (orderPlace.item.cost / 10).ceil();
                                                    }else{
                                                      _money += orderPlace.item.cost;
                                                    }
                                                    returnItemToOwner(orderPlace.item,orderPlace.isPlayer);
                                                  });
                                                },
                                                child: null,
                                                style: defaultNoneButtonStyle
                                                    .copyWith(
                                                  backgroundBuilder: ((context, state,
                                                      child) {
                                                    return Container(
                                                        width: _size.width * 0.3,
                                                        alignment: Alignment.center,
                                                        margin: const EdgeInsets.all(3),
                                                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: const Color(0xFF739461)
                                                          ),
                                                          color: orderPlace.isPlayer ? const Color(0xDFFF5c4d) : const Color(0xDF70FF4d),
                                                          borderRadius: BorderRadius.circular(15),
                                                          // boxShadow: [BoxShadow(color: orderPlace.isPlayer ? const Color(0xDFFF5c4d) : const Color(0xDF70FF4d), spreadRadius: 1, blurRadius: 1)]
                                                        ),
                                                        child:
                                                        Column(
                                                            children: infoAboutChoosen(orderPlace.item,!orderPlace.isPlayer,count,true)
                                                        )
                                                    );
                                                  }),
                                                ));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    width: _size.width * 0.3,
                                    height: _size.height * 0.75,
                                    child: CustomScrollView(
                                      slivers: <Widget>[
                                        SliverAppBar(
                                          backgroundColor: const Color(0xFFdfc08e),
                                          shadowColor: const Color(0xFF739461),
                                          pinned: true,
                                          expandedHeight: 70,
                                          actions: [
                                            IconButton(
                                              icon: const Icon(Icons.arrow_circle_left),
                                              onPressed: () {
                                                setState(() {
                                                  _shopInventarPage++;
                                                  _shopInventarPage =
                                                  _shopInventarPage < 0
                                                      ? 7
                                                      : _shopInventarPage > 7
                                                      ? 0
                                                      : _shopInventarPage;
                                                });
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.arrow_circle_right),
                                              onPressed: () {
                                                setState(() {
                                                  _shopInventarPage--;
                                                  _shopInventarPage =
                                                  _shopInventarPage < 0
                                                      ? 7
                                                      : _shopInventarPage > 7
                                                      ? 0
                                                      : _shopInventarPage;
                                                });
                                              },
                                            ),
                                          ],
                                          flexibleSpace: FlexibleSpaceBar(
                                            centerTitle: true,
                                            title: Text(getName(true)),
                                          ),
                                        ),
                                        SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                            childCount: shopList.length,
                                                (BuildContext context, int index) {
                                              Item curItem = itemFromName(
                                                  shopList.keys.toList(
                                                      growable: false)[index]);
                                              int count = shopList[curItem.id]!;
                                              return ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _money -= curItem.cost;
                                                      count--;
                                                      if(count == 0){
                                                        shopList.remove(curItem.id);
                                                      }else{
                                                        shopList[curItem.id] = count;
                                                      }
                                                      PlaceInOrder newOrder = PlaceInOrder(curItem, false);
                                                      if(_dealList.containsKey(newOrder)){
                                                        _dealList.update(newOrder, (value) => value+1);
                                                      }else {
                                                        _dealList.putIfAbsent(newOrder, () => 1);
                                                      }
                                                    });
                                                  },
                                                  child: null,
                                                  style: defaultNoneButtonStyle
                                                      .copyWith(
                                                    backgroundBuilder: ((context, state,
                                                        child) {
                                                      return Container(
                                                          width: _size.width * 0.3,
                                                          alignment: Alignment.center,
                                                          margin: const EdgeInsets.all(3),
                                                          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: const Color(0xFF739461)
                                                              ),
                                                              borderRadius: BorderRadius.circular(15),
                                                              boxShadow: const [BoxShadow(color: Color(0xFF705c4d), spreadRadius: 1, blurRadius: 1)]
                                                          ),
                                                          child:
                                                          Column(
                                                              children: infoAboutChoosen(curItem,true,count,false)
                                                          )
                                                      );
                                                    }),
                                                  ));
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                )
                              ]
                          )
                      )
                    ]
                ),
              ]

          )

      );
  }

  bool isNowDress(Item item)
  {
    switch(item.dressType) {
      case InventarType.helmet:
        return widget.game.playerData.helmetDress.value.id == item.id;
      case InventarType.bodyArmor:
        return widget.game.playerData.armorDress.value.id == item.id;
      case InventarType.gloves:
        return widget.game.playerData.glovesDress.value.id == item.id;
      case InventarType.boots:
        return widget.game.playerData.bootsDress.value.id == item.id;
      case InventarType.sword:
        return widget.game.playerData.swordDress.value.id == item.id;
      case InventarType.ring:
        return widget.game.playerData.ringDress.value.id == item.id;
      default: return false;
    }
  }

  void returnItemToOwner(Item item, bool toPlayer)
  {
    switch(item.dressType){
      case InventarType.helmet:
        {
          if (toPlayer) {
            if(playerHelmets.containsKey(item.id)){
              playerHelmets.update(item.id, (value) => value + 1);
            }else{
              playerHelmets[item.id] = 1;
            }
          }else{
            if(helmets.containsKey(item.id)){
              helmets.update(item.id, (value) => value + 1);
            }else{
              helmets[item.id] = 1;
            }
          }
        }
        break;
      case InventarType.bodyArmor:
        {
          if (toPlayer) {
            if(playerArmors.containsKey(item.id)){
              playerArmors.update(item.id, (value) => value + 1);
            }else{
              playerArmors[item.id] = 1;
            }
          }else{
            if(armors.containsKey(item.id)){
              armors.update(item.id, (value) => value + 1);
            }else{
              armors[item.id] = 1;
            }
          }
        }
        break;
      case InventarType.gloves:
        {
          if (toPlayer) {
            if(playerGloves.containsKey(item.id)){
              playerGloves.update(item.id, (value) => value + 1);
            }else{
              playerGloves[item.id] = 1;
            }
          }else{
            if(gloves.containsKey(item.id)){
              gloves.update(item.id, (value) => value + 1);
            }else{
              gloves[item.id] = 1;
            }
          }
        }
        break;
      case InventarType.boots:
        {
          if (toPlayer) {
            if(playerBoots.containsKey(item.id)){
              playerBoots.update(item.id, (value) => value + 1);
            }else{
              playerBoots[item.id] = 1;
            }
          }else{
            if(boots.containsKey(item.id)){
              boots.update(item.id, (value) => value + 1);
            }else{
              boots[item.id] = 1;
            }
          }
        }
        break;
      case InventarType.sword:
        {
          if (toPlayer) {
            if(playerSwords.containsKey(item.id)){
              playerSwords.update(item.id, (value) => value + 1);
            }else{
              playerSwords[item.id] = 1;
            }
          }else{
            if(swords.containsKey(item.id)){
              swords.update(item.id, (value) => value + 1);
            }else{
              swords[item.id] = 1;
            }
          }
        }
        break;
      case InventarType.ring:
        {
          if (toPlayer) {
            if(playerRings.containsKey(item.id)){
              playerRings.update(item.id, (value) => value + 1);
            }else{
              playerRings[item.id] = 1;
            }
          }else{
            if(rings.containsKey(item.id)){
              rings.update(item.id, (value) => value + 1);
            }else{
              rings[item.id] = 1;
            }
          }
        }
        break;
      case InventarType.flask:
        {
          if (toPlayer) {
            if(playerFlasks.containsKey(item.id)){
              playerFlasks.update(item.id, (value) => value + 1);
            }else{
              playerFlasks[item.id] = 1;
            }
          }else{
            if(flasks.containsKey(item.id)){
              flasks.update(item.id, (value) => value + 1);
            }else{
              flasks[item.id] = 1;
            }
          }
        }
        break;
      case InventarType.item:
        {
          if (toPlayer) {
            if(playerItems.containsKey(item.id)){
              playerItems.update(item.id, (value) => value + 1);
            }else{
              playerItems[item.id] = 1;
            }
          }else{
            if(items.containsKey(item.id)){
              items.update(item.id, (value) => value + 1);
            }else{
              items[item.id] = 1;
            }
          }
        }
        break;
    }
  }

  String getName(bool shopPage) {
    // _shopInventarPage = _shopInventarPage < 0 ? 7 : _shopInventarPage > 7 ? 0 : _shopInventarPage;
    int val;
    if (shopPage) {
      val = _shopInventarPage;
    } else {
      val = _myInventarPage;
    }
    switch (val) {
      case 0:
        return 'Шлемы';
      case 1:
        return 'Доспехи';
      case 2:
        return 'Перчатки';
      case 3:
        return 'Мечи';
      case 4:
        return 'Кольца';
      case 5:
        return 'Ботинки';
      case 6:
        return 'Фляги';
      default:
        return 'Предметы';
    }
  }

  Map<String, int> getItems(bool shop) {
    int val;
    if (shop) {
      val = _shopInventarPage;
    } else {
      val = _myInventarPage;
    }
    if (!shop) {
      switch (val) {
        case 0:
          return widget.game.playerData.helmetInventar;
        case 1:
          return widget.game.playerData.bodyArmorInventar;
        case 2:
          return widget.game.playerData.glovesInventar;
        case 3:
          return widget.game.playerData.swordInventar;
        case 4:
          return widget.game.playerData.ringInventar;
        case 5:
          return widget.game.playerData.bootsInventar;
        case 6:
          return widget.game.playerData.flaskInventar;
        default:
          return widget.game.playerData.itemInventar;
      }
    }
    switch (val) {
      case 0:
        return helmets;
      case 1:
        return armors;
      case 2:
        return gloves;
      case 3:
        return swords;
      case 4:
        return rings;
      case 5:
        return boots;
      case 6:
        return flasks;
      default:
        return items;
    }
  }

  List<Widget> infoAboutChoosen(Item myItem, bool isShop, int count, bool isOrder) {
    List<Widget> myList = [];
    const double rowHeight = 35;
    myList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
        [
          Image.asset('assets/${myItem.source}',
            width: 64, fit: BoxFit.contain, height: 64,),
          const Spacer(),
          Image.asset('assets/images/inventar/gold.png',
            width: 40, fit: BoxFit.fitWidth,),
          AutoSizeText(isShop ? myItem.cost.toString() : (myItem.cost / 10).ceil().toString(), textAlign: TextAlign.left,
              style: isOrder ? defaultInventarTextStyle : defaultInventarTextStyleGold,
              minFontSize: 10,
              maxLines: 1),
          const Spacer(),
          AutoSizeText('x$count', textAlign: TextAlign.right,
              style: defaultInventarTextStyle,
              minFontSize: 10,
              maxLines: 1),
        ]
    ));
    if (myItem.description != null) {
      myList.add(Container(constraints: const BoxConstraints.expand(
          width: double.infinity, height: rowHeight * 4), child:
      AutoSizeText(myItem.description!,
        textAlign: TextAlign.center,
        style: defaultInventarTextStyle,
        minFontSize: 10,
        maxLines: 2,)
      ));
    }
    if (myItem.dressType == InventarType.flask ||
        myItem.dressType == InventarType.item) {
      double secs = myItem.secsOfPermDamage == 0 ? 1 : myItem.secsOfPermDamage;
      if (myItem.hp != 0) {
        myList.add(Container(constraints: const BoxConstraints.expand(
            width: double.infinity, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Image.asset('assets/images/inventar/UI-9-sliced object-55.png',
                    width: rowHeight / 1.5,
                    height: rowHeight / 1.5,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerRight,))
              ,Expanded(
                // alignment: Alignment.centerRight,
                //   margin: const EdgeInsets.only(left: 10),
                //   height: rowHeight,
                  child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child:AutoSizeText((myItem.hp * secs).toStringAsFixed(1),
                        style: defaultInventarTextStyle,
                        minFontSize: 10,
                        textAlign: TextAlign.left,
                        maxLines: 1,)))
            ])));
      }
      if (myItem.mana != 0) {
        myList.add(Container(constraints: const BoxConstraints.expand(
            width: double.infinity, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Image.asset(
                    'assets/images/inventar/UI-9-sliced object-56Mana.png',
                    fit: BoxFit.contain,
                    width: rowHeight / 1.5,
                    height: rowHeight / 1.5,
                    alignment: Alignment.centerRight,))
              , Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: AutoSizeText((myItem.hp * secs).toStringAsFixed(1),
                        style: defaultInventarTextStyle,
                        minFontSize: 10,
                        textAlign: TextAlign.left,
                        maxLines: 1,)))
            ])));
      }
      if (myItem.energy != 0) {
        myList.add(Container(constraints: const BoxConstraints.expand(
            width: double.infinity, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:Image.asset('assets/images/inventar/UI-9-sliced object-56.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.centerRight,
                    width: rowHeight / 1.5,
                    height: rowHeight / 1.5,))
              ,
              Expanded(
                  child:Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: AutoSizeText(
                        myItem.energy * secs >
                            widget.game.playerData.maxEnergy.value
                            ? 'Full'
                            : (myItem.energy * secs).toStringAsFixed(1),
                        style: defaultInventarTextStyle,
                        minFontSize: 10,
                        textAlign: TextAlign.left,
                        maxLines: 1,)))
            ])));
      }
      myList.add(Container(constraints: const BoxConstraints.expand(
          width: double.infinity, height: rowHeight), child:
      Row(mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child:Image.asset('assets/images/inventar/clock.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.centerRight,
                  height: rowHeight,))
            , Expanded(
                child:Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: AutoSizeText(myItem.secsOfPermDamage.toString(),
                      style: defaultInventarTextStyle,
                      minFontSize: 10,
                      textAlign: TextAlign.left,
                      maxLines: 1,)))
          ])));
    } else {
      if (myItem.hp != 0) {
        myList.add(Container(constraints: const BoxConstraints.expand(
            width: double.infinity, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:Image.asset('assets/images/inventar/healthInInventar.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.centerRight,
                    width: rowHeight,))
              ,
              Expanded(
                  child:Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: AutoSizeText(
                      textAlign: TextAlign.left,
                      myItem.hp.toStringAsFixed(2),
                      style: defaultInventarTextStyle,
                      minFontSize: 10,
                      maxLines: 1,),)),
            ])));
      }
      if (myItem.mana != 0) {
        myList.add(Container(constraints: const BoxConstraints.expand(
            width: double.infinity, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:Image.asset('assets/images/inventar/manaInInventar.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.centerRight,
                    width: rowHeight,))
              ,
              Expanded(
                  child:Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: AutoSizeText(
                      textAlign: TextAlign.left,
                      myItem.mana.toStringAsFixed(2),
                      style: defaultInventarTextStyle,
                      minFontSize: 10,
                      maxLines: 1,),))
            ])));
      }
      if (myItem.energy != 0) {
        myList.add(Container(constraints: const BoxConstraints.expand(
            width: double.infinity, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:Image.asset('assets/images/inventar/staminaInInventar.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.centerRight,
                    width: rowHeight,))
              , Expanded(
                  child:Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: AutoSizeText(
                        myItem.energy.toStringAsFixed(2),
                        style: defaultInventarTextStyle,
                        minFontSize: 10,
                        textAlign: TextAlign.left,
                        maxLines: 1,)))
            ])));
      }
      if (myItem.armor != 0) {
        myList.add(Container(constraints: const BoxConstraints.expand(
            width: double.infinity, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:Image.asset(
                    'assets/images/inventar/UI-9-sliced object-66Less.png',
                    height: rowHeight,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerRight,))
              , Expanded(
                  child:Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: AutoSizeText(myItem.armor.toStringAsFixed(2),
                        style: defaultInventarTextStyle,
                        minFontSize: 10,
                        textAlign: TextAlign.left,
                        maxLines: 1,)))
            ])));
      }
      if (myItem.damage != 0) {
        myList.add(Container(constraints: const BoxConstraints.expand(
            width: double.infinity, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:Image.asset(
                    'assets/images/inventar/UI-9-sliced object-65Less.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.centerRight,
                    height: rowHeight,))
              , Expanded(
                  child:Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: AutoSizeText(
                        myItem.damage.toStringAsFixed(2),
                        style: defaultInventarTextStyle,
                        minFontSize: 10,
                        textAlign: TextAlign.left,
                        maxLines: 1,)))
            ])));
      }

      if (myItem.permanentDamage != 0 || myItem.secsOfPermDamage != 0) {
        myList.add(Container(constraints: const BoxConstraints.expand(
            width: double.infinity, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:
                      [
                        Image.asset('assets/${getMagicStateString(myItem.magicDamage)}',
                          fit: BoxFit.contain,
                          height: rowHeight,
                          alignment: Alignment.center,)
                        ,Image.asset(myItem.magicSpellVariant ==
                          MagicSpellVariant.circle
                          ? 'assets/images/inventar/aroundSpell.png'
                          : 'assets/images/inventar/forwardSpell.png',
                        height: rowHeight,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,),
                      ]
                  )),

              Expanded(
                  child:Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: AutoSizeText(
                        (myItem.permanentDamage * myItem.secsOfPermDamage)
                            .toStringAsFixed(1),
                        style: defaultInventarTextStyle,
                        minFontSize: 10,
                        textAlign: TextAlign.left,
                        maxLines: 1,)
                  ))
            ])
        ));
        myList.add(Container(constraints: const BoxConstraints.expand(
            width: double.infinity, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:Image.asset(
                      'assets/images/inventar/UI-9-sliced object-56Mana.png',
                      fit: BoxFit.contain,
                      alignment: Alignment.centerRight,
                      width: rowHeight))
              , Expanded(
                  child:Container(
                      margin: const EdgeInsets.only(left: 10),
                      height: rowHeight,
                      child: AutoSizeText(
                        myItem.manaCost.toStringAsFixed(2),
                        style: defaultInventarTextStyle,
                        minFontSize: 10,
                        textAlign: TextAlign.left,
                        maxLines: 1,)))
            ])));
        myList.add(Container(constraints: const BoxConstraints.expand(
            width: double.infinity, height: rowHeight), child:
        Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:Image.asset('assets/images/inventar/clock.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.centerRight,
                    height: rowHeight,))
              , Expanded(
                  child:Container(
                      margin: const EdgeInsets.only(left: 10),
                      height: rowHeight,
                      child: AutoSizeText(myItem.secsOfPermDamage.toString(),
                        style: defaultInventarTextStyle,
                        minFontSize: 10,
                        textAlign: TextAlign.left,
                        maxLines: 1,)))
            ])));
      }
    }
    return myList;
  }
}
