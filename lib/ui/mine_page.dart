import 'package:catmaster_app/constants.dart';
import 'package:catmaster_app/entity/manager.dart';
import 'package:catmaster_app/ui/login_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MinePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }

}

class MinePageState extends State<MinePage> {
  Manager _manager;

  static const String _SCAN_CODE = "扫码签到";
  static const String _ORDER_CLASS = "代约课";
  static const String _FEEDBACK = "意见反馈";
  static const String _EDIT_PASSWORD = "修改/找回 密码";
  static const String _CONNECT_US = "联系我们";

  @override
  void initState() {
    super.initState();
    _getManager();
  }

  _getManager() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String managerStr = sharedPreferences.getString(Constants.KEY_MANAGER);
    setState(() {
      _manager = Manager.fromJson(json.decode(managerStr));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text("我的"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            child: SvgPicture.asset(
                              "assets/admin.svg",
                              width: 50,
                              height: 50,
                            ),
                            backgroundColor: Colors.grey[300],
                            maxRadius: 30,
                          ),
                          Expanded(
                              child: Padding(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  _manager == null ? "未命名" : (_manager.name == null || _manager.name == ""?
                                  "uid_" + _manager.id.substring(0,8) : _manager.name),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                                Text("店长")
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                            padding: EdgeInsets.fromLTRB(24, 0, 0, 0),
                          )),
                          SvgPicture.asset(
                            "assets/right_arrow.svg",
                            width: 20,
                            height: 20,
                            color: Colors.grey,
                          )
                        ],
                      ),
                      Padding(
                        child: Divider(height: 1, color: Colors.grey),
                        padding: EdgeInsets.fromLTRB(0, 8, 9, 9),
                      ),
                      Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            "assets/vip_tag.svg",
                            width: 30,
                            height: 30,
                          ),
                          Padding(
                            child: Text(
                              "管家有效期：${_manager == null?"": intToDateStr(_manager.expireTime)}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            padding: EdgeInsets.fromLTRB(24, 0, 0, 0),
                          )
                        ],
                      )
                    ]),
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 12),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: Container(
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          _createItem("assets/scan_qrcode.svg", _SCAN_CODE,
                              _jumpPage(_SCAN_CODE)),
                          Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          _createItem("assets/order_class.svg", _ORDER_CLASS,
                              _jumpPage(_ORDER_CLASS)),
                        ],
                      ),
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: Container(
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          _createItem("assets/feedback.svg", _FEEDBACK,
                              _jumpPage(_FEEDBACK)),
                          Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          _createItem("assets/edit_password.svg",
                              _EDIT_PASSWORD, _jumpPage(_EDIT_PASSWORD)),
                          Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          _createItem("assets/connect_us.svg", _CONNECT_US,
                              _jumpPage(_CONNECT_US)),
                        ],
                      ),
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                    ),
                  )
                ],
              ),
              flex: 1,
            ),
            Padding(child: RaisedButton(
              child: Text(
                "退出登录",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _deletToken();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (ctx){
                    return LoginPage();
                  }
                ), (route) => false);
              },
            ),padding: EdgeInsets.all(24),)
            
          ],
        ));
  }

  String intToDateStr(int date){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  }


  _deletToken() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(Constants.KEY_TOKEN);
    sharedPreferences.remove(Constants.KEY_TOKEN_SAVE);
  }

  _jumpPage(String tag) {}

  Widget _createItem(String iconCode, String name, Function callback) {
    return GestureDetector(
      child: Padding(
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              iconCode,
              width: 30,
              height: 30,
            ),
            Expanded(
              child: Padding(
                child: Text(name),
                padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
              ),
              flex: 1,
            ),
            SvgPicture.asset(
              "assets/right_arrow.svg",
              width: 20,
              height: 20,
              color: Colors.grey,
            )
          ],
        ),
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      ),
      onTap: () {
        callback();
      },
    );
  }
}
