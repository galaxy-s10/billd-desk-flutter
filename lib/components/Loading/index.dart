import 'package:billd_desk_flutter_pro/const.dart';
import 'package:flutter/material.dart';

class BilldLoading {
  static OverlayEntry? inst;

  static void showLoading(BuildContext context) {
    stop();
    inst = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(
            color: themeColor,
          ),
        ),
      ),
    );
    Overlay.of(context).insert(inst!);
  }

  static void stop() {
    if (inst != null) {
      inst!.remove();
      inst = null;
    }
  }
}
