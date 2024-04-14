import 'package:billd_desk_flutter/api/user_api.dart';
import 'package:billd_desk_flutter/components/Loading/index.dart';
import 'package:billd_desk_flutter/const.dart';
import 'package:billd_desk_flutter/stores/app.dart';
import 'package:billd_desk_flutter/views/live/live.dart';
import 'package:flutter/material.dart';
import 'package:bruno/bruno.dart';
import 'package:get/get.dart';
import 'package:billd_desk_flutter/utils/index.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<StatefulWidget> createState() => UserState();
}

class UserState extends State<User> {
  // int? id;
  // String? password;
  int? id = 101;
  String? password = '123456';
  bool isLogin = false;

  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 检测页面是否在前台
    billdPrint('检测页面是否在前台user-$state');
  }

  @override
  Widget build(BuildContext context) {
    final Controller store = Get.put(Controller());

    return Column(children: [
      isLogin == true
          ? Container(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                store.userInfo['avatar'] == ''
                    ? Container(
                        decoration: const BoxDecoration(
                          color: themeColor,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      )
                    : CircleAvatar(
                        backgroundImage:
                            billdNetworkImage(store.userInfo['avatar']),
                      ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: Obx(() => Text('${store.userInfo['username']}')),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: BrnBigGhostButton(
                    title: '直播中心',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Live(),
                        ),
                      );
                    },
                  ),
                ),
                BrnBigGhostButton(
                  title: '退出登录',
                  bgColor: const Color.fromRGBO(244, 67, 54, 0.2),
                  titleColor: const Color.fromRGBO(244, 67, 54, 1),
                  onTap: () {
                    BrnDialogManager.showConfirmDialog(context,
                        barrierDismissible: false,
                        title: '提示',
                        message: '确定退出登录？',
                        cancel: '取消',
                        confirm: '确定',
                        onCancel: () => {Navigator.pop(context)},
                        onConfirm: () {
                          setState(() {
                            BrnToast.show('退出登录成功', context);
                            isLogin = false;
                            store.setToken('');
                            store.setUserInfo({});
                            Navigator.pop(context);
                          });
                        });
                  },
                )
              ]),
            )
          : Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      '欢迎登录',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  BrnTextInputFormItem(
                    controller: TextEditingController()..text = '${id ?? ''}',
                    title: "账号",
                    hint: "请输入账号",
                    inputType: BrnInputType.number,
                    onTip: () {},
                    onAddTap: () {},
                    onRemoveTap: () {},
                    onChanged: (newValue) {
                      setState(() {
                        if (newValue != '') {
                          id = int.parse(newValue);
                        }
                      });
                    },
                  ),
                  BrnTextInputFormItem(
                    controller: TextEditingController()..text = password ?? '',
                    title: "密码",
                    hint: "请输入密码",
                    inputType: BrnInputType.pwd,
                    obscureText: true,
                    onTip: () {},
                    onAddTap: () {},
                    onRemoveTap: () {},
                    onChanged: (newValue) {
                      setState(() {
                        password = newValue;
                      });
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: BrnBigGhostButton(
                      title: '登录',
                      onTap: () async {
                        // BrnToast.show("开始登录", context);
                        if (id == null || password == null) {
                          BrnToast.show('请输入完整', context);
                          return;
                        }
                        if (password!.length < 6 || password!.length > 10) {
                          BrnToast.show('密码长度要求6-10位', context);
                          return;
                        }
                        try {
                          BilldLoading.showLoading(context);
                          var res =
                              await UserApi.login(id: id!, password: password!);
                          if (res['code'] != 200) {
                            if (context.mounted) {
                              BrnToast.show(res['message'], context);
                            }
                            return;
                          }
                          store.setToken(res['data']);
                          var res1 = await UserApi.getUserInfo();
                          if (res1['code'] == 200) {
                            if (context.mounted) {
                              BrnToast.show('登录成功', context);
                            }
                            store.setUserInfo(res1['data']);
                            setState(() {
                              isLogin = true;
                            });
                          } else {
                            if (context.mounted) {
                              BrnToast.show(res['message'], context);
                            }
                          }
                        } catch (e) {
                          billdPrint(e);
                        } finally {
                          BilldLoading.stop();
                        }
                      },
                    ),
                  )
                ],
              ))
    ]);
  }
}
