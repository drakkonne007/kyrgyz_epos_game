import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/components/game_worlds.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:mutex/mutex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

final mutex = Mutex();

Future loadObjs(GameWorldData worldData) async
{
  var dir = await getApplicationSupportDirectory();
  ReceivePort objsReceivePort = ReceivePort();
  var isol = await  Isolate.spawn<SendPort>(_loadObjs, objsReceivePort.sendPort,errorsAreFatal: false);
  SendPort objsSendPort = await objsReceivePort.first;
  ReceivePort objResponseReceivePort = ReceivePort();
  objsSendPort.send([
    objResponseReceivePort.sendPort,
    '${dir.path}/${worldData.nameForGame}',
    worldData.gameConsts.maxColumn!,
    worldData.gameConsts.maxRow!
  ]);

  final objsResponse = await objResponseReceivePort.first;
  if(objsResponse is Map<String,Iterable<XmlElement>>){
    KyrgyzGame.cachedObjXmls = objsResponse;
    isMapCached.value++;
  }
  objResponseReceivePort.close();
  objsReceivePort.close();
  isol.kill(priority: Isolate.immediate);
}

void _loadObjs(SendPort mySendPort) async
{
  ReceivePort mikeReceivePort = ReceivePort();
  mySendPort.send(mikeReceivePort.sendPort);
  await for (final message in mikeReceivePort) {
    if (message is List) {
      final SendPort mikeResponseSendPort = message[0];
      Map<String,Iterable<XmlElement>> objXmls = {};
      String path = message[1];
      int column = message[2];
      int row = message[3];
      for(int cl = 0; cl < column; cl++) {
        for (int rw = 0; rw < row; rw++) {
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

Future loadAnimsHigh(GameWorldData worldData) async
{
  var dir = await getApplicationSupportDirectory();
  ReceivePort animsReceivePort = ReceivePort();
  var isol = await Isolate.spawn<SendPort>(_loadAnimsHigh, animsReceivePort.sendPort,errorsAreFatal: false);
  SendPort animsSendPort = await animsReceivePort.first;
  ReceivePort animsResponseReceivePort = ReceivePort();
  animsSendPort.send([
    animsResponseReceivePort.sendPort,
    '${dir.path}/${worldData.nameForGame}',
    worldData.gameConsts.maxColumn!,
    worldData.gameConsts.maxRow!
  ]);

  final animPngsResponse = await animsResponseReceivePort.first;
  if(animPngsResponse is Map<String,Iterable<XmlElement>>){
    await mutex.protect(() async {
      KyrgyzGame.cachedAnims.addAll(animPngsResponse);
      for(final key in KyrgyzGame.cachedAnims.keys){
        for(final anim in KyrgyzGame.cachedAnims[key]!){
          KyrgyzGame.cachedImgs[anim.getAttribute('src')!] = await Flame.images.load(anim.getAttribute('src')!);
        }
      }
    });
    isMapCached.value++;
  }
  animsResponseReceivePort.close();
  animsReceivePort.close();
  isol.kill(priority: Isolate.immediate);
}

void _loadAnimsHigh(SendPort mySendPort) async
{
  ReceivePort mikeReceivePort = ReceivePort();
  mySendPort.send(mikeReceivePort.sendPort);
  await for (final message in mikeReceivePort) {
    if (message is List) {
      final SendPort mikeResponseSendPort = message[0];
      Map<String, Iterable<XmlElement>> anims = {};
      String path = message[1];
      int column = message[2];
      int row = message[3];
      for (int cl = 0; cl < column; cl++) {
        for (int rw = 0; rw < row; rw++) {
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

Future loadAnimsDown(GameWorldData worldData) async
{
  var dir = await getApplicationSupportDirectory();
  ReceivePort animsReceivePort = ReceivePort();
  var isol = await Isolate.spawn<SendPort>(_loadAnimsDown, animsReceivePort.sendPort,errorsAreFatal: false);
  SendPort animsSendPort = await animsReceivePort.first;
  ReceivePort animsResponseReceivePort = ReceivePort();
  animsSendPort.send([
    animsResponseReceivePort.sendPort,
    '${dir.path}/${worldData.nameForGame}',
    worldData.gameConsts.maxColumn!,
    worldData.gameConsts.maxRow!
  ]);

  final animPngsResponse = await animsResponseReceivePort.first;
  if(animPngsResponse is Map<String,Iterable<XmlElement>>){
    await mutex.protect(() async{
      KyrgyzGame.cachedAnims.addAll(animPngsResponse);
      for(final key in KyrgyzGame.cachedAnims.keys){
        for(final anim in KyrgyzGame.cachedAnims[key]!){
          KyrgyzGame.cachedImgs[anim.getAttribute('src')!] = await Flame.images.load(anim.getAttribute('src')!);
        }
      }
    });
    isMapCached.value++;
  }
  animsResponseReceivePort.close();
  animsReceivePort.close();
  isol.kill(priority: Isolate.immediate);
}

void _loadAnimsDown(SendPort mySendPort) async
{
  ReceivePort mikeReceivePort = ReceivePort();
  mySendPort.send(mikeReceivePort.sendPort);
  await for (final message in mikeReceivePort) {
    if (message is List) {
      final SendPort mikeResponseSendPort = message[0];
      Map<String, Iterable<XmlElement>> anims = {};
      String path = message[1];
      int column = message[2];
      int row = message[3];
      for (int cl = 0; cl < column; cl++) {
        for (int rw = 0; rw < row; rw++) {
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
  // var dir = await getApplicationCacheDirectory();
  var dir = await getApplicationSupportDirectory();
  // dir.listSync().forEach((element) {
  //   element.deleteSync(recursive: true);
  // });
  final allFullMaps = fullMaps();
  for(final bigWorlds in allFullMaps) {
    Directory dirdsds = Directory('${dir.path}/${bigWorlds.nameForGame}');
    if(dirdsds.existsSync()){
      dirdsds.deleteSync(recursive: true);
    }
    dirdsds.createSync(recursive: true);
  }

  for(final world in allFullMaps){
    print(world.nameForGame);
    for (int cl = 0; cl < world.gameConsts.maxColumn!; cl++) {
      for (int rw = 0; rw < world.gameConsts.maxRow!; rw++) {
        print('$cl-$rw');

        try {
          var temp = await rootBundle.loadString(
              'assets/metaData/${world.nameForGame}/$cl-$rw.objXml', cache: false);
          File file = File('${dir.path}/${world.nameForGame}/$cl-$rw.objXml');
          file.writeAsStringSync(temp);
          print('${world.nameForGame} success');
        } catch (e) {
          e;
        }
        try {
          var temp1 = await rootBundle.loadString(
              'assets/metaData/${world.nameForGame}/$cl-${rw}_high.anim', cache: false);
          File file = File('${dir.path}/${world.nameForGame}/$cl-${rw}_high.anim');
          file.writeAsStringSync(temp1);
          var objects = XmlDocument.parse(temp1.toString()).findAllElements(
              'an');
          for (final obj in objects) {
            var path = obj.getAttribute('src')!.split('/');
            path.removeLast();
            File file = File('${dir.path}/${world.nameForGame}/${obj.getAttribute('src')!}');
            var temp = await rootBundle.load(
                'assets/${obj.getAttribute('src')!}');
            file.writeAsBytesSync(temp.buffer.asUint8List());
          }
        } catch (e) {
          e;
        }
        try {
          var temp3 = await rootBundle.loadString(
              'assets/metaData/${world.nameForGame}/$cl-${rw}_down.anim', cache: false);
          File file = File('${dir.path}/${world.nameForGame}/$cl-${rw}_down.anim');
          file.writeAsStringSync(temp3);
          var objects = XmlDocument.parse(temp3.toString()).findAllElements('an');
          for (final obj in objects) {
            var path = obj.getAttribute('src')!.split('/');
            path.removeLast();
            File file = File('${dir.path}/${world.nameForGame}/${obj.getAttribute('src')!}');
            var temp = await rootBundle.load(
                'assets/${obj.getAttribute('src')!}');
            file.writeAsBytesSync(temp.buffer.asUint8List());
          }
        } catch (e) {
          e;
        }
      }
    }

  }
}
