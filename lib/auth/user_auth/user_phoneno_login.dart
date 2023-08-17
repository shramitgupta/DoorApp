import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorapp/auth/admin_auth/admin_phoneno_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'user_otp.dart';

class UserPhoneNoLogin extends StatefulWidget {
  UserPhoneNoLogin({Key? key});

  @override
  State<UserPhoneNoLogin> createState() => _UserPhoneNoLoginState();
}

class _UserPhoneNoLoginState extends State<UserPhoneNoLogin> {
  final TextEditingController _contactNumberController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId; // Store the verification ID for OTP verification
  bool isLoading = false; // Track loading state for the button
  String? _errorText; // Error text to show if phone number is invalid

  Future<bool> checkIfPhoneNumberExists(String phoneNumber) async {
    String phoneString = _contactNumberController.text.trim();
    int phone = int.parse(phoneString);
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('carpenterData')
          .where('cpno', isEqualTo: phone)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Function to send OTP to the user's phone number
  Future<void> _sendOTP() async {
    setState(() {
      isLoading = true; // Show loading indicator on button
    });

    String phoneNumber = '+91${_contactNumberController.text.trim()}';
    if (_contactNumberController.text.trim().length != 10) {
      setState(() {
        _errorText = 'Phone number should be exactly 10 digits.';
        isLoading = false; // Hide loading indicator on button
      });
      return;
    } else {
      setState(() {
        _errorText = null;
      });
    }

    try {
      // Check if the phone number exists in the Firestore collection "carpenterData"
      bool phoneNumberExists = await checkIfPhoneNumberExists(phoneNumber);

      if (phoneNumberExists) {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Auto-retrieve the OTP in case of instant verification (rare case)
            await _auth.signInWithCredential(credential);
            _navigateToUserOtp(); // Navigate to UserOtp page after OTP verification
          },
          verificationFailed: (FirebaseAuthException e) {
            print('Phone number verification failed: ${e.message}');
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              _verificationId = verificationId;
              isLoading = false; // Hide loading indicator on button
            });
            _navigateToUserOtp(); // Navigate to UserOtp page after code is sent
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            setState(() {
              _verificationId = verificationId;
              isLoading = false; // Hide loading indicator on button
            });
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found. Please sign up first.')),
        );
        setState(() {
          isLoading = false; // Hide loading indicator on button
        });
      }
    } catch (e) {
      print('Error sending OTP: $e');
      setState(() {
        isLoading = false; // Hide loading indicator on button
      });
    }
  }

  // Function to navigate to the UserOtp page
  void _navigateToUserOtp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserOtp(verificationId: _verificationId.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'images/logo.png',
                height: screenHeight * 0.22,
              ),
              // SizedBox(
              //   height: screenHeight * 0.1,
              // ),
              Text(
                " User",
                style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade900),
              ),
              Text(
                " Login",
                style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade900),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  controller: _contactNumberController,
                  cursorColor: Colors.brown.shade900,
                  decoration: InputDecoration(
                    counter: const Offstage(),
                    labelText: 'Enter Phone No',
                    errorText: _errorText, // Show error text if not null
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _sendOTP,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 7.0),
                      backgroundColor: Colors.brown.shade900,
                      shape: const StadiumBorder(),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.brown.shade900,
                            ),
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login as Admin?"),
                  TextButton(
                    child: Text(
                      'Admin',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.brown.shade900,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminPhoneNoLogin()),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
