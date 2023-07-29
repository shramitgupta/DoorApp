// import 'package:doorapp/auth/admin_auth/admin_gmail_login.dart';
// import 'package:doorapp/auth/user_auth/user_gmail_login.dart';
// import 'package:flutter/material.dart';

// class UserPhoneNoLogin extends StatefulWidget {
//   UserPhoneNoLogin({Key? key});

//   @override
//   State<UserPhoneNoLogin> createState() => _UserPhoneNoLoginState();
// }

// class _UserPhoneNoLoginState extends State<UserPhoneNoLogin> {
//   final TextEditingController _contactNumberController =
//       TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     //double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         color: const Color.fromARGB(255, 70, 63, 60),
//         child: Padding(
//           padding: const EdgeInsets.all(30.0),
//           child: Container(
//             color: const Color.fromARGB(255, 195, 162, 132),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: screenHeight * 0.1,
//                 ),
//                 const Text(
//                   " User",
//                   style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
//                 ),
//                 const Text(
//                   " Login",
//                   style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(
//                   height: screenHeight * 0.1,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextFormField(
//                     controller: _contactNumberController,
//                     // style: const TextStyle(height: 30),
//                     cursorColor: const Color.fromARGB(255, 70, 63, 60),
//                     decoration: InputDecoration(
//                       labelText: 'Enter Phone No',
//                       labelStyle: const TextStyle(
//                           color: Color.fromARGB(255, 70, 63, 60)),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         borderSide:
//                             const BorderSide(width: 3, color: Colors.white),
//                       ),
//                       focusedBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 3,
//                           color: Color.fromARGB(255, 70, 63, 60),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     margin: const EdgeInsets.all(10),
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //       builder: (context) => const AdminOtp()),
//                         // );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20.0, vertical: 7.0),
//                         backgroundColor: Colors.white,
//                         shape: const StadiumBorder(),
//                       ),
//                       child: const Text(
//                         "Login",
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("Login with G-Mail?"),
//                     TextButton(
//                       child: const Text(
//                         'Login',
//                         style: TextStyle(
//                           fontSize: 20,
//                           color: Colors.yellow,
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => UserGmailLogin()),
//                         );
//                       },
//                     )
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("Login as Admin?"),
//                     TextButton(
//                       child: const Text(
//                         'Admin',
//                         style: TextStyle(
//                           fontSize: 20,
//                           color: Colors.yellow,
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => AdminGmailLogin()),
//                         );
//                       },
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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

  // Function to send OTP to the user's phone number
  Future<void> _sendOTP() async {
    String phoneNumber =
        '+91${_contactNumberController.text.trim()}'; // Replace this with your country code
    try {
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
          });
          _navigateToUserOtp(); // Navigate to UserOtp page after code is sent
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

  // Function to navigate to the UserOtp page
  void _navigateToUserOtp() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              UserOtp(verificationId: _verificationId.toString())),
    );
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
                  " User",
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
                      onPressed: _sendOTP,
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
                // ... Login with G-Mail and Login as Admin buttons remain the same
              ],
            ),
          ),
        ),
      ),
    );
  }
}
