import 'package:azlistview/azlistview.dart';
import 'package:catmaster_app/ui/edit_customer_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MemberListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MemberListState();
  }
}

class _MemberListState extends State<MemberListPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("会员"),
    actions: <Widget>[
      IconButton(icon: Icon(Icons.filter_list,),
        onPressed: (){
        },),
      IconButton(icon: Icon(Icons.search,),
      onPressed: (){
        showSearch(context:context,delegate: searchBarDelegate());
      },),
      IconButton(icon: Icon(Icons.add,),
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return EditCustomerPage();
        }));
      },)
    ],),body:  AzListView(
      data: null,
      topData: null,
      itemBuilder: (context, model) => null,
      suspensionWidget: null,
      isUseRealIndex: true,
      itemHeight: 100,
      suspensionHeight: 100,
      onSusTagChanged: null,
      //showCenterTip: false,
    ),);
  }
}


class searchBarDelegate extends SearchDelegate<String>{

  static const searchList = [
  ];

  static const recentSuggest = [
  ];
  
  //初始化加载
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: ()=>query="",
      )
    ];
  }
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: ()=>close(context, null),
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
      itemBuilder: (context,index) => ListTile(
        title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                children:[
                  TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(
                          color: Colors.grey
                      )
                  )
                ]
            )
        ),
      ),
    );
  }
}