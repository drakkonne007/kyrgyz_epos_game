

import 'package:flame/components.dart';

class CountTimer extends TimerComponent
{
  CountTimer({required super.period, super.autoStart = true, super.onTick, super.repeat = true, super.removeOnFinish = false, this.count = 0, this.onEndCount})
  {
    currentCount = count;
  }
  int count = 0;
  int currentCount = 0;
  Function()? onEndCount;

  @override
  void onTick()
  {
    if(count > 0){
      currentCount--;
      if(currentCount < 0){
        onEndCount?.call();
        removeFromParent();
      }else{
        super.onTick();
      }
    }else{
      super.onTick();
    }
  }
}

class TempEffect extends Component
{
  TempEffect({required this.period, this.autoStart = true, this.onEndEffect, this.onUpdate, this.onStartEffect, required this.parentId});

  double period;
  double _currTime = 0;
  bool autoStart = true;
  bool _started = false;
  String parentId;
  Function()? onEndEffect;
  Function(double dt)? onUpdate;
  Function()? onStartEffect;
  get timeBeforeEnd => period - _currTime;

  @override
  onRemove()
  {
    onEndEffect?.call();
  }

  void start()
  {
    autoStart = true;
  }

  @override
  void update(double dt)
  {
    if(!autoStart){
      return;
    }
    if(!_started){
      _started = true;
      onStartEffect?.call();
    }
    _currTime += dt;
    if(_currTime >= period){
      removeFromParent();
      return;
    }
    if(isMounted) {
      onUpdate?.call(dt);
    }
  }
}