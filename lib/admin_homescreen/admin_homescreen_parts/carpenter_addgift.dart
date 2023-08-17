import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorapp/admin_homescreen/admin_homescreen_parts/carpenter_editgift.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CarpenterAddGifts extends StatefulWidget {
  const CarpenterAddGifts({Key? key}) : super(key: key);

  @override
  State<CarpenterAddGifts> createState() => _CarpenterAddGiftsState();
}

class _CarpenterAddGiftsState extends State<CarpenterAddGifts> {
  TextEditingController pointController = TextEditingController();
  TextEditingController giftController = TextEditingController();
  TextEditingController cashController = TextEditingController();

  File? giftpic;
  Future<void> _getImageFromSource(ImageSource source) async {
    XFile? selectedImage = await ImagePicker().pickImage(source: source);

    if (selectedImage != null) {
      File convertedFile = File(selectedImage.path);
      setState(() {
        giftpic = convertedFile;
      });
      log('Image selected!');
    } else {
      log('No image selected!');
    }
  }

  bool isUploading = false;

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Gift added successfully!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uploading'),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Please wait...'),
            ],
          ),
        );
      },
    );
  }

  Future<void> saveGift() async {
    setState(() {
      isUploading = true;
    });

    String pointString = pointController.text.trim();
    String giftname = giftController.text.trim();
    String cashString = cashController.text.trim();

    if (pointString.isEmpty ||
        giftname.isEmpty ||
        cashString.isEmpty ||
        giftpic == null) {
      showErrorSnackbar('Please fill all fields.');
      setState(() {
        isUploading = false;
      });
      return;
    }

    int point = int.parse(pointString);
    int cash = int.parse(cashString);

    pointController.clear();
    giftController.clear();
    cashController.clear();
    if (pointString.isNotEmpty &&
        cashString.isNotEmpty &&
        giftname.isNotEmpty &&
        giftpic != null) {
      showLoadingDialog(); // Show the loading dialog

      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("giftpictures")
          .child(const Uuid().v1())
          .putFile(giftpic!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      Map<String, dynamic> giftData = {
        "point": point,
        "giftname": giftname,
        "cash": cash,
        "giftpic": downloadUrl,
      };
      FirebaseFirestore.instance.collection("Gifts").add(giftData);

      setState(() {
        isUploading = false;
        giftpic = null;
      });

      Navigator.pop(context); // Hide the loading dialog
      showSuccessDialog(); // Show the success dialog
    } else {
      log('fill data');
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
          'ADD GIFTS AND PRIZE ',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  _getImageFromSource(ImageSource.gallery);
                                },
                                leading: const Icon(Icons.photo_library),
                                title: const Text("Choose from Gallery"),
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  _getImageFromSource(ImageSource.camera);
                                },
                                leading: const Icon(Icons.camera_alt),
                                title: const Text("Take a Photo"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      //width: 100,
                      width: screenWidth * 0.3,
                      //height: 100,
                      height: screenHeight * 0.15,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: (giftpic != null)
                            ? DecorationImage(
                                image: FileImage(giftpic!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Colors.brown.shade200,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: pointController,
                    // style: const TextStyle(height: 30),
                    cursorColor: Colors.brown.shade900,
                    decoration: InputDecoration(
                      labelText: 'Enter Points as Prize',
                      labelStyle: TextStyle(
                        color: Colors.brown.shade900,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.brown.shade900,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.brown.shade900,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: !isUploading,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLength: 10,
                    controller: giftController,
                    // style: const TextStyle(height: 30),
                    cursorColor: Colors.brown.shade900,
                    decoration: InputDecoration(
                      counter: const Offstage(),
                      labelText: 'Enter Gift Name',
                      labelStyle: TextStyle(
                        color: Colors.brown.shade900,
                      ),
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
                    enabled: !isUploading,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: cashController,
                    // style: const TextStyle(height: 30),
                    cursorColor: Colors.brown.shade900,
                    decoration: InputDecoration(
                      labelText: 'Enter Cash Prize',
                      labelStyle: TextStyle(
                        color: Colors.brown.shade900,
                      ),
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
                    keyboardType: TextInputType.number,
                    enabled: !isUploading,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        saveGift();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 7.0,
                        ),
                        backgroundColor: Colors.brown.shade900,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        "Upload",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CarpenterEditGifts(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 7.0,
                        ),
                        backgroundColor: Colors.brown.shade900,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        "Delete Upload",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
