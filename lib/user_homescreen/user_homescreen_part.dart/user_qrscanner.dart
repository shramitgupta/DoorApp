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
  String _qrId = '';

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
                'Scanned Points: $_scannedPoints\nQR ID: $_qrId',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
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
          String qrData = scanData.code.toString();
          _scannedPoints = _parseScannedData(qrData);
          debugPrint("Scanned Points: $_scannedPoints");

          _qrId = _parseQrCodeDocumentId(qrData);
          if (_qrId.isNotEmpty) {
            // Update points in Firestore and delete the QR data
            _updatePointsInFirestore(_scannedPoints, qrData);
          } else {
            print("QR document ID not found.");
          }
        });
        code = scanData.code.toString();
      }

      setState(() {
        log(scanData.code.toString());
        _scannedPoints = _parseScannedData(scanData.code.toString());
        debugPrint("Scanned Points: $_scannedPoints");
      });
    });
  }

  int _parseScannedData(String data) {
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
  void _updatePointsInFirestore(int points, String qrCodeData) {
    String? userId = _currentUserId; // Replace with the user's ID
    // Assuming you have 'carpenterdata' collection in Firestore
    FirebaseFirestore.instance.collection('carpenterData').doc(userId).update({
      'points': FieldValue.increment(points), // Increment points in Firestore
    }).then((value) {
      print('Points updated in Firestore: $points');
      _deleteQrDataFromFirestore(
          qrCodeData); // Delete the particular QR data from Firestore after updating points
    }).catchError((error) {
      print('Failed to update points in Firestore: $error');
    });
  }

  // Function to delete the particular QR data from Firestore
  void _deleteQrDataFromFirestore(String qrCodeData) {
    String docIdValue = _parseQrCodeDocumentId(qrCodeData);

    if (docIdValue.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('qr')
          .doc(docIdValue)
          .delete()
          .then((value) {
        print('QR data deleted from Firestore.');
      }).catchError((error) {
        print('Failed to delete QR data from Firestore: $error');
      });
    }
  }

  String _parseQrCodeDocumentId(String data) {
    int idIndex = data.indexOf("ID:");
    if (idIndex != -1 && idIndex + 3 < data.length) {
      // Extract the document ID value after "ID:"
      String docIdValue = data.substring(idIndex + 3).trim();

      // Find the index of the comma after removing "ID:"
      int commaIndex = docIdValue.indexOf(",");
      if (commaIndex != -1) {
        // Extract the data before the comma
        docIdValue = docIdValue.substring(0, commaIndex).trim();
        return docIdValue;
      }
    }

    return ""; // Return an empty string if document ID data cannot be extracted
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
