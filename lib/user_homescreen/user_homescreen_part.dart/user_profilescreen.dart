import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String? documentId;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('carpenterData');

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
        setState(() {
          documentId = user.uid;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder<DocumentSnapshot>(
      future: customers.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 35,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.brown.shade900,
              title: const Text(
                'PROFILE',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
            body: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: Hero(
                        tag: 'profileImage',
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 10, color: Colors.brown.shade900),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.brown.shade900,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(data["cprofilepic"]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: screenHeight * 0.2,
                          width: screenHeight * 0.2,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "NAME: ${data["cname"]}",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            "Age: ${data["cage"].toString()}",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            "Phone No: ${data["cpno"].toString()}",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            "Address: ${data["caddress"]}",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            "Date Of Birth: ${data["cdob"]}",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            "Marital Status: ${data["cmaritalstatus"]}",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            "Anniversary Date: ${data["canniversarydate"]}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(
                        'images/logo.png',
                        height: screenHeight * 0.22,
                        //width: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: Colors.brown.shade900,
          ),
        );
      },
    );
  }
}
