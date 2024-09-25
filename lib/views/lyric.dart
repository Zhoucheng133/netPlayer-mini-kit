import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_miniplay/variables/color_var.dart';
import 'package:netplayer_miniplay/variables/data_var.dart';

class Lyric extends StatefulWidget {
  const Lyric({super.key});

  @override
  State<Lyric> createState() => _LyricState();
}

class _LyricState extends State<Lyric> {

  final d=Get.put(DataVar());
  final c=ColorVar();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(()=>
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Text(
            d.nowLyric.value,
            style: TextStyle(
              fontSize: 18,
              color: c.color6,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.fade,
            ),
            softWrap: false,
          ),
        ),
      ),
    );
  }
}