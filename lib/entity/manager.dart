class Manager {
    String id;
    String name;
    String headIcon;
    String localUrl;
    int expireTime;

    Manager({
        this.id,
        this.name,
        this.headIcon,
        this.localUrl,
        this.expireTime
    });

    factory Manager.fromJson(Map<String,dynamic> map){
        return Manager(id:map['id'],
            name:map['name'],
            headIcon:map['headIcon'],
            localUrl:map['localUrl'],
            expireTime:map['expireTime']);
    }

    Map<String,dynamic> toJson(){
        Map<String,dynamic> map = Map();
        map['id'] = id;
        map['name'] = name;
        map['headIcon'] = headIcon;
        map['localUrl'] = localUrl;
        map['expireTime'] = expireTime;
        return map;
    }
}