import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_miniplay/service/ws_service.dart';
import 'package:netplayer_miniplay/variables/color_var.dart';
import 'package:netplayer_miniplay/variables/data_var.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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
  late Worker listener;
  bool hoverMode=false;

  bool playedLyric(int index){
    if(d.lyric.length==1){
      return true;
    }
    return d.line.value-1==index;
  }

  AutoScrollController controller=AutoScrollController();

  void scrollLyric(){
    if(d.line.value==0){
      return;
    }
    controller.scrollToIndex(d.line.value-1, preferPosition: AutoScrollPosition.middle);
  }

  @override
  void initState() {
    super.initState();
    listener=ever(d.line, (_){
      scrollLyric();
    });
    Future.delayed(const Duration(seconds: 3), (){
      if(widget.ws.socket==null){
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          showDialog(
            context: context, builder: (context)=>AlertDialog(
              title: const Text('连接失败'),
              content: const Text('请检查netPlayer是否打开ws服务'),
              actions: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  child: const Text('好的')
                )
              ],
            )
          );
        });
      }
    });
  }

  @override
  void dispose() {
    listener.dispose();
    super.dispose();
  }
  

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
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double topBottomHeight = constraints.maxHeight / 2;
                      return ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: Obx(()=>
                          ListView.builder(
                            controller: controller,
                            itemCount: d.lyric.length,
                            itemBuilder: (BuildContext context, int index){
                              return Column(
                                children: [
                                  index==0 ?  SizedBox(height: topBottomHeight-30,) :Container(),
                                  AutoScrollTag(
                                    key: ValueKey(index), 
                                    controller: controller, 
                                    index: index,
                                    child: Text(
                                      d.lyric[index]['content'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        height: 2.3,
                                        color: playedLyric(index) ? c.color5:c.color3,
                                        fontWeight: playedLyric(index) ? FontWeight.bold: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  index==d.lyric.length-1 ? SizedBox(height: topBottomHeight-10,) : Container(),
                                ],
                              );
                            }
                          )
                        ),
                      );
                    }
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: PopupMenuButton(
                      color: c.color1,
                      // splashRadius: 0,
                      onSelected: (val) async {
                        d.playMode.value=val;
                        widget.ws.mode(val);
                      },
                      itemBuilder: (BuildContext context)=>[
                        PopupMenuItem(
                          value: "list",
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.repeat_rounded,
                                size: 18,
                              ),
                              const SizedBox(width: 5,),
                              Text("loop".tr)
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: "repeat",
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.repeat_one_rounded,
                                size: 18,
                              ),
                              const SizedBox(width: 5,),
                              Text("single".tr)
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: "random",
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shuffle_rounded,
                                size: 18,
                              ),
                              const SizedBox(width: 5,),
                              Text("shuffle".tr)
                            ],
                          ),
                        )
                      ],
                      child: Container(
                        color: c.color1,
                        child: Tooltip(
                          waitDuration: const Duration(seconds: 1),
                          message: 'playMode'.tr,
                          child: MouseRegion(
                            onEnter: (_){
                              setState(() {
                                hoverMode=true;
                              });
                            },
                            onExit: (_){
                              setState(() {
                                hoverMode=false;
                              });
                            },
                            child: TweenAnimationBuilder(
                              tween: ColorTween(end: hoverMode ? c.color6 : c.color5), 
                              duration: const Duration(milliseconds: 200), 
                              builder: (_, value, __)=>Obx(()=>
                                d.playMode.value=='list' ?  Icon(
                                  Icons.repeat_rounded,
                                  size: 18,
                                  color: value,
                                ) : d.playMode.value=='repeat' ?
                                Icon(
                                  Icons.repeat_one_rounded,
                                  size: 18,
                                  color: value
                                ) : Icon(
                                  Icons.shuffle_rounded,
                                  size: 18,
                                  color: value,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    )
                  )
                ],
              ),
            )
          )
        ],
      )
    );
  }
}