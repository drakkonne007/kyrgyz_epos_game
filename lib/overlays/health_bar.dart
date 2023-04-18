

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'dart:math' as math;


class HealthBar extends StatefulWidget
{
  static const id = 'HealthBar';
  @override
  State<HealthBar> createState() => _HealthBarState();

  var myTextStyle =  const TextStyle( fontSize: 45, letterSpacing: 0.5, fontFamily: 'Samson');
}

class _HealthBarState extends State<HealthBar> {
  var _health = OrthoPlayerVals.health.value;
  var _armor = OrthoPlayerVals.armor.value;
  var _energy = OrthoPlayerVals.energy.value;
  double _percRun = 1;
  double _percHealth = 1;
  double _percArm = 1;

  @override
  initState(){
    super.initState();
    _percHealth = _health / OrthoPlayerVals.maxHealth;
    _percArm = _armor / OrthoPlayerVals.maxArmor;
    _percRun = _energy / OrthoPlayerVals.maxEnergy;
  }


  _HealthBarState() {
    OrthoPlayerVals.health.addListener(() {
      _health = OrthoPlayerVals.health.value;
      _percHealth = _health / OrthoPlayerVals.maxHealth;
      if(mounted) {
        setState(() {
        });
      }
    });
    OrthoPlayerVals.armor.addListener(() {
      _armor = OrthoPlayerVals.armor.value;
      _percArm = _armor / OrthoPlayerVals.maxArmor;
      if(mounted) {
        setState(() {
        });
      }
    });
    OrthoPlayerVals.energy.addListener(() {
      _energy = OrthoPlayerVals.energy.value;
      _percRun = _energy / OrthoPlayerVals.maxEnergy;
      if(mounted) {
        setState(() {
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                      children:[
                        SizedBox(
                          width: 42,
                          height: 42,
                          child: CustomPaint(
                            painter: ArcGradientPainter(color: Colors.red, currentProc: _percHealth),
                            child:const Icon(Icons.heart_broken, color: Colors.red,size: 35,
                              shadows: [
                                BoxShadow(color: Colors.black,blurRadius: 5,offset: Offset(-1,1), blurStyle: BlurStyle.normal)
                              ],),
                          ),
                        ),
                        const SizedBox(width: 5, height: 0,),
                        Text('$_health',style: widget.myTextStyle.copyWith(color: Colors.red[700]!),),
                      ]
                  ),
                  const SizedBox(width: 1, height: 8,),
                  Row(
                      children:[
                        SizedBox(
                          width: 42,
                          height: 42,
                          child: CustomPaint(
                            painter: ArcGradientPainter(color: Colors.green, currentProc: _percArm),
                            child:const Icon(Icons.shield_sharp, color: Colors.green,size: 35,
                              shadows: [
                                BoxShadow(color: Colors.black,blurRadius: 5,offset: Offset(-1,1),spreadRadius: 1, blurStyle: BlurStyle.normal)
                              ],),
                          ),
                        ),
                        const SizedBox(width: 5, height: 0,),
                        Text('$_armor',style: widget.myTextStyle.copyWith(color: Colors.green[700]!),),
                      ]
                  ),
                  const SizedBox(width: 1, height: 8,),
                  Row(
                    children:[
                      SizedBox(
                        width: 42,
                        height: 42,
                        child: CustomPaint(
                          painter: ArcGradientPainter(color: Colors.blue, currentProc: _percRun),
                          child:const Icon(Icons.directions_run, color: Colors.blue,size: 35,
                            shadows: [
                              BoxShadow(color: Colors.black,blurRadius: 2,offset: Offset(0,0),spreadRadius: 1, blurStyle: BlurStyle.normal)
                            ],),
                        ),
                      ),
                      const SizedBox(width: 5, height: 0,),
                      Text(_energy.toStringAsFixed(1),style: widget.myTextStyle.copyWith(color: Colors.blue[700]!),),
                    ],
                  )
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
        colors: [color.withAlpha(180),color.withAlpha(180), Colors.black.withAlpha(180), Colors.black.withAlpha(180)],
        transform: const GradientRotation(-math.pi/2));
    final paint = Paint()
      ..shader = _gradient.createShader(rect)
      ..strokeCap = StrokeCap.butt  // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    const startAngle = -math.pi / 2;
    const sweepAngle = 2 * math.pi;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}