import 'dart:convert';

import 'package:catmaster_app/constants.dart';
import 'package:catmaster_app/entity/store.dart';
import 'package:catmaster_app/ui/edit_store_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage>{
  var stores = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: InkWell(child:Row(
        children: <Widget>[
          Offstage(
            offstage: stores.length == 0,
          child:SvgPicture.asset("assets/default_logo.svg",width: 36,height: 36,)
          ,),
          Padding(child: Text("新增门店"),
            padding: EdgeInsets.fromLTRB(10, 0, 5, 0)
            ,),
          SvgPicture.asset("assets/right_arrow.svg",width: 20,height: 20,),
        ],
      ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context){
              return EditStorePage();
            }
          ));
        },
      ),automaticallyImplyLeading: false,),
    );
  }

  @override
  void initState() {
    super.initState();
    getStores();
  }
  
  void getStores() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String storeStr =  sharedPreferences.get(Constants.KEY_STORES);
    List decodeJson = json.decode(storeStr);
    stores = decodeJson.map((m) => new Store.fromJson(m)).toList();
  }
}