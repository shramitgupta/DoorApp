import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CarpenterRegester extends StatefulWidget {
  const CarpenterRegester({super.key});

  @override
  State<CarpenterRegester> createState() => _CarpenterRegesterState();
}

class _CarpenterRegesterState extends State<CarpenterRegester> {
  TextEditingController cnameController = TextEditingController();
  TextEditingController cpnoController = TextEditingController();
  TextEditingController caddressController = TextEditingController();
  TextEditingController cageController = TextEditingController();
  TextEditingController cmaritalstatusController = TextEditingController();
  TextEditingController cdobController = TextEditingController();
  TextEditingController canniversarydateController = TextEditingController();
  File? cprofilepic;
  Future<void> _getImageFromSource(ImageSource source) async {
    XFile? selectedImage = await ImagePicker().pickImage(source: source);

    if (selectedImage != null) {
      File convertedFile = File(selectedImage.path);
      setState(() {
        cprofilepic = convertedFile;
      });
      print('Image selected!');
    } else {
      print('No image selected!');
    }
  }

  Future<void> regesterCarpenter() async {
    String cname = cnameController.text.trim();
    String cpnoString = cpnoController.text.trim();
    String caddress = caddressController.text.trim();
    String cageString = cageController.text.trim();
    String cmaritalstatus = cmaritalstatusController.text.trim();
    String cdob = cdobController.text.trim();
    String canniversarydate = canniversarydateController.text.trim();

    int cpno = int.parse(cpnoString);
    int cage = int.parse(cageString);

    cnameController.clear();
    cpnoController.clear();
    caddressController.clear();
    cageController.clear();
    cmaritalstatusController.clear();
    cdobController.clear();
    canniversarydateController.clear();
    if (cname.isNotEmpty &&
        cpnoString.isNotEmpty &&
        caddress.isNotEmpty &&
        cageString.isNotEmpty &&
        cmaritalstatus.isNotEmpty &&
        cdob.isNotEmpty &&
        canniversarydate.isNotEmpty &&
        cprofilepic != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("cprofilepic")
          .child(Uuid().v1())
          .putFile(cprofilepic!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      Map<String, dynamic> carpenterData = {
        "cname": cname,
        "cpno": cpno,
        "caddress": caddress,
        "cage": cage,
        "cmaritalstatus": cmaritalstatus,
        "cprofilepic": downloadUrl,
        "cdob": cdob,
        "canniversarydate": canniversarydate,
      };
      FirebaseFirestore.instance.collection("carpenterData").add(carpenterData);
      print('data Uploaded');
    } else {
      print('fill data');
    }

    setState(() {
      cprofilepic = null;
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
                            image: (cprofilepic != null)
                                ? DecorationImage(
                                    image: FileImage(cprofilepic!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: Colors.grey,
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: cnameController,
                      // style: const TextStyle(height: 30),
                      cursorColor: const Color.fromARGB(255, 70, 63, 60),
                      decoration: InputDecoration(
                        labelText: 'Enter Name',
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
                      maxLength: 10,
                      controller: cpnoController,
                      // style: const TextStyle(height: 30),
                      cursorColor: const Color.fromARGB(255, 70, 63, 60),
                      decoration: InputDecoration(
                        counter: const Offstage(),
                        labelText: 'Enter Contact No',
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
                      controller: caddressController,
                      // style: const TextStyle(height: 30),
                      cursorColor: const Color.fromARGB(255, 70, 63, 60),
                      decoration: InputDecoration(
                        labelText: 'Enter Address',
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
                      controller: cageController,
                      // style: const TextStyle(height: 30),
                      cursorColor: const Color.fromARGB(255, 70, 63, 60),
                      decoration: InputDecoration(
                        labelText: 'Enter Age',
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
                      controller: cmaritalstatusController,
                      // style: const TextStyle(height: 30),
                      cursorColor: const Color.fromARGB(255, 70, 63, 60),
                      decoration: InputDecoration(
                        labelText: 'Enter Marital Status ',
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
                      controller: cdobController,
                      // style: const TextStyle(height: 30),
                      cursorColor: const Color.fromARGB(255, 70, 63, 60),
                      decoration: InputDecoration(
                        labelText: 'Enter DOB ',
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
                      controller: canniversarydateController,
                      // style: const TextStyle(height: 30),
                      cursorColor: const Color.fromARGB(255, 70, 63, 60),
                      decoration: InputDecoration(
                        labelText: 'Enter Anniversary Date',
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
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          regesterCarpenter();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 7.0),
                          backgroundColor:
                              const Color.fromARGB(255, 70, 63, 60),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          "Regester",
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
