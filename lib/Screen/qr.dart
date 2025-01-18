import 'dart:async';
import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:simpleapp/backend/add-product.dart';

class ScannerWidget extends StatefulWidget {
  ScannerWidget({super.key});

  @override
  State<ScannerWidget> createState() => _ScannerState();
}

class _ScannerState extends State<ScannerWidget> with WidgetsBindingObserver {
  MobileScannerController? controller;
  StreamSubscription<Object?>? _subscription;

  String scannedValue = "";
  bool isScanning = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _initializeScanner();
 
  }



  void _initializeScanner() {
    controller = MobileScannerController(
      autoStart: false,
      torchEnabled: false,
      useNewCameraSelector: true,
      facing: CameraFacing.back,
    );
    _subscription = controller?.barcodes.listen(_handleBarcode);
    _startScanner();
  }

  Future<void> _startScanner() async {
    try {
      await controller?.start();
    } catch (e) {
      _disposeCurrentController();
      _initializeScanner();
    }
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (mounted) {
      final String? value = barcodes.barcodes.firstOrNull?.displayValue?.trim();
      if (value != null && isScanning) {
        setState(() {
          scannedValue = value;
          isScanning = false;
        });

       String res=await AddProduct().addProductToCart(id:value);
        // String message = "res";
        Color snackBarColor = Colors.green;

      
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res),
            backgroundColor: snackBarColor,
            duration: Duration(seconds: 3),
          ),
        );

        
        await Future.delayed(Duration(seconds: 3));
        setState(() {
          isScanning = true; 
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.resumed:
        _startScanner();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _stopScanner();
        break;
      default:
        break;
    }
  }

  Future<void> _stopScanner() async {
    await _subscription?.cancel();
    _subscription = null;
    await controller?.stop();
  }

  void _disposeCurrentController() {
    _stopScanner();
    controller?.dispose();
    controller = null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[900],
        appBar: AppBar(
          title: const Text(
            "Scan QR",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.black.withOpacity(0.01),
          elevation: 0,
          leading: InkWell(
            child: const Icon(Icons.arrow_back),
            onTap: () async {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: MobileScanner(
                  controller: controller!,
                  errorBuilder: (context, error, child) {
                    return Center(child: Text(error.toString()));
                  },
                  placeholderBuilder: (context, val) {
                    return Center(child: Text(val.toString()));
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                color: Colors.black.withOpacity(0.6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ToggleFlashlightButton(controller: controller!),
                    IconButton(
                      icon: const Icon(Icons.switch_camera, color: Colors.white, size: 32),
                      onPressed: () async {
                        await _stopScanner();
                        await controller?.switchCamera();
                        await _startScanner();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    _disposeCurrentController();
    super.dispose();
  }
}

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        Icon icon;
        switch (state.torchState) {
          case TorchState.auto:
            icon = const Icon(Icons.flash_auto, color: Colors.white, size: 32);
            break;
          case TorchState.off:
            icon = const Icon(Icons.flash_off, color: Colors.white, size: 32);
            break;
          case TorchState.on:
            icon = const Icon(Icons.flash_on, color: Colors.white, size: 32);
            break;
          case TorchState.unavailable:
            return const Icon(Icons.no_flash, color: Colors.grey);
        }

        return IconButton(
          icon: icon,
          onPressed: () async {
            await controller.toggleTorch();
          },
        );
      },
    );
  }
}
