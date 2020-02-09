import 'package:azlistview/azlistview.dart';

class Customer extends ISuspensionBean{
  String name;
  int sex;
  String phoneNum;
  int birthday;
  int joinTime;
  String remarks;
  String headIcon;
  String localUrl;
  String tagIndex;
  String namePinyin;
  int credit = 0;

  Customer({
    this.name,
    this.sex,
    this.phoneNum,
    this.birthday,
    this.joinTime,
    this.remarks,
    this.headIcon,
    this.localUrl});

  factory Customer.fromJson(Map<String,dynamic> map){
    return Customer(name:map['name'],
    sex:map['sex'],phoneNum:map['phoneNum'],
    birthday:map['birthday'],joinTime:map['joinTime'],
    remarks:map['remarks'],headIcon:map['headIcon'],
    localUrl: map['localUrl']);
  }

  @override
  String getSuspensionTag() => tagIndex;

  Map<String,dynamic> toJson(){
    Map<String,dynamic> map = Map();
    map['name'] = name;
    map['sex'] = sex;
    map['phoneNum'] = phoneNum;
    map['birthday'] = birthday;
    map['joinTime'] = joinTime;
    map['remarks'] = remarks;
    map['headIcon'] = headIcon;
    map['localUrl'] = localUrl;
    return map;
  }
}