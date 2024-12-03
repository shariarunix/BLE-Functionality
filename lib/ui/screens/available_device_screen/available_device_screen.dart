import 'package:ble_gtx/controllers/available_device_controller.dart';
import 'package:ble_gtx/ui/screens/available_device_screen/components/device_list_tile.dart';
import 'package:ble_gtx/ui/screens/selected_device_screen/selected_device_screen.dart';
import 'package:ble_gtx/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvailableDeviceScreen extends StatefulWidget {
  const AvailableDeviceScreen({super.key});

  @override
  State<AvailableDeviceScreen> createState() => _AvailableDeviceScreenState();
}

class _AvailableDeviceScreenState extends State<AvailableDeviceScreen> {
  final _controller = Get.find<AvailableDeviceController>();

  @override
  void initState() {
    super.initState();

    _controller.checkLocationPermission();
    _controller.checkBluetoothPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // App Bar Section
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: true,
        title: const Text(AppString.AVAILABLE_DEVICE_SCREEN_TITLE),
      ),

      // Scan Button Section
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.startOrStopScan();
        },
        child: Obx(() {
          // If scanning then show a progressbar else show the scan icon
          if (_controller.isScanning.value) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                strokeCap: StrokeCap.round,
              ),
            );
          }
          return const Icon(Icons.restart_alt_rounded);
        }),
      ),

      // Body Section
      body: Obx((){
        if(_controller.isScanning.value){
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (_controller.scanData.value.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No Device Found'),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 88),
          physics: const BouncingScrollPhysics(),
          itemCount: _controller.scanData.value.length,
          itemBuilder: (context, index) {
            return DeviceListTile(
              device: _controller.scanData.value[index],
              onPressed: (device) {
                Get.to(SelectedDeviceScreen(device: device.device));
              },
            );
          },
        );
      }),
    );
  }
}
