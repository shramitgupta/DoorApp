import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorapp/auth/user_auth/user_phoneno_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserSignIn extends StatefulWidget {
  const UserSignIn({Key? key});

  @override
  State<UserSignIn> createState() => _UserSignInState();
}

class _UserSignInState extends State<UserSignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phonenoController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void signUpUser(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    String phonenoString = phonenoController.text;

    int phoneno = int.parse(phonenoString);

    emailController.clear();
    passwordController.clear();
    phonenoController.clear();

    try {
      // Create a user with email and password using Firebase Authentication
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // String phone = "+91" + phonenoController.text.trim();

      // await FirebaseAuth.instance.verifyPhoneNumber(
      //     phoneNumber: phone,
      //     codeSent: (verificationId, resendToken) {
      //       Navigator.push(
      //           context,
      //           CupertinoPageRoute(
      //               builder: (context) => AdminOtp(
      //                     verificationId: verificationId,
      //                   )));
      //     },
      //     verificationCompleted: (credential) {},
      //     verificationFailed: (ex) {
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(content: Text(' $ex')),
      //       );
      //     },
      //     codeAutoRetrievalTimeout: (verificationId) {},
      //     timeout: Duration(seconds: 30));
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'password': password,
        'contactNumber': phoneno,
      });

      // Show success message or navigate to the next screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup successful')),
      );
    } catch (e) {
      // Handle signup error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
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
                  " Sign Up",
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
                    // style: const TextStyle(height: 30),
                    cursorColor: const Color.fromARGB(255, 70, 63, 60),
                    decoration: InputDecoration(
                      labelText: 'Enter E-Mail',
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 70, 63, 60),
                      ),
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
                    controller: passwordController,
                    // style: const TextStyle(height: 30),
                    cursorColor: const Color.fromARGB(255, 70, 63, 60),
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
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
                    controller: phonenoController,
                    // style: const TextStyle(height: 30),
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
                        signUpUser(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 7.0),
                        backgroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        "Sign in",
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
                    const Text('Already have account?'),
                    TextButton(
                      child: const Text(
                        'Login',
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
