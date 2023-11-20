import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';


Future loadObjs() async
{
  var timer = Stopwatch();
  timer.start();
  var dir = await getApplicationCacheDirectory();
  ReceivePort objsReceivePort = ReceivePort();
  var isol = await  Isolate.spawn<SendPort>(_loadObjs, objsReceivePort.sendPort,errorsAreFatal: false);
  SendPort objsSendPort = await objsReceivePort.first;
  ReceivePort objResponseReceivePort = ReceivePort();
  objsSendPort.send([
    objResponseReceivePort.sendPort
    ,dir.path
  ]);

  final objsResponse = await objResponseReceivePort.first;
  if(objsResponse is Map<String,Iterable<XmlElement>>){
    print('objsResponse');
    KyrgyzGame.cachedObjXmls = objsResponse;
  }
  objResponseReceivePort.close();
  objsReceivePort.close();
  isol.kill(priority: Isolate.immediate);
  print(timer.elapsed.inMilliseconds);
  timer.stop();
}

void _loadObjs(SendPort mySendPort) async
{
  ReceivePort mikeReceivePort = ReceivePort();
  mySendPort.send(mikeReceivePort.sendPort);
  await for (final message in mikeReceivePort) {
    if (message is List) {
      print('start _loadObjs');
      final SendPort mikeResponseSendPort = message[0];
      Map<String,Iterable<XmlElement>> objXmls = {};
      String path = message[1];
      for(int cl = 0; cl < GameConsts.maxColumn; cl++) {
        for (int rw = 0; rw < GameConsts.maxRow; rw++) {
          try {
            var file = File('$path/$cl-$rw.objXml').readAsStringSync();
            objXmls['$cl-$rw.objXml'] = XmlDocument.parse(file).findAllElements('o');
          } catch (e) {
            e;
          }
        }
      }
      mikeResponseSendPort.send(objXmls);
    }
  }
}

Future loadAnimsHigh() async
{
  var timer = Stopwatch();
  timer.start();
  var dir = await getApplicationCacheDirectory();
  ReceivePort animsReceivePort = ReceivePort();
  var isol = await Isolate.spawn<SendPort>(_loadAnimsHigh, animsReceivePort.sendPort,errorsAreFatal: false);
  SendPort animsSendPort = await animsReceivePort.first;
  ReceivePort animsResponseReceivePort = ReceivePort();
  animsSendPort.send([
    animsResponseReceivePort.sendPort
    ,dir.path
  ]);

  final animPngsResponse = await animsResponseReceivePort.first;
  if(animPngsResponse is Map<String,Iterable<XmlElement>>){
    print('animPngsResponse');
    KyrgyzGame.cachedAnims.addAll(animPngsResponse);
    for(final key in KyrgyzGame.cachedAnims.keys){
      for(final anim in KyrgyzGame.cachedAnims[key]!){
        KyrgyzGame.cachedImgs[anim.getAttribute('src')!] = await Flame.images.load(anim.getAttribute('src')!);
      }
    }
  }
  animsResponseReceivePort.close();
  animsReceivePort.close();
  isol.kill(priority: Isolate.immediate);
  timer.stop();
  print(timer.elapsed.inMilliseconds);
}

void _loadAnimsHigh(SendPort mySendPort) async
{
  ReceivePort mikeReceivePort = ReceivePort();
  mySendPort.send(mikeReceivePort.sendPort);
  await for (final message in mikeReceivePort) {
    if (message is List) {
      print('start _loadAnimsHigh');
      final SendPort mikeResponseSendPort = message[0];
      Map<String, Iterable<XmlElement>> anims = {};
      String path = message[1];
      for (int cl = 0; cl < GameConsts.maxColumn; cl++) {
        for (int rw = 0; rw < GameConsts.maxRow; rw++) {
          try {
            var file = File('$path/$cl-${rw}_high.anim').readAsStringSync();
            anims['$cl-${rw}_high.anim'] = XmlDocument.parse(file).findAllElements('an');
          } catch (e) {
            e;
          }
        }
      }
      mikeResponseSendPort.send(anims);
    }
  }
}

Future loadAnimsDown() async
{
  var timer = Stopwatch();
  timer.start();
  var dir = await getApplicationCacheDirectory();
  ReceivePort animsReceivePort = ReceivePort();
  var isol = await Isolate.spawn<SendPort>(_loadAnimsDown, animsReceivePort.sendPort,errorsAreFatal: false);
  SendPort animsSendPort = await animsReceivePort.first;
  ReceivePort animsResponseReceivePort = ReceivePort();
  animsSendPort.send([
    animsResponseReceivePort.sendPort
    ,dir.path
  ]);

  final animPngsResponse = await animsResponseReceivePort.first;
  if(animPngsResponse is Map<String,Iterable<XmlElement>>){
    print('animPngsResponse');
    KyrgyzGame.cachedAnims.addAll(animPngsResponse);
    for(final key in KyrgyzGame.cachedAnims.keys){
      for(final anim in KyrgyzGame.cachedAnims[key]!){
        KyrgyzGame.cachedImgs[anim.getAttribute('src')!] = await Flame.images.load(anim.getAttribute('src')!);
      }
    }
  }
  animsResponseReceivePort.close();
  animsReceivePort.close();
  isol.kill(priority: Isolate.immediate);
  timer.stop();
  print(timer.elapsed.inMilliseconds);
}

void _loadAnimsDown(SendPort mySendPort) async
{
  ReceivePort mikeReceivePort = ReceivePort();
  mySendPort.send(mikeReceivePort.sendPort);
  await for (final message in mikeReceivePort) {
    if (message is List) {
      print('start _loadAnimsDown');
      final SendPort mikeResponseSendPort = message[0];
      Map<String, Iterable<XmlElement>> anims = {};
      String path = message[1];
      for (int cl = 0; cl < GameConsts.maxColumn; cl++) {
        for (int rw = 0; rw < GameConsts.maxRow; rw++) {
          try {
            var file = File('$path/$cl-${rw}_down.anim').readAsStringSync();
            anims['$cl-${rw}_down.anim'] = XmlDocument.parse(file).findAllElements('an');
          } catch (e) {
            e;
          }
        }
      }
      mikeResponseSendPort.send(anims);
    }
  }
}

Future firstCachedIntoInternal() async
{
  print('start');
  var dir = await getApplicationCacheDirectory();
  dir.listSync().forEach((element) {element.deleteSync(recursive: true);});
  for (int cl = 0; cl < GameConsts.maxColumn; cl++) {
    for (int rw = 0; rw < GameConsts.maxRow; rw++) {
      try{
        var temp = await rootBundle.loadString(
            'assets/metaData/$cl-$rw.objXml', cache: false);
        File file = File('${dir.path}/$cl-$rw.objXml');
        file.writeAsStringSync(temp);
      }catch(e){
        e;
      }
      try {
        var temp1 = await rootBundle.loadString(
            'assets/metaData/$cl-${rw}_high.anim', cache: false);
        File file = File('${dir.path}/$cl-${rw}_high.anim');
        file.writeAsStringSync(temp1);
        var objects = XmlDocument.parse(temp1.toString()).findAllElements(
            'an');
        for (final obj in objects) {
          var path = obj.getAttribute('src')!.split('/');
          path.removeLast();
          Directory dirSs = Directory('${dir.path}/${path.join('/')}');
          dirSs.createSync(recursive: true);
          File file = File('${dir.path}/${obj.getAttribute('src')!}');
          var temp = await rootBundle.load('assets/${obj.getAttribute('src')!}');
          file.writeAsBytesSync(temp.buffer.asUint8List());
        }
      }catch(e){
        e;
      }
      try {
        var temp3 = await rootBundle.loadString(
            'assets/metaData/$cl-${rw}_down.anim', cache: false);
        File file = File('${dir.path}/$cl-${rw}_down.anim');
        file.writeAsStringSync(temp3);
        var objects = XmlDocument.parse(temp3.toString()).findAllElements('an');
        for (final obj in objects) {
          var path = obj.getAttribute('src')!.split('/');
          path.removeLast();
          Directory dirSs = Directory('${dir.path}/${path.join('/')}');
          dirSs.createSync(recursive: true);
          File file = File('${dir.path}/${obj.getAttribute('src')!}');
          var temp = await rootBundle.load('assets/${obj.getAttribute('src')!}');
          file.writeAsBytesSync(temp.buffer.asUint8List());
        }
      }catch(e){
        e;
      }
    }
  }
  print('end copy to internal');
}
