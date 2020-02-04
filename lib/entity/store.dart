class Store {
  String id;
  String name;
  String contactPhone;
  String contact;
  String fixedPhone;
  String areaCode;
  String detailAddr;
  String introduce;
  String storeIcon;
  List<String> imageUrls;
  String localUrl;

  Store({
      this.id,
      this.name,
      this.contactPhone,
      this.contact,
      this.fixedPhone,
      this.areaCode,
      this.detailAddr,
      this.introduce,
      this.storeIcon,
      this.imageUrls,
  this.localUrl});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
        id: json["id"],
        name: json["name"],
        contactPhone: json["contactPhone"],
        contact: json["contact"],
        fixedPhone: json["fixedPhone"],
        areaCode: json["areaCode"],
        detailAddr: json["detailAddr"],
        introduce: json["introduce"],
        storeIcon: json["storeIcon"],
        imageUrls: List<String>.from(json["imageUrls"]),
        localUrl: json["localUrl"]);
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = Map<String, dynamic>();
    json["id"] = id;
    json["name"] = name ;
    json["contactPhone"] =contactPhone;
    json["contact"] = contact;
    json["fixedPhone"] =fixedPhone;
    json["areaCode"] = areaCode;
    json["detailAddr"] =detailAddr;
    json["introduce"] =introduce;
    json["storeIcon"] = storeIcon;
    json["imageUrls"] = imageUrls;
    json["localUrl"] = localUrl;
    return json;
  }
}
