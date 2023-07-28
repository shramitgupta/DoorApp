import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserAddress extends StatefulWidget {
  UserAddress(
      {required this.giftna,
      required this.cashamt,
      required this.points,
      required this.yourpoints,
      required this.giftpic,
      super.key});
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
        "giftpic": widget.giftpic
        //"yourpoints": widget.yourpoints,
      };
      FirebaseFirestore.instance.collection("giftasked").add(giftData);
      print('data Uploaded');
    } else {
      print('fill data');
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
            color: Color.fromARGB(255, 195, 162, 132),
            size: 35,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color.fromARGB(255, 70, 63, 60),
        title: const Text(
          'GIFT OR CASH',
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
            color: const Color.fromARGB(255, 195, 162, 132),
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
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          choice = 'GIFT';
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 70, 63, 60),
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
                          choice = 'CASH';
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 70, 63, 60),
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
                      controller: pnoController,
                      cursorColor: const Color.fromARGB(255, 70, 63, 60),
                      decoration: InputDecoration(
                        counter: const Offstage(),
                        labelText: 'Enter Phone No',
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
                      controller: addressController,
                      minLines: 1,
                      maxLines: 5,
                      cursorColor: const Color.fromARGB(255, 70, 63, 60),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 40.0, horizontal: 10),
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
                      controller: dnameController,
                      cursorColor: const Color.fromARGB(255, 70, 63, 60),
                      decoration: InputDecoration(
                        labelText: 'Enter Dealer Name',
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
                      controller: dpnoController,
                      cursorColor: const Color.fromARGB(255, 70, 63, 60),
                      //maxLength: 10,
                      decoration: InputDecoration(
                        labelText: 'Enter Dealer No',
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
                      controller: daddressController,
                      minLines: 1,
                      maxLines: 5,
                      cursorColor: const Color.fromARGB(255, 70, 63, 60),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 40.0, horizontal: 10),
                        labelText: 'Enter Dealer Address',
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
                  ElevatedButton(
                    onPressed: () {
                      saveaddress();
                      // if (widget.points <= widget.yourpoints) {
                      //   int remainingPoints = widget.yourpoints - widget.points;
                      //   String documentId = 'points';

                      //   FirebaseFirestore.instance
                      //       .collection('carpenterData')
                      //       .doc(documentId)
                      //       .update({'points': remainingPoints}).then((_) {
                      //     // The points have been updated in Firestore.
                      //     // Now, proceed with saving the address details.
                      //     saveaddress();
                      //   }).catchError((error) {
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return AlertDialog(
                      //           title: const Text('Error'),
                      //           content: const Text(
                      //               'Failed to update points. Please try again later.'),
                      //           actions: [
                      //             TextButton(
                      //               onPressed: () {
                      //                 Navigator.of(context).pop();
                      //               },
                      //               child: const Text('OK'),
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //     );
                      //   });
                      // } else {
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return AlertDialog(
                      //         title: const Text('Insufficient Points'),
                      //         content: const Text(
                      //             'You do not have enough points to proceed.'),
                      //         actions: [
                      //           TextButton(
                      //             onPressed: () {
                      //               Navigator.of(context).pop();
                      //             },
                      //             child: const Text('OK'),
                      //           ),
                      //         ],
                      //       );
                      //     },
                      //   );
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 125.0, vertical: 15.0),
                      backgroundColor: const Color.fromARGB(255, 70, 63, 60),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      "SEND",
                      style: TextStyle(color: Colors.white, fontSize: 18),
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