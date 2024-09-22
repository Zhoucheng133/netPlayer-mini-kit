import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:netplayer_miniplay/variables/data_var.dart';

class WsService{
  late WebSocket socket;

  final d=Get.put(DataVar());

  Future<void> init(String port) async {
    socket = await WebSocket.connect('ws://127.0.0.1:$port');
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
    socket.add(d.isPlay.value ? 'pause': 'play');
    d.isPlay.value=!d.isPlay.value;
  }

  skip(){
    socket.add("skip");
  }

  forw(){
    socket.add('forw');
  }
  
}