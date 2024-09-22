import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    init();
  }

  Future<void> init() async {
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
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansScTextTheme(),
      ),
      home: Obx(()=>
        Scaffold(
          backgroundColor: Colors.white.withAlpha(s.opacity.value),
          body: DragToMoveArea(
            child: Center(
              child: TextButton(
                onPressed: () async {
                  final top=await windowManager.isAlwaysOnTop();
                  windowManager.setAlwaysOnTop(!top);
                }, 
                child: const Text('切换顶置')
              ),
            )
          ),
        ),
      )
    );
  }
}
