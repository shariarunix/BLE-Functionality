import 'package:ble_gtx/ui/components/ble_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceListTile extends StatelessWidget {
  const DeviceListTile({
    super.key,
    required this.device,
    required this.onPressed,
  });

  final ScanResult device;
  final void Function(ScanResult) onPressed;

  @override
  Widget build(BuildContext context) {
    var isConnectAble = device.advertisementData.connectable;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        title: Text(
          device.advertisementData.advName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(device.device.remoteId.str),
        trailing: isConnectAble
            ? BleButton(
                text: 'Connect',
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                onPressed: () {
                  onPressed(device);
                },
              )
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
