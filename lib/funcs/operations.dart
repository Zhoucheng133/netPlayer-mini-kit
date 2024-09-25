import 'dart:ui';

import 'package:get/get.dart';
import 'package:netplayer_miniplay/variables/style_var.dart';
import 'package:window_manager/window_manager.dart';

class Operations{
  final StyleVar s=Get.put(StyleVar());
  void toggleWindow(){
    s.singleLyric.value=!s.singleLyric.value;
    if(s.singleLyric.value){
      windowManager.setSize(const Size(600, 130));
    }else{
      windowManager.setSize(const Size(300, 500));
    }
  }
}