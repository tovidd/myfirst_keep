import 'package:dio/dio.dart';

class DioClient {
  DioClient();
  Dio get dio => _getDio();

  Dio _getDio() {
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(minutes: 1).inMilliseconds,
      receiveTimeout: const Duration(minutes: 1).inMilliseconds,
    );

    Dio dio = Dio(options);
    dio.interceptors.addAll([
      // _interceptor(),
    ]);
    return dio;
  }
}
