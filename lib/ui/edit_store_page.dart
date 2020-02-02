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

class EditStorePage extends StatefulWidget {
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
  TextEditingController _storeNameCtrl,_contactCtrl,_contactPhoneCtrl,_areaCtrl,_fixPhoneCtrl,_introduceCtrl;

  @override
  void initState() {
    super.initState();
    logoWidget = SvgPicture.asset(
      "assets/default_logo.svg",
      width: 36,
      height: 36,
    );
    getToken();

    _storeNameCtrl = TextEditingController();
    _storeNameCtrl = TextEditingController();
    _contactCtrl = TextEditingController();
    _contactPhoneCtrl = TextEditingController();
    _areaCtrl = TextEditingController();
    _fixPhoneCtrl = TextEditingController();
    _introduceCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新增门店"),
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
                        createItem("门店名称", true, 20,_storeNameCtrl),
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
                        createItem("负责人", true, 10,_contactCtrl),
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        createItem("联系手机", true, 11,_contactPhoneCtrl),
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        createItem("联系座机", false, 15,_fixPhoneCtrl),
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
                        createItem("详细地址", true, 30,_areaCtrl),
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
                    if(storeName == ""){
                      showToast("请填写门店名称");
                      return;
                    }
                    String contact = _contactCtrl.text.trim();
                    if(contact == ""){
                      showToast("请填写负责人");
                      return;
                    }
                    String contactPhone = _contactPhoneCtrl.text.trim();
                    if(contactPhone == ""){
                      showToast("请填写联系手机");
                      return;
                    }
                    if(areaCode == ""){
                      showToast("请选择所在地区");
                      return;
                    }
                    String area = _areaCtrl.text.trim();
                    if(area == ""){
                      showToast("请填写详细地址");
                      return;
                    }
                    String fixPhone = _fixPhoneCtrl.text.trim();
                    String introduce = _introduceCtrl.text.trim();
                    //TODO 创建Store对象
                    //saveStore();
                  },
                )
              ])),
    );
  }

  void getToken() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token =  sharedPreferences.getString(Constants.KEY_TOKEN);
  }

  void saveStore(Store store){
    if(croppedFile != null) {
      RestClient().uploadFile(token,croppedFile, "store.png", (data) {
        /*RestClient().saveStore(token, store, (data){

        }, (errorCode, description) {

        });*/
      }, (errorCode, description) {
        showToast(description);
      });
    }
  }

  void showCityPicker() async {
    Result result = await CityPickers.showFullPageCityPicker(context: context);
    setState(() {
      fullAreaName = result.provinceName + result.cityName + result.areaName;
      areaCode = result.areaId;
    });
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
      var appDocDir = await getExternalStorageDirectory();
      String appDocPath = appDocDir.path;

      File file = File(appDocPath +
          "/store_pic_" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".jpg");
      print(file.path);
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

  Row createItem(String title, bool isMust, int maxLength,TextEditingController controller) {
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
          decoration:
              InputDecoration(border: InputBorder.none, counterText: ""),
          maxLength: maxLength,
          textDirection: TextDirection.rtl,
              controller: controller,
        ))
      ],
    );
  }
}
