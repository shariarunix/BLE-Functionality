import 'dart:convert';

import 'package:ble_gtx/ui/components/get_x_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class SelectedDeviceController extends GetxController {

  TextEditingController commandEditingController = TextEditingController();

  Rx<List<BluetoothService>> services = Rx([]);
  RxString readData = RxString('');
  RxString notifyData = RxString('');
  RxBool isLoading = RxBool(false);
  RxBool isReading = RxBool(false);
  RxBool isNotifyEnabled = RxBool(false);

  Future<void> connectOrDisconnectDevice(BluetoothDevice device) async {
    try{
      if (device.isConnected) {
        await device.disconnect();
      } else {
        await device.connect();
        fetchServices(device);
      }
    } catch(e) {
      getXSnackbar(message: e.toString());
    }
  }

  Future<void> fetchServices(BluetoothDevice device) async {
    try {
      isLoading.value = true;
      var tempServices = await device.discoverServices();
      services.value = tempServices;
    } catch (e) {
      getXSnackbar(message: 'Something went wrong in fetching services.');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleReadMode(BluetoothService service) {
    if (!isReading.value) {
      startReading(service.characteristics[0]);
    } else {
      cancelReading(service.characteristics[0]);
    }
  }

  void startReading(BluetoothCharacteristic characteristics) {
    if(isReading.value) return;

    characteristics.lastValueStream.listen((data){
      readData.value = String.fromCharCodes(data);
    }).onError((error){
      getXSnackbar(message: 'Something went wrong on reading data.');
    });

    isReading.value = true;
  }

  void cancelReading(BluetoothCharacteristic characteristics) {
    characteristics.lastValueStream.listen((data){}).cancel();
    isReading.value = false;
  }

  Future<void> writeCommand(BluetoothCharacteristic characteristic) async {
    if(commandEditingController.text.isNotEmpty){
      await characteristic
          .write(utf8
          .encode(commandEditingController.text)
          .toList());

      commandEditingController.clear();
    }
  }

  void toggleNotifyMode(BluetoothService service){
    if(!isNotifyEnabled.value){
      startNotify(service.characteristics[0]);
    } else {
      cancelNotify(service.characteristics[0]);
    }
  }

  void startNotify(BluetoothCharacteristic characteristic) {
    if(isNotifyEnabled.value) return;
    
    characteristic.setNotifyValue(true);
    characteristic.lastValueStream.listen((data){
      notifyData.value = String.fromCharCodes(data);
    }).onError((error){
      getXSnackbar(message: 'Something went wrong on notify');
    });

    isNotifyEnabled.value = true;
  }

  void cancelNotify(BluetoothCharacteristic characteristic) {
    characteristic.setNotifyValue(false);
    isNotifyEnabled.value = false;
  }

  @override
  void onClose() {
    super.onClose();

    commandEditingController.dispose();
  }
}
