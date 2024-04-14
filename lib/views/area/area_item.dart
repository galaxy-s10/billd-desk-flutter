import 'package:billd_desk_flutter/const.dart';
import 'package:billd_desk_flutter/stores/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AreaItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final Controller store = Get.put(Controller());

  AreaItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    var w = (store.screenWidth.value / 2) - 20;
    var h = w / (normalVideoRatio);

    var imgurl = item['cover_img'];
    if (imgurl == null || imgurl == '') {
      imgurl = item['users']?[0]?['avatar'];
    }
    return Column(
      children: [
        SizedBox(
            width: w,
            height: h,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imgurl == null || imgurl == ''
                    ? Container(
                        decoration: const BoxDecoration(
                          color: themeColor,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      )
                    : Image.network(
                        imgurl,
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('加载图片错误');
                        },
                      ))),
        Container(
          width: w,
          alignment: Alignment.centerLeft,
          child: Text(
            item['name'],
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
