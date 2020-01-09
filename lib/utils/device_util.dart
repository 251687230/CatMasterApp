import 'package:package_info/package_info.dart';

class DeviceUtil{
  static void getVersionName(GetVersionName getVersionName) async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    getVersionName(packageInfo.version);
  }

}
typedef GetVersionName = dynamic Function(String versionName);