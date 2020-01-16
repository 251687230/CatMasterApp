import 'dart:async';

import 'package:catmaster_app/network/http_client.dart';
import 'package:catmaster_app/widget/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oktoast/oktoast.dart';

import '../constants.dart';

class EditPsdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("找回密码"),),
      body: Padding(padding: EdgeInsets.fromLTRB(32,16,32,0),
      child: EditPsdField(),),
    );
  }
}

class EditPsdField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditPsdFiledState();
  }
}

class EditPsdFiledState extends State<EditPsdField> {
  GlobalKey formKey = new GlobalKey<FormState>();
  FocusNode _phoneFn, _passwdFn;
  TextEditingController _phoneCtrl, _passwordCtrl,_captchaCtrl;
  String _captchaHint = "获取验证码";
  int _second = 0;
  Timer _countTimer;
  bool _psdVisibility = false;
  final _commitPublish = BehaviorSubject<int>();

  @override
  void initState() {
    _phoneFn = FocusNode();
    _passwdFn = FocusNode();
    _phoneCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _captchaCtrl = TextEditingController();

    getLastSendTime();

    _commitPublish.throttle((_) => TimerStream(true, Duration(seconds: 1))).listen((data){
      if ((formKey.currentState as FormState).validate()) {
        _phoneFn.unfocus();
        _passwdFn.unfocus();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return new LoadingDialog(
                text: "加载中…",
              );
            });
        verifyCaptcha(_phoneCtrl.text,_captchaCtrl.text,_passwordCtrl.text);
      } else {
        showToast("请检查您的输入");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(key: formKey,
        autovalidate: true,child:Column(
      children: <Widget>[
        TextFormField(
            decoration: const InputDecoration(hintText: "请输入手机号码"),
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
        Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            TextFormField(
              controller: _captchaCtrl,
              decoration: const InputDecoration(
                hintText: "请输入验证码",
              ),
              validator: (text) {
                return text.length < 6 ? "请输入正确的验证码" : null;
              },
              maxLength: 6,
              keyboardType: TextInputType.number,
            ),
            Positioned(
                bottom: 30,
                child: SizedBox(
                  child: OutlineButton(
                    child: Text(
                      _captchaHint,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor),
                    ),
                    highlightColor: Colors.pink[100],
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: Theme.of(context).primaryColor,
                        width: 1),
                    onPressed: _second == 0
                        ? () {
                      if (verifyPhoneNum(_phoneCtrl.text)) {
                        saveLastSendTime();
                        _startTimer(60);
                        getCaptcha(_phoneCtrl.text);
                      } else {
                        showToast("请输入有效的手机号码");
                      }
                    }
                        : null,
                  ),
                  width: 110,
                  height: 32,
                ))
          ],
        ),
        TextFormField(
          decoration:  InputDecoration(hintText: "请输入密码",suffixIcon: IconButton(icon: Icon(_psdVisibility?Icons.visibility:
          Icons.visibility_off),onPressed: (){
            setState(() {
              _psdVisibility = !_psdVisibility;
            });
          },)),
          focusNode: _passwdFn,
          keyboardType: TextInputType.visiblePassword,
          maxLength: 20,
          validator: (text) {
            return text.trim().length > 5 ? null : "密码不能少于6位";
          },
          controller: _passwordCtrl,
          textInputAction: TextInputAction.done,
          obscureText: !_psdVisibility,
        ), Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: RaisedButton(
                onPressed: () {
                  _commitPublish.add(1);
                },
                child: Text(
                  "提交",
                  style: TextStyle(color: Colors.white),
                ))),
      ],
    ));
  }

  bool verifyPhoneNum(String phoneNum) {
    RegExp mobile = new RegExp(r"^[1][3-5,7-9]\d{9}$");
    return mobile.hasMatch(phoneNum);
  }

  void clearLastSendTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(Constants.KEY_SEND_TIME, 0);
  }

  void getLastSendTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int sendTime = prefs.getInt(Constants.KEY_SEND_TIME) ?? 0;
    print("get sendTime $sendTime");
    int durationTime =
        60 - (DateTime.now().millisecondsSinceEpoch - sendTime) ~/ 1000.ceil();
    if (durationTime > 0) {
      setState(() {
        _second = durationTime;
        _captchaHint = "$durationTime秒后重发";
        _startTimer(durationTime);
      });
    }
  }

  void getCaptcha(String phoneNum) {
    RestClient().getCaptcha(phoneNum, (errorCode, description) {
      setState(() {
        _second = 0;
        _captchaHint = "重新获取";
        clearLastSendTime();
      });
      _countTimer.cancel();
      _countTimer = null;
      showToast(description);
    });
  }

  void verifyCaptcha(String phoneNum, String captcha, String password) {
    RestClient().verifyCaptcha(phoneNum, captcha, (data) {
      editPassword(phoneNum,password);
    }, (errorCode, description) {
      showToast(description);
      Navigator.pop(context);
    });
  }

  void editPassword(String phoneNum,String password){
    RestClient().editPassword(phoneNum, password, (data){
      Navigator.pop(context);
      showDialog(context: context,barrierDismissible: false,builder:(ctx) {
        return AlertDialog(
          title: Text("提示"), content: Text("修改密码成功"
        ), actions: <Widget>[
          FlatButton(child: Text("确定"),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(ctx);
            },)
        ],);
      });
    }, (errorCode, description) {
      showToast(description);
      Navigator.pop(context);
    });
  }

  void _startTimer(int totalTime) {
    const period = const Duration(seconds: 1);
    setState(() {
      _second = totalTime;
      _captchaHint = "$totalTime秒后重发";
    });
    _countTimer = Timer.periodic(period, (timer) {
      totalTime--;
      if (mounted) {
        if (totalTime <= 0) {
          //取消定时器，避免无限回调
          setState(() {
            _second = 0;
            _captchaHint = "重新获取";
          });
          _countTimer.cancel();
          _countTimer = null;
        } else {
          setState(() {
            _second = totalTime;
            _captchaHint = "$totalTime秒后重发";
          });
        }
      }
    });
  }

  void saveLastSendTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("set sendTime ${DateTime.now().millisecondsSinceEpoch}");
    prefs.setInt(
        Constants.KEY_SEND_TIME, DateTime.now().millisecondsSinceEpoch);
  }
}