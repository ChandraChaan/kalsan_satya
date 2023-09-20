import 'package:dio/dio.dart';


class DioApiService {
  static String get _base {

    return 'https://beta5.365hosting.in';
  }


  Dio dio() {
    print(_base);
    String token="";
    // AppInjector.instance.userDataStore.getUser().then((u){
    //   token= u!.token!;
    // });
    Dio dio = Dio(
      new BaseOptions(baseUrl: _base, headers: {
        "Authorization": token,
      }),
    );
    dio.interceptors.add(CustomInterceptors());
    return dio;
  }
}

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  Future? onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.data}');
    return null;
  }

  @override
  Future? onError(DioError err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.error}');
    return null;
  }
}