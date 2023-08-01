import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorapp/auth/user_auth/user_phoneno_login.dart';
import 'package:doorapp/auth/admin_auth/admin_otp_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminPhoneNoLogin extends StatefulWidget {
  AdminPhoneNoLogin({Key? key});

  @override
  State<AdminPhoneNoLogin> createState() => _AdminPhoneNoLoginState();
}

class _AdminPhoneNoLoginState extends State<AdminPhoneNoLogin> {
  final TextEditingController _contactNumberController =
      TextEditingController();

  Future<bool> checkIfPhoneNumberExists(String phoneNumber) async {
    String phoneString = _contactNumberController.text.trim();
    int phone = int.parse(phoneString);
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Admin')
          .where('contactNumber', isEqualTo: phone)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void startPhoneNumberVerification() async {
    String phoneNumber = "+91" + _contactNumberController.text.trim();

    bool phoneNumberExists = await checkIfPhoneNumberExists(phoneNumber);

    if (phoneNumberExists) {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {
            // This callback will be triggered when the verification is completed automatically (e.g., on Android devices)
          },
          verificationFailed: (FirebaseAuthException e) {
            // Handle verification failure (e.g., invalid phone number)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Phone number verification failed: ${e.message}')),
            );
          },
          codeSent: (String verificationId, int? resendToken) {
            // Navigate to the OTP screen passing the verificationId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AdminOtpLogin(verificationId: verificationId),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // The verification code could not be automatically retrieved.
            // You can handle it if necessary.
          },
          timeout: Duration(
              seconds:
                  60), // Optional timeout duration for the code to be sent (default is 30 seconds)
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during phone verification: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not found. Please sign up first.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color.fromARGB(255, 70, 63, 60),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            color: const Color.fromARGB(255, 195, 162, 132),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                const Text(
                  " Admin",
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
                const Text(
                  " Login",
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _contactNumberController,
                    cursorColor: const Color.fromARGB(255, 70, 63, 60),
                    decoration: InputDecoration(
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
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        startPhoneNumberVerification();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 7.0),
                        backgroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Login as Carpenter"),
                    TextButton(
                      child: const Text(
                        'Carpenter',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.yellow,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserPhoneNoLogin()),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
