import 'package:catmaster_app/ui/edit_store_page.dart';
import 'package:catmaster_app/ui/main_menu_page.dart';
import 'package:catmaster_app/ui/splash_page.dart';
import 'package:catmaster_app/utils/locale_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'ui/login_in_page.dart';
import 'package:oktoast/oktoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MaterialApp(
      title: "喵管家",
      home: SplashPage(),
      theme: ThemeData(
        primarySwatch: Colors.pink,
        buttonTheme: ButtonThemeData(
            minWidth: double.infinity,
            height: 40,
            buttonColor: Colors.pinkAccent,
            focusColor: Colors.pink,
            hoverColor: Colors.pink),
      ),
      localizationsDelegates: [
        ChineseCupertinoLocalizations.delegate, // 这里加上这个,是自定义的delegate
        DefaultCupertinoLocalizations.delegate, // 这个截止目前只包含英文
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
       supportedLocales: [
         const Locale('en', 'US'),
         const Locale('zh', 'CH'),
       ],
    ));
  }
}
