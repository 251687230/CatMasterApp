import 'dart:io';

import 'package:catmaster_app/constants.dart';
import 'package:catmaster_app/entity/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_store_page.dart';

List<Store> _stores;
String _selectStoreId;

class StoresListPage extends StatefulWidget {
  StoresListPage(List<Store> stores, String storeId) {
    _stores = stores;
    _selectStoreId = storeId;
  }

  @override
  State<StatefulWidget> createState() {
    return _StoresListState();
  }
}

class _StoresListState extends State<StoresListPage> {
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:Scaffold(
      appBar: AppBar(
        title: Text("门店管理"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add,size: 30,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
              builder:(context){
                return EditStorePage();
              }
              ));
            },
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          Store store = _stores[index];
          Widget iconWidget;
          if (store.localUrl != null) {
            iconWidget = Image.file(
              File(store.localUrl),
              width: 50,
              height: 50,
            );
          } else {
            iconWidget = SvgPicture.asset(
              "assets/default_logo.svg",
              width: 50,
              height: 50,
            );
          }
          return GestureDetector(child:Container(
            child: Padding(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Row(
                      children: <Widget>[
                        Icon(
                          selectIndex == index ? Icons.check_box : Icons.check_box_outline_blank,
                          color: Colors.pink,
                        ),
                        Padding(
                          child: iconWidget,
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        ),
                        Text(
                          store.name,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    )),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        jumpPage(store);
                      },
                    )
                  ],
                ),
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
            decoration: BoxDecoration(
                border:
                    index == _stores.length - 1?Border():Border(bottom: BorderSide(width: 1, color: Colors.grey))),
          ),onTap: (){
            setState(() {
              selectIndex = index;
            });
            saveSelectIndex(_stores[selectIndex].id);
          },);
        },
        itemCount: _stores.length,
        padding: EdgeInsets.all(24),
      ),
    ),onWillPop: () async{
      Navigator.pop(context,"");
      return false;
    },);
  }

  void saveSelectIndex(String storeId) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Constants.KEY_SELECT_STORE, storeId);
  }

  void jumpPage(Store store) async{
    List<Store> returnStores = await Navigator.push(context, MaterialPageRoute(builder:
        (context){
      return EditStorePage(store: store);
    }));
    setState(() {
      _stores = returnStores;
    });
  }

  @override
  void initState() {
    super.initState();
  }
}
