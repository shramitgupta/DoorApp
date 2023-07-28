import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CarpenterRegister extends StatefulWidget {
  const CarpenterRegister({super.key});

  @override
  State<CarpenterRegister> createState() => _CarpenterRegisterState();
}

class _CarpenterRegisterState extends State<CarpenterRegister> {
  TextEditingController cnameController = TextEditingController();
  TextEditingController cpnoController = TextEditingController();
  TextEditingController caddressController = TextEditingController();
  TextEditingController cageController = TextEditingController();
  TextEditingController cmaritalstatusController = TextEditingController();
  TextEditingController cdobController = TextEditingController();
  TextEditingController canniversarydateController = TextEditingController();
  File? cprofilepic;
  int points = 0;
  String? _verificationId; // Store the verification ID for OTP verification

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

  // Function to send OTP to the user's phone number
  Future<void> _sendOTP() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String cpnoString = cpnoController.text.trim();
    String countryCode = '+91'; // Replace this with your country code
    String phoneNumber = '$countryCode$cpnoString';

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieve the OTP in case of instant verification (rare case)
          await auth.signInWithCredential(credential);
          await _uploadData(); // Proceed with data upload after OTP verification
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Phone number verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          _showOTPDialg(); // Show OTP entry dialog when code is sent
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      print('Error sending OTP: $e');
    }
  }

  // Function to show OTP entry dialog
  void _showOTPDialg() {
    showDialog(
      context: context,
      builder: (context) {
        String enteredOTP = ''; // Store the OTP entered by the user

        return AlertDialog(
          title: Text('Enter OTP'),
          content: TextFormField(
            keyboardType: TextInputType.number,
            maxLength: 6,
            onChanged: (value) {
              enteredOTP = value; // Update the entered OTP as the user types
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _verifyOTP(enteredOTP); // Verify the entered OTP
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  // Function to verify the OTP entered by the user
  Future<void> _verifyOTP(String smsCode) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      // Create a PhoneAuthCredential with the entered OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      // Sign in the user with the credential
      await auth.signInWithCredential(credential);

      // OTP verification successful, proceed with data upload
      await _uploadData();
    } catch (e) {
      print('Error verifying OTP: $e');
    }
  }

  Future<void> _uploadData() async {
    String cname = cnameController.text.trim();
    String cpnoString = cpnoController.text.trim();
    String caddress = caddressController.text.trim();
    String cageString = cageController.text.trim();
    String cmaritalstatus = cmaritalstatusController.text.trim();
    String cdob = cdobController.text.trim();
    String canniversarydate = canniversarydateController.text.trim();

    int cpno = int.parse(cpnoString);
    int cage = int.parse(cageString);

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
        "points": points,
      };
      await FirebaseFirestore.instance
          .collection("carpenterData")
          .add(carpenterData);
      print('Data Uploaded');

      // Clear fields after successful data upload
      clearFields();
    } else {
      print('Fill in all data fields');
    }
  }

  void clearFields() {
    setState(() {
      cnameController.clear();
      cpnoController.clear();
      caddressController.clear();
      cageController.clear();
      cmaritalstatusController.clear();
      cdobController.clear();
      canniversarydateController.clear();
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
                          _sendOTP();
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
