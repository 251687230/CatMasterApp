import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:catmaster_app/constants.dart';
import 'package:catmaster_app/entity/store.dart';
import 'package:catmaster_app/network/http_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oktoast/oktoast.dart';
import 'edit_store_page.dart';

List<Store> _stores;
String _selectStoreId;

typedef DealComplete = void Function(List<Store> stores);

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
  RefreshController _controller = new RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("门店管理"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () async{
              List<Store> stores = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EditStorePage();
              }));
              setState(() {
                _stores = stores;
              });
            },
          )
        ],
      ),
      body:SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(
          waterDropColor: Colors.pink,
        ),
        child:  _stores.length ==0?_createEmptyBody():_createListBody(),
        onRefresh: _onRefresh,
        controller: _controller,
      ),
    );
  }

  void _onRefresh() async {
    RestClient().getStores((data) {
      List decodeJson = json.decode(data);
      List<Store> stores =
          decodeJson.map((m) => new Store.fromJson(m)).toList();

      getStoreIcons(stores,true,(stores){
        dealComplete(stores);
        _controller.refreshCompleted();
      });
    }, (errorCode, description) {
      _controller.refreshCompleted();
    });
  }




  void getStoreIcons(List<Store> stores,bool downloadAll,DealComplete onDealComplete) {
    int count = 0;
    for (int i = 0; i < stores.length; i++) {
      Store store = stores[i];
      if (store.storeIcon != null) {
        if(!downloadAll && store.localUrl != null){
          count++;
          continue;
        }
        RestClient().downloadFile(stores[i].storeIcon, (data) async {
          File saveFile = await _saveImage(stores[i].id,data);
          if (saveFile != null) {
            store.localUrl = saveFile.path;
            stores[i] = store;
          }
          count++;
          if (count == stores.length) {
            onDealComplete(stores);
          }
        }, (errorCode, description) {
          count++;
          if (count == stores.length) {
            onDealComplete(stores);
          }
        });
      } else {
        count++;
        if (count == stores.length) {
          onDealComplete(stores);
        }
      }
    }
  }

  void dealComplete(List<Store> stores) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Constants.KEY_STORES, jsonEncode(stores));

    setState(() {
      _stores = stores;
    });

  }

  Future<File> _saveImage(String storeId,String data) async {
    File file;
    try {
      var appDocDir;
      if (Platform.isIOS) {
        appDocDir = await getApplicationDocumentsDirectory();
      } else {
        appDocDir = await getExternalStorageDirectory();
      }
      String appDocPath = appDocDir.path;

      file = File(appDocPath +
          "/store_pic_" +
          storeId +".jpg");
      bool isExit = await file.exists();
      if (!isExit) {
        var createdFile = await file.create();
        createdFile.writeAsBytes(Base64Decoder().convert(data));
      }
    } catch (err) {
      print(err);
    }
    return Future.value(file);
  }

  Widget _createEmptyBody(){
    return Center(child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset("assets/empty_view.svg",width: 120,height:120,),
        Padding(child:
        Text("暂无数据",style: TextStyle(fontSize: 32,color: Colors.grey)),
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
      ],
    ));
  }

  Widget _createListBody() {
    return ListView.builder(
      itemBuilder: (context, index) {
        Store store = _stores[index];
        Widget iconWidget;
        if (store.localUrl != null) {
          iconWidget = CircleAvatar(
              backgroundImage: Image.file(
                File(store.localUrl),
                width: 50,
                height: 50,
              ).image,
              radius: 25);
        } else {
          iconWidget = SvgPicture.asset(
            "assets/default_logo.svg",
            width: 50,
            height: 50,
          );
        }
        return GestureDetector(
          child: Container(
            child: Padding(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Row(
                      children: <Widget>[
                        Icon(
                          selectIndex == index
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
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
                border: index == _stores.length - 1
                    ? Border()
                    : Border(bottom: BorderSide(width: 1, color: Colors.grey))),
          ),
          onTap: () {
            setState(() {
              selectIndex = index;
            });
            saveSelectIndex(_stores[selectIndex].id);
          },
        );
      },
      itemCount: _stores.length,
      padding: EdgeInsets.all(24),
    );
  }

  void saveSelectIndex(String storeId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Constants.KEY_SELECT_STORE, storeId);
  }

  void jumpPage(Store store) async {
    List<Store> returnStores =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditStorePage(store: store);
    }));
    if (returnStores != null) {
      setState(() {
        _stores = returnStores;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if(_stores != null){
      for(int i=0 ;i < _stores.length; i++){
        if(_stores[i].id == _selectStoreId){
          selectIndex = i;
        }
      }
      getStoreIcons(_stores, false, (stores) {
        dealComplete(stores);
      });
    }
  }
}
