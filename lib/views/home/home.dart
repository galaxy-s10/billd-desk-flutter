import 'dart:ui' as ui;

import 'package:billd_desk_flutter/api/live_api.dart';
import 'package:billd_desk_flutter/const.dart';
import 'package:billd_desk_flutter/stores/app.dart';
import 'package:billd_desk_flutter/utils/index.dart';

import 'package:flutter/material.dart';
import 'package:bruno/bruno.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

VideoPlayerController? _controller;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  final Controller store = Get.put(Controller());
  Map<String, dynamic> livedata = {};
  ValueNotifier<int> currentItemIndex = ValueNotifier(0);
  bool loading = false;
  double videoRatio = normalVideoRatio;

  @override
  initState() {
    super.initState();
    getData().then((_) {
      if (store.tabIndex.value == 0) {
        playVideo(livedata['rows']?[currentItemIndex.value]?['live_room']
            ?['hls_url']);
      }
    });
    store.tabIndex.listen((value) async {
      if (value != 0) {
        await stopVideo();
      } else {
        await playVideo(livedata['rows']?[currentItemIndex.value]?['live_room']
            ?['hls_url']);
      }
    });
    currentItemIndex.addListener(() async {
      await playVideo(
          livedata['rows']?[currentItemIndex.value]?['live_room']['hls_url']);
    });
  }

  Future getData() async {
    var res;
    bool err = false;
    try {
      res = await LiveApi.getLiveList();
      if (res['code'] == 200) {
        setState(() {
          livedata = res['data'];
        });
      } else {
        err = true;
      }
    } catch (e) {
      billdPrint(e);
    }
    if (err && context.mounted) {
      BrnToast.show(res['message'], context);
    }
    return err;
  }

  playVideo(String url) async {
    try {
      await stopVideo();
      String newurl = url.replaceAll('localhost', localIp);
      billdPrint('newurl:$newurl');
      var res = VideoPlayerController.networkUrl(Uri.parse(newurl),
          videoPlayerOptions: VideoPlayerOptions());
      _controller = res;
      setState(() {});
      await res.initialize();
      await res.play();
      videoRatio = res.value.aspectRatio;
      setState(() {
        loading = false;
      });
    } catch (e) {
      billdPrint('播放错误');
      billdPrint(e);
      if (context.mounted) {
        BrnToast.show('播放错误', context);
      }
    }
  }

  stopVideo() async {
    setState(() {
      loading = true;
    });
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (livedata['rows'] != null && store.tabIndex.value == 0) {
      final size = MediaQuery.of(context).size;
      double height =
          size.height - kBottomNavigationBarHeight - store.safeHeight.value;
      var imgurl =
          livedata['rows']?[currentItemIndex.value]?['live_room']['cover_img'];
      if (imgurl == null || imgurl == '') {
        imgurl = livedata['rows'][currentItemIndex.value]['user']['avatar'];
      }
      return Container(
          decoration: imgurl == null || imgurl == ''
              ? const BoxDecoration(color: Colors.black)
              : BoxDecoration(
                  image: DecorationImage(
                  image: billdNetworkImage(imgurl),
                  fit: BoxFit.cover,
                )),
          width: store.screenWidth.value,
          height: height,
          child: ClipRect(
            child: BackdropFilter(
              filter:
                  ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // 设置模糊效果的程度
              child: CarouselSlider.builder(
                itemCount: livedata.isNotEmpty ? livedata['total'] : 0,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  if (_controller != null && livedata['rows'] != null) {
                    return Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: loading
                              ? const Text(
                                  '加载中...',
                                  style: TextStyle(
                                    color: themeColor,
                                    fontSize: 20,
                                  ),
                                )
                              : AspectRatio(
                                  aspectRatio: videoRatio,
                                  child: VideoPlayer(_controller!),
                                ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromRGBO(0, 0, 0, 0.5),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            margin: const EdgeInsets.fromLTRB(6, 0, 0, 6),
                            child: Container(
                                transform: Matrix4.translationValues(0, -1, 0),
                                child: Text(
                                  '${livedata['rows']?[currentItemIndex.value]?['live_room']['name']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              child: Container(
                                height: 50,
                                // color: Colors.red,
                                margin: const EdgeInsets.fromLTRB(0, 0, 20, 20),
                                child: Column(children: [
                                  Image.asset(
                                    "assets/images/home/sync.png",
                                    width: 30,
                                  ),
                                  const Text(
                                    '同步',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                              ),
                              onTap: () async {
                                await playVideo(livedata['rows']
                                        [currentItemIndex.value]['live_room']
                                    ['hls_url']);
                              },
                            )),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              child: Container(
                                height: 50,
                                margin: const EdgeInsets.fromLTRB(0, 0, 20, 90),
                                child: Column(children: [
                                  Image.asset(
                                    "assets/images/home/reload.png",
                                    width: 30,
                                  ),
                                  const Text(
                                    '刷新',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                              ),
                              onTap: () async {
                                var err = await getData();
                                if (!err) {
                                  if (context.mounted) {
                                    BrnToast.show('更新直播列表成功', context);
                                  }
                                }
                              },
                            ))
                      ],
                    );
                  }
                  return Container();
                },
                options: CarouselOptions(
                    height: height,
                    autoPlay: false,
                    enlargeCenterPage: false,
                    viewportFraction: 1,
                    scrollDirection: Axis.vertical,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 300),
                    onPageChanged: (index, reason) async {
                      setState(() {
                        currentItemIndex.value = index;
                      });
                    }),
              ),
            ),
          ));
    } else {
      return Container();
    }
  }
}
