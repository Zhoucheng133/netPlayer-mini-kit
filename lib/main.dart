import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_miniplay/service/ws_service.dart';
import 'package:netplayer_miniplay/variables/style_var.dart';
import 'package:netplayer_miniplay/views/main_view.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_popup/flutter_popup.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(300, 500),
    center: true,
    backgroundColor: Colors.transparent,
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
  
  WsService ws=WsService();
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
    ws.init("9098");
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
      home:  Obx(()=>
        Scaffold(
          backgroundColor: Color.fromARGB(s.opacity.value, 248, 249, 255),
          body: Column(
            children: [
              SizedBox(
                height: 25,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: DragToMoveArea(child: Container())),
                    CustomPopup(
                      content: SizedBox(
                        width: 150,
                        height: 50,
                        child: Column(
                          children: [
                            Obx(()=>
                              Row(
                                children: [
                                  Checkbox(
                                    splashRadius: 0,
                                    activeColor: Colors.blue,
                                    value: s.showShadow.value, 
                                    onChanged: (val) async {
                                      s.showShadow.value=val??true;
                                      if(!s.showShadow.value){
                                        await windowManager.setAsFrameless();
                                      }
                                      windowManager.setHasShadow(s.showShadow.value);
                                    }
                                  ),
                                  const SizedBox(width: 10,),
                                  GestureDetector(
                                    onTap: () async {
                                      s.showShadow.value=!s.showShadow.value;
                                      if(!s.showShadow.value){
                                        await windowManager.setAsFrameless();
                                      }
                                      windowManager.setHasShadow(s.showShadow.value);
                                    },
                                    child: const MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Text('显示窗口阴影')
                                    )
                                  )
                                ],
                              )
                            ),
                            SliderTheme(
                              data: SliderThemeData(
                                thumbColor: Colors.blue,
                                overlayColor: Colors.transparent,
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
                                trackHeight: 2,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 7,
                                  elevation: 0,
                                  pressedElevation: 0,
                                ),
                                activeTrackColor: Colors.blue[400],
                                inactiveTrackColor: Colors.blue[200],
                              ),
                              child: Obx(()=>
                                Slider(
                                  value: (s.opacity.value)/255, 
                                  onChanged: (val){
                                    s.opacity.value=(val*255).toInt();
                                  }
                                )
                              ),
                            ),
                          ],
                        )
                      ),
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
                          duration: const Duration(milliseconds: 200),
                          height: 25,
                          width: 40,
                          decoration: BoxDecoration(
                            color: hoverOpacity ? const Color.fromARGB(255, 240, 240, 240) : const Color.fromARGB(0, 230, 230, 230)
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.droplet,
                              size: 12,
                              color: Colors.grey[700],
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
                          duration: const Duration(milliseconds: 200),
                          height: 25,
                          width: 40,
                          decoration: BoxDecoration(
                            color: hoverPin ? const Color.fromARGB(255, 240, 240, 240) : const Color.fromARGB(0, 230, 230, 230)
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
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: hoverLyric ? const Color.fromARGB(255, 240, 240, 240) : const Color.fromARGB(0, 230, 230, 230)
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
                        windowManager.close();
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
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: hoverClose ? const Color.fromARGB(255, 210, 0, 0) : const Color.fromARGB(0, 230, 230, 230)
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
              ),
              Expanded(child: MainView(ws: ws,))
            ],
          ),
        ),
      )
    );
  }
}
