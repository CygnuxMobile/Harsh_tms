import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:video_player/video_player.dart';
import '../../app_routes.dart';
import '../../utils/pref.dart';

RxBool isNetOn = false.obs;

class SplashScreenController extends GetxController {
  late VideoPlayerController controller;
  final player = AudioPlayer();
  AppUpdateInfo? _updateInfo;

  @override
  void onInit() {
    player.play(AssetSource('audio/welcome_tms_app.mp3'));
    Connectivity().checkConnectivity().then((value) => noInterNetDialog(value));
    Connectivity().onConnectivityChanged.listen((event) {
      noInterNetDialog(event);
    });
    super.onInit();
  }

  @override
  void onReady() {
    checkLogin();
    super.onReady();
  }

  void noInterNetDialog(List<ConnectivityResult> result) {
    bool isConnected = (result != ConnectivityResult.none);
    if (!isConnected) {
      Get.defaultDialog(
        title: 'No Internet Connection',
        backgroundColor: Colors.white,
        middleText: 'Please check your internet connection and try again.',
        barrierDismissible: false,
        confirm: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          child: const Text(
            'OK',
          ),
          onPressed: () {
            Connectivity().checkConnectivity().then((value) {
              if (value == ConnectivityResult.none) {
                isNetOn = false.obs;
              } else {
                Get.back();
                isNetOn = true.obs;
              }
            });
          },
        ),
      );
    } else {
      // isNetOn = true.obs;
    }
  }

  Future<void> checkForUpdate() async {
    try {

      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('update')
          .doc('8DvlhcsusYyhLY0ZDCcc')
          .get();

      bool isLive = snapshot.exists && snapshot.data()?['isLive'] == true;

      print("LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL${snapshot.data()}");
      print("JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ${isLive}");

      if (isLive) {
        _updateInfo = await InAppUpdate.checkForUpdate();
        if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
          try {
            await InAppUpdate.startFlexibleUpdate();
            await InAppUpdate.completeFlexibleUpdate();
            // TmsToast.msg("Update completed successfully!");
          } catch (e) {
            print("Error during update: $e");
            // TmsToast.msg("Update failed: ${e.toString()}");
          }
        } else {
          // TmsToast.msg("No update available");
        }
      } else {
        // TmsToast.msg("Update check skipped: App is not live.");
      }
    } catch (e) {
      print("Update check failed: $e");
      // TmsToast.msg("Update check failed: ${e.toString()}");

      // Handle specific error codes
      if (e.toString().contains('ERROR_INSTALL_NOT_ALLOWED')) {
        // TmsToast.msg("Update not allowed: Check battery or storage.");
      }
    }
  }


  Future checkLogin() async {
    Future.delayed(
      const Duration(seconds: 3, milliseconds: 500),
      () {
        if (Pref().getIsLogin() == false) {
          Get.offAllNamed(AppRoutes.loginScreen);
        } else {
          Get.offAllNamed(AppRoutes.dashboardScreen);
        }
      },
    );
  }
}
