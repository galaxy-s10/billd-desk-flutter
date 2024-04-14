import 'package:billd_desk_flutter/api/area_api.dart';
import 'package:billd_desk_flutter/const.dart';
import 'package:billd_desk_flutter/stores/app.dart';
import 'package:billd_desk_flutter/utils/index.dart';
import 'package:billd_desk_flutter/views/area/area_item.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AreaList extends StatefulWidget {
  final int id;
  final String areaName;
  const AreaList({required this.id, required this.areaName, super.key});

  @override
  State<StatefulWidget> createState() => AreaListState();
}

class AreaListState extends State<AreaList> {
  Map<String, dynamic> areadata = {};
  final Controller store = Get.put(Controller());

  var id;
  var areaName;

  @override
  void initState() {
    id = widget.id;
    areaName = widget.areaName;
    super.initState();
    getData();
  }

  getData() async {
    var res;
    bool err = false;
    try {
      res = await AreaApi.getAreaLiveRoomList(id);
      if (res['code'] == 200) {
        setState(() {
          areadata = res['data'];
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var titleHeight = 40.0;
    var h = size.height - store.safeHeight.value - titleHeight;
    if (areadata['rows'] == null) {
      return fullLoading();
    }
    return Scaffold(
        body: SafeArea(
            child: RefreshIndicator(
      child: Column(
        children: [
          Container(
            height: titleHeight,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text(
              '$areaName分区',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          areadata['rows'].length == 0
              ? SizedBox(
                  height: h,
                  child: ListView(
                    children: const [
                      Center(
                        child: Text('暂无数据'),
                      )
                    ],
                  ),
                )
              : SizedBox(
                  height: h,
                  child: ListView.builder(
                      itemCount: areadata['total'],
                      itemBuilder: (context, index) {
                        var len = areadata["rows"].length;
                        return Container(
                          color: Colors.white,
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: [
                              len == 0
                                  ? Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                      child: const Text('暂无数据'),
                                    )
                                  : GridView.count(
                                      crossAxisCount: 2,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      mainAxisSpacing: 0,
                                      crossAxisSpacing: 0,
                                      // Item的宽高比，由于GridView的Item宽高并不由Item自身控制，默认情况下，交叉轴是横轴，因此Item的宽度均分屏幕宽度，这个时候设置childAspectRatio可以改变Item的高度，反之亦然；
                                      childAspectRatio:
                                          (normalVideoRatio) * 0.8,
                                      children: List.generate(len, (indey) {
                                        var res = areadata["rows"][indey];
                                        return res == null
                                            ? Container(
                                                alignment: Alignment.centerLeft,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 2, 0, 2),
                                                child: const Text('暂无数据'),
                                              )
                                            : AreaItemWidget(
                                                item: res,
                                              );
                                      })),
                            ],
                          ),
                        );
                      }),
                )
        ],
      ),
      onRefresh: () async {
        await getData();
        if (context.mounted) {
          BrnToast.show('刷新成功', context);
        }
      },
    )));
  }
}
