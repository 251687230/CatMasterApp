import 'dart:async';
class RxUtil {
  static Function debounce(Function fn, int t) {
    Timer _debounce;
    return () {
      // 还在时间之内，抛弃上一次
      if (_debounce?.isActive ?? false) _debounce.cancel();

      _debounce = Timer(Duration(milliseconds: t), () {
        fn();
      });
    };
  }
}