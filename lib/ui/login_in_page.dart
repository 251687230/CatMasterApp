import 'dart:convert';

import 'package:catmaster_app/constants.dart';
import 'package:catmaster_app/network/http_client.dart';
import 'package:catmaster_app/ui/edit_psd_page.dart';
import 'package:catmaster_app/ui/main_menu_page.dart';
import 'package:catmaster_app/ui/register_page.dart';
import 'package:catmaster_app/utils/device_util.dart';
import 'package:catmaster_app/widget/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(32, 100, 32, 10),
      child: LoginField(),
    ));
  }
}

class LoginField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginFieldState();
  }
}

class LoginFieldState extends State<LoginField> {
  FocusNode _phoneFn, _passwdFn;
  TextEditingController _phoneCtrl, _passwordCtrl;
  GlobalKey formKey = new GlobalKey<FormState>();
  String _versionName = "";
  bool _psdVisibility = false;
  final _loginPublish = BehaviorSubject<int>();

  @override
  void initState() {
    super.initState();
    _phoneFn = FocusNode();
    _passwdFn = FocusNode();
    _phoneCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    DeviceUtil.getVersionName((version) {
      setState(() {
        _versionName = version;
      });
    });
    _loginPublish.throttle((_) => TimerStream(true, Duration(seconds: 1))).listen((data){
      if ((formKey.currentState as FormState).validate()) {
        _phoneFn.unfocus();
        _passwdFn.unfocus();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return LoadingDialog(
                text: "账号登录中…",
              );
            });
        login(_phoneCtrl.text, _passwordCtrl.text);
      } else {
        showToast("请检查您的输入");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset("assets/logo.svg", width: 60, height: 60),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
            child: SvgPicture.asset(
              "assets/logo_name.svg",
              width: 116,
              height: 37.2,
            )),
        Form(
            key: formKey,
            autovalidate: true,
            child: Column(children: <Widget>[
              TextFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone), hintText: "请输入手机号码"),
                  keyboardType: TextInputType.phone,
                  validator: (text) {
                    return text.trim().length > 0 ? null : "手机号不能为空";
                  },
                  maxLength: 11,
                  controller: _phoneCtrl,
                  focusNode: _phoneFn,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    _phoneFn.unfocus();
                    FocusScope.of(context).requestFocus(_passwdFn);
                  }),
              TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "请输入密码",
                    suffixIcon: IconButton(icon: Icon(_psdVisibility?Icons.visibility:
                    Icons.visibility_off),onPressed: (){
                      setState(() {
                        _psdVisibility = !_psdVisibility;
                      });
                    },)),
                obscureText: !_psdVisibility,
                focusNode: _passwdFn,
                keyboardType: TextInputType.visiblePassword,
                maxLength: 20,
                validator: (text) {
                  return text.trim().length > 5 ? null : "密码不能少于6位";
                },
                controller: _passwordCtrl,
                textInputAction: TextInputAction.done,
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: RaisedButton(
                      onPressed: (){_loginPublish.add(1);},
                      child: Text(
                        "登陆",
                        style: TextStyle(color: Colors.white),
                      ))),
            ])),
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: Container(
                  child:
                      Text("忘记密码?", style: TextStyle(color: Colors.pinkAccent)),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EditPsdPage(type: 0,);
                  }));
                },
              ),
            ),
            Expanded(
              child: InkWell(
                  child: Container(
                      child: Text("新用户注册",
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.pinkAccent))),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RegisterPage();
                    }));
                  }),
            ),
          ],
        ),
        Expanded(
            child: Container(
          height: double.infinity,
          child: Text("Version $_versionName"),
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
        ))
      ],
    );
  }

  void login(String userName, String password) {
    RestClient().login(userName, password, (data) {
      showToast("登录成功");
      saveLoginInfo(data);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(
        builder: (context){
          return MainMenuPage(false);
        }
      ));
    }, (responseCode, description) {
      showToast(description);
      Navigator.pop(context);
    });
  }

  void saveLoginInfo(var data) async{
    var jsonData = jsonDecode(data);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Constants.KEY_TOKEN, jsonData["sessionToken"]);
    print("Token = " +jsonData["sessionToken"]);
    sharedPreferences.setInt(Constants.KEY_TOKEN_SAVE, DateTime.now().millisecondsSinceEpoch);
    sharedPreferences.setString(Constants.KEY_STORES, jsonData["stores"]);
  }
}
