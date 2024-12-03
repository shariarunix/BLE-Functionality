import 'package:flutter/material.dart';
import 'package:get/get.dart';

void getXSnackbar({
  required String message,
}) {
  Get.showSnackbar(GetSnackBar(
    message: message,
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.all(16),
    borderRadius: 8,
    isDismissible: false,
  ));
}
