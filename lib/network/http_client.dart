import 'package:catmaster_app/constants.dart';
import 'package:catmaster_app/utils/secret_util.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';


class RestClient {
  void login(String userName,String password) async {
    FormData formData = new FormData.from({
      "UserName": userName,
      "Passowrd": SecretUtil.generateMd5(password)
    });
    var dio = new Dio();
    var response = await dio.post(Constants.LOGIN_URL, data: formData);
    var _content = response.data.toString();
  }
}


