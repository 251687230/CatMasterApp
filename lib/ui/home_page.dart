import 'dart:convert';
import 'dart:io';

import 'package:catmaster_app/constants.dart';
import 'package:catmaster_app/entity/store.dart';
import 'package:catmaster_app/network/http_client.dart';
import 'package:catmaster_app/ui/edit_store_page.dart';
import 'package:catmaster_app/ui/stores_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
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
  Widget storeIcon =  SvgPicture.asset(
    "assets/default_logo.svg", width: 36, height: 36,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: InkWell(child: Row(
        children: <Widget>[
          Offstage(child:storeIcon,offstage: stores == null || stores.length == 0,),
          Padding(child: Text(storeName),
            padding: EdgeInsets.fromLTRB(10, 0, 5, 0)
            ,),
          SvgPicture.asset("assets/right_arrow.svg", width: 20, height: 20,)
        ],
      ),
        onTap: () {
         jumpPage();
        },
      ), automaticallyImplyLeading: false,),
    );
  }

  void jumpPage() async{
    var result = await Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          if(stores.length == 0) {
            return EditStorePage();
          }else{
            return StoresListPage(stores,selectId);
          }
        }
    ));
    getStores();
  }

  @override
  void initState() {
    super.initState();
    getStores();
  }

  void getStores() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String storeStr = sharedPreferences.getString(Constants.KEY_STORES);
    String selectStoreId = sharedPreferences.getString(
        Constants.KEY_SELECT_STORE);
    List decodeJson = json.decode(storeStr);
    setState(() {
      stores = decodeJson.map((m) =>  Store.fromJson(m)).toList();
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
              storeIcon = CircleAvatar(backgroundImage: Image.file(File(store.localUrl),width: 36,height: 36,).image,
      radius: 18);
            }else{
              storeIcon =  SvgPicture.asset(
                "assets/default_logo.svg", width: 36, height: 36,);
              if(store.storeIcon != null){
                _downloadStoreIcon(store);
              }
            }
        }
      }else{
        storeName = "新增门店";
      }
    });
  }

  _downloadStoreIcon(Store store) async{
    RestClient().downloadFile(store.storeIcon, (data) async {
      File saveFile = await _saveImage(store.id,data);
      if (saveFile != null) {
        store.localUrl = saveFile.path;
        for(int i= 0;i < stores.length; i++){
            stores[i] = store;
          break;
        }
        setState(() {
          storeIcon =  CircleAvatar(backgroundImage: Image.file(File(store.localUrl),width: 36,height: 36,).image,
              radius: 18);
        });
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString(Constants.KEY_STORES, jsonEncode(stores));
      }
    }, (errorCode, description) {
      print(description);
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
}