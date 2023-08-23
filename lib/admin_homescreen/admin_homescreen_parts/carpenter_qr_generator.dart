import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart'; // Import the UUID package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class QrGenerator extends StatefulWidget {
  const QrGenerator({Key? key}) : super(key: key);

  @override
  _QrGeneratorState createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  List<String> _generatedQRData = [];

  //int _qrCodesPerPage = 9; // QR codes per page in the PDF
  final companyLogoPath = 'images/logo.png'; // Provide the actual path

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.brown.shade900,
        title: const Text(
          'QR CODE GENERATOR',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,

                controller: _quantityController,
                enabled: true, // You didn't specify the isLoading value here
                cursorColor: Colors.brown.shade900,
                decoration: InputDecoration(
                  counter: const Offstage(),
                  labelText: 'Enter quantity of QR codes',
                  labelStyle: TextStyle(color: Colors.brown.shade900),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(width: 3, color: Colors.brown.shade900),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Colors.brown.shade900,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,

                controller: _pointsController,
                enabled: true, // You didn't specify the isLoading value here
                cursorColor: Colors.brown.shade900,
                decoration: InputDecoration(
                  counter: const Offstage(),
                  labelText: 'Enter points for QR codes',
                  labelStyle: TextStyle(color: Colors.brown.shade900),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(width: 3, color: Colors.brown.shade900),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Colors.brown.shade900,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                maxLength: 10,
                controller: _categoryController,
                enabled: true, // You didn't specify the isLoading value here
                cursorColor: Colors.brown.shade900,
                decoration: InputDecoration(
                  counter: const Offstage(),
                  labelText: 'Enter category',
                  labelStyle: TextStyle(color: Colors.brown.shade900),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(width: 3, color: Colors.brown.shade900),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Colors.brown.shade900,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateQRCodes,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.brown.shade900,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5.0,
              ),
              child: const Text(
                'Generate QR Codes',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
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
                backgroundColor: Colors.brown.shade900,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5.0,
              ),
              child: const Text(
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
      String id = const Uuid().v4(); // Generate a unique ID using UUID
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
      log('Error uploading data to Firebase: $e');
    }
  }

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    final qrCodesPerPage = 44;
    final rows = 11;
    final columns = 4;

    for (int i = 0; i < _generatedQRData.length; i += qrCodesPerPage) {
      final endIndex = (i + qrCodesPerPage <= _generatedQRData.length)
          ? i + qrCodesPerPage
          : _generatedQRData.length;

      final pageQRData = _generatedQRData.sublist(i, endIndex);

      final qrCodeWidgets = <pw.Widget>[];
      for (int j = 0; j < pageQRData.length; j++) {
        final qrCodeData = pageQRData[j];
        final qrCodeImage = await QrPainter(
          data: qrCodeData,
          version: QrVersions.auto,
          gapless: false,
        ).toImageData(55);

        final qrCode = pw.Padding(
          padding: pw.EdgeInsets.all(4),
          child: pw.Row(
            //crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Image(pw.MemoryImage(qrCodeImage!.buffer.asUint8List())),
              pw.SizedBox(height: 4),
              pw.Padding(
                  padding: pw.EdgeInsets.all(4),
                  child: pw.Column(
                    children: [
                      pw.Image(
                        pw.MemoryImage((await rootBundle.load(companyLogoPath))
                            .buffer
                            .asUint8List()),
                        width: 55,
                        height: 55,
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        _categoryController.text,
                        style: pw.TextStyle(fontSize: 12),
                      ),
                    ],
                  ))
            ],
          ),
        );

        qrCodeWidgets.add(qrCode);
      }

      final pageRows = <pw.Widget>[];
      for (int rowIndex = 0; rowIndex < rows; rowIndex++) {
        final startIndex = rowIndex * columns;
        final endIndex = (startIndex + columns <= qrCodeWidgets.length)
            ? startIndex + columns
            : qrCodeWidgets.length;

        if (startIndex < qrCodeWidgets.length) {
          pageRows.add(pw.Row(
            children: qrCodeWidgets.sublist(startIndex, endIndex),
          ));
        }
      }

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Wrap(children: pageRows);
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
                OpenFile.open(pdfPath);
              },
              child: Text('View & Download'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _pointsController.dispose();
    _categoryController.dispose(); // Dispose the category controller
    super.dispose();
  }
}
