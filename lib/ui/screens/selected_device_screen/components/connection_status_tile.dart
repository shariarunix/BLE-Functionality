import 'package:ble_gtx/ui/components/ble_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectionStatusTile extends StatelessWidget {
  const ConnectionStatusTile({
    super.key,
    required this.device,
    required this.onConnectDisconnect,
  });

  final BluetoothDevice device;
  final void Function(BluetoothDevice) onConnectDisconnect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Connection Status : ',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            StreamBuilder(
              stream: device.connectionState,
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return Text(
                    'Try Again',
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                }

                var state = snapshots.data!;

                if (state == BluetoothConnectionState.disconnected) {
                  return BleButton(
                    text: 'Disconnected',
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                    onPressed: () {
                      onConnectDisconnect(device);
                    },
                  );
                }

                if (state == BluetoothConnectionState.connected) {
                  return BleButton(
                    text: 'Connected',
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                    onPressed: () {
                      onConnectDisconnect(device);
                    },
                  );
                }

                return const Text('Connecting..');
              },
            )
          ],
        ),
      ),
    );
  }
}
