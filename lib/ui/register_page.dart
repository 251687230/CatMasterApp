import 'package:catmaster_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:catmaster_app/utils/rx_util.dart';
import 'package:catmaster_app/widget/progress_dialog.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(10, 40, 32, 10),
      child: Column(
        children: <Widget>[
          Container(
              alignment: Alignment.topLeft,
              width: double.infinity,
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
          Padding(padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
          child: RegisterField(),)

        ],
      )
    ));
  }
}

class RegisterField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterFiledState();
  }
}

class RegisterFiledState extends State<RegisterField> {
  FocusNode _phoneFn, _passwdFn;
  TextEditingController _phoneCtrl, _passwordCtrl;
  GlobalKey formKey = new GlobalKey<FormState>();
  String _captchaHint = "获取验证码";
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
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: SvgPicture.asset("assets/logo.svg", width: 60, height: 60),
        ),
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
                    decoration: const InputDecoration(
                      hintText: "请输入验证码",
                    ),
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
                          onPressed: () {},
                        ),
                        width: 110,
                        height: 32,
                      ))
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "请输入密码"),
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
                      onPressed: RxUtil.debounce(() {
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
                          //login(_phoneCtrl.text, _passwordCtrl.text);
                        } else {
                          Fluttertoast.showToast(
                              msg: "请检查您的输入", toastLength: Toast.LENGTH_SHORT);
                        }
                      }, 1000),
                      child: Text(
                        "立即注册",
                        style: TextStyle(color: Colors.white),
                      ))),
            ])),
      ],
    );
  }
}
