import 'package:catmaster_app/network/http_client.dart';
import 'package:catmaster_app/ui/home_page.dart';
import 'package:catmaster_app/ui/manage_page.dart';
import 'package:catmaster_app/ui/mine_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

bool _isRefreshToken = false;

class MainMenuPage extends StatefulWidget{

  MainMenuPage(bool refreshToken){
    _isRefreshToken = refreshToken;
  }

  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int _tabIndex = 0;

  var tabImages;

  var appBarTitles = ['首页', '管理', '我的'];

  /*
   * 存放三个页面，跟fragmentList一样
   */
  var _pageList = [HomePage(),ManagePage(),MinePage()];

  @override
  Widget build(BuildContext context) {
    initData();
    return Scaffold(bottomNavigationBar: BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: getTabIcon(0),title: getTabTitle(0)
        ),
        BottomNavigationBarItem(
            icon:  getTabIcon(1),title: getTabTitle(1)
        ),
        BottomNavigationBarItem(
            icon:  getTabIcon(2),title: getTabTitle(2)
        ),
      ],
      type: BottomNavigationBarType.fixed,
      //默认选中首页
      currentIndex: _tabIndex,
      iconSize: 24.0,
      //点击事件
      onTap: (index) {
        setState(() {
          _tabIndex = index;
        });
      },
    ),
    body: _pageList[_tabIndex],);
  }

  Text getTabTitle(int curIndex) {
    if (curIndex == _tabIndex) {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 14.0, color:  Colors.pinkAccent));
    } else {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 14.0, color: Color(0xFF8A8A8A)));
    }
  }

  SvgPicture getTabImage(path) {
    return SvgPicture.asset(path,width: 24,height: 24,);
  }

  SvgPicture getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  void initData() {
    /*
     * 初始化选中和未选中的icon
     */
    tabImages = [
      [getTabImage('assets/home.svg'), getTabImage('assets/home_select.svg')],
      [getTabImage('assets/manage.svg'), getTabImage('assets/manage_select.svg')],
      [getTabImage('assets/mine.svg'), getTabImage('assets/mine_select.svg')]
    ];
  }

  @override
  void initState() {
    super.initState();
    if(_isRefreshToken){
      refreshToken();
    }
  }

  void refreshToken() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString(Constants.KEY_TOKEN);
    print("requesttoken =" + token );
    if(token != null) {
      RestClient().refreshToken(token,(data){
        saveLoginInfo(data);
      },(errorCode,description){
        print("errorCode = " + errorCode.toString() + ",description = " + description);
      });
    }
  }

  void saveLoginInfo(var data) async{
    print("receiveToken =" + data );
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Constants.KEY_TOKEN,data);
    sharedPreferences.setInt(Constants.KEY_TOKEN_SAVE, DateTime.now().millisecondsSinceEpoch);
  }
}