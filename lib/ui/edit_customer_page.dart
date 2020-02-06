import 'dart:io';

import 'package:catmaster_app/widget/common_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

typedef DatePickCallback(DateTime date);

class EditCustomerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditCustomerState();
  }
}

class EditCustomerState extends State<EditCustomerPage> {
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _phoneCtrl = TextEditingController();
  TextEditingController _introduceCtrl = TextEditingController();

  int sex = 0;

  Widget logoWidget = SvgPicture.asset(
    "assets/customer_header.svg",
    width: 60,
    height: 60,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("新增会员"),
        ),
        body: Padding(
          child: Center(
              child: ListView(children: <Widget>[
                GestureDetector(child:
                logoWidget,
                  onTap: clickHeadPhoto,
                )
           ,
            Padding(
              child:
              Center(child:Text(
                "门店名称",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
              padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
            ),
            Container(
              color: Color(0xFFEEEEEE),
              height: 12,
            ),
            createEditItem("姓名", true, 9, _nameCtrl),
            Divider(
              height: 1,
              color: Colors.grey,
              indent: 12,
              endIndent: 12,
            ),
            createSelectItem("性别", sex == 0? "女" : "男", clickSexItem),
            Divider(
              height: 1,
              color: Colors.grey,
              indent: 12,
              endIndent: 12,
            ),
            createEditItem("手机", true, 11, _phoneCtrl,
                textInputType: TextInputType.phone),
            Divider(
              height: 1,
              color: Colors.grey,
              indent: 12,
              endIndent: 12,
            ),
            createSelectItem("生日", "请选择", clickBirthdayItem),
            Divider(
              height: 1,
              color: Colors.grey,
              indent: 12,
              endIndent: 12,
            ),
            createSelectItem("入会时间", "请选择", clickJoinTime),
            Divider(
              height: 1,
              color: Colors.grey,
              indent: 12,
              endIndent: 12,
            ),
            Padding(
              child: Column(
                children: <Widget>[
                  Text("备注",
                      style: TextStyle(color: Colors.grey[900], fontSize: 16)),
                  Container(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "请输入门店简介",
                      ),
                      maxLength: 100,
                      maxLines: null,
                      controller: _introduceCtrl,
                    ),
                    constraints: BoxConstraints(maxHeight: 100),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              padding: EdgeInsets.all(16),
            ),
            Divider(
              height: 1,
              color: Colors.grey,
              indent: 12,
              endIndent: 12,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: RaisedButton(
                child: Text(
                  "保存",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              ),
            )
          ])),
          padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
        ));
  }

  void clickHeadPhoto(){
    showDialog(
        barrierDismissible: true,//是否点击空白区域关闭对话框,默认为true，可以关闭
        context: context,
        builder: (BuildContext context) {
          var list = List();
          list.add('打开相机');
          list.add('从相册中选择');
          return CommonBottomSheet(
            list: list,
            onItemClickListener: (index) async {
              Navigator.pop(context);
              var image = await ImagePicker.pickImage(source: index ==0 ?ImageSource.camera : ImageSource.gallery);
              _cropImage(image);
            },
          );
        });
  }

  void _cropImage(File image) async {
    var croppedFile = await ImageCropper.cropImage(
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
          width: 60,
          height: 60,
        ).image,
        radius: 30,
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
          "/customer_pic_" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".jpg");
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

  void clickSexItem() {
    showDialog(
        barrierDismissible: true,//是否点击空白区域关闭对话框,默认为true，可以关闭
        context: context,
        builder: (BuildContext context) {
          var list = List();
          list.add('女');
          list.add('男');
          return CommonBottomSheet(
            list: list,
            onItemClickListener: (index) async {
              Navigator.pop(context);
              setState(() {
                sex = index;
              });
            },
          );
        });
  }

  void clickBirthdayItem() {
   showDatePicker((date) {});
  }

  void showDatePicker(DatePickCallback onDatePick){
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2000, 1, 1),
        maxTime: DateTime(2039, 12, 31), onChanged: (date) {
        }, onConfirm: (date) {
          onDatePick(date);
        }, currentTime: DateTime.now(), locale: LocaleType.zh);
  }

  void clickJoinTime() {
    showDatePicker((date) {});
  }

  Widget createSelectItem(String title, String hintText, Function function) {
    return InkWell(
        child: Padding(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(title,
                      style: TextStyle(color: Colors.grey[900], fontSize: 16))),
              Padding(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 200,
                      child: Text(
                        hintText,
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
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        ),
        onTap: () {
          function();
        });
  }

  Widget createEditItem(String title, bool isMust, int maxLength,
      TextEditingController controller,
      {TextInputType textInputType}) {
    return Padding(
      child: Row(
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
                hintText: isMust ? "必填" : ""),
            style: TextStyle(color: ThemeData().hintColor),
            textAlign: TextAlign.end,
            maxLength: maxLength,
            keyboardType: textInputType,
            controller: controller,
          ))
        ],
      ),
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
    );
  }
}
