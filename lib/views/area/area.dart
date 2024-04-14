import 'package:billd_desk_flutter/api/area_api.dart';
import 'package:billd_desk_flutter/const.dart';
import 'package:billd_desk_flutter/utils/index.dart';
import 'package:billd_desk_flutter/views/area/area_item.dart';
import 'package:billd_desk_flutter/views/area/list.dart';
import 'package:bruno/bruno.dart';

import 'package:flutter/material.dart';

class Area extends StatefulWidget {
  const Area({super.key});

  @override
  State<StatefulWidget> createState() => AreaState();
}

class AreaState extends State<Area> {
  Map<String, dynamic> areadata = {};

  @override
  initState() {
    super.initState();
    billdPrint('initState-area');
    getData();
  }

  getData() async {
    var res;
    bool err = false;
    try {
      res = await AreaApi.getAreaAreaLiveRoomList();
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
    if (areadata.isEmpty) {
      return fullLoading();
    }
    return RefreshIndicator(
      child: ListView.builder(
          itemCount: areadata['total'],
          itemBuilder: (context, index) {
            if (areadata['rows'] != null) {
              var len = areadata["rows"][index]['area_live_rooms'].length;
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text(areadata["rows"][index]['name'])),
                            GestureDetector(
                              child: const Text(
                                '查看全部',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AreaList(
                                      id: areadata["rows"][index]['id'],
                                      areaName: areadata["rows"][index]['name'],
                                    ),
                                  ),
                                );
                              },
                            )
                          ]),
                    ),
                    len == 0
                        ? Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                            child: const Text('暂无数据'),
                          )
                        : GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 0,
                            // Item的宽高比，由于GridView的Item宽高并不由Item自身控制，默认情况下，交叉轴是横轴，因此Item的宽度均分屏幕宽度，这个时候设置childAspectRatio可以改变Item的高度，反之亦然；
                            childAspectRatio: (normalVideoRatio) * 0.8,
                            children: List.generate(len, (indey) {
                              var res = areadata["rows"][index]
                                  ['area_live_rooms'][indey]['live_room'];
                              return res == null
                                  ? Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                      child: const Text('暂无数据'),
                                    )
                                  : AreaItemWidget(
                                      item: res,
                                    );
                            })),
                  ],
                ),
              );
            }
            return null;
          }),
      onRefresh: () async {
        await getData();
        if (context.mounted) {
          BrnToast.show('刷新成功', context);
        }
      },
    );
  }
}
