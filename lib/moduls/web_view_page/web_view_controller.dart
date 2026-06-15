import 'package:get/get.dart';
import 'package:harsh/moduls/home_page/dash_board_screen.dart';
import 'package:harsh/utils/pref.dart';
class WebViewScreenController extends GetxController {
  @override
  void onInit() async {
    initialUrl;
    logoutUrl;
    javascriptCode;
    super.onInit();
  }


  RxBool isProgressVisible = true.obs;
  final String initialUrl = "http://103.232.124.146/Harsh_Test/Account/Login";
  final String javascriptCode = webViewEnum == WebViewEnum.manifest
      ? 'WebViewAutoLogin("${Pref().getUserId()}","${Pref().getUserPassword()}","${Pref().getBaseLocation()}","MF")'
      : webViewEnum == WebViewEnum.thc
          ? 'WebViewAutoLogin("${Pref().getUserId()}","${Pref().getUserPassword()}","${Pref().getBaseLocation()}","THC")'
          : webViewEnum == WebViewEnum.stockUpdate
              ? 'WebViewAutoLogin("${Pref().getUserId()}","${Pref().getUserPassword()}","${Pref().getBaseLocation()}","StockUpdate")'
              : 'WebViewAutoLogin("${Pref().getUserId()}","${Pref().getUserPassword()}","${Pref().getBaseLocation()}","Arrival")';

  final logoutUrl = "http://103.232.124.146/Harsh_TEST/Account/LogOff";

}
