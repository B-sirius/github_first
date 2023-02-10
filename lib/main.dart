import 'package:flutter/material.dart';
import './common/global.dart';
import "package:provider/provider.dart";
import "package:github_first/states/index.dart";
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:github_first/l10n/localization_intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:github_first/routes/language.dart';
import 'package:github_first/routes/login.dart';
import 'package:github_first/routes/theme.dart';
import 'package:github_first/routes/home_page.dart';
import 'dart:io';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Global.init(),
        builder: (context, snapshot) {
          debugPrint(snapshot.connectionState.toString());
          if (snapshot.connectionState != ConnectionState.done) {
            return const MaterialApp(
              home: Center(
                child: Text('Initing.'),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ThemeState()),
              ChangeNotifierProvider(create: (_) => UserState()),
              ChangeNotifierProvider(create: (_) => LocaleState()),
            ],
            child: Consumer2<ThemeState, LocaleState>(
              builder: (BuildContext context, themeState, localeState, child) {
                return MaterialApp(
                  builder: EasyLoading.init(),
                  theme: ThemeData(
                    primarySwatch: themeState.theme,
                  ),
                  onGenerateTitle: (context) {
                    return CustomLocalizations.of(context)?.title;
                  },
                  home: HomeRoute(),
                  locale: localeState.getLocale(),
                  //我们只支持美国英语和中文简体
                  supportedLocales: const [
                    Locale('en', 'US'), // 美国英语
                    Locale('zh', 'CN'), // 中文简体
                  ],
                  localizationsDelegates: const [
                    // 本地化的代理类
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    CustomLocalizationsDelegate()
                  ],
                  localeResolutionCallback: (_locale, supportedLocales) {
                    if (localeState.getLocale() != null) {
                      //如果已经选定语言，则不跟随系统
                      return localeState.getLocale();
                    } else {
                      //跟随系统
                      Locale locale;
                      if (supportedLocales.contains(_locale)) {
                        locale = _locale!;
                      } else {
                        //如果系统语言不是中文简体或美国英语，则默认使用美国英语
                        locale = const Locale('en', 'US');
                      }
                      return locale;
                    }
                  },
                  // 注册路由表
                  routes: <String, WidgetBuilder>{
                    "login": (context) => const LoginRoute(),
                    "themes": (context) => ThemeChangeRoute(),
                    "language": (context) => LanguageRoute(),
                  },
                );
              },
            ),
          );
        });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
