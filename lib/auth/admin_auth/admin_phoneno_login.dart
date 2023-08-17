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
  bool isLoading = false; // Track the loading state
  String? _errorText; // Error text to show if input is invalid

  bool validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      setState(() {
        _errorText =
            'Please enter a phone number'; // Show error for blank input
      });
      return false;
    } else if (phoneNumber.length != 10) {
      setState(() {
        _errorText =
            'Phone number must be 10 digits'; // Show error for incorrect length
      });
      return false;
    } else {
      setState(() {
        _errorText = null; // Clear error text if input is valid
      });
      return true;
    }
  }

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
    setState(() {
      isLoading = true; // Show loading indicator on button
    });

    String phoneNumber = "+91" + _contactNumberController.text.trim();
    bool isValidPhoneNumber =
        validatePhoneNumber(_contactNumberController.text.trim());

    if (isValidPhoneNumber) {
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
            timeout: const Duration(
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

    setState(() {
      isLoading = false; // Hide loading indicator on button
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        // color: const Color.fromARGB(255, 70, 63, 60),
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
                " Admin",
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
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.brown.shade900,
                        //color: Colors.white
                      ),
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
                    onPressed: isLoading ? null : startPhoneNumberVerification,
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
                  const Text("Login as Carpenter"),
                  TextButton(
                    child: Text(
                      'Carpenter',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.brown.shade900,
                        fontWeight: FontWeight.bold,
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
    );
  }
}
