import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart'; // Import the UUID package
import 'package:cloud_firestore/cloud_firestore.dart';

class QrGenerator extends StatefulWidget {
  @override
  _QrGeneratorState createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  List<String> _generatedQRData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 195, 162, 132),
            size: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 70, 63, 60),
        title: const Text(
          'QR CODE GENERATER',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 195, 162, 132),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter quantity of QR codes',
              ),
            ),
            TextField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter points for QR codes',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateQRCodes,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.brown,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5.0,
              ),
              child: Text(
                'Generate QR Codes',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _generatedQRData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_generatedQRData[index]),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _generatePDF,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.brown,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5.0,
              ),
              child: Text(
                'Generate PDF & Download',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateQRCodes() {
    final int quantity = int.tryParse(_quantityController.text) ?? 0;
    final int points = int.tryParse(_pointsController.text) ?? 0;
    List<String> newQRData = [];

    for (int i = 1; i <= quantity; i++) {
      String id = Uuid().v4(); // Generate a unique ID using UUID
      String data = 'ID: $id, Points: $points';
      newQRData.add(data);

      // Upload the data to Firebase
      _uploadQRDataToFirebase(id, points);
    }

    setState(() {
      _generatedQRData = newQRData;
    });
  }

  Future<void> _uploadQRDataToFirebase(String id, int points) async {
    try {
      // Replace 'your_collection_name' with the actual name of your Firebase collection
      final collectionReference = FirebaseFirestore.instance.collection('qr');

      await collectionReference.doc(id).set({
        'id': id,
        'points': points,
      });
    } catch (e) {
      print('Error uploading data to Firebase: $e');
    }
  }

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    for (int i = 0; i < _generatedQRData.length; i++) {
      final qrCodeData = _generatedQRData[i];
      final qrCodeImage = await QrPainter(
        data: qrCodeData,
        version: QrVersions.auto,
        gapless: false,
      ).toImageData(200);

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Center(
              child:
                  pw.Image(pw.MemoryImage(qrCodeImage!.buffer.asUint8List())),
            );
          },
        ),
      );
    }

    final output = await getTemporaryDirectory();
    final pdfPath = '${output.path}/QR_Codes.pdf';
    final pdfFile = File(pdfPath);

    await pdfFile.writeAsBytes(await pdf.save());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('PDF Generated'),
          content: Text('PDF file saved at: $pdfPath'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                // Open the PDF file to view and download it
                OpenFile.open(pdfPath);
              },
              child: Text('View & Download'),
            ),
          ],
        );
      },
    );
  }
}
