


import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'dart:math' as math;

import 'package:game_flame/kyrgyz_game.dart';

class HealthBar extends StatelessWidget
{
  HealthBar(this.game, {Key? key}) : super(key: key);
  final KyrgyzGame game;
  double _firstHp = 0;

  bool isHurt(double val){
    bool isLower = val < _firstHp;
    _firstHp = val;
    if(val > 5 && isLower){
      Future.delayed(const Duration(milliseconds: 500),(){
        game.playerData.health.notifyListeners();
      });
    }
    return isLower;
  }

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
                            valueListenable: game.playerData.health,
                            builder: (_,val,__) =>
                                ShakeWidget(
                                    shakeConstant: ShakeDefaultConstant2(),
                                    autoPlay: isHurt(val),
                                    child: SizedBox(
                                      width: 42,
                                      height: 42,
                                      child: GestureDetector(
                                        onTap: game.doInventoryHud,
                                        child: Stack(
                                            fit: StackFit.passthrough,
                                            children:[
                                              CustomPaint(
                                                painter: ArcGradientPainter(color: Colors.red, currentProc: val / game.playerData.maxHealth.value),
                                              ),
                                              Container(alignment: Alignment.center, width: 42,height: 42,
                                                  child: Image.asset('assets/images/inventar/heartForGui.png', width: 32, height: 32, alignment: Alignment.center,)),
                                            ]
                                        ),
                                      ),))
                        ),
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
                          ShakeWidget(
                              shakeConstant: ShakeDefaultConstant2(),
                              autoPlay: isHurt(val),
                              child: SizedBox(
                                width: 42,
                                height: 42,
                                child: GestureDetector(
                                  onTap: game.doInventoryHud,
                                  child: Stack(
                                      fit: StackFit.passthrough,
                                      children:[
                                        CustomPaint(
                                          painter: ArcGradientPainter(color: const Color.fromARGB(255, 81, 183, 228), currentProc: val / game.playerData.maxMana.value),
                                        ),
                                        Container(alignment: Alignment.center, width: 42,height: 42,
                                            child: Image.asset('assets/images/inventar/manaForGui.png', width: 32, height: 32, alignment: Alignment.center,)),
                                      ]
                                  ),
                                ),))
                  ),
                  const SizedBox(height: 15,),
                  ValueListenableBuilder(
                      valueListenable: game.playerData.energy,
                      builder: (_,val,__) =>
                          ShakeWidget(
                            shakeConstant: ShakeDefaultConstant2(),
                            autoPlay: false,
                            child: SizedBox(
                                width: 42,
                                height: 42,
                                child: GestureDetector(
                                onTap: game.doInventoryHud,
                                child: Stack(
                                    fit: StackFit.passthrough,
                                    children:[
                                      CustomPaint(
                                          painter: ArcGradientPainter(color: const Color.fromARGB(255, 247, 220, 106), currentProc: val / game.playerData.maxEnergy.value)),
                                      Container(alignment: Alignment.center, width: 42,height: 42,
                                          child: Image.asset('assets/images/inventar/staminaForGui.png', width: 32, height: 32, alignment: Alignment.center,)),
                                    ]
                                )
                              // child:
                            )),
                          ),
                  ),

                ]
            )
      );
  }
}



class ArcGradientPainter extends CustomPainter
{
  final Color color;
  late Gradient _gradient;
  final double _strokeWidth = 6;
  final double currentProc;
  ArcGradientPainter({
    required this.color,required this.currentProc});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    _gradient = SweepGradient(
        stops: [0.0,currentProc,currentProc,1],
        tileMode: TileMode.repeated,
        colors: [color,color, Colors.black.withAlpha(80), Colors.black.withAlpha(80)],
        transform: const GradientRotation(-math.pi/2));
    final paint = Paint()
      ..shader = _gradient.createShader(rect)
      ..strokeCap = StrokeCap.butt  // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    const startAngle = -math.pi / 2;
    const sweepAngle = tau;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}