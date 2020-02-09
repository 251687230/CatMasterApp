import 'package:azlistview/azlistview.dart';
import 'package:catmaster_app/entity/customer.dart';
import 'package:catmaster_app/entity/store.dart';
import 'package:catmaster_app/network/http_client.dart';
import 'package:catmaster_app/ui/edit_customer_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lpinyin/lpinyin.dart';

Store _store;
List<Customer> _customers;

class CustomerListPage extends StatefulWidget {
  CustomerListPage(Store store) {
    _store = store;
  }

  @override
  State<StatefulWidget> createState() {
    return _CustomerListState();
  }
}

class _CustomerListState extends State<CustomerListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("会员"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.filter_list,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.search,
              ),
              onPressed: () {
                showSearch(context: context, delegate: searchBarDelegate());
              },
            ),
            IconButton(
              icon: Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditCustomerPage(_store);
                }));
              },
            )
          ],
        ),
        body: _customers == null || _customers.length == 0
            ? _createEmptyBody()
            : _createListBody());
  }

  Widget _createListBody() {
    return AzListView(
      data: _customers,
      topData: null,
      itemBuilder: (context, model) {
        Customer customer = model;
        String localUrl = customer.localUrl;
        String susTag = model.getSuspensionTag();
        return Column(
          children: <Widget>[
            Offstage(
              offstage: model.isShowSuspension != true,
              child: _buildSusWidget(susTag),
            ),
            GestureDetector(child: Padding(
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
                            croppedFile,
                            width: 50,
                            height: 50,
                          ).image,
                          radius: 25,
                        ),
                  Padding(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              child: Text(
                                customer.name,
                                style: TextStyle(fontSize: 18),
                              ),
                              padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                            ),
                            SvgPicture.asset(
                              customer.sex == 0
                                  ? "assets/woman.svg"
                                  : "assets/man.svg",
                              width: 16,
                              height: 16,
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "积分：   ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              customer.credit.toString(),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                  )
                ],
              ),
              padding: EdgeInsets.all(16),
            ),onTap: (){

            },)
          ],
        );
      },
      suspensionWidget: null,
      isUseRealIndex: true,
      itemHeight: 100,
      suspensionHeight: 100,
      onSusTagChanged: null,
      //showCenterTip: false,
    );
  }

  Widget _buildSusWidget(String susTag) {
    return Container(
      height: 30,
      padding: const EdgeInsets.only(left: 15.0),
      color: Colors.grey[350],
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  Widget _createEmptyBody() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          "assets/empty_view.svg",
          width: 120,
          height: 120,
        ),
        Padding(
            child: Text("暂无数据",
                style: TextStyle(fontSize: 32, color: Colors.grey)),
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
      ],
    ));
  }

  @override
  void initState() {
    super.initState();
    _getCustomers(_store.id);
  }

  void _getCustomers(String storeId) {
    RestClient().getCustomer(storeId, (data) {
      List decodeJson = json.decode(data);
      if (decodeJson == null || decodeJson.isEmpty) return;
      List<Customer> items =
          decodeJson.map((m) => Customer.fromJson(m)).toList();
      for (int i = 0, length = items.length; i < length; i++) {
        String pinyin = PinyinHelper.getPinyinE(items[i].name);
        String tag = pinyin.substring(0, 1).toUpperCase();
        items[i].namePinyin = pinyin;
        if (RegExp("[A-Z]").hasMatch(tag)) {
          items[i].tagIndex = tag;
        } else {
          items[i].tagIndex = "#";
        }
      }
      //根据A-Z排序
      SuspensionUtil.sortListBySuspensionTag(items);
      setState(() {
        _customers = items;
      });
    }, (errorCode, description) {
      showToast(description);
    });
  }
}

class searchBarDelegate extends SearchDelegate<String> {
  static const searchList = [];

  static const recentSuggest = [];

  //初始化加载
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      child: Card(
        color: Colors.redAccent,
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSuggest
        : searchList.where((input) => input.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                  text: suggestionList[index].substring(query.length),
                  style: TextStyle(color: Colors.grey))
            ])),
      ),
    );
  }
}
