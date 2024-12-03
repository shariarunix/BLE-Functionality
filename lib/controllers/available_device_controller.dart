import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../ui/components/get_x_snackbar.dart';

class AvailableDeviceController extends GetxController {
  // Private Variables
  StreamSubscription<BluetoothAdapterState>? _bluetoothState;
  StreamSubscription<bool>? _scanningState;

  // Reactive Variables
  RxBool isScanReady = RxBool(false);
  RxBool isScanning = RxBool(false);

  Rx<List<ScanResult>> scanData = Rx([]);

  // Method for start an stop FlutterBluePlus scanning
  void startOrStopScan() {
    if (!isScanning.value) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
      fetchScanData();
    } else {
      FlutterBluePlus.stopScan();
    }
  }

  void fetchScanData() {
    FlutterBluePlus.scanResults.listen((data){
      scanData.value = data;
    });
  }

  // Method for Checking is Device support Bluetooth or not;
  Future<void> checkIsSupported() async {
    try {
      if (await FlutterBluePlus.isSupported == false) {
        getXSnackbar(message: 'Bluetooth is not supported.');
        return;
      }

      // If device supported bluetooth then check is it on or of.
      _checkIsBluetoothOnOrOff();
    } catch (e) {
      getXSnackbar(message: 'Something went wrong. Try again.');
    }
  }

  // Method for checking is Device bluetooth on or off
  void _checkIsBluetoothOnOrOff() {
    _bluetoothState ??= FlutterBluePlus.adapterState.listen(
      (state) {
        if (state == BluetoothAdapterState.off) {
          getXSnackbar(message: 'Please turn on the Bluetooth.');
          isScanReady = RxBool(false);
        }

        isScanReady = RxBool(true);
      },
    );
  }

  // Method for checking location permission
  void checkLocationPermission() async {
    try {
      LocationPermission locationPermission;

      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

      if (!isLocationEnabled) {
        getXSnackbar(
          message: 'Location is off. Please turn it on.',
        );
        return;
      }

      locationPermission = await Geolocator.checkPermission();

      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.denied) return;
      }

      if (locationPermission == LocationPermission.deniedForever) {
        getXSnackbar(
          message: 'Location permission is denied. Please grant permission.',
        );
        return;
      }
    } catch (e) {
      getXSnackbar(
        message: 'Something went wrong, Try again.',
      );
      return;
    }
  }

  // Method for checking bluetooth permission
  void checkBluetoothPermission() async {
    try {
      var bluetoothPermission = await Permission.bluetooth.request();

      if (bluetoothPermission == PermissionStatus.denied) {
        bluetoothPermission = await Permission.bluetooth.request();
        return;
      }

      if (bluetoothPermission == PermissionStatus.permanentlyDenied) {
        getXSnackbar(
          message: 'Bluetooth permission is denied. Please grant permission.',
        );
        return;
      }
    } catch (e) {
      getXSnackbar(
        message: 'Something went wrong, Try again',
      );
      return;
    }
  }

  @override
  void onInit() {
    super.onInit();

    // Check is FlutterBluePlus scanning or not
    _scanningState = FlutterBluePlus.isScanning.listen((state) {
      isScanning.value = state;
    });
  }

  @override
  void onClose() {
    // Cancelling all subscriptions
    _bluetoothState?.cancel();
    _scanningState?.cancel();

    super.onClose();

    // Cancel Subscription
    FlutterBluePlus.scanResults.listen((data){}).cancel();
  }
}
