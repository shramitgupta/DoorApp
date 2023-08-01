import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:doorapp/admin_homescreen/admin_homescreen_parts/carpenter_profile.dart';

class CarpenterDelete extends StatefulWidget {
  const CarpenterDelete({Key? key}) : super(key: key);

  @override
  State<CarpenterDelete> createState() => _CarpenterDeleteState();
}

class _CarpenterDeleteState extends State<CarpenterDelete> {
  final TextEditingController _searchController = TextEditingController();
  final String _searchText = "";

  Stream<QuerySnapshot> _getCarpentersStream() {
    return FirebaseFirestore.instance
        .collection("carpenterData")
        .orderBy("points", descending: false)
        .snapshots();
  }

  void deleteCarpenter(String documentId) {
    FirebaseFirestore.instance
        .collection("carpenterData")
        .doc(documentId)
        .delete()
        .then((_) {
      log("Carpenter deleted successfully!");
    }).catchError((error) {
      log("Error deleting carpenter: $error");
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
          'DELETE CARPENTER',
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
        color: const Color.fromARGB(255, 70, 63, 60),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: const Color.fromARGB(255, 195, 162, 132),
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: Focus(
                //     autofocus: true,
                //     child: TextField(
                //       controller: _searchController,
                //       decoration: InputDecoration(
                //         hintText: 'Search by name',
                //         suffixIcon: IconButton(
                //           onPressed: () {
                //             _searchController.clear();
                //           },
                //           icon: Icon(Icons.clear),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _getCarpentersStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          List<QueryDocumentSnapshot> carpenters =
                              snapshot.data!.docs;

                          // Filter carpenters based on search text
                          if (_searchText.isNotEmpty) {
                            carpenters = carpenters.where((carpenter) {
                              String carpenterName =
                                  carpenter["cname"].toString().toLowerCase();
                              return carpenterName
                                  .contains(_searchText.toLowerCase());
                            }).toList();
                          }

                          return ListView.builder(
                            itemCount: carpenters.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document = carpenters[index];

                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CarpenterProfile(
                                        pic: document["cprofilepic"],
                                        address: document["caddress"],
                                        age: document["cage"].toString(),
                                        annaversary:
                                            document["canniversarydate"],
                                        dob: document["cdob"],
                                        name: document["cname"],
                                        phoneno: document["cpno"].toString(),
                                        status: document["cmaritalstatus"],
                                      ),
                                    ),
                                  );
                                },
                                title: Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01,
                                    horizontal: screenWidth * 0.001,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Positioned(
                                            top: screenHeight * 0.01,
                                            left: screenHeight * 0.01,
                                            right: 0,
                                            child: Container(
                                              constraints: BoxConstraints(
                                                maxHeight: screenHeight * 0.06,
                                              ),
                                              padding: EdgeInsets.only(
                                                top: screenHeight * 0.022,
                                                bottom: screenHeight * 0.01,
                                                left: screenWidth * 0.2,
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Name: ${document["cname"]}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Card(
                                            elevation: 15,
                                            margin:
                                                const EdgeInsets.only(left: 20),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            shadowColor: Colors.amber,
                                            child: SizedBox(
                                              height: screenHeight * 0.057,
                                              width: screenWidth * 0.12,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.network(
                                                  document["cprofilepic"],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Delete Carpenter"),
                                          content: const Text(
                                              "Are you sure you want to delete this carpenter?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteCarpenter(document.id);
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Delete"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text("Delete"),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Expanded(child: Text("No data"));
                        }
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
