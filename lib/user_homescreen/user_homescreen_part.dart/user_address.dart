import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorapp/user_homescreen/user_homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAddress extends StatefulWidget {
  UserAddress({
    required this.giftna,
    required this.cashamt,
    required this.points,
    required this.yourpoints,
    required this.giftpic,
  });

  var points;
  String giftna;
  var cashamt;
  var yourpoints;
  String giftpic;

  @override
  State<UserAddress> createState() => _UserAddressState();
}

class _UserAddressState extends State<UserAddress> {
  String? choice;
  String status = "pending";
  TextEditingController nameController = TextEditingController();
  TextEditingController pnoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dnameController = TextEditingController();
  TextEditingController dpnoController = TextEditingController();
  TextEditingController daddressController = TextEditingController();

  String? userId;

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  void getUserID() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  void onChoiceSelected(String selectedChoice) {
    setState(() {
      choice = selectedChoice;
    });
  }

  bool hasEnoughPoints() {
    int userPoints = widget.yourpoints;
    log(userPoints.toString());
    int requiredPoints = widget.points;
    log(requiredPoints.toString());
    return userPoints >= requiredPoints;
  }

  void deductPoints() {
    int userPoints = widget.yourpoints;
    int requiredPoints = widget.points;
    int updatedPoints = userPoints - requiredPoints;
    if (userId != null) {
      FirebaseFirestore.instance
          .collection("carpenterData")
          .doc(userId!) // Use the user ID as the document ID
          .update({"points": updatedPoints});
    }
  }

  Future<void> saveaddress() async {
    String name = nameController.text.trim();
    String pnoString = pnoController.text.trim();
    String address = addressController.text.trim();
    String dname = dnameController.text.trim();
    String dpnoString = dpnoController.text.trim();
    String daddress = daddressController.text.trim();

    int pno = int.parse(pnoString);
    int dpno = int.parse(dpnoString);

    nameController.clear();
    pnoController.clear();
    addressController.clear();
    dnameController.clear();
    dpnoController.clear();
    daddressController.clear();

    if (name.isNotEmpty &&
        pnoString.isNotEmpty &&
        address.isNotEmpty &&
        dname.isNotEmpty &&
        dpnoString.isNotEmpty &&
        daddress.isNotEmpty &&
        choice!.isNotEmpty) {
      if (hasEnoughPoints()) {
        deductPoints();
        Map<String, dynamic> giftData = {
          "gifttype": choice,
          "name": name,
          "phoneno": pno,
          "address": address,
          "dname": dname,
          "dphoneno": dpno,
          "daddress": daddress,
          "status": status,
          "points": widget.points,
          "giftname": widget.giftna,
          "cashamount": widget.cashamt,
          "giftpic": widget.giftpic,
          "userid": userId,
          'timestamp': FieldValue.serverTimestamp(),
        };
        FirebaseFirestore.instance.collection("giftasked").add(giftData);
        print('Data Uploaded: Successfully Sent');

        // Show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Successfully Sent'),
              content: Text('Gift request sent successfully.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    // Navigate to the UserHomeScreen when the dialog is closed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserHomeScreen(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('You do not have enough points.');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Not Enough Points'),
              content:
                  Text('You do not have enough points to request this gift.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      print('Fill in all the data.');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Missing Information'),
            content: Text('Please fill in all the required information.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.brown.shade900,
        title: const Text(
          'GIFT OR CASH',
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'Choose One:',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          onChoiceSelected('GIFT');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: choice == 'GIFT'
                              ? Colors.green // Change the color when selected
                              : Colors.brown.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'GIFT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          onChoiceSelected('CASH');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: choice == 'CASH'
                              ? Colors.green // Change the color when selected
                              : Colors.brown.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'CASH',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: nameController,
                      // style: const TextStyle(height: 30),
                      cursorColor: Colors.brown.shade900,
                      decoration: InputDecoration(
                        labelText: 'Enter Name',
                        labelStyle: TextStyle(color: Colors.brown.shade900),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              width: 3, color: Colors.brown.shade900),
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
                      controller: pnoController,
                      maxLength: 10,
                      cursorColor: Colors.brown.shade900,
                      decoration: InputDecoration(
                        counter: const Offstage(),
                        labelText: 'Enter Phone No',
                        labelStyle: TextStyle(color: Colors.brown.shade900),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              width: 3, color: Colors.brown.shade900),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Colors.brown.shade900,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: addressController,
                      minLines: 1,
                      maxLines: 5,
                      cursorColor: Colors.brown.shade900,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 40.0, horizontal: 10),
                        labelText: 'Enter Address',
                        labelStyle: TextStyle(color: Colors.brown.shade900),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              width: 3, color: Colors.brown.shade900),
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
                      controller: dnameController,
                      cursorColor: Colors.brown.shade900,
                      decoration: InputDecoration(
                        labelText: 'Enter Dealer Name',
                        labelStyle: TextStyle(color: Colors.brown.shade900),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              width: 3, color: Colors.brown.shade900),
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
                      controller: dpnoController,
                      cursorColor: Colors.brown.shade900,
                      maxLength: 10,
                      decoration: InputDecoration(
                        counter: const Offstage(),
                        labelText: 'Enter Dealer No',
                        labelStyle: TextStyle(color: Colors.brown.shade900),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              width: 3, color: Colors.brown.shade900),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Colors.brown.shade900,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: daddressController,
                      minLines: 1,
                      maxLines: 5,
                      cursorColor: Colors.brown.shade900,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 40.0, horizontal: 10),
                        labelText: 'Enter Dealer Address',
                        labelStyle: TextStyle(color: Colors.brown.shade900),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              width: 3, color: Colors.brown.shade900),
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
                  ElevatedButton(
                    onPressed: () {
                      saveaddress();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 120.0, vertical: 15.0),
                      backgroundColor: Colors.brown.shade900,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      "SEND",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
