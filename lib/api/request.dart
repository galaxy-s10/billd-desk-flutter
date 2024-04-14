import 'package:billd_desk_flutter/const.dart';
import 'package:get/get.dart' as get_x;
import 'package:billd_desk_flutter/stores/app.dart';
import 'package:dio/dio.dart';
import 'package:billd_desk_flutter/utils/index.dart';

class HttpRequest {
  static BaseOptions baseOptions = BaseOptions(
      baseUrl: axiosBaseUrl,
      connectTimeout: const Duration(seconds: axiosTimeoutSeconds));
  static Dio dio = Dio(baseOptions);

  static Future get(url, {Map<String, dynamic>? params}) async {
    final Controller store = get_x.Get.put(Controller());

    try {
      var resp = await dio.request(url,
          queryParameters: params,
          options: Options(
              method: 'get',
              headers: {'Authorization': 'Bearer ${store.token}'}));
      return resp.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future post(url, {Map<String, dynamic>? data}) async {
    try {
      final Controller store = get_x.Get.put(Controller());
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
            // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
            // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
            return handler.next(options);
          },
          onResponse: (Response response, ResponseInterceptorHandler handler) {
            // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
            billdPrint('====onResponse====');
            return handler.next(response);
          },
          onError: (DioException e, ErrorInterceptorHandler handler) {
            // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
            billdPrint('====onError====');
            handler.resolve(e.response!);
            // return handler.next(e);
          },
        ),
      );
      var resp = await dio.request(url,
          data: data,
          options: Options(
              method: 'post',
              headers: {'Authorization': 'Bearer ${store.token}'}));
      return resp.data;
    } catch (e) {
      rethrow;
    }
  }
}
