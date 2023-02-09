import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_first/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "./cache.dart";
import "./git.dart";

// 主题色
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red
];

class Global {
  static SharedPreferences? _prefs;

  static Profile profile = Profile();

  // 网络缓存对象
  static NetCache netCache = NetCache();

  // 可选主题列表
  static List<MaterialColor> get themes => _themes;

  // 是否为release版本
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  // 初始化全局信息，在App启动时执行
  static Future init() async => _prefs = await SharedPreferences.getInstance();

  static Future getProfile() {
    final completer = Completer<String?>();
    final myProfile = _prefs?.getString("profile");
    if (myProfile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(myProfile));
      } catch (e) {
        print(e);
      }
    } else {
      profile = Profile();
      profile.theme = 0;
    }

    profile.cache = profile.cache ?? CacheConfig()
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;

    Git.init();

    print(_prefs);
    print('finished init');
    completer.complete(myProfile);
    return completer.future;
  }

  // 持久化Profile信息
  static saveProfile() {
    _prefs?.setString("profile", jsonEncode(profile.toJson()));
  }
}
