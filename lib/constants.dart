
class Constants{
  static const int mainColor = 0xf7999f;

  static const int toastBgColor = 0x656565;

  static const String VERIFE_KEY = "zous.catmaster@2019";

  static const String BASE_URL = "http://192.168.0.104:80";

  static const String LOGIN_URL = BASE_URL + "/account/login";

  static const String GET_CAPTCHA_URL = BASE_URL + "/captcha/getCaptcha";

  static const String VERIFY_CAPTCHA_URL = BASE_URL + "/captcha/verifyCaptcha";

  static const String REGISTER_URL = BASE_URL + "/account/register";

  static const String EDIT_PWD_URL = BASE_URL + "/account/changePassword";

  static const String UPLOAD_FILE_URL = BASE_URL + "/file/upload";

  static const String DOWNLOAD_FILE_URL = BASE_URL + "/file/download";

  static const String SAVE_STORE_URL = BASE_URL + "/business/saveStore";

  static const String SAVE_CUSTOMER_URL = BASE_URL + "/business/saveCustomer";

  static const String GET_CUSTOMER_URL = BASE_URL + "/business/getCustomers";

  static const String REFRESH_TOKEN_URL = BASE_URL + "/account/refreshToken";

  static const String DELETE_STORE_URL = BASE_URL + "/business/deleteStore";

  static const String GET_STORES_URL = BASE_URL + "/business/getStores";

  static const int ERROR_SERVICE_EXCEPTION = -1;

  static const String KEY_SEND_TIME = "send_time";

  static const String KEY_TOKEN = "token";

  static const String KEY_TOKEN_SAVE = "token_save";

  static const String KEY_SELECT_STORE = "select_store";

  static const String KEY_STORES = "stores";
}