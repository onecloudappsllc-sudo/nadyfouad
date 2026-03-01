import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_grocery/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  Dio? dio;
  String? token;

  DioClient(this.baseUrl,
      Dio? dioC, {
        required this.loggingInterceptor,
        required this.sharedPreferences,
      }) {
    token = sharedPreferences.getString(AppConstants.token);
    dio = dioC ?? Dio();


    updateHeader(dioC: dioC, getToken: token);

  }

  Future<void> updateHeader({String? getToken, Dio? dioC, String? languageCode})async {
    dio?..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $getToken',
        'X-localization': languageCode ?? sharedPreferences.getString(AppConstants.languageCode)
            ?? AppConstants.languages[0].languageCode,
        'guest-id': sharedPreferences.getString(AppConstants.guestId) ?? '',

      };

    dio?.interceptors.add(loggingInterceptor);
  }

  Future<Response> get(String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio!.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {

      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      if (kDebugMode) {
        print('===============${e.toString()}');
      }
      rethrow;
    }
  }

  Future<Response> post(String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    debugPrint('apiCall ==> url=> $uri \nparams---> $queryParameters\nheader=> ${dio!.options.headers}\nbody=> $data');

    try {
      var response = await dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postMultipart(String uri, {
    Map<String, dynamic>? data,
    List<XFile?>? files,
    String? fileKey,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    debugPrint('apiCall ==> url=> $uri \nparams---> $queryParameters\nheader=> ${dio!.options.headers}');

    try{
      List<MultipartFile> fileList = [];

      if(files != null) {
        for(int i = 0; i < files.length; i++) {
          fileList.add(MultipartFile.fromBytes(
            await files[i]!.readAsBytes(),
            filename: files[i]!.name,
          ));
        }
      }

      if(fileList.isNotEmpty) {
        data?.addAll({
          '${fileKey ?? 'image'}[]' : fileList,
        });
      }

    }catch(e) {
      rethrow;
    }




    try {
      var response = await dio!.post(
        uri,
        data: FormData.fromMap(data ?? {}),
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> put(String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var response = await dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

}
