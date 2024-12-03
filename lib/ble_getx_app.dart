import 'package:ble_gtx/bindings/controller_bindings.dart';
import 'package:ble_gtx/ui/screens/available_device_screen/available_device_screen.dart';
import 'package:ble_gtx/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BleGetxApp extends StatelessWidget {
  const BleGetxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppString.APP_TITLE,
      initialBinding: ControllerBindings(),
      theme: ThemeData(
        colorSchemeSeed: Colors.blueAccent,
      ),
      home: const AvailableDeviceScreen(),
    );
  }
}
