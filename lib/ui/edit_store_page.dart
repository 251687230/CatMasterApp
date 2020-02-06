import 'dart:convert';
import 'dart:io';

import 'package:catmaster_app/entity/store.dart';
import 'package:catmaster_app/network/http_client.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:catmaster_app/constants.dart';
import 'package:oktoast/oktoast.dart';
import 'package:catmaster_app/widget/progress_dialog.dart';

Store _store;

class EditStorePage extends StatefulWidget {
  EditStorePage({Store store}) {
    _store = store;
  }

  @override
  State<StatefulWidget> createState() {
    return _EditStoreState();
  }
}

class _EditStoreState extends State<EditStorePage> {
  String fullAreaName = "";
  Widget logoWidget;
  File croppedFile;
  String token = "";
  String areaCode = "";
  String localFilePath;
  TextEditingController _storeNameCtrl,
      _contactCtrl,
      _contactPhoneCtrl,
      _areaCtrl,
      _fixPhoneCtrl,
      _introduceCtrl,
      _deleteStoreCtrl;

  @override
  void initState() {
    super.initState();
    logoWidget = (_store == null || _store.localUrl == null)
        ? SvgPicture.asset(
            "assets/default_logo.svg",
            width: 36,
            height: 36,
          )
        : CircleAvatar(backgroundImage:Image.file(
            File(_store.localUrl),
            width: 36,
            height: 36,
          ).image,radius: 18);
    getToken();

    _storeNameCtrl = TextEditingController();
    _contactCtrl = TextEditingController();
    _contactPhoneCtrl = TextEditingController();
    _areaCtrl = TextEditingController();
    _fixPhoneCtrl = TextEditingController();
    _introduceCtrl = TextEditingController();
    _deleteStoreCtrl = TextEditingController();

    if (_store != null) {
      _storeNameCtrl.text = _store.name;
      _contactCtrl.text = _store.contact;
      _contactPhoneCtrl.text = _store.contactPhone;
      _areaCtrl.text = _store.detailAddr;
      _fixPhoneCtrl.text = _store.fixedPhone;
      _introduceCtrl.text = _store.introduce;
      areaCode = _store.areaCode;

      CityPickerUtil utils = CityPickers.utils();
      Result result = utils.getAreaResultByCode(_store.areaCode);
      fullAreaName = result.provinceName + result.cityName + result.areaName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_store == null ? "新增门店" : "编辑门店"),
        actions: _store == null
            ? null
            : <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("请注意"),
                            content: Column(
                              children: <Widget>[
                                Text("您正在执行不可恢复的删除操作，删除门店将会导致门店下的所有信息都被清除。"
                                    "如果您仍要执行此操作，请在下面输入框输入删除门店的名称，防止误操作："),
                                TextField(
                                  decoration:
                                      InputDecoration(hintText: "请输入要删除门店的名称"),
                                  controller: _deleteStoreCtrl,
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                            ),
                            actions: <Widget>[
                              FlatButton(
                                  child: Text("确定"),
                                  onPressed: () {
                                    String inputText = _deleteStoreCtrl.text;
                                    if (inputText != null &&
                                        inputText == _store.name) {
                                      Navigator.pop(context);
                                      _deleteStore(_store.id);
                                    } else {
                                      showToast("输入名称不一致，无法删除");
                                    }
                                  }),
                              FlatButton(
                                child: Text("取消"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                  },
                )
              ],
      ),
      body: Container(
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        createItem("门店名称", true, 20, _storeNameCtrl),
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text("门店标识",
                                    style: TextStyle(
                                        color: Colors.grey[900], fontSize: 16)),
                              ),
                              InkWell(
                                child: logoWidget,
                                onTap: () {
                                  getImage();
                                },
                              )
                            ],
                          ),
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        createItem("负责人", true, 10, _contactCtrl),
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        createItem("联系手机", true, 11, _contactPhoneCtrl,
                            textInputType: TextInputType.phone),
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        createItem("联系座机", false, 15, _fixPhoneCtrl,
                            textInputType: TextInputType.phone),
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        InkWell(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "所在地区",
                                            style: TextStyle(
                                                color: Colors.grey[900],
                                                fontSize: 16)),
                                        TextSpan(
                                            text: "*",
                                            style: TextStyle(
                                                color: Colors.red[900]))
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 200,
                                        child: Text(
                                          fullAreaName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        alignment: Alignment.centerRight,
                                      ),
                                      SvgPicture.asset(
                                        "assets/right_arrow.svg",
                                        width: 20,
                                        height: 20,
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                )
                              ],
                            ),
                            onTap: () {
                              showCityPicker();
                            }),
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        createItem("详细地址", true, 30, _areaCtrl),
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          child: Text(
                            "简介",
                            style: TextStyle(
                                color: Colors.grey[900], fontSize: 16),
                          ),
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        Container(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "请输入门店简介",
                            ),
                            maxLength: 1000,
                            maxLines: null,
                            controller: _introduceCtrl,
                          ),
                          constraints: BoxConstraints(maxHeight: 100),
                        )
                      ]),
                ),
                RaisedButton(
                  child: Text(
                    "保存",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    String storeName = _storeNameCtrl.text.trim();
                    if (storeName == "") {
                      showToast("请填写门店名称");
                      return;
                    }
                    String contact = _contactCtrl.text.trim();
                    if (contact == "") {
                      showToast("请填写负责人");
                      return;
                    }
                    String contactPhone = _contactPhoneCtrl.text.trim();
                    if (contactPhone == "") {
                      showToast("请填写联系手机");
                      return;
                    }
                    if (areaCode == "") {
                      showToast("请选择所在地区");
                      return;
                    }
                    String area = _areaCtrl.text.trim();
                    if (area == "") {
                      showToast("请填写详细地址");
                      return;
                    }
                    String fixPhone = _fixPhoneCtrl.text.trim();
                    String introduce = _introduceCtrl.text.trim();
                    if (_store == null) {
                      _store = Store();
                    }
                    _store.areaCode = areaCode;
                    _store.contact = contact;
                    _store.contactPhone = contactPhone;
                    _store.fixedPhone = fixPhone;
                    _store.detailAddr = area;
                    _store.introduce = introduce;
                    _store.name = storeName;
                    uploadPic(_store);
                  },
                )
              ])),
    );
  }

  void getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString(Constants.KEY_TOKEN);
  }

  void _deleteStore(String id) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return LoadingDialog(
            text: "删除中…",
          );
        });
    RestClient().deleteStore(id, (data) {
      saveStoreInfo(_store, isDelete: true);
    }, (errorCode, description) {
      Navigator.pop(context);
      showToast(description);
    });
  }

  void uploadPic(Store store) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(
            text: "保存中…",
          );
        });
    if (croppedFile != null) {
      RestClient().uploadFile(croppedFile, "store.png", (data) {
        store.storeIcon = data;
        store.localUrl = localFilePath;
        saveStore(store);
      }, (errorCode, description) {
        Navigator.pop(context);
        showToast(description);
      });
    } else {
      saveStore(store);
    }
  }

  void saveStore(Store store) {
    RestClient().saveStore(store, (data) {
      Store returnStore = Store.fromJson(json.decode(data));
      saveStoreInfo(returnStore);
    }, (errorCode, description) {
      Navigator.pop(context);
      showToast(description);
    });
  }

  void saveStoreInfo(Store store, {bool isDelete = false}) async {
    if(localFilePath != null){
      var appDocDir;
      if(Platform.isIOS){
        appDocDir = await getApplicationDocumentsDirectory();
      }else {
        appDocDir = await getExternalStorageDirectory();
      }
      String appDocPath = appDocDir.path;

      File file = File(localFilePath);
      String newPath = appDocPath + "/store_pic_" + store.id + ".jpg";
      file.rename(newPath);
      store.localUrl = newPath;
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String storeStr = sharedPreferences.getString(Constants.KEY_STORES);
    List decodeJson = json.decode(storeStr);
    List<Store> stores = decodeJson.map((m) => new Store.fromJson(m)).toList();
    bool isExit = false;
    if (!isDelete) {
      for (int i=0 ; i < stores.length; i++) {
        Store element = stores[i];
        if (element.id == store.id) {
          isExit = true;
          stores[i] = store;
          break;
        }
      }
      if (!isExit) {
        stores.add(store);
      }
    } else {
      for (Store element in stores) {
        if (element.id == store.id) {
          stores.remove(element);
          break;
        }
      }
    }
    sharedPreferences.setString(Constants.KEY_STORES, jsonEncode(stores));
    Navigator.pop(context);
    Navigator.pop(context, stores);
  }

  void showCityPicker() async {
    Result result = await CityPickers.showFullPageCityPicker(
        context: context,
        locationCode: _store != null ? _store.areaCode : "110000");
    if (result != null) {
      setState(() {
        fullAreaName = result.provinceName + result.cityName + result.areaName;
        areaCode = result.areaId;
      });
    }
  }

  void getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _cropImage(image);
  }

  void _cropImage(File image) async {
    croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        maxHeight: 300,
        maxWidth: 300,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '编辑图片',
            toolbarColor: Colors.pink,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
        cropStyle: CropStyle.circle,
        compressQuality: 100);
    setState(() {
      logoWidget = CircleAvatar(
        backgroundImage: Image.file(
          croppedFile,
          width: 36,
          height: 36,
        ).image,
        radius: 18,
      );
    });
    _saveImage(croppedFile);
  }

  void _saveImage(File croppedFile) async {
    try {
      var appDocDir;
      if(Platform.isIOS){
        appDocDir = await getApplicationDocumentsDirectory();
      }else {
        appDocDir = await getExternalStorageDirectory();
      }
      String appDocPath = appDocDir.path;

      File file = File(appDocPath +
          "/store_pic_" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".jpg");
      localFilePath = file.path;
      bool isExit = await file.exists();
      if (!isExit) {
        var createdFile = await file.create();
        var data = await croppedFile.readAsBytes();
        createdFile.writeAsBytes(data);
      }
    } catch (err) {
      print(err);
    }
  }

  Row createItem(String title, bool isMust, int maxLength,
      TextEditingController controller,
      {TextInputType textInputType}) {
    return Row(
      children: <Widget>[
        Expanded(
            child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: title,
                  style: TextStyle(color: Colors.grey[900], fontSize: 16)),
              TextSpan(
                  text: isMust ? "*" : "",
                  style: TextStyle(color: Colors.red[900]))
            ],
          ),
        )),
        Expanded(
            child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            counterText: "",
          ),
          maxLength: maxLength,
          keyboardType: textInputType,
          textDirection: TextDirection.rtl,
          controller: controller,
        ))
      ],
    );
  }
}
