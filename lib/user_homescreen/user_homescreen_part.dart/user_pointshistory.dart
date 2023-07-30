import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorapp/admin_homescreen/admin_homescreen_parts/carpenter_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPointsHistory extends StatefulWidget {
  const UserPointsHistory({Key? key}) : super(key: key);

  @override
  State<UserPointsHistory> createState() => _UserPointsHistoryState();
}

class _UserPointsHistoryState extends State<UserPointsHistory> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    log(currentUserId.toString());

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
          'POINTS HISTORY',
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
            color: const Color.fromARGB(255, 195, 162, 132),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("qrscandata")
                  .where('userId', isEqualTo: currentUserId)
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No data"));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    log(document.toString());
                    DateTime dateTime =
                        (document["timestamp"] as Timestamp).toDate();
                    // log(document["timestamp"].toString());
                    return ListTile(
                      title: Container(
                        margin: EdgeInsets.symmetric(
                          //vertical: 10,
                          vertical: screenHeight * 0.01,
                          horizontal: screenWidth * 0.001,
                          //horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Time: ${dateTime.toString()}", // Display the time
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Points: ${document["scannedPoints"]}", // Display the points
                              style: TextStyle(fontWeight: FontWeight.bold),
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
// title: Container(
                            //   margin: EdgeInsets.symmetric(
                            //     vertical: screenHeight * 0.01,
                            //     horizontal: screenWidth * 0.001,
                            //   ),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.stretch,
                            //     children: [
                            //       Stack(
                            //         clipBehavior: Clip.none,
                            //         children: [
                            //           Positioned(
                            //             top: screenHeight * 0.01,
                            //             left: screenHeight * 0.01,
                            //             right: 0,
                            //             child: Container(
                            //               constraints: BoxConstraints(
                            //                 maxHeight: screenHeight * 0.06,
                            //               ),
                            //               padding: EdgeInsets.only(
                            //                 top: screenHeight * 0.022,
                            //                 bottom: screenHeight * 0.01,
                            //                 left: screenWidth * 0.2,
                            //               ),
                            //               decoration: BoxDecoration(
                            //                   color: Colors.white,
                            //                   borderRadius:
                            //                       BorderRadius.circular(15)),
                            //               child: Row(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.spaceBetween,
                            //                 children: [
                            //                   Text(
                            //                     "Time: ${dateTime.toString()}", // Display the time
                            //                     style: TextStyle(
                            //                         fontWeight:
                            //                             FontWeight.bold),
                            //                   ),
                            //                   Text(
                            //                     "Points: ${document["scannedPoints"]}", // Display the points
                            //                     style: TextStyle(
                            //                         fontWeight:
                            //                             FontWeight.bold),
                            //                   ),
                            //                   SizedBox(
                            //                     width: screenWidth * 0.01,
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),