import 'package:doorapp/auth/user_auth/user_phoneno_login.dart';
import 'package:doorapp/user_homescreen/user_homescreen_part.dart/User_contact.dart';
import 'package:doorapp/user_homescreen/user_homescreen_part.dart/User_pointsused.dart';
import 'package:doorapp/user_homescreen/user_homescreen_part.dart/user_banking.dart';
import 'package:doorapp/user_homescreen/user_homescreen_part.dart/user_giftdetails.dart';
import 'package:doorapp/user_homescreen/user_homescreen_part.dart/user_leaderboard.dart';
import 'package:doorapp/user_homescreen/user_homescreen_part.dart/user_profilescreen.dart';
import 'package:doorapp/user_homescreen/user_homescreen_part.dart/user_qrscanner.dart';
import 'package:doorapp/user_homescreen/user_homescreen_part.dart/user_redeemstatus.dart';
import 'package:doorapp/user_homescreen/user_homescreen_part.dart/user_totalpoints.dart';
import 'package:doorapp/user_homescreen/user_homescreen_part.dart/user_upcomming.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

List button = [
  'Profile Screen',
  'Qr Scanner',
  'Total Points',
  'Leader Board',
  'Gift Details',
  'Redeem Status',
  'Points Used',
  'Contact Details',
  'Banking',
  'Upcomming Events',
];

class _UserHomeScreenState extends State<UserHomeScreen> {
  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => UserPhoneNoLogin()));
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
          'CARPENTER HOME',
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
                            builder: (context) => const UserProfileScreen(),
                          ),
                        );
                      } else if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserQrScanner(),
                          ),
                        );
                      } else if (index == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserTotalPoints(),
                          ),
                        );
                      } else if (index == 3) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserLeaderBoard(),
                          ),
                        );
                      } else if (index == 4) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserGiftDetails(),
                          ),
                        );
                      } else if (index == 5) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserRedeemStatus(),
                          ),
                        );
                      } else if (index == 6) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserPointsUsed(),
                          ),
                        );
                      } else if (index == 7) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserContactDetails(),
                          ),
                        );
                      } else if (index == 8) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserBanking(),
                          ),
                        );
                      } else if (index == 9) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserUpcommingEvent(),
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
