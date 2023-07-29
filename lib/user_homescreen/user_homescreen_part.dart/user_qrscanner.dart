// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class UserQrScanner extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _UserQrScannerState();
// }

// class _UserQrScannerState extends State<UserQrScanner> {
//   QRViewController? _controller;
//   final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
//   int _scannedPoints = 0;

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
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 80.0),
//               child: Text(
//                 'Scanned Points: $_scannedPoints',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
//     String code = "";
//     _controller!.scannedDataStream.listen((scanData) {
//       // Handle the scanned QR code data here
//       log(scanData.code.toString());
//       if (code != scanData.code.toString()) {
//         log("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");

//         setState(() {
//           _scannedPoints = _parseScannedData(scanData.code.toString());
//         });
//         code = scanData.code.toString();
//       }
//       setState(() {
//         log(scanData.code.toString());
//         _scannedPoints = _parseScannedData(scanData.code.toString());
//       });
//     });
//   }

//   int _parseScannedData(String data) {
//     // You'll need to implement your own logic to parse the scanned data and extract points.
//     // For demonstration purposes, let's assume the scanned data format is "ID:XXXX, Points:XX",
//     // and we'll extract the points from it.

//     // Find the index of the "Points:" substring
//     int pointsIndex = data.indexOf("Points:");

//     if (pointsIndex != -1 && pointsIndex + 7 < data.length) {
//       // Extract the points value after "Points:"
//       String pointsValue = data.substring(pointsIndex + 7).trim();

//       // Convert the points value to an integer and return it
//       return int.tryParse(pointsValue) ?? 0;
//     }

//     return 0; // Return 0 if points data cannot be extracted
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
// }

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserQrScanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserQrScannerState();
}

class _UserQrScannerState extends State<UserQrScanner> {
  QRViewController? _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  int _scannedPoints = 0;

  @override
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserId = user.uid;
      });
    } else {
      // User is not signed in. Handle this case as needed.
      print('User is not signed in.');
    }
  }

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
    String code = "";
    _controller!.scannedDataStream.listen((scanData) {
      // Handle the scanned QR code data here
      log(scanData.code.toString());
      if (code != scanData.code.toString()) {
        log("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");

        setState(() {
          _scannedPoints = _parseScannedData(scanData.code.toString());
          // Update points in Firestore
          _updatePointsInFirestore(_scannedPoints);
        });
        code = scanData.code.toString();
      }
      setState(() {
        log(scanData.code.toString());
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

  // Function to update points in Firestore
  void _updatePointsInFirestore(int points) {
    String? userId = _currentUserId; // Replace with the user's ID
    // Assuming you have 'carpenterdata' collection in Firestore
    FirebaseFirestore.instance.collection('carpenterData').doc(userId).update({
      'points': FieldValue.increment(points), // Increment points in Firestore
    }).then((value) {
      print('Points updated in Firestore: $points');
    }).catchError((error) {
      print('Failed to update points in Firestore: $error');
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
