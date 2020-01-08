import 'package:catmaster_app/network/http_client.dart';
import 'package:catmaster_app/utils/rx_util.dart';
import 'package:catmaster_app/widget/progress_dialog.dart';
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
  TextEditingController _phoneCtrl, _passwordCtrl;
  GlobalKey formKey = new GlobalKey<FormState>();
  @override
  void initState() {
    _phoneFn = FocusNode();
    _passwdFn = FocusNode();
    _phoneCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
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
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock), hintText: "请输入密码"),
                focusNode: _passwdFn,
                keyboardType: TextInputType.visiblePassword,
                maxLength: 20,
                validator: (text) {
                  return text.trim().length > 5 ? null : "密码不能少于6位";
                },
                controller: _passwordCtrl,
                textInputAction: TextInputAction.done,
                obscureText: true,
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: RaisedButton(
                      onPressed: RxUtil.debounce((){
                        if ((formKey.currentState as FormState).validate()) {
                          _phoneFn.unfocus();
                          _passwdFn.unfocus();
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return new LoadingDialog(
                                  text: "账号登录中…",
                                );
                              });
                          login(_phoneCtrl.text, _passwordCtrl.text);
                        }else{
                          Fluttertoast.showToast(msg: "请检查您的输入",toastLength: Toast.LENGTH_SHORT);
                        }
                      },1000),
                      child: Text(
                        "登陆",
                        style: TextStyle(color: Colors.white),
                      ))),
            ])),
        Row(
          children: <Widget>[
            Expanded(
                child:
                    InkWell(child:Container(child:Text("忘记密码?", style: TextStyle(color: Colors.pinkAccent)),
                    )
                    ,onTap: (){
                      Fluttertoast.showToast(msg: "forget pswd");
                      },),
            ),
            Expanded(
                child: Text("新用户注册",
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.pinkAccent))),
          ],
        ),
      ],
    );
  }

  void login(String userName, String password) {
    RestClient().login(userName, password, (data) {},
        (responseCode, errorCode, description) {
      Fluttertoast.showToast(msg: "responseCode ${responseCode}");
      Navigator.pop(context);
    });
  }
}
