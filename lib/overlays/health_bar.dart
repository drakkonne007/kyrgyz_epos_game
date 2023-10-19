

import 'dart:ui';

import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'dart:math' as math;

import 'package:game_flame/kyrgyz_game.dart';

@immutable
class HealthBar extends StatefulWidget
{
  HealthBar(this.game, {Key? key}) : super(key: key);
  final KyrgyzGame game;
  static const id = 'HealthBar';
  @override
  State<HealthBar> createState() => _HealthBarState();
  var myTextStyle =  const TextStyle( fontSize: 45, letterSpacing: 0.5, fontFamily: 'Samson');
}

class _HealthBarState extends State<HealthBar> with SingleTickerProviderStateMixin
{
  _HealthBarState();
  double _firstHp = 0;

  bool isHurt(double val){
    bool isLower = val < _firstHp;
    _firstHp = val;
    if(val > 5 && isLower){
      Future.delayed(const Duration(milliseconds: 500),(){
        widget.game.playerData.health.notifyListeners();
      });
    }
    return isLower;
  }

  @override
  void initState() {
    _firstHp = widget.game.playerData.health.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ValueListenableBuilder(
                    valueListenable: widget.game.playerData.health,
                    builder: (_,val,__) => Row(
                        children:[
                          ShakeWidget(
                            shakeConstant: val > 5 ? ShakeDefaultConstant2() : ShakeHardConstant2(),
                            autoPlay: isHurt(val),
                            child: SizedBox(
                              width: 42,
                              height: 42,
                              child:
                              CustomPaint(
                                painter: ArcGradientPainter(color: Colors.red, currentProc: val / widget.game.playerData.maxHealth.value),
                                child:const Icon(Icons.heart_broken, color: Colors.red,size: 35,
                                  shadows: [
                                    BoxShadow(color: Colors.black,blurRadius: 5,offset: Offset(-1,1), blurStyle: BlurStyle.normal)
                                  ],),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5, height: 0,),
                          // Text('$val',style: widget.myTextStyle.copyWith(color: Colors.red[700]!),),
                        ]
                    ),
                  ),
                  const SizedBox(width: 1, height: 8,),
                  ValueListenableBuilder(
                    valueListenable: widget.game.playerData.armor,
                    builder: (_,val,__) => Row(
                        children:[
                          SizedBox(
                            width: 42,
                            height: 42,
                            child: CustomPaint(
                              painter: ArcGradientPainter(color: Colors.green, currentProc: 100),
                              child:const Icon(Icons.shield_sharp, color: Colors.green,size: 35,
                                shadows: [
                                  BoxShadow(color: Colors.black,blurRadius: 5,offset: Offset(-1,1),spreadRadius: 1, blurStyle: BlurStyle.normal)
                                ],),
                            ),
                          ),
                          const SizedBox(width: 5, height: 0,),
                          // Text('$val',style: widget.myTextStyle.copyWith(color: Colors.green[700]!),),
                        ]
                    ),
                  ),
                  const SizedBox(width: 1, height: 8,),
                  ValueListenableBuilder(
                      valueListenable: widget.game.playerData.energy,
                      builder: (_,val,__) => Row(
                        children:[
                          ShakeWidget(
                            shakeConstant: ShakeDefaultConstant2(),
                            autoPlay: false,
                            child: SizedBox(
                              width: 42,
                              height: 42,
                              child: CustomPaint(
                                painter: ArcGradientPainter(color: Colors.blue, currentProc: val / widget.game.playerData.maxEnergy.value),
                                child:const Icon(Icons.directions_run, color: Colors.blue,size: 35,
                                  shadows: [
                                    BoxShadow(color: Colors.black,blurRadius: 2,offset: Offset(0,0),spreadRadius: 1, blurStyle: BlurStyle.normal)
                                  ],),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ]
            )
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
        colors: [color.withAlpha(180),color.withAlpha(180), Colors.black.withAlpha(80), Colors.black.withAlpha(80)],
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