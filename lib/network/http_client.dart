import 'dart:math';

import 'package:catmaster_app/constants.dart';
import 'package:catmaster_app/entity/result.dart';
import 'package:catmaster_app/utils/secret_util.dart';
import 'package:dio/dio.dart';


class RestClient {
  static const int TYPE_GET = 1;
  static const int TYPE_POST = 2;

  Dio _dio;

  // 工厂模式
  factory RestClient() => _getInstance();

  static RestClient get instance => _getInstance();
  static RestClient _instance;

  RestClient._internal() {
    // 初始化
    _dio = new Dio();
    _dio.options.connectTimeout = 10000;
    _dio.options.receiveTimeout = 10000;
  }

  static RestClient _getInstance() {
    if (_instance == null) {
      _instance = new RestClient._internal();
    }
    return _instance;
  }

  void login(String userName, String password, HttpSuccess onSuccess,
      HttpFail onFail) async {
    FormData formData =  FormData.from({
      "UserName": userName,
      "Passowrd": SecretUtil.generateMd5(password)
    });
    doRequest(TYPE_POST,Constants.LOGIN_URL, formData, onSuccess, onFail);
  }

  void getCaptcha(String phoneNum,HttpFail onFail) async{
    FormData formData =  FormData.from({
      "PhoneNum": phoneNum
    });
    doRequest(TYPE_GET,Constants.GET_CAPTCHA_URL, formData, null, onFail);
  }

  void verifyCaptcha(String phoneNum,String captcha,HttpSuccess onSuccess,HttpFail onFail) async{
    FormData formData =  FormData.from({
      "PhoneNum": phoneNum,
      "Captcha": captcha
    });
    doRequest(TYPE_GET,Constants.VERIFY_CAPTCHA_URL, formData, onSuccess, onFail);
  }

  void editPassword(String phoneNum,String password,HttpSuccess onSuccess,HttpFail onFail)  {
    FormData formData = FormData.from({
      "UserName": phoneNum,
      "NewPassword": SecretUtil.generateMd5(password)
    });
    doRequest(TYPE_POST,Constants.EDIT_PWD_URL, formData, onSuccess, onFail);
  }

  void doRequest(int type,String url,FormData formData,HttpSuccess onSuccess,HttpFail onFail) async{
    try{
      var response;
      if(type == TYPE_GET){
        response = await  _dio.get(url, data: formData,options: _addHead());
      }else{
        response = await  _dio.post(url, data: formData,options: _addHead());
      }
      var _content = response.data;
      int responseCode = response.statusCode;
      if (responseCode != 200) {
        dealResponseCode(onFail, responseCode);
      }
      Result<String> _result = Result.fromJson(_content);
      if (_result.errorCode != 0) {
        onFail(_result.errorCode, _result.description);
      }else{
        if(onSuccess != null) {
          onSuccess(_result.data);
        }
      }
    }on DioError catch(error){
      dealException(onFail, error);
    }
  }

  void register(String phoneNum,String password,String captcha,HttpSuccess onSuccess,HttpFail onFail) async{
    FormData formData =  FormData.from({
      "UserName": phoneNum,
      "Password": password
    });
    doRequest(TYPE_POST,Constants.REGISTER_URL, formData, onSuccess, onFail);
  }

  Options _addHead(){
    String random = Random().nextInt(10000).toString();
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    String encodeStr = SecretUtil.generateMd5(timeStamp+ random + Constants.VERIFE_KEY);
    return Options(headers: {'Random':random,'TimeStamp':timeStamp,'EncoderStr': encodeStr});
  }
}

void dealException(HttpFail onFail,DioError error){
  // 超时
  if (error.type == DioErrorType.CONNECT_TIMEOUT) {
    onFail(Constants.ERROR_SERVICE_EXCEPTION,"请求超时，请检查网络连接");
  }else if(error.type == DioErrorType.DEFAULT){
    onFail(Constants.ERROR_SERVICE_EXCEPTION,"无法连接到服务器");
  }else if(error.type == DioErrorType.RECEIVE_TIMEOUT){
    onFail(Constants.ERROR_SERVICE_EXCEPTION,"从服务器获取数据超时");
  }else if(error.type == DioErrorType.RESPONSE){
    dealResponseCode(onFail, error.response.statusCode);
  }
}

void dealResponseCode(HttpFail onFail,int responseCode){
  if(responseCode == 500){
    onFail(0,"服务器错误");
  }else if(responseCode == 403){
    onFail(0,"您操作的过于频繁，请歇息一下再做尝试");
  }
}

typedef HttpSuccess = dynamic Function(dynamic data);
typedef HttpFail = dynamic Function(int errorCode,String description);



