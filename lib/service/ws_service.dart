import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:netplayer_miniplay/variables/data_var.dart';
import 'package:window_manager/window_manager.dart';

class WsService{
  WebSocket? socket;

  final d=Get.put(DataVar());

  Future<void> init(String port,) async {
    try {
      socket = await WebSocket.connect('ws://127.0.0.1:$port');
    } catch (_) {
      socket=null;
    }
    if(socket!=null){
      final command=json.encode({
        "command": 'get',
      });
      socket!.add(command);
      socket!.listen((message) {
        final msg=json.decode(message);

        if(msg['command']=="close"){
          windowManager.close();
        }else{
          d.artist.value=msg['artist'];
          d.cover.value=msg['cover'];
          d.line.value=msg['line'];
          d.lyric.value=msg['fullLyric'];
          d.title.value=msg['title'];
          d.isPlay.value=msg['isPlay'];
          d.playMode.value=msg['mode'];
          d.nowLyric.value=msg['lyric'];
        }
      });
    }
  }

  toggle(){
    final command=json.encode({
      "command": d.isPlay.value ? 'pause': 'play'
    });
    try {
      socket!.add(command);
    } catch (_) {}
    d.isPlay.value=!d.isPlay.value;
  }

  skip(){
    final command=json.encode({
      "command": "skip"
    });
    try {
      socket!.add(command);
    } catch (_) {}
  }

  forw(){
    final command=json.encode({
      "command": "forw"
    });
    try {
      socket!.add(command);
    } catch (_) {}
  }
  
  mode(String val){
    final command=json.encode({
      "command": "mode",
      "data": val,
    });
    try {
      socket!.add(command);
    } catch (_) {}
  }

  close(){
    final command=json.encode({
      "command": "miniClose"
    });
    try {
      socket!.add(command);
    } catch (_) {}
  }
}