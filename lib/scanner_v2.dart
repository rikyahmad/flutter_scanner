import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerV2 extends StatefulWidget {
  const ScannerV2({Key? key, required this.title, required this.subTitle})
      : super(key: key);

  final String title;
  final String subTitle;

  @override
  State<ScannerV2> createState() => _ScannerV2State();
}

class _ScannerV2State extends State<ScannerV2> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildQrView(context)),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    double cornerRadius = 20;
    var size = MediaQuery.of(context).size;
    var margin = 40;
    var marginInner = 25;
    var scanArea = (size.width > size.height)
        ? size.height - (margin * 2)
        : size.width - (margin * 2);
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(widget.title,
              style: const TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600)),
          const SizedBox(
            height: 10,
          ),
          Text(widget.subTitle,
              style:
                  const TextStyle(fontSize: 16, fontStyle: FontStyle.normal)),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: scanArea,
            height: scanArea,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(cornerRadius),
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderRadius: cornerRadius,
                    borderLength: 30,
                    borderWidth: 0,
                    overlayColor: const Color(0xffc7c7e7),
                    cutOutSize: scanArea - (marginInner * 2)),
                onPermissionSet: (ctrl, p) =>
                    _onPermissionSet(context, ctrl, p),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 20),
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: const Color(0xffc7c7e7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {});
                  },
                  splashColor: Colors.blue,
                  icon: FutureBuilder<bool?>(
                    future: controller?.getFlashStatus(),
                    builder: (context, snapshot) {
                      return Icon(
                        snapshot.data == true
                            ? Icons.flash_off
                            : Icons.flash_on,
                        size: 26,
                        color: const Color(0xffc7c7e7),
                      );
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      startCamera();
    });
    controller.scannedDataStream.listen((scanData) async {
      debugPrint("Result Code : ${scanData.code}");
      Navigator.of(context).pop(scanData);
      await controller.stopCamera();
      controller.dispose();
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void startCamera() async {
    try {
      await controller?.resumeCamera();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
