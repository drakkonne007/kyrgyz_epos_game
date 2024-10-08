
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/components/physic_vals.dart';
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
    if(widget.game.currentItemInInventar.value != null){
      switch(widget.game.currentItemInInventar.value!.dressType){
        case InventarType.flask:
          if(!widget.game.playerData.flaskInventar.containsKey(widget.game.currentItemInInventar.value!.id)){
            widget.game.currentItemInInventar.value = null;
          }
          break;
        case InventarType.item:
          if(!widget.game.playerData.itemInventar.containsKey(widget.game.currentItemInInventar.value!.id)){
            widget.game.currentItemInInventar.value = null;
          }
          break;
        case InventarType.helmet:
          if(!widget.game.playerData.helmetInventar.containsKey(widget.game.currentItemInInventar.value!.id)){
            widget.game.currentItemInInventar.value = null;
          }
          break;
        case InventarType.bodyArmor:
          if(!widget.game.playerData.bodyArmorInventar.containsKey(widget.game.currentItemInInventar.value!.id)){
            widget.game.currentItemInInventar.value = null;
          }
          break;
        case InventarType.gloves:
          if(!widget.game.playerData.glovesInventar.containsKey(widget.game.currentItemInInventar.value!.id)){
            widget.game.currentItemInInventar.value = null;
          }
          break;
        case InventarType.sword:
          if(!widget.game.playerData.swordInventar.containsKey(widget.game.currentItemInInventar.value!.id)){
            widget.game.currentItemInInventar.value = null;
          }
          break;
        case InventarType.ring:
          if(!widget.game.playerData.ringInventar.containsKey(widget.game.currentItemInInventar.value!.id)){
            widget.game.currentItemInInventar.value = null;
          }
          break;
        case InventarType.boots:
          if(!widget.game.playerData.bootsInventar.containsKey(widget.game.currentItemInInventar.value!.id)){
            widget.game.currentItemInInventar.value = null;
          }
          break;
      }
    }
    return LayoutBuilder(builder: (context,constraints){
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children:[
            ValueListenableBuilder(valueListenable: widget.game.currentStateInventar, builder: (context, value, child) {
              return Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: getUpTabs((constraints.maxWidth)/11,(constraints.maxHeight * 0.70)/6)
              );
            }),
            Stack(
                alignment: Alignment.topCenter,
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
    return widget.game.currentStateInventar.value == InventarOverlayType.helmet
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
      case InventarOverlayType.spells:
        widget.game.currentStateInventar.value == type ? source = 'UI-9-sliced object-133.png' : source = 'UI-9-sliced object-133Grey.png';
        break;
    }
    return 'assets/images/inventar/$source';
  }

  List<Widget> getUpTabs(double width, double height) //
  {
    List<Widget> temp = [SizedBox(width: width/2,)];

    temp.add(
        ElevatedButton(
            onPressed: (){
              setState(() {
                if(nowIsDress()){
                  return;
                }else {
                  if(widget.game.currentStateInventar.value !=
                      InventarOverlayType.helmet) {
                    widget.game.currentStateInventar.value =
                        InventarOverlayType.helmet;
                    widget.game.currentItemInInventar.value = null;
                  }
                }});
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
                    getImage(InventarOverlayType.armor),
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
                if(widget.game.currentStateInventar.value != InventarOverlayType.flask) {
                  widget.game.currentItemInInventar.value = null;
                  widget.game.currentStateInventar.value =
                      InventarOverlayType.flask;
                }
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
                if(widget.game.currentStateInventar.value != InventarOverlayType.item){
                  widget.game.currentItemInInventar.value = null;
                  widget.game.currentStateInventar.value = InventarOverlayType.item;
                }
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
                widget.game.currentItemInInventar.value = null;
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
                widget.game.currentStateInventar.value = InventarOverlayType.spells;
                // widget.game.doGameHud();
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
                  Image.asset(widget.game.currentStateInventar.value == InventarOverlayType.spells ? 'assets/images/inventar/UI-9-sliced object-34.png' : 'assets/images/inventar/UI-9-sliced object-35.png',
                    fit: BoxFit.fill,
                    centerSlice: widget.game.currentStateInventar.value == InventarOverlayType.spells ? const Rect.fromLTWH(10,13,32,37) : const Rect.fromLTWH(8, 8, 34 , 38),
                    isAntiAlias: true,
                    filterQuality: FilterQuality.high,
                    width: width,
                    height: widget.game.currentStateInventar.value == InventarOverlayType.spells ? height - 5: height - 10,
                    alignment: Alignment.bottomCenter,
                  ),
                  Image.asset(
                    getImage(InventarOverlayType.spells),
                    width: width,
                    height: height - 10,
                    alignment: Alignment.center,
                  ),
                  ValueListenableBuilder(valueListenable: widget.game.playerData.statChangeTrigger, builder: (_,val,__) =>
                  widget.game.playerData.getFreeSpellPoints() == 0 ? Container() :
                  Container(width: width,
                      height: height,
                      alignment: Alignment.center,
                      child:AutoSizeText(widget.game.playerData.getFreeSpellPoints().toString()
                          , textAlign: TextAlign.center,style: defaultInventarTextStyle.copyWith(shadows: const [Shadow(color: Colors.yellow, blurRadius: 2)]),
                          minFontSize: 10,
                          maxLines: 1)))
                ]
            )
        )
    );
    temp.add(
        ElevatedButton(
            onPressed: (){
              setState(() {
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
                  Image.asset('assets/images/inventar/UI-9-sliced object-35.png',
                    fit: BoxFit.fill,
                    centerSlice: const Rect.fromLTWH(8, 8, 34 , 38),
                    isAntiAlias: true,
                    filterQuality: FilterQuality.high,
                    width: width,
                    height: height - 10,
                    alignment: Alignment.bottomCenter,
                  ),
                  Image.asset(
                    'assets/images/inventar/UI-9-sliced object-114Close.png',
                    width: width,
                    height: height - 10,
                    alignment: Alignment.center,
                  )
                ]
            )
        )
    );
    temp.add(const Spacer());
    temp.add(
        Container(
            constraints: BoxConstraints(minWidth: width, minHeight: height-10, maxWidth: double.infinity, maxHeight: height - 10),
            decoration: const BoxDecoration(image: DecorationImage(
              image: AssetImage('assets/images/inventar/UI-9-sliced object-121Small.png',),
              centerSlice: Rect.fromLTWH(15,13,2,6),
            )),
            alignment: Alignment.center,
            child:
            Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  const SizedBox(width: 7),
                  Image.asset('assets/images/inventar/gold.png'),
                  AutoSizeText(widget.game.playerData.money.value.toString(),
                    textAlign: TextAlign.left,
                    style: defaultInventarTextStyleGold,
                    minFontSize: 10,
                    maxLines: 1,),
                  const SizedBox(width: 7),])
        )
    );
    temp.add(
        Container(
            constraints: BoxConstraints.loose(Size(width,height-10)),
            decoration: const BoxDecoration(image: DecorationImage(
              image: AssetImage('assets/images/inventar/UI-9-sliced object-121Small.png',),
              centerSlice: Rect.fromLTWH(15,13,2,6),
            )),
            alignment: Alignment.center,
            child:
            Stack(
                fit: StackFit.passthrough,
                alignment: Alignment.center,
                children:
                [
                  ValueListenableBuilder(valueListenable: widget.game.playerData.experience, builder: (_,val,__) =>
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top:11, bottom: 10, left: 10, right: 10),
                    child:CustomPaint(
                          size: Size(width,height-10),
                          painter: ExperienceCircle(percentOfLevel(widget.game.playerData.experience.value))),
                  )),
                  AutoSizeText(widget.game.playerData.playerLevel.value.toString(), textAlign: TextAlign.center,style: defaultInventarTextStyle.copyWith(shadows: const [Shadow(color: Colors.yellow, offset: Offset(0, 0), blurRadius: 10)]),
                          minFontSize: 10,
                          maxLines: 1)
                  // AutoSizeText(widget.game.playerData.playerLevel.value.toString())
                ]
            )
        )
    );
    temp.add(const SizedBox(width: 50,));


    return temp;
  }
}

class ExperienceCircle extends CustomPainter
{
  ExperienceCircle(this.currentProc);
  double time = 0;
  final double currentProc;

  @override
  void paint(Canvas canvas, Size size)
  {
    Paint paint = Paint()..color = const Color(0xFF54463C);

    // Рисуем весь овал
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height - 4);
    // canvas.drawRect(rect, paint);

    // Обрезаем область рисования, чтобы заполнить только левую половину
    Path clipPath = Path();
    clipPath.addRect(Rect.fromLTWH(0, 2, size.width * currentProc, size.height));
    canvas.clipPath(clipPath);

    paint = Paint()..color = const Color(0xFFe74747);
    // Заполняем обрезанную область
    canvas.drawRect(rect, paint);



    // final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // _gradient = LinearGradient(
    //   // transform: const GradientRotation(-math.pi/2),
    //     stops: [0.0,currentProc,currentProc,1],
    //   begin: Alignment.centerLeft,
    //   end: Alignment.centerRight,
    //     colors: [_color,_color, Colors.black.withAlpha(80), Colors.black.withAlpha(80)],);
    // final paint = Paint()
    //   ..shader = _gradient.createShader(rect)
    //   ..strokeCap = StrokeCap.butt
    //   ..strokeWidth = size.height/2 - 2.5// StrokeCap.round is not recommended.
    //   ..style = PaintingStyle.stroke;
    // // canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
    // //     startAngle, sweepAngle, false, paint);
    // canvas.drawOval(Rect.fromPoints(const Offset(0, 0), Offset(size.width,size.height - 5)), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate)
  {
    if(oldDelegate is ExperienceCircle){
      return oldDelegate.currentProc != currentProc;
    }
    return false;
  }
}