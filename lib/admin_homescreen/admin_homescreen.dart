import 'package:doorapp/Auth_admin/admin_signup.dart';
import 'package:doorapp/admin_homescreen/admin_homescreen_parts/carpenter_addgift.dart';
import 'package:doorapp/admin_homescreen/admin_homescreen_parts/carpenter_delete.dart';
import 'package:doorapp/admin_homescreen/admin_homescreen_parts/carpenter_details.dart';
import 'package:doorapp/admin_homescreen/admin_homescreen_parts/carpenter_giftrequest.dart';
import 'package:doorapp/admin_homescreen/admin_homescreen_parts/carpenter_leaderboard.dart';
import 'package:doorapp/admin_homescreen/admin_homescreen_parts/carpenter_regester.dart';
import 'package:doorapp/admin_homescreen/admin_homescreen_parts/carpenter_totalgifts.dart';
import 'package:doorapp/admin_homescreen/admin_homescreen_parts/carpenter_whattosend.dart';
import 'package:doorapp/admin_homescreen/admin_homescreen_parts/qr_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

List button = [
  'Carpenter Regester',
  'Qr Generator',
  'Carpenter Details',
  'Leader Board',
  'Gift Request',
  'What to Send',
  'Total Gifts Sent',
  'Add Gifts',
  'Delete Carpenter',
];

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => AdminSignIn()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.notifications_none,
            color: Color.fromARGB(255, 195, 162, 132),
            size: 35,
          ),
          onPressed: () {},
        ),
        backgroundColor: const Color.fromARGB(255, 70, 63, 60),
        title: const Text(
          'ADMIN HOME',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 195, 162, 132),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout_sharp,
              color: Color.fromARGB(255, 195, 162, 132),
              size: 35,
            ),
            onPressed: () {
              logOut();
            },
          )
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 70, 63, 60),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            color: const Color.fromARGB(255, 195, 162, 132),
            child: ListView.builder(
                itemCount: button.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CarpenterRegester(),
                          ),
                        );
                      } else if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QrGenerator(),
                          ),
                        );
                      } else if (index == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CarpenterDetails(),
                          ),
                        );
                      } else if (index == 3) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CarpenterLeaderBoard(),
                          ),
                        );
                      } else if (index == 4) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CarpenterGiftRequest(),
                          ),
                        );
                      } else if (index == 5) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CarpenterWhatToSend(),
                          ),
                        );
                      } else if (index == 6) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CarpenterTotalGifts(),
                          ),
                        );
                      } else if (index == 7) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CarpenterAddGifts(),
                          ),
                        );
                      } else if (index == 8) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CarpenterDelete(),
                          ),
                        );
                      }
                    },
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      child: Container(
                        color: const Color.fromARGB(255, 70, 63, 60),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              button[index],
                              style: const TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB(255, 195, 162, 132),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
