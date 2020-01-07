class Result<T>{
  int errorCode;
  String description;
  T data;

  Result({this.errorCode,this.description,this.data});

  factory Result.fromJson(Map<String,dynamic> json){
    return Result(
      errorCode: json['errorCode'],
      description: json['description'],
      data : json['data']
    );
  }
}