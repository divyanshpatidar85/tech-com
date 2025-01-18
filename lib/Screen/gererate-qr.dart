import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class GenerateQR extends StatefulWidget {
  final String productId;

  GenerateQR({required this.productId});

  @override
  _GenerateQRState createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  late String qrData;

  @override
  void initState() {
    super.initState();
    // Initialize qrData with the productId passed from the previous screen
    qrData = widget.productId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Product ID QR Code")),
      ),
      body: Center(
        
        child:QrImageView(data:qrData)
      ),
    );
  }
}
