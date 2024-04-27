import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class Control extends GetxController {
  FlutterBlue blueScan = FlutterBlue.instance;

  Future<void> scan() async {
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted) {
      List<ScanResult> results = await blueScan.startScan(timeout: const Duration(seconds: 10));

      blueScan.stopScan();

      if (results.isEmpty) {
        // Display "No devices found" if no devices are found during scanning
        Get.snackbar(
          'No Devices Found',
          'No Bluetooth devices found nearby.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Stream<List<ScanResult>> get scanResults => blueScan.scanResults;
}
