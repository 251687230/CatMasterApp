import 'package:catmaster_app/constants.dart';
import 'package:catmaster_app/entity/result.dart';
import 'package:catmaster_app/utils/secret_util.dart';
import 'package:dio/dio.dart';
import 'dart:convert';


class RestClient {
  Dio dio;

  // 工厂模式
  factory RestClient() => _getInstance();

  static RestClient get instance => _getInstance();
  static RestClient _instance;

  RestClient._internal() {
    // 初始化
    dio = new Dio();
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
  }

  static RestClient _getInstance() {
    if (_instance == null) {
      _instance = new RestClient._internal();
    }
    return _instance;
  }

  void login(String userName, String password, HttpSuccess onSuccess,
      HttpFail onFail) async {
    FormData formData = new FormData.from({
      "UserName": userName,
      "Passowrd": SecretUtil.generateMd5(password)
    });
    try {
      var response = await dio.post(Constants.LOGIN_URL, data: formData);
      var _content = response.data.toString();
      int responseCode = response.statusCode;
      if (responseCode != 200) {
        onFail(responseCode, 0, "");
      }
      Result<String> _result = Result.fromJson(json.decode(_content));
      if (_result.errorCode == 0) {
        onSuccess(_result.data);
      } else {
        onFail(200, _result.errorCode, _result.description);
      }
    } on DioError catch (error) {
      doError(onFail, error);
    }
  }
}

void doError(HttpFail onFail,DioError error){
  // 超时
  if (error.type == DioErrorType.CONNECT_TIMEOUT) {
    onFail(Constants.ERROR_TIME_OUT,0,"请检查网络");
  }
}

typedef HttpSuccess = dynamic Function(dynamic data);
typedef HttpFail = dynamic Function(int responseCode,int errorCode,String description);



