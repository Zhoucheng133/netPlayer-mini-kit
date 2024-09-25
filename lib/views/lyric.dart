import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_miniplay/variables/color_var.dart';
import 'package:netplayer_miniplay/variables/data_var.dart';
import 'package:netplayer_miniplay/variables/style_var.dart';

class Lyric extends StatefulWidget {
  const Lyric({super.key});

  @override
  State<Lyric> createState() => _LyricState();
}

class _LyricState extends State<Lyric> {

  final d=Get.put(DataVar());
  final c=ColorVar();
  final s=Get.put(StyleVar());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(()=>
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Stack(
            children: [
              Text(
                d.nowLyric.value,
                style: TextStyle(
                  fontSize: s.fontSize.value.toDouble(),
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.fade,
                  foreground: Paint()
                  ..style=PaintingStyle.stroke
                  ..strokeWidth=3
                  ..color=c.color6
                ),
                softWrap: false,
              ),
              Text(
                d.nowLyric.value,
                style: TextStyle(
                  fontSize: s.fontSize.value.toDouble(),
                  color: c.color1,
                  overflow: TextOverflow.fade,
                ),
                softWrap: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}