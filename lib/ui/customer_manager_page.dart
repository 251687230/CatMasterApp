import 'dart:io';

import 'package:catmaster_app/entity/customer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

Customer _customer;


class CustomerManagerPage extends StatefulWidget {

  CustomerManagerPage(Customer customer) {
    _customer = customer;
  }

  @override
  State<StatefulWidget> createState() {
    return CustomerManagerState();
  }

}

class CustomerManagerState extends State<CustomerManagerPage> {


  @override
  Widget build(BuildContext context) {
    String localUrl = _customer.localUrl;
    return Scaffold(
        appBar: AppBar(title: Text("会员管理"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.delete,color: Colors.white,),
          onPressed: (){
            _showDeleteDialog();
          },)
        ],),
        backgroundColor: Colors.grey[100],
        body: Column(children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                localUrl == null
                    ? SvgPicture.asset(
                        "assets/customer_header.svg",
                        width: 50,
                        height: 50,
                      )
                    : CircleAvatar(
                        backgroundImage: Image.file(
                          File(localUrl),
                          width: 50,
                          height: 50,
                        ).image,
                        radius: 25,
                      ),
                Expanded(
                  child: Padding(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              _customer.name,
                              style: TextStyle(fontSize: 18),
                            ),
                            Padding(
                              child: SvgPicture.asset(
                                _customer.sex == 0
                                    ? "assets/woman.svg"
                                    : "assets/man.svg",
                                width: 16,
                                height: 16,
                              ),
                              padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                        ),
                        Text(
                          _customer.phoneNum,
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                    ),
                    padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                  ),
                  flex: 1,
                ),
                IconButton(
                  icon: Icon(
                    Icons.message,
                    color: Colors.pink,
                  ),
                  onPressed: () {
                    _sms(_customer.phoneNum);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.call,
                    color: Colors.pink,
                  ),
                  onPressed: () {
                    _call(_customer.phoneNum);
                  },
                ),
                SvgPicture.asset(
                  "assets/right_arrow.svg",
                  width: 20,
                  height: 20,
                  color: Colors.grey[400],
                )
              ],
              mainAxisSize: MainAxisSize.min,
            ),
            color: Colors.white,
            padding: EdgeInsets.all(24),
          ),
          Padding(
            child: Container(
              child: Padding(
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text("累计积分：")),
                    Text("${_customer.credit}"),
                    SvgPicture.asset(
                      "assets/right_arrow.svg",
                      width: 20,
                      height: 20,
                      color: Colors.grey,
                    )
                  ],
                ),
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              ),
              color: Colors.white,
              height: 40,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
          ),
          Container(
            child: Padding(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text("会员卡列表")),
                  IconButton(icon: Icon(Icons.add,color: Colors.pink,),onPressed: (){

                  },)
                ],
              ),
              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
            ),
            color: Colors.white,
            height: 40,
            width: double.infinity,
            alignment: Alignment.center,
          ),
        ]));
  }

  _showDeleteDialog(){
    showDialog(context: context,builder:
    (ctx){
      return AlertDialog(title:Text("请注意"),
      content: Text("删除会员操作不可恢复，并且该会员下所有的会员卡数据都将被删除。请谨慎操作!"),
      actions: <Widget>[
        FlatButton(child: Text("确定"),
        onPressed: (){
          _deleteCustomer(_customer.accountId);
        },),
        FlatButton(child:Text("取消"),
        onPressed: (){
          Navigator.pop(ctx);
        },)
      ],);
    });
  }

  _deleteCustomer(String customerId){

  }

  _call(String phoneNum) async {
    String url = 'tel:$phoneNum';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _sms(String phoneNum) async {
    String url = 'sms:$phoneNum';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
