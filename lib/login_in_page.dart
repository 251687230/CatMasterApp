import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  @override
  void initState() {
    _phoneFn = FocusNode();
    _passwdFn = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset("assets/logo.svg", width: 60, height: 60),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
            child: Text("喵管家",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
        TextFormField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone), hintText: "请输入手机号码"),
            keyboardType: TextInputType.phone,
            maxLength: 11,
            focusNode: _phoneFn,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              _phoneFn.unfocus();
              FocusScope.of(context).requestFocus(_passwdFn);
            }),
        TextFormField(
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock), hintText: "请输入密码"),
          focusNode: _passwdFn,
          keyboardType: TextInputType.visiblePassword,
          maxLength: 20,
          textInputAction: TextInputAction.done,
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: RaisedButton(
                onPressed: () {
                  Fluttertoast.showToast(msg: "点击了登陆");
                },
                child: Text(
                  "登陆",
                  style: TextStyle(color: Colors.white),
                ))),
        Row(
          children: <Widget>[
            Expanded(
            child:Text("忘记密码?",style: TextStyle(color: Colors.pinkAccent))),
            Expanded(
                child:Text("新用户注册",textAlign: TextAlign.end,style: TextStyle(color: Colors.pinkAccent))),
          ],
        ),
        Padding(padding: EdgeInsets.fromLTRB(0, 60, 0, 10),
        child:SvgPicture.asset("assets/wechat.svg",width:40,height:40)
        ),
        Text("微信快速登陆")
      ],
    );
  }
}
