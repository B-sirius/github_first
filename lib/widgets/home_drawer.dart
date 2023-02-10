import 'package:github_first/states/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:github_first/l10n/localization_intl.dart';
import 'package:github_first/widgets/gm_avatar.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(), //构建抽屉菜单头部
            Expanded(child: _buildMenus()), //构建功能菜单
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<UserState>(
      builder: (BuildContext context, UserState value, Widget? child) {
        return GestureDetector(
          child: Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.only(top: 60, bottom: 20),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ClipOval(
                    // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                    child: value.isLogin
                        ? gmAvatar(value.user!.avatar_url!,
                            width: 80, height: 80)
                        : Image.asset(
                            "imgs/avatar-default.png",
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Text(
                  value.isLogin
                      ? value.user!.login
                      : CustomLocalizations.of(context)?.login,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            if (!value.isLogin) Navigator.of(context).pushNamed("login");
          },
        );
      },
    );
  }

  // 构建菜单项
  Widget _buildMenus() {
    return Consumer<UserState>(
      builder: (BuildContext context, UserState userModel, Widget? child) {
        var gm = CustomLocalizations.of(context);
        return ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: Text(gm?.theme),
              onTap: () => Navigator.pushNamed(context, "themes"),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(gm?.language),
              onTap: () => Navigator.pushNamed(context, "language"),
            ),
            if (userModel.isLogin)
              ListTile(
                leading: const Icon(Icons.power_settings_new),
                title: Text(gm?.logout),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      //退出账号前先弹二次确认窗
                      return AlertDialog(
                        content: Text(gm?.logoutTip),
                        actions: <Widget>[
                          TextButton(
                            child: Text(gm?.cancel),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text(gm?.yes),
                            onPressed: () {
                              //该赋值语句会触发MaterialApp rebuild
                              userModel.user = null;
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
