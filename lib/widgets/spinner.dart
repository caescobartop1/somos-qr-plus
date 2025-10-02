import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  final String message;

  const LoadingSpinner({super.key, this.message = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
            ),
            const SizedBox(height: 16),
            // Text(
            //   message,
            //   style: const TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w500,
            //     color: Colors.black87,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
