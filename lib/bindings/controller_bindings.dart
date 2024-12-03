import 'package:ble_gtx/controllers/selected_device_controller.dart';
import 'package:get/get.dart';

import '../controllers/available_device_controller.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AvailableDeviceController());
    Get.put(SelectedDeviceController());
  }
}