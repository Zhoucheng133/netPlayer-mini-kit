import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_miniplay/lang/zh_tw.dart';
import 'package:netplayer_miniplay/variables/ws_var.dart';
import 'package:netplayer_miniplay/views/main_window.dart';
import 'package:window_manager/window_manager.dart';
import 'package:netplayer_miniplay/lang/zh_cn.dart';
import 'package:netplayer_miniplay/lang/en_us.dart';


Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final wsVar=Get.put(WsVar());
  wsVar.port.value=args.isEmpty?"9098":args[0];
  wsVar.lang.value=args.length==2?args[1]:"zh_CN";
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

class MainTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'zh_CN': zhCN,
    'zh_TW': zhTW,
  };
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: MainTranslations(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansScTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home:const MainWindow(),
    );
  }
}