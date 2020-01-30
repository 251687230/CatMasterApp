import 'dart:io';

import 'package:catmaster_app/ui/cut_image_page.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class EditStorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditStoreState();
  }
}

class _EditStoreState extends State<EditStorePage> {
  String fullAreaName = "";
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
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    createItem("门店名称", true, 20),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Padding(child:
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text("门店标识",style: TextStyle(color: Colors.grey[900], fontSize: 16)),
                        ),
                        InkWell(child:
                        SvgPicture.asset("assets/default_logo.svg",width: 36,height: 36,),
                        onTap: (){
                        getImage();
                        },)
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(0, 8 , 0, 8),),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    createItem("负责人", true, 10),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    createItem("联系手机", true, 11),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    createItem("联系座机", false, 15),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    InkWell(child:
                    Row(
                      children: <Widget>[
                        Expanded(
                            child:RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: "所在地区",
                                  style: TextStyle(
                                      color: Colors.grey[900], fontSize: 16)),

                              TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red[900]))
                            ],
                          ),
                        ),),
                        Padding(
                          child: Row(
                            children: <Widget>[
                              Container(width: 200,child:
                              Text(
                                fullAreaName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),alignment: Alignment.centerRight,),
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
                    ),onTap: (){
                      showCityPicker();
                    }),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    createItem("详细地址", true, 30),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Padding(
                      child: Text(
                        "简介",
                        style: TextStyle(color: Colors.grey[900], fontSize: 16),
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
                      ),
                      constraints: BoxConstraints(maxHeight: 100),
                    )
                  ]),
                ),
                RaisedButton(child:
                  Text("保存",style: TextStyle(color: Colors.white),),
                onPressed: (){
                  print("点击了保存按钮");
                },)
              ])),
    );
  }
  
  void showCityPicker() async{
    Result result = await CityPickers.showFullPageCityPicker(context: context);
    setState(() {
      fullAreaName = result.provinceName + result.cityName + result.areaName;
    });
  }

  void getImage() async{
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    Navigator.push(context, MaterialPageRoute(
      builder: (context){
        return CutImagePage(image);
      }
    ));
  }

  Row createItem(String title, bool isMust, int maxLength) {
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
        ))
      ],
    );
  }
}
