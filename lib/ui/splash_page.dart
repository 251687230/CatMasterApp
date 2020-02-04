import 'package:catmaster_app/ui/login_in_page.dart';
import 'package:catmaster_app/ui/main_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class SplashPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
   return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(32, 150, 32, 30),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
          Expanded(child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset("assets/logo.svg", width: 80, height: 80),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                  child: SvgPicture.asset(
                    "assets/logo_name.svg",
                    width: 116,
                    height: 37.2,

                  )),
            ],
          )),
          Padding(child:
          SvgPicture.asset("assets/slog.svg",width:204.7,height: 96.4,),
          padding: EdgeInsets.fromLTRB(0, 0, 0 , 50),),
          Text("Copyright@2020")
        ])
    ));
  }


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      loadLoginInfo();
    });

  }

  void loadLoginInfo() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString(Constants.KEY_TOKEN);
    var tokenSaveTime = sharedPreferences.getInt(Constants.KEY_TOKEN_SAVE);
    if(token == null){
      jumpPage(LoginPage());
    }else{
      if(tokenSaveTime != null && DateTime.now().millisecondsSinceEpoch - tokenSaveTime > 640800000){
        jumpPage(LoginPage());
      }else{
        jumpPage(MainMenuPage(true));
      }
    }
  }

  void jumpPage(Widget widget){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context){
          return widget;
        }
    ), (route) => false);
  }
}