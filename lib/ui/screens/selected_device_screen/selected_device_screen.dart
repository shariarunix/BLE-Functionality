import 'package:ble_gtx/controllers/selected_device_controller.dart';
import 'package:ble_gtx/ui/components/ble_button.dart';
import 'package:ble_gtx/ui/screens/selected_device_screen/components/command_dialog.dart';
import 'package:ble_gtx/ui/screens/selected_device_screen/components/connection_status_tile.dart';
import 'package:ble_gtx/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class SelectedDeviceScreen extends StatefulWidget {
  const SelectedDeviceScreen({super.key, required this.device});

  final BluetoothDevice device;

  @override
  State<SelectedDeviceScreen> createState() => _SelectedDeviceScreenState();
}

class _SelectedDeviceScreenState extends State<SelectedDeviceScreen> {

  final _controller = Get.find<SelectedDeviceController>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar Section
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          widget.device.advName.isNotEmpty
              ? widget.device.advName
              : AppString.UNNAMED_DEVICE,
        ),
      ),

      // Body Section
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Connection Status Tile
            ConnectionStatusTile(
              device: widget.device,
              onConnectDisconnect: (device) {
                // Connect Disconnect
                _controller.connectOrDisconnectDevice(device);
              },
            ),

            Obx(() {
              if (_controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return Column(
                children: [
                  for (var service in _controller.services.value)
                    if (service.uuid == Guid('1800') ||
                        service.uuid == Guid('1801')) ...[
                      ListTile(
                        title: Text('Service UUID : ${service.uuid}'),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(),
                      )
                    ] else ...[
                      ListTile(
                        title: Text('Service UUID : ${service.uuid}'),
                      ),

                      // Read Data State Section
                      Obx((){
                        if(_controller.isReading.value) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text('Reading State : ${_controller.readData.value}', style: Theme.of(context).textTheme.titleLarge, ),
                          );
                        }

                        return const SizedBox(height: 1);
                      }),

                      // Notify Data State Section
                      Obx(() {
                        if(_controller.isNotifyEnabled.value){
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text('Notification State : ${_controller.notifyData.value}', style: Theme.of(context).textTheme.titleLarge, ),
                          );
                        }
                        return const SizedBox(height: 1);
                      }),

                      // Read Write Notify Button section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (service.characteristics[0].properties.read)
                            BleButton(
                              text: 'Read',
                              onPressed: () {
                                _controller.toggleReadMode(service);
                              },
                            ),
                          if (service.characteristics[0].properties.write)
                            BleButton(
                              text: 'Write',
                              onPressed: () {
                                commandDialog(
                                    textEditingController: _controller.commandEditingController,
                                    onPressed: (){
                                      _controller.writeCommand(service.characteristics[0]);
                                    }
                                );
                              },
                            ),
                          if (service.characteristics[0].properties.notify)
                            BleButton(
                              text: 'Notify',
                              onPressed: () {
                                _controller.toggleNotifyMode(service);
                              },
                            ),
                        ],
                      )
                    ]
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
