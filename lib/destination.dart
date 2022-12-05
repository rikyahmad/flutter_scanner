import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Destination extends StatelessWidget {
  const Destination({Key? key, this.result}) : super(key: key);

  final Barcode? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Text("Result : ${result?.code}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
