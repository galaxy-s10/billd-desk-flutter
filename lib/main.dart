import 'dart:async';

import 'package:billd_desk_flutter_pro/api/global_msg.dart';
import 'package:billd_desk_flutter_pro/const.dart';
import 'package:billd_desk_flutter_pro/stores/app.dart';
import 'package:billd_desk_flutter_pro/utils/index.dart';
import 'package:billd_desk_flutter_pro/views/connect/connect.dart';
import 'package:billd_desk_flutter_pro/views/setting/setting.dart';
import 'package:bruno/bruno.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  final Controller store = Get.put(Controller());
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  store.appInfo.value = packageInfo;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    billdRequestPermissions();
    final size = MediaQuery.of(context).size;
    final Controller store = Get.put(Controller());
    store.setScreenWidth(size.width);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false, //右上角的debug信息
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        // primaryColor: Colors.red,
      ),
      home: const NavBarWidget(),
    );
  }
}

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return NavBarState();
  }
}

class NavBarState extends State<NavBarWidget> {
  final Controller store = Get.put(Controller());
  var currentTabIndex = 0;
  var exitTimer = false;
  var exitDelay = 1;

  @override
  initState() {
    super.initState();
    init();
  }

  init() async {
    try {
      var res = await GlobalMsgGlobalApi.fetchGlobalMsgGlobal(
        orderName: 'priority',
        orderBy: 'desc',
        show: 0,
      );
      if (res['code'] == 200) {
        setState(() {
          store.globalMsg.value = res['data'];
        });
      }
    } catch (e) {
      billdPrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.paddingOf(context);
    final size = MediaQuery.of(context).size;
    var normalHeight =
        size.height - kBottomNavigationBarHeight - store.safeHeight.value;
    store.setNormalHeight(normalHeight);
    store.setSafeHeight(padding.top);
    store.setTabIndex(currentTabIndex);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        if (exitTimer == true) {
          setState(() {
            exitTimer = false;
          });
          SystemNavigator.pop();
        } else {
          BrnToast.show(
            '再按一次退出$appTitle',
            context,
            duration: Duration(seconds: exitDelay),
          );
          setState(() {
            exitTimer = true;
          });
          Future.delayed(Duration(seconds: exitDelay), () {
            if (mounted) {
              setState(() {
                exitTimer = false;
              });
            }
          });
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Color.fromRGBO(247, 247, 247, 1),
            // appBar: AppBar(title: const Text(appTitle)),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              items: [
                createBarItem('connect', '连接'),
                createBarItem('setting', '设置'),
              ],

              currentIndex: currentTabIndex,
              onTap: (int index) {
                store.setTabIndex(index);
                setState(() {
                  currentTabIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 14,
              unselectedFontSize: 14,
              selectedItemColor: themeColor,
            ),
            body: SafeArea(
              child: IndexedStack(
                index: currentTabIndex,
                children: const [Connect(), Setting()],
              ),
            ),
          ),
          axiosBaseUrl.contains('hsslive') == false
              ? const Positioned(
                bottom: 55,
                right: 10,
                child: IgnorePointer(
                  child: Text(
                    'beta',
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 14,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              )
              : Container(),
        ],
      ),
    );
  }
}

BottomNavigationBarItem createBarItem(String iconName, String label) {
  return BottomNavigationBarItem(
    icon: Image.asset("assets/images/tabbar/$iconName.png", width: 26),
    activeIcon: Image.asset(
      "assets/images/tabbar/${iconName}_active.png",
      width: 26,
    ),
    label: label,
  );
}
