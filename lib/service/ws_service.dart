import 'dart:io';

class WsService{
  late WebSocket socket;

  Future<void> init() async {
    socket = await WebSocket.connect('ws://127.0.0.1:9098');
    socket.listen((message) {
      // print('Received: $message');
    });
  }

  WsService(){
    init();
  }
  
}