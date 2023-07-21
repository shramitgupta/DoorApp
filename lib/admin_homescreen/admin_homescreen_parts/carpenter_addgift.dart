import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CarpenterAddGifts extends StatefulWidget {
  const CarpenterAddGifts({super.key});

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
      print('Image selected!');
    } else {
      print('No image selected!');
    }
  }

  Future<void> saveGift() async {
    String pointString = pointController.text.trim();
    String giftname = giftController.text.trim();
    String cashString = cashController.text.trim();

    int point = int.parse(pointString);
    int cash = int.parse(cashString);

    pointController.clear();
    giftController.clear();
    cashController.clear();
    if (pointString.isNotEmpty &&
        cashString.isNotEmpty &&
        giftname.isNotEmpty &&
        giftpic != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("giftpictures")
          .child(Uuid().v1())
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
      print('data Uploaded');
    } else {
      print('fill data');
    }

    setState(() {
      giftpic = null;
    });
  }

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
          'CARPENTER REGESTER',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 195, 162, 132),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 70, 63, 60),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: const Color.fromARGB(255, 195, 162, 132),
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
                                  leading: Icon(Icons.photo_library),
                                  title: Text("Choose from Gallery"),
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    _getImageFromSource(ImageSource.camera);
                                  },
                                  leading: Icon(Icons.camera_alt),
                                  title: Text("Take a Photo"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: (giftpic != null)
                              ? DecorationImage(
                                  image: FileImage(giftpic!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: pointController,
                      // style: const TextStyle(height: 30),
                      cursorColor: const Color.fromARGB(255, 70, 63, 60),
                      decoration: InputDecoration(
                        labelText: 'Enter Points as Prize',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 70, 63, 60)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Color.fromARGB(255, 70, 63, 60),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLength: 10,
                      controller: giftController,
                      // style: const TextStyle(height: 30),
                      cursorColor: const Color.fromARGB(255, 70, 63, 60),
                      decoration: InputDecoration(
                        counter: const Offstage(),
                        labelText: 'Enter Gift Name',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 70, 63, 60)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Color.fromARGB(255, 70, 63, 60),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: cashController,
                      // style: const TextStyle(height: 30),
                      cursorColor: const Color.fromARGB(255, 70, 63, 60),
                      decoration: InputDecoration(
                        labelText: 'Enter Cash Prize',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 70, 63, 60)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Color.fromARGB(255, 70, 63, 60),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
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
                              horizontal: 20.0, vertical: 7.0),
                          backgroundColor:
                              const Color.fromARGB(255, 70, 63, 60),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          "Upload",
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
      ),
    );
  }
}
