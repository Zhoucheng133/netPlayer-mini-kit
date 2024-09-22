// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_miniplay/service/ws_service.dart';
import 'package:netplayer_miniplay/variables/style_var.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(300, 500),
    center: true,
    // backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: 'netPlayer mini'
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WindowListener {

  final StyleVar s=Get.put(StyleVar());
  final WsService ws=WsService();
  bool alwaysOnTop=false;
  bool hoverPin=false;
  bool hoverLyric=false;
  bool hoverClose=false;
  bool hoverOpacity=false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    init();
  }

  Future<void> init() async {
    await windowManager.setResizable(false);
    // await windowManager.setAsFrameless();
    // await windowManager.setHasShadow(false);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansScTextTheme(),
      ),
      home: Obx(()=>
        Scaffold(
          backgroundColor: Colors.white.withAlpha(s.opacity.value),
          body: DragToMoveArea(
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Container()),
                        GestureDetector(
                          onTap: (){
                            // TODO 切换透明度
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_){
                              setState(() {
                                hoverOpacity=true;
                              });
                            },
                            onExit: (_){
                              setState(() {
                                hoverOpacity=false;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              height: 25,
                              width: 40,
                              decoration: BoxDecoration(
                                color: hoverOpacity ? Colors.grey[200] : Colors.white
                              ),
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.droplet,
                                  size: 12,
                                  color: alwaysOnTop ? Colors.grey[700] : Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              alwaysOnTop=!alwaysOnTop;
                            });
                            windowManager.setAlwaysOnTop(alwaysOnTop);
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_){
                              setState(() {
                                hoverPin=true;
                              });
                            },
                            onExit: (_){
                              setState(() {
                                hoverPin=false;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              height: 25,
                              width: 40,
                              decoration: BoxDecoration(
                                color: hoverPin ? Colors.grey[200] : Colors.white
                              ),
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.thumbtack,
                                  size: 12,
                                  color: alwaysOnTop ? Colors.grey[700] : Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            // TODO 切换歌词
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_){
                              setState(() {
                                hoverLyric=true;
                              });
                            },
                            onExit: (_){
                              setState(() {
                                hoverLyric=false;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: hoverLyric ? Colors.grey[200] : Colors.white
                              ),
                              height: 25,
                              width: 40,
                              child: Center(
                                child: Icon(
                                  Icons.lyrics_rounded,
                                  size: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            // TODO 关闭
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_){
                              setState(() {
                                hoverClose=true;
                              });
                            },
                            onExit: (_){
                              setState(() {
                                hoverClose=false;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: hoverClose ? Colors.red[600] : Colors.white
                              ),
                              height: 25,
                              width: 40,
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.xmark,
                                  size: 14,
                                  color: hoverClose ? Colors.white : Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ),
        ),
      )
    );
  }
}
