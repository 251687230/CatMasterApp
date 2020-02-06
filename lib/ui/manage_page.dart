import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'member_list_page.dart';

const String MEMBER_LIST = "会员列表";
const String VIP_CARD_MANAGE = "会员卡管理";
const String POINT_SETTING = "积分设置";
const String COURSE_MANAGE = "课程管理";
const String COURSE_TABLE = "课程表";
const String COURSE_PRICE = "课时费设置";
const String STORE_INFO = "门店信息";
const String STAFF = "员工/教练";
const String STORE_PIC = "门店照片";

class ManagePage extends StatelessWidget {
  var _context;
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("管理"),
      ),
      backgroundColor: Color(0xFFEEEEEE),
      body: Column(
        children: <Widget>[
          Card(
            child: Padding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "会员管理",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    child:  Row(children: <Widget>[
                        _createItem("assets/customer.svg", MEMBER_LIST),
                      _createItem("assets/vip_card.svg", VIP_CARD_MANAGE),
                      _createItem("assets/point.svg", POINT_SETTING)
                    ],mainAxisAlignment: MainAxisAlignment.spaceAround,),
                    padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                  )
                ],
              ),
              padding: EdgeInsets.all(16),
            ),
            margin: EdgeInsets.all(16),
            elevation: 15.0,
          ),
          Card(
            child: Padding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "课程管理",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    child:  Row(children: <Widget>[
                      _createItem("assets/course.svg", COURSE_MANAGE),
                      _createItem("assets/course_table.svg", COURSE_TABLE),
                      _createItem("assets/course_price.svg", COURSE_PRICE)
                    ],mainAxisAlignment: MainAxisAlignment.spaceAround,),
                    padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                  )
                ],
              ),
              padding: EdgeInsets.all(16),
            ),
            margin: EdgeInsets.all(16),
            elevation: 15.0,
          ),
          Card(
            child: Padding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "门店管理",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    child:  Row(children: <Widget>[
                      _createItem("assets/store.svg", STORE_INFO),
                      _createItem("assets/staff.svg", STAFF),
                      _createItem("assets/store_pic.svg", STORE_PIC)
                    ],mainAxisAlignment: MainAxisAlignment.spaceAround,),
                    padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                  )
                ],
              ),
              padding: EdgeInsets.all(16),
            ),
            margin: EdgeInsets.all(16),
            elevation: 15.0,
          )
        ],
      ),
    );
  }

  Widget _createItem(String assetName,String itemName){
    return GestureDetector(child:Column(children: <Widget>[
      SvgPicture.asset(assetName,width: 40,height: 40,),
      Padding(child:
      Text(itemName),padding: EdgeInsets.fromLTRB(0, 8, 0, 0),)
    ],),onTap: (){
        _jumpPage(itemName);
    });
  }

  void _jumpPage(String itemName){
    Widget widget;
    switch(itemName){
      case MEMBER_LIST:
        widget = MemberListPage();
    }
    if(widget != null){
      Navigator.push(_context, MaterialPageRoute(builder: (context){
        return widget;
      }));
    }
  }
}
