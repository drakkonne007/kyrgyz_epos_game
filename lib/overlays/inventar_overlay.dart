
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/game_widgets/LootInventar.dart';
import 'package:game_flame/game_widgets/bigWindowInventar.dart';
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

class InventoryOverlayState extends State<InventoryOverlay> //Делает верхние вкладки с инвентарями
{
  @override
  Widget build(BuildContext context)
  {
    return LayoutBuilder(builder: (context,constraints){
      return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children:[
                Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: getUpTabs((constraints.maxWidth)/11,(constraints.maxHeight * 0.75)/7)
                ),
                Stack(
                    alignment: Alignment.center,
                    fit: StackFit.passthrough,
                    clipBehavior: Clip.none,
                    children:[
                      Image.asset('assets/images/inventar/UI-9-sliced object-31.png',
                        fit: BoxFit.fill,
                        centerSlice: const Rect.fromLTWH(18,18,14,20),
                        isAntiAlias: true,
                        filterQuality: FilterQuality.high,
                        width: constraints.maxWidth * 0.95,
                        height: constraints.maxHeight * 0.85,
                      ),
                      BigWindowInventar(widget.game, Size(constraints.maxWidth * 0.95,constraints.maxHeight * 0.85))
                    ]
                ),
              ]
      );
    })  ;
  }

  bool nowIsDress()
  {
    return widget.game.currentStateInventar.value == InventarOverlayType.dress || widget.game.currentStateInventar.value == InventarOverlayType.helmet
        || widget.game.currentStateInventar.value == InventarOverlayType.armor
        || widget.game.currentStateInventar.value == InventarOverlayType.gloves
        || widget.game.currentStateInventar.value == InventarOverlayType.boots
        || widget.game.currentStateInventar.value == InventarOverlayType.sword
        || widget.game.currentStateInventar.value == InventarOverlayType.ring;
  }

  String getImage(InventarOverlayType type)
  {
    String source = '';
    switch(type){
      // case 0: index == widget.game.currentStateInventar ? source = 'UI-9-sliced object-3.png' : source = 'UI-9-sliced object-18.png'; break;
      // case 1: index == widget.game.currentStateInventar ? source = 'shieldYark.png' : source = 'shield.png'; break;
      // case 2: index == widget.game.currentStateInventar ? source = 'manaBright.png' : source = 'manaDark.png'; break;
      // case 3: index == widget.game.currentStateInventar ? source = 'UI-9-sliced object-4.png' : source = 'UI-9-sliced object-19.png'; break;
      // case 4: index == widget.game.currentStateInventar ? source = 'UI-9-sliced object-1.png' : source = 'UI-9-sliced object-16.png'; break;
      // case 5: index == widget.game.currentStateInventar ? source = 'UI-9-sliced object-2.png' : source = 'UI-9-sliced object-17.png'; break;
      case InventarOverlayType.dress:
      case InventarOverlayType.helmet:
      case InventarOverlayType.armor:
      case InventarOverlayType.gloves:
      case InventarOverlayType.boots:
      case InventarOverlayType.sword:
      case InventarOverlayType.ring:
        widget.game.currentStateInventar.value == type ? source = 'UI-9-sliced object-3.png' : source = 'UI-9-sliced object-18.png';
        break;
      case InventarOverlayType.flask:
        widget.game.currentStateInventar.value == type ? source = 'manaBright.png' : source = 'manaDark.png';
        break;
      case InventarOverlayType.item:
        widget.game.currentStateInventar.value == type ? source = 'UI-9-sliced object-4.png' : source = 'UI-9-sliced object-19.png';
        break;
      case InventarOverlayType.quests:
        widget.game.currentStateInventar.value == type ? source = 'UI-9-sliced object-1.png' : source = 'UI-9-sliced object-16.png';
        break;
      case InventarOverlayType.map:
        widget.game.currentStateInventar.value == type ? source = 'UI-9-sliced object-2.png' : source = 'UI-9-sliced object-17.png';
        break;
    }
    return 'assets/images/inventar/$source';
  }

  List<Widget> getUpTabs(double width, double height) //
  {
    List<Widget> temp = [SizedBox(width: width,)];

    temp.add(
        ElevatedButton(
            onPressed: (){
              setState(() {
                  widget.game.currentStateInventar.value = InventarOverlayType.dress;
              });
            },
            style: defaultNoneButtonStyle.copyWith(
                maximumSize: WidgetStateProperty.all<Size>(Size(width,height - 5)),
                minimumSize: WidgetStateProperty.all<Size>(Size(width,height - 5)),
                alignment: Alignment.bottomCenter
            ),
            child:
            Stack(
                fit: StackFit.passthrough,
                alignment: Alignment.bottomCenter,
                children:
                [
                  Image.asset(nowIsDress() ? 'assets/images/inventar/UI-9-sliced object-34.png' : 'assets/images/inventar/UI-9-sliced object-35.png',
                    fit: BoxFit.fill,
                    centerSlice: nowIsDress() ? const Rect.fromLTWH(10,13,32,37) : const Rect.fromLTWH(8, 8, 34 , 38),
                    isAntiAlias: true,
                    filterQuality: FilterQuality.high,
                    width: width,
                    height: nowIsDress() ? height - 5: height - 10,
                    alignment: Alignment.bottomCenter,
                  ),
                  Image.asset(
                    getImage(InventarOverlayType.dress),
                    width: width,
                    height: height - 10,
                    alignment: Alignment.center,
                  )
                ]
            )
        )
    );
    temp.add(
        ElevatedButton(
            onPressed: (){
              setState(() {
                widget.game.currentStateInventar.value = InventarOverlayType.flask;
              });
            },
            style: defaultNoneButtonStyle.copyWith(
                maximumSize: WidgetStateProperty.all<Size>(Size(width,height - 5)),
                minimumSize: WidgetStateProperty.all<Size>(Size(width,height - 5)),
                alignment: Alignment.bottomCenter
            ),
            child:
            Stack(
                fit: StackFit.passthrough,
                alignment: Alignment.bottomCenter,
                children:
                [
                  Image.asset(widget.game.currentStateInventar.value == InventarOverlayType.flask ? 'assets/images/inventar/UI-9-sliced object-34.png' : 'assets/images/inventar/UI-9-sliced object-35.png',
                    fit: BoxFit.fill,
                    centerSlice: widget.game.currentStateInventar.value == InventarOverlayType.flask ? const Rect.fromLTWH(10,13,32,37) : const Rect.fromLTWH(8, 8, 34 , 38),
                    isAntiAlias: true,
                    filterQuality: FilterQuality.high,
                    width: width,
                    height: widget.game.currentStateInventar.value == InventarOverlayType.flask ? height - 5: height - 10,
                    alignment: Alignment.bottomCenter,
                  ),
                  Image.asset(
                    getImage(InventarOverlayType.flask),
                    width: width,
                    height: height - 10,
                    alignment: Alignment.center,
                  )
                ]
            )
        )
    );
    temp.add(
        ElevatedButton(
            onPressed: (){
              setState(() {
                widget.game.currentStateInventar.value = InventarOverlayType.item;
              });
            },
            style: defaultNoneButtonStyle.copyWith(
                maximumSize: WidgetStateProperty.all<Size>(Size(width,height - 5)),
                minimumSize: WidgetStateProperty.all<Size>(Size(width,height - 5)),
                alignment: Alignment.bottomCenter
            ),
            child:
            Stack(
                fit: StackFit.passthrough,
                alignment: Alignment.bottomCenter,
                children:
                [
                  Image.asset(widget.game.currentStateInventar.value == InventarOverlayType.item ? 'assets/images/inventar/UI-9-sliced object-34.png' : 'assets/images/inventar/UI-9-sliced object-35.png',
                    fit: BoxFit.fill,
                    centerSlice: widget.game.currentStateInventar.value == InventarOverlayType.item ? const Rect.fromLTWH(10,13,32,37) : const Rect.fromLTWH(8, 8, 34 , 38),
                    isAntiAlias: true,
                    filterQuality: FilterQuality.high,
                    width: width,
                    height: widget.game.currentStateInventar.value == InventarOverlayType.item ? height - 5: height - 10,
                    alignment: Alignment.bottomCenter,
                  ),
                  Image.asset(
                    getImage(InventarOverlayType.item),
                    width: width,
                    height: height - 10,
                    alignment: Alignment.center,
                  )
                ]
            )
        )
    );
    temp.add(
        ElevatedButton(
            onPressed: (){
              setState(() {
                widget.game.currentStateInventar.value = InventarOverlayType.quests;
              });
            },
            style: defaultNoneButtonStyle.copyWith(
                maximumSize: WidgetStateProperty.all<Size>(Size(width,height - 5)),
                minimumSize: WidgetStateProperty.all<Size>(Size(width,height - 5)),
                alignment: Alignment.bottomCenter
            ),
            child:
            Stack(
                fit: StackFit.passthrough,
                alignment: Alignment.bottomCenter,
                children:
                [
                  Image.asset(widget.game.currentStateInventar.value == InventarOverlayType.quests ? 'assets/images/inventar/UI-9-sliced object-34.png' : 'assets/images/inventar/UI-9-sliced object-35.png',
                    fit: BoxFit.fill,
                    centerSlice: widget.game.currentStateInventar.value == InventarOverlayType.quests ? const Rect.fromLTWH(10,13,32,37) : const Rect.fromLTWH(8, 8, 34 , 38),
                    isAntiAlias: true,
                    filterQuality: FilterQuality.high,
                    width: width,
                    height: widget.game.currentStateInventar.value == InventarOverlayType.quests ? height - 5: height - 10,
                    alignment: Alignment.bottomCenter,
                  ),
                  Image.asset(
                    getImage(InventarOverlayType.quests),
                    width: width,
                    height: height - 10,
                    alignment: Alignment.center,
                  )
                ]
            )
        )
    );
    temp.add(
        ElevatedButton(
            onPressed: (){
              setState(() {
                // widget.game.currentStateInventar.value = InventarOverlayType.map;
                widget.game.doGameHud();
              });
            },
            style: defaultNoneButtonStyle.copyWith(
                maximumSize: WidgetStateProperty.all<Size>(Size(width,height - 5)),
                minimumSize: WidgetStateProperty.all<Size>(Size(width,height - 5)),
                alignment: Alignment.bottomCenter
            ),
            child:
            Stack(
                fit: StackFit.passthrough,
                alignment: Alignment.bottomCenter,
                children:
                [
                  Image.asset(widget.game.currentStateInventar.value == InventarOverlayType.map ? 'assets/images/inventar/UI-9-sliced object-34.png' : 'assets/images/inventar/UI-9-sliced object-35.png',
                    fit: BoxFit.fill,
                    centerSlice: widget.game.currentStateInventar.value == InventarOverlayType.map ? const Rect.fromLTWH(10,13,32,37) : const Rect.fromLTWH(8, 8, 34 , 38),
                    isAntiAlias: true,
                    filterQuality: FilterQuality.high,
                    width: width,
                    height: widget.game.currentStateInventar.value == InventarOverlayType.map ? height - 5: height - 10,
                    alignment: Alignment.bottomCenter,
                  ),
                  Image.asset(
                    getImage(InventarOverlayType.map),
                    width: width,
                    height: height - 10,
                    alignment: Alignment.center,
                  )
                ]
            )
        )
    );
    return temp;
  }
}
