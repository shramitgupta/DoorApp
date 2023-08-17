import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorapp/user_homescreen/user_homescreen_part.dart/user_address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserGiftDetails extends StatefulWidget {
  const UserGiftDetails({Key? key}) : super(key: key);

  @override
  State<UserGiftDetails> createState() => _UserGiftDetailsState();
}

class _UserGiftDetailsState extends State<UserGiftDetails> {
  int yourpoints = 0;
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  @override
  void initState() {
    super.initState();
    fetchUserPoints();
  }

  Future<void> fetchUserPoints() async {
    try {
      //  String currentUserId = currentUserId(); // Replace with your authentication method to get the current user ID

      final userDoc = await FirebaseFirestore.instance
          .collection(
              "carpenterData") // Replace "users" with your Firestore collection name
          .doc(currentUserId)
          .get();

      int userPoints = userDoc["points"];

      setState(() {
        yourpoints = userPoints;
        log(yourpoints.toString());
      });
    } catch (error) {
      print("Error fetching user points: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.brown.shade900,
        title: const Text(
          'Scheme',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("Gifts").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document =
                              snapshot.data!.docs[index];

                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserAddress(
                                    cashamt: document['cash'],
                                    giftna: document['giftname'],
                                    points: document['point'],
                                    giftpic: document['giftpic'],
                                    yourpoints: yourpoints,
                                  ),
                                ),
                              );
                            },
                            title: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: Colors.brown.shade200,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                document["giftpic"]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 18),
                                          child: Text(
                                            'Points:${document['point']}',
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 44, 30, 26),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Gifts:${document['giftname']} Or',
                                          style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 44, 30, 26),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Cash-${document['cash']}',
                                          style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 44, 30, 26),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Container(
                            decoration: new BoxDecoration(
                                image: new DecorationImage(
                          image: new AssetImage("images/gift.png"),
                          //fit: BoxFit.fill,
                        ))),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
