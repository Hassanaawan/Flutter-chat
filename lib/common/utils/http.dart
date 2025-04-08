import 'dart:async';

import 'package:chat/common/store/user.dart';
import 'package:chat/common/utils/loading.dart';

import 'package:chat/common/values/server.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData;

/*
  * HTTP Utility Class
*/
class HttpUtil {
  static HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;

  late Dio dio;
  CancelToken cancelToken = CancelToken();

  HttpUtil._internal() {
    // BaseOptions, Options, and RequestOptions can all configure parameters,
    // with priority increasing in order, and parameters can be overridden based on priority
    BaseOptions options = BaseOptions(
      // Base URL for requests, can include sub-paths
      baseUrl: SERVER_API_URL,

      // Connection timeout in milliseconds
      connectTimeout: 10000 as Duration,

      // Interval between receiving data in the response stream, in milliseconds
      receiveTimeout: 5000 as Duration,

      // HTTP request headers
      headers: {},

      /// Request Content-Type, default is "application/json; charset=utf-8"
      /// If you want to encode request data as "application/x-www-form-urlencoded",
      /// set this option to `Headers.formUrlEncodedContentType`.
      contentType: 'application/json; charset=utf-8',

      /// ResponseType defines how the response data is expected to be received.
      /// Supported types: `JSON`, `STREAM`, `PLAIN`.
      /// Default is `JSON`. If content-type is "application/json", Dio automatically
      /// converts the response content to a JSON object.
      responseType: ResponseType.json,
    );

    dio = Dio(options);

    // Cookie management
    CookieJar cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    // Adding interceptors
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Do something before the request is sent
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Do something with response data
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        // Handle response errors
        Loading.dismiss();
        ErrorEntity eInfo = createErrorEntity(e);
        onError(eInfo);
        return handler.next(e);
      },
    ));
  }

  /*
   * Unified error handling
   */

  void onError(ErrorEntity eInfo) {
    print('error.code -> ${eInfo.code}, error.message -> ${eInfo.message}');
    switch (eInfo.code) {
      case 401:
        UserStore.to.onLogout();
        EasyLoading.showError(eInfo.message);
        break;
      default:
        EasyLoading.showError('Unknown Error');
        break;
    }
  }

  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        return ErrorEntity(code: -1, message: "Request Cancelled");
      case DioErrorType.connectionTimeout:
        return ErrorEntity(code: -1, message: "Connection Timeout");
      case DioErrorType.sendTimeout:
        return ErrorEntity(code: -1, message: "Request Timeout");
      case DioErrorType.receiveTimeout:
        return ErrorEntity(code: -1, message: "Response Timeout");
      case DioErrorType.badResponse:
        {
          int errCode = error.response?.statusCode ?? -1;
          switch (errCode) {
            case 400:
              return ErrorEntity(code: errCode, message: "Bad Request");
            case 401:
              return ErrorEntity(code: errCode, message: "Unauthorized");
            case 403:
              return ErrorEntity(code: errCode, message: "Forbidden");
            case 404:
              return ErrorEntity(code: errCode, message: "Not Found");
            case 500:
              return ErrorEntity(
                  code: errCode, message: "Internal Server Error");
            default:
              return ErrorEntity(
                code: errCode,
                message: error.response?.statusMessage ?? "Unknown Error",
              );
          }
        }
      default:
        return ErrorEntity(code: -1, message: error.message as String);
    }
  }

  void cancelRequests(CancelToken token) {
    token.cancel("Request Cancelled");
  }

  Map<String, dynamic>? getAuthorizationHeader() {
    var headers = <String, dynamic>{};
    if (Get.isRegistered<UserStore>() && UserStore.to.hasToken) {
      headers['Authorization'] = 'Bearer ${UserStore.to.token}';
    }
    return headers;
  }

  Future get(String path,
      {Map<String, dynamic>? queryParameters, Options? options}) async {
    options?.headers?.addAll(getAuthorizationHeader() ?? {});
    var response = await dio.get(path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);
    return response.data;
  }

  Future post(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    options?.headers?.addAll(getAuthorizationHeader() ?? {});
    var response = await dio.post(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);
    return response.data;
  }

  Future put(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    options?.headers?.addAll(getAuthorizationHeader() ?? {});
    var response = await dio.put(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);
    return response.data;
  }

  Future delete(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    options?.headers?.addAll(getAuthorizationHeader() ?? {});
    var response = await dio.delete(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);
    return response.data;
  }
}

// Exception handling class
class ErrorEntity implements Exception {
  int code;
  String message;
  ErrorEntity({required this.code, required this.message});
  @override
  String toString() => "Exception: code $code, $message";
}
