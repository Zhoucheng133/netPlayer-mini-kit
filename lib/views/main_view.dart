import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_miniplay/service/ws_service.dart';
import 'package:netplayer_miniplay/variables/color_var.dart';
import 'package:netplayer_miniplay/variables/data_var.dart';

class MainView extends StatefulWidget {

  final WsService ws;

  const MainView({super.key, required this.ws});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  final DataVar d=Get.put(DataVar());
  final ColorVar c=ColorVar();
  bool hoverSkip=false;
  bool hoverPre=false;
  bool hoverPause=false;
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        children: [
          Row(
            children: [
              Obx(()=>
                d.cover.value.isNotEmpty ? Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image:  DecorationImage(
                      image: NetworkImage(d.cover.value),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ): const SizedBox(
                  width: 60,
                  height: 60,
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: Obx(()=>
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.title.value,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        d.artist.value,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600]
                        ),
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  widget.ws.forw();
                },
                child: Tooltip(
                  waitDuration: const Duration(seconds: 1),
                  message: 'skipPre'.tr,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_){
                      setState(() {
                        hoverPre=true;
                      });
                    },
                    onExit: (_){
                      setState(() {
                        hoverPre=false;
                      });
                    },
                    child: TweenAnimationBuilder(
                      tween: ColorTween(end: hoverPre ? c.color6 : c.color5), 
                      duration: const Duration(milliseconds: 200),
                      builder: (_, value, __) => Icon(
                        Icons.skip_previous_rounded,
                        color: value,
                      ),
                    )
                  ),
                ),
              ),
              const SizedBox(width: 15,),
              GestureDetector(
                onTap: (){
                  widget.ws.toggle();
                },
                child: Tooltip(
                  waitDuration: const Duration(seconds: 1),
                  message: 'play/pause'.tr,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_){
                      setState(() {
                        hoverPause=true;
                      });
                    },
                    onExit: (_){
                      setState(() {
                        hoverPause=false;
                      });
                    },
                    child: AnimatedContainer(
                      height: 34,
                      width: 34,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: hoverPause ? c.color6 : c.color5
                      ),
                      duration: const Duration(milliseconds: 200),
                      child: Center(
                        child: Obx(()=>
                          d.isPlay.value ? const Icon(
                            Icons.pause_rounded,
                            color: Colors.white,
                          ): const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                          )
                        )
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15,),
              GestureDetector(
                onTap: (){
                  widget.ws.skip();
                },
                child: Tooltip(
                  waitDuration: const Duration(seconds: 1),
                  message: 'skipNext'.tr,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_){
                      setState(() {
                        hoverSkip=true;
                      });
                    },
                    onExit: (_){
                      setState(() {
                        hoverSkip=false;
                      });
                    },
                    child: TweenAnimationBuilder(
                      tween: ColorTween(end: hoverSkip ? c.color6 : c.color5), 
                      duration: const Duration(milliseconds: 200),
                      builder: (_, value, __) => Icon(
                        Icons.skip_next_rounded,
                        color: value,
                      ),
                    )
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Obx(()=>
                ListView.builder(
                  itemCount: d.lyric.length,
                  itemBuilder: (BuildContext context, int index){
                    return Text(
                      d.lyric[index]['content'],
                      textAlign: TextAlign.center,
                    );
                  }
                )
              ),
            )
          )
        ],
      )
    );
  }
}