import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AuthenticatorPopup extends StatefulWidget {
  final String secret;
  final String qrCodeUrl;

  const AuthenticatorPopup({
    Key? key,
    required this.secret,
    required this.qrCodeUrl,
  }) : super(key: key);

  @override
  State<AuthenticatorPopup> createState() => _AuthenticatorPopupState();
}

class _AuthenticatorPopupState extends State<AuthenticatorPopup> {
  bool _showSecret = false;

  void _toggleSecret() {
    setState(() {
      _showSecret = true;
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.secret));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Secret code copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        'Add to Authenticator App',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      content: SingleChildScrollView(
        // ✅ Permite scroll si el contenido crece y evita intrinsics
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Scan this QR code using Google/Microsoft Authenticator '
              'to enable two-factor authentication.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // ✅ Tamaño fijo para el QR
            SizedBox(
              width: 200,
              height: 200,
              child: QrImageView(
                data: widget.qrCodeUrl,
                version: QrVersions.auto,
              ),
            ),

            const SizedBox(height: 20),

            // Manual code reveal
            GestureDetector(
              onTap: _toggleSecret,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      _showSecret ? widget.secret : 'Tap to show secret code',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        decoration: _showSecret
                            ? TextDecoration.none
                            : TextDecoration.underline,
                      ),
                    ),
                  ),
                  if (_showSecret)
                    IconButton(
                      icon:
                          const Icon(Icons.copy, size: 18, color: Colors.blue),
                      onPressed: _copyToClipboard,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
