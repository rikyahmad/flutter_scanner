import 'package:flutter/material.dart';
import 'package:flutter_scanner/destination.dart';
import 'package:flutter_scanner/scanner.dart';
import 'package:flutter_scanner/scanner_v2.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() => runApp(const MaterialApp(
    title: "QR Scanner", debugShowCheckedModeBanner: false, home: MyHome()));

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  Barcode? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner')),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (result != null) Text("Result : ${result?.code}"),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Scanner(
                      onResult: (Barcode value) {
                        setState(() {
                          result = value;
                        });
                      },
                    ),
                  ));
                },
                child: const Text('Open Scanner'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: () {
                  openScannerV2();
                },
                child: const Text('Open Scanner v2'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openScannerV2() async {
    final resultV2 = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          const ScannerV2(title: "Scan QR Code", subTitle: "Material Receive"),
    ));

    if (resultV2 is Barcode) {
      openDestination(resultV2);
    }
  }

  void openDestination(Barcode resultV2) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Destination(
        result: resultV2,
      ),
    ));
  }
}
