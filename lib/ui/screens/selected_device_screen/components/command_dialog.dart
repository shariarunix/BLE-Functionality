import 'package:flutter/material.dart';
import 'package:get/get.dart';

void commandDialog({
  required TextEditingController textEditingController,
  required VoidCallback onPressed,
}) {
  Get.dialog(
    Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TextField to take input from the user
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                labelText: 'Enter Command',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 48), // Space between TextField and button
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Theme.of(Get.context!).colorScheme.inversePrimary),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 56)),
              ),
              onPressed: onPressed,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    ),
  );
}
