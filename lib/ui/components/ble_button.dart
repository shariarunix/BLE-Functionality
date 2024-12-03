import 'package:flutter/material.dart';

class BleButton extends StatelessWidget {
  const BleButton({
    super.key,
    required this.text,
    this.backgroundColor,
    required this.onPressed,
  });

  final String text;
  final Color? backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
            backgroundColor ?? Theme.of(context).colorScheme.inversePrimary,
        ),
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
