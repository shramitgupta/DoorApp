import 'package:doorapp/auth/user_auth/user_phoneno_login.dart';
import 'package:doorapp/user_homescreen/user_homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (FirebaseAuth.instance.currentUser != null)
          ? const UserHomeScreen() // UserPhoneNoLogin
          : UserPhoneNoLogin(),
    );
    //     MaterialApp(
    //   home: (FirebaseAuth.instance.currentUser != null)
    //       ? const AdminHomeScreen()
    //       : AdminPhoneNoLogin(),
    // );
  }
}
