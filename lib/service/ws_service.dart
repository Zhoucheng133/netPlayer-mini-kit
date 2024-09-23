import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:netplayer_miniplay/variables/data_var.dart';

class WsService{
  late WebSocket socket;

  final d=Get.put(DataVar());

  Future<void> init(String port) async {
    socket = await WebSocket.connect('ws://127.0.0.1:$port');
    final command=json.encode({
      "command": 'get',
    });
    socket.add(command);
    socket.listen((message) {
      final msg=json.decode(message);
      d.artist.value=msg['artist'];
      d.cover.value=msg['cover'];
      d.line.value=msg['line'];
      d.lyric.value=msg['fullLyric'];
      d.title.value=msg['title'];
      d.isPlay.value=msg['isPlay'];
    });
  }

  toggle(){
    final command=json.encode({
      "command": d.isPlay.value ? 'pause': 'play'
    });
    socket.add(command);
    d.isPlay.value=!d.isPlay.value;
  }

  skip(){
    final command=json.encode({
      "command": "skip"
    });
    socket.add(command);
  }

  forw(){
    final command=json.encode({
      "command": "forw"
    });
    socket.add(command);
  }
  
}