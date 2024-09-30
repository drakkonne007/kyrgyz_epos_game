


import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'dart:math' as math;

import 'package:game_flame/kyrgyz_game.dart';

class HealthBar extends StatelessWidget
{
  const HealthBar(this.game, {Key? key}) : super(key: key);
  final KyrgyzGame game;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, top: 10),
        child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children:
                  [
                    ValueListenableBuilder(
                        valueListenable: game.playerData.hurtMainPlayerChanger,
                        builder: (_,val12,__) =>
                            ShakeWidget(
                                shakeConstant: ShakeDefaultConstant2(),
                                autoPlay: val12 != 0,
                                child: SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: GestureDetector(
                                      onTap: game.doInventoryHud,
                                      child: ValueListenableBuilder(
                                        valueListenable: game.playerData.health,
                                        builder: (_,val,__) => Stack(
                                            fit: StackFit.passthrough,
                                            children:[
                                              CustomPaint(
                                                painter: ArcGradientPainter(color: Colors.red, currentProc: val / game.playerData.maxHealth.value),
                                              ),
                                              Container(alignment: Alignment.center, width: 42,height: 42,
                                                  child: Image.asset('assets/images/inventar/heartForGui.png', width: 32, height: 32, alignment: Alignment.center,)),
                                              ValueListenableBuilder(
                                                  valueListenable: game.playerData.plusHealthMainPlayerChanger,
                                                  builder: (_,val12,__) => val12 == 0 ? Container() : Container(alignment: Alignment.center, width: 42,height: 42,
                                                      child: Image.asset('assets/images/inventar/healthGif.gif', width: 30, height: 30, alignment: Alignment.center,))),
                                            ]
                                        ),
                                      ),))
                            )
                    ),
                    const SizedBox(width: 15,),
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      child: GestureDetector(
                          onTap: game.doMapHud,
                          child: Image.asset('assets/images/inventar/UI-9-sliced object-53Hud.png', width: 42, height: 42, alignment: Alignment.center,)),
                    )
                  ]
              ),
              const SizedBox(height: 15,),
              ValueListenableBuilder(
                  valueListenable: game.playerData.mana,
                  builder: (_,val,__) =>
                      SizedBox(
                        width: 42,
                        height: 42,
                        child:GestureDetector(
                          onTap: game.doInventoryHud,
                          child: Stack(
                              fit: StackFit.passthrough,
                              children:[
                                CustomPaint(
                                  painter: ArcGradientPainter(color: const Color.fromARGB(255, 81, 183, 228), currentProc: val / game.playerData.maxMana.value),
                                ),
                                Container(alignment: Alignment.center, width: 42,height: 42,
                                    child: Image.asset('assets/images/inventar/manaForGui.png', width: 32, height: 32, alignment: Alignment.center,)),
                                ValueListenableBuilder(
                                    valueListenable: game.playerData.plusManaMainPlayerChanger,
                                    builder: (_,val12,__) => val12 == 0 ? Container() : Container(alignment: Alignment.center, width: 42,height: 42,
                                        child: Image.asset('assets/images/inventar/healthGif.gif', width: 30, height: 30, alignment: Alignment.center,))),
                              ]
                          ),
                        ),)
              ),
              const SizedBox(height: 15,),
              ValueListenableBuilder(
                valueListenable: game.playerData.energy,
                builder: (_,val,__) =>
                    SizedBox(
                        width: 42,
                        height: 42,
                        child: GestureDetector(
                            onTap: game.doInventoryHud,
                            child: Stack(
                                fit: StackFit.passthrough,
                                alignment: Alignment.center,
                                children:[
                                  CustomPaint(
                                      painter: ArcGradientPainter(color: const Color.fromARGB(255, 247, 220, 106), currentProc: val / game.playerData.maxEnergy.value)),
                                  Container(alignment: Alignment.center, width: 42,height: 42,
                                      child: Image.asset('assets/images/inventar/staminaForGui.png', width: 32, height: 32, alignment: Alignment.center,)),
                                  ValueListenableBuilder(
                                      valueListenable: game.playerData.plusStaminaMainPlayerChanger,
                                      builder: (_,val12,__) => val12 == 0 ? Container() : Container(alignment: Alignment.center, width: 42,height: 42,
                                          child: Image.asset('assets/images/inventar/healthGif.gif', width: 30, height: 30, alignment: Alignment.center,))),
                                ]
                            )
                          // child:
                        )
                    ),
              ),

            ]
        )
    );
  }
}



class ArcGradientPainter extends CustomPainter
{
  double time = 0;
  final Color color;
  late Gradient _gradient;
  final double _strokeWidth = 6;
  final double currentProc;
  ArcGradientPainter({
    required this.color,required this.currentProc});

  @override
  void paint(Canvas canvas, Size size)
  {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);

    _gradient = SweepGradient(
        stops: [0.0,currentProc,currentProc,1],
        tileMode: TileMode.repeated,
        colors: [color,color, Colors.black.withAlpha(80), Colors.black.withAlpha(80)],
        transform: const GradientRotation(-math.pi/2));
    const startAngle = -math.pi / 2;
    const sweepAngle = tau;
    final paint = Paint()
      ..shader = _gradient.createShader(rect)
      ..strokeCap = StrokeCap.butt  // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepAngle, false, paint);


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate)
  {
    if(oldDelegate is ArcGradientPainter){
      return oldDelegate.currentProc != currentProc;
    }
    return true;
  }
}