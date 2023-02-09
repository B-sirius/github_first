import 'package:flutter/material.dart';
import 'package:github_first/common/Global.dart';

import "package:github_first/models/profile.dart";
import "package:github_first/models/user.dart";

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;

  void notifyListeners() {
    Global.saveProfile(); // 保存状态变更
    super.notifyListeners(); // 通知依赖的Widget更新
  }
}

// 用户状态
class UserState extends ProfileChangeNotifier {
  User? get user => _profile.user;

  // 是否登陆
  bool get isLogin => user != null;

  set user(User? user) {
    if (user?.login != _profile.user?.login) {
      _profile.lastLogin = _profile.user?.login;
      _profile.user = user;
      notifyListeners();
    }
  }
}

// APP主题状态
class ThemeState extends ProfileChangeNotifier {
  ColorSwatch get theme =>
      Global.themes.firstWhere((item) => item.value == _profile.theme,
          orElse: () => Colors.blue);

  set theme(ColorSwatch color) {
    if (color != theme && color[500] != null) {
      _profile.theme = color[500]!.value;
      notifyListeners();
    }
  }
}

// APP语言状态
class LocaleState extends ProfileChangeNotifier {
  Locale? getLocale() {
    if (_profile.locale == null) return null;
    var t = _profile.locale!.split("_");
    return Locale(t[0], t[1]);
  }

  String? get locale => _profile.locale;

  set locale(String? locale) {
    if (locale != _profile.locale) {
      _profile.locale = locale;
      notifyListeners();
    }
  }
}
