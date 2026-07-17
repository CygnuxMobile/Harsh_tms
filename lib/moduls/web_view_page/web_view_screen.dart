// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tms_newui/moduls/web_view_page/web_view_controller.dart';
// import 'package:tms_newui/utils/tms_color.dart';
// import 'package:tms_newui/widgets/tms_normaltext.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// import '../home_page/dash_board_screen.dart';
//
// class WebViewScreen extends StatelessWidget {
//   WebViewScreen({super.key});
//
//   final WebViewScreenController webViewScreenController =
//       Get.put(WebViewScreenController());
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         webViewScreenController.webViewController.clearCache();
//         final cookieManager = CookieManager();
//         // cookieManager.clearCookies();
//         WebView(
//           initialUrl: 'http://103.232.124.146/Harsh_TEST/Account/LogOff',
//           javascriptMode: JavascriptMode.disabled,
//         );
//         Get.back();
//         return true;
//       },
//       child: SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Color(0xff000a62),
//             title: TmsText(
//               text: webViewEnum == WebViewEnum.manifest
//                   ? "Manifest"
//                   : webViewEnum == WebViewEnum.arrival
//                       ? "Arrival"
//                       : webViewEnum == WebViewEnum.thc
//                           ? "Thc"
//                           : "Stock Update",
//               color: AppColor.white,
//             ),
//             centerTitle: true,
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back,color: AppColor.white,),
//               onPressed: () {
//                 webViewScreenController.webViewController.clearCache();
//                 final cookieManager = CookieManager();
//                 cookieManager.clearCookies();
//                 WebView(
//                   initialUrl: 'http://103.232.124.146/Harsh_TEST/Account/LogOff',
//                   javascriptMode: JavascriptMode.disabled,
//                 );
//                 Get.back();
//               },
//             ),
//           ),
//           body: Obx(
//             () => Stack(
//               children: [
//                 WebView(
//                   zoomEnabled: false,
//                   initialUrl: webViewScreenController.initialUrl,
//                   onPageFinished: (String url) {
//                     print(
//                         "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$url>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//                     List<String> parts = url.split('/');
//                     print(",,,,,,,,,,,,,,,,,,<<<<<<<<<<<<<<<<<<<<<<<<$parts");
//                     String last = parts.last;
//                     List<String> lastParts = last.split("&");
//                     print(
//                         ",,,,,,,,,,,,,,,,,,<<<<<<<<<<<<<<<<<<<<<<<<$lastParts");
//                     showLoader(lastParts);
//                     if (url == webViewScreenController.initialUrl) {
//                       _injectJavascript();
//                     }
//                   },
//                   javascriptMode: JavascriptMode.unrestricted,
//                   onWebViewCreated: (WebViewController controller) {
//                     webViewScreenController.webViewController = controller;
//                   },
//                 ),
//                 if (webViewScreenController.isProgressVisible.isTrue) ...{
//                   Container(
//                     color: Colors.white,
//                     width: double.infinity,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         TmsText(text: "Please Wait...."),
//                         SizedBox(
//                           height: 05,
//                         ),
//                         CircularProgressIndicator(color: Color(0xff000a62),),
//                       ],
//                     ),
//                   ),
//                 }
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void showLoader(List<String> lastParts) {
//     if (lastParts[0] != "Login") {
//       if (webViewEnum == WebViewEnum.manifest) {
//         if (lastParts[1] == "IsMobileUser=1") {
//           webViewScreenController.isProgressVisible.value = false;
//         }
//       } else if (webViewEnum == WebViewEnum.thc) {
//         if (lastParts[1] == "IsMobileUser=1") {
//           webViewScreenController.isProgressVisible.value = false;
//         }
//       } else if (webViewEnum == WebViewEnum.stockUpdate) {
//         print(lastParts[0] == "2?IsMobileUser=1");
//         if (lastParts[0] == "2?IsMobileUser=1") {
//           print("object1");
//           webViewScreenController.isProgressVisible.value = false;
//         }
//       } else if (webViewEnum == WebViewEnum.arrival) {
//         print("${lastParts[0]}");
//         print(lastParts[0] == "1?IsMobileUser=1");
//         if (lastParts[0] == "1?IsMobileUser=1") {
//           print("object2");
//           webViewScreenController.isProgressVisible.value = false;
//         }
//       }
//     }
//   }
//
//   void _injectJavascript() async {
//     await Future.delayed(const Duration(milliseconds: 0));
//     await webViewScreenController.webViewController
//         .runJavascript(webViewScreenController.javascriptCode);
//   }
// }
