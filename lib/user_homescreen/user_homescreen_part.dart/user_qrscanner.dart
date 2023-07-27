// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class UserQrScanner extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _UserQrScannerState();
// }

// class _UserQrScannerState extends State<UserQrScanner> {
//   QRViewController? _controller;
//   final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR Scanner'),
//       ),
//       body: Stack(
//         children: [
//           buildQrView(context),
//           Positioned.fill(
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // You can handle button tap here
//                   },
//                   child: Text('Scan QR Code'),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildQrView(BuildContext context) {
//     return QRView(
//       key: _qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//         borderColor: Theme.of(context).primaryColor,
//         borderRadius: 10,
//         borderLength: 30,
//         borderWidth: 10,
//         cutOutSize: MediaQuery.of(context).size.width * 0.8,
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       _controller = controller;
//     });
//     _controller!.scannedDataStream.listen((scanData) {
//       // Handle the scanned QR code data here
//       print('Scanned data: ${scanData.code}');
//     });
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class UserQrScanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserQrScannerState();
}

class _UserQrScannerState extends State<UserQrScanner> {
  QRViewController? _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  int _scannedPoints = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Stack(
        children: [
          buildQrView(context),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // You can handle button tap here
                  },
                  child: Text('Scan QR Code'),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: Text(
                'Scanned Points: $_scannedPoints',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) {
    return QRView(
      key: _qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).primaryColor,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    _controller!.scannedDataStream.listen((scanData) {
      // Handle the scanned QR code data here
      setState(() {
        _scannedPoints = _parseScannedData(scanData.code.toString());
      });
    });
  }

  int _parseScannedData(String data) {
    // You'll need to implement your own logic to parse the scanned data and extract points.
    // For demonstration purposes, let's assume the scanned data format is "ID:XXXX, Points:XX",
    // and we'll extract the points from it.

    // Find the index of the "Points:" substring
    int pointsIndex = data.indexOf("Points:");

    if (pointsIndex != -1 && pointsIndex + 7 < data.length) {
      // Extract the points value after "Points:"
      String pointsValue = data.substring(pointsIndex + 7).trim();

      // Convert the points value to an integer and return it
      return int.tryParse(pointsValue) ?? 0;
    }

    return 0; // Return 0 if points data cannot be extracted
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
