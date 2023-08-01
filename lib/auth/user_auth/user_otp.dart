import 'package:doorapp/unused/admin_signup.dart';
import 'package:doorapp/unused/user_signup.dart';
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

  void verifyOTP() async {
    String otp = otpController.text.trim();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        // Navigate to the AdminSignIn page after successful verification
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => UserHomeScreen()));
      }
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' $ex')),
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
                  " Enter",
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
                const Text(
                  " OTP",
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: otpController,
                    cursorColor: const Color.fromARGB(255, 70, 63, 60),
                    decoration: InputDecoration(
                      labelText: 'Enter Otp',
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
                      onPressed: verifyOTP, // Call the verifyOTP function
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 7.0),
                        backgroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        "Submit",
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
                    const Text("Don't have an account?"),
                    TextButton(
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.yellow,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserSignIn()),
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
