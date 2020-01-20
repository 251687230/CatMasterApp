import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditStorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditStoreState();
  }
}

class _EditStoreState extends State<EditStorePage> {
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
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: RichText(
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
                        )),
                        Padding(
                          child: Row(
                            children: <Widget>[
                              Text(
                                "",
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
