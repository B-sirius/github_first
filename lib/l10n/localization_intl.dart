import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'messages_all.dart';

class CustomLocalizations {
  static Future<CustomLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode!.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((value) {
      Intl.defaultLocale = localeName;
      return CustomLocalizations();
    });
  }

  static CustomLocalizations? of(BuildContext context) {
    return Localizations.of<CustomLocalizations>(context, CustomLocalizations);
  }

  get title {
    return Intl.message('Flutter APP',
        name: 'title', desc: 'Title for demo app');
  }

  get home {
    return Intl.message('Home Text',
        name: 'home', desc: 'Home ttext for demo app');
  }

  get login {
    return Intl.message('login', name: 'login', desc: 'login text');
  }

  get noDescription {
    return Intl.message('no description',
        name: 'noDescription', desc: 'no description');
  }

  get theme {
    return Intl.message('theme', name: 'theme');
  }

  get language {
    return Intl.message('language', name: 'language');
  }

  get logout {
    return Intl.message('logout', name: 'logout');
  }

  get logoutTip {
    return Intl.message('logoutTip', name: 'logoutTip');
  }

  get cancel {
    return Intl.message('cancel', name: 'cancel');
  }

  get yes {
    return Intl.message('yes', name: 'yes');
  }

  get password {
    return Intl.message('password', name: 'password');
  }

  get passwordRequired {
    return Intl.message('passwordRequired', name: 'passwordRequired');
  }

  get userName {
    return Intl.message('userName', name: 'userName');
  }

  get userNameRequired {
    return Intl.message('userNameRequired', name: 'userNameRequired');
  }

  get userNameOrPasswordWrong {
    return Intl.message('userNameOrPasswordWrong',
        name: 'userNameOrPasswordWrong');
  }

  get auto {
    return Intl.message('auto', name: 'auto');
  }
}

class CustomLocalizationsDelegate
    extends LocalizationsDelegate<CustomLocalizations> {
  const CustomLocalizationsDelegate();

  // 是否支持某个Local
  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  // Flutter会调用此类加载相应的Locale资源类
  @override
  Future<CustomLocalizations> load(Locale locale) {
    return CustomLocalizations.load(locale);
  }

  // 当Localizations Widget重新build时，是否调用load重新加载Locale资源
  @override
  bool shouldReload(CustomLocalizationsDelegate old) => false;
}
