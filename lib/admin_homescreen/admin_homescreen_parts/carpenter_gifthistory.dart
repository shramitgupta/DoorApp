import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CarpenterGiftHistory extends StatefulWidget {
  const CarpenterGiftHistory({super.key});

  @override
  State<CarpenterGiftHistory> createState() => _CarpenterGiftHistoryState();
}

class _CarpenterGiftHistoryState extends State<CarpenterGiftHistory> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String app = 'approved';
    //log(currentUserId.toString());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 195, 162, 132),
            size: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 70, 63, 60),
        title: const Text(
          'GIFT HISTORY',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 195, 162, 132),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 70, 63, 60),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors
                .white, // Changed to white for the main container background
            child: FutureBuilder<QuerySnapshot?>(
              future: FirebaseFirestore.instance
                  .collection("giftasked")
                  .where('status', isEqualTo: app)
                  .get(),
              builder: (context, snapshot) {
                log(snapshot.data.toString());
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No data"));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    log(document.toString());
                    DateTime dateTime =
                        (document["timestamp"] as Timestamp).toDate();
                    // Format the DateTime to display in hours and minutes
                    String formattedTime =
                        DateFormat('dd MMM yyyy, HH:mm').format(dateTime);

                    return ListTile(
                      title: Container(
                        margin: EdgeInsets.symmetric(
                          //vertical: 10,
                          vertical: screenHeight * 0.01,
                          horizontal: screenWidth * 0.001,
                          //horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 195, 162, 132),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Name:  ${document["name"]}", // Display the formatted time
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Set text color to white
                              ),
                            ),
                            Text(
                              "Date & Time: $formattedTime", // Display the formatted time
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Set text color to white
                              ),
                            ),
                            Text(
                              "Points: ${document["points"]}", // Display the points
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Set text color to white
                              ),
                            ),
                            Text(
                              "Gift: ${document["gifttype"]}", // Display the points
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Set text color to white
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
