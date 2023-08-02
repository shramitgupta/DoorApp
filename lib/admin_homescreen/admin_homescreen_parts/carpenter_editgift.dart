import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorapp/user_homescreen/user_homescreen_part.dart/user_address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CarpenterEditGifts extends StatefulWidget {
  const CarpenterEditGifts({Key? key}) : super(key: key);

  @override
  State<CarpenterEditGifts> createState() => _CarpenterEditGiftsState();
}

class _CarpenterEditGiftsState extends State<CarpenterEditGifts> {
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

  void _showConfirmationDialog(String giftId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Gift'),
          content: Text('Are you sure you want to delete this gift?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                _deleteGift(giftId);
                Navigator.pop(context);
              },
              child: Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  void _deleteGift(String giftId) async {
    try {
      await FirebaseFirestore.instance.collection("Gifts").doc(giftId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gift deleted successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete gift. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
      print("Error deleting gift: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 195, 162, 132),
            size: 35,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color.fromARGB(255, 70, 63, 60),
        title: const Text(
          'DELETE GIFTS',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 195, 162, 132),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(255, 195, 162, 132),
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
                          String giftId = document.id;

                          return ListTile(
                            title: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: const Color.fromARGB(255, 237, 240, 225),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                    IconButton(
                                      iconSize: 30,
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _showConfirmationDialog(giftId);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Text("No data");
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
