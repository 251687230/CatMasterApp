import 'dart:convert';
import 'dart:io';

import 'package:catmaster_app/constants.dart';
import 'package:catmaster_app/entity/store.dart';
import 'package:catmaster_app/ui/edit_store_page.dart';
import 'package:catmaster_app/ui/stores_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  var stores = [];
  var storeName = "新增门店";
  String selectId;
  Widget storeIcon = SvgPicture.asset("assets/right_arrow.svg", width: 20, height: 20,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: InkWell(child: Row(
        children: <Widget>[
          Offstage(
            offstage: stores.length == 0,
            child: SvgPicture.asset(
              "assets/default_logo.svg", width: 36, height: 36,)
            ,),
          Padding(child: Text(storeName),
            padding: EdgeInsets.fromLTRB(10, 0, 5, 0)
            ,),
          storeIcon,
        ],
      ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                if(stores.length == 0) {
                  return EditStorePage();
                }else{
                  return StoresListPage(stores,selectId);
                }
              }
          ));
        },
      ), automaticallyImplyLeading: false,),
    );
  }

  @override
  void initState() {
    super.initState();
    print("init state");
    getStores();
  }

  void getStores() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String storeStr = sharedPreferences.getString(Constants.KEY_STORES);
    String selectStoreId = sharedPreferences.getString(
        Constants.KEY_SELECT_STORE);
    List decodeJson = json.decode(storeStr);
    setState(() {
      stores = decodeJson.map((m) => new Store.fromJson(m)).toList();
      if (stores != null && stores.length > 0) {
        Store store;
        if (selectStoreId == null) {
          store = stores[0];
        } else {
          for (Store temp in stores) {
            if (temp.id == selectStoreId) {
              store = temp;
              break;
            }
          }
        }
        if (store != null) {
          selectId = store.id;
            storeName = store.name;
            if(store.localUrl != null){
              storeIcon = Image.file(File(store.localUrl),width: 20,height: 20,);
            }
        }
      }
    });
  }
}