import 'package:doorapp/auth/admin_auth/admin_phoneno_login.dart';
import 'package:doorapp/user_homescreen/user_homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserOtp extends StatefulWidget {
  const UserOtp({Key? key, required this.verificationId});
  final String verificationId;

  @override
  State<UserOtp> createState() => _UserOtpState();
}

class _UserOtpState extends State<UserOtp> {
  TextEditingController otpController = TextEditingController();
  bool isLoading = false; // Track the loading state
  String? _errorText; // Error text to show if OTP is invalid

  void verifyOTP() async {
    setState(() {
      isLoading = true; // Show loading indicator on button
    });

    String otp = otpController.text.trim();
    if (otp.isEmpty) {
      setState(() {
        _errorText = 'Please enter OTP'; // Show error text if OTP is blank
        isLoading = false; // Hide loading indicator on button
      });
      return;
    } else {
      setState(() {
        _errorText = null; // Clear error text if OTP is not blank
      });
    }

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp,
    );

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        // Navigate to the UserHomeScreen page after successful verification
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => UserHomeScreen()),
        );
      }
    } on FirebaseAuthException catch (ex) {
      setState(() {
        _errorText =
            'Invalid OTP. Please try again.'; // Show error text for invalid OTP
        isLoading = false; // Hide loading indicator on button
      });
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator on button
      });
    }
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
                " Enter",
                style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade900),
              ),
              Text(
                " OTP",
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
                  keyboardType: TextInputType.phone,
                  maxLength: 6,
                  controller: otpController,
                  cursorColor: Colors.brown.shade900,
                  decoration: InputDecoration(
                    counter: const Offstage(),
                    labelText: 'Enter OTP',
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
                    onPressed: isLoading
                        ? null
                        : verifyOTP, // Disable the button when loading
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
                            "Submit",
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
                  const Text("Login as Admin"),
                  TextButton(
                    child: Text(
                      'Admin',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.brown.shade900,
                          fontWeight: FontWeight.bold),
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
