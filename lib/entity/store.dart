class Store {
  int id;
  String name;
  String contactPhone;
  String contact;
  String fixedPhone;
  String areaCode;
  String detailAddr;
  String introduce;
  String storeIcon;
  List<String> imageUrls;

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
      this.imageUrls});

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
        imageUrls: json["imageUrls"]);
  }
}
