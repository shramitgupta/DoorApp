import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorapp/user_homescreen/user_homescreen_part.dart/user_address.dart';
import 'package:flutter/material.dart';

class UserGiftDetails extends StatefulWidget {
  const UserGiftDetails({super.key});

  @override
  State<UserGiftDetails> createState() => _UserGiftDetailsState();
}

class _UserGiftDetailsState extends State<UserGiftDetails> {
  int yourpoints = 0;
  @override
  void initState() {
    super.initState();
    fetchUserPoints();
  }

  Future<void> fetchUserPoints() async {
    try {
      final userQuery =
          await FirebaseFirestore.instance.collection("carpenterData").get();
      int totalPoints = 0;
      for (final userDoc in userQuery.docs) {
        int userPoints = userDoc["points"];
        totalPoints += userPoints;
      }
      setState(() {
        yourpoints = totalPoints;
        print(yourpoints);
      });
    } catch (error) {
      print("Error fetching user points: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 195, 162, 132),
      child: SafeArea(
        child: Scaffold(
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
              'Scheme',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 195, 162, 132),
              ),
            ),
            centerTitle: true,
          ),
          body: Container(
            color: const Color.fromARGB(255, 195, 162, 132),
            child: Column(
              children: [
                // SizedBox(
                //   height: 120,
                //   child: Column(
                //     children: [
                //       const SizedBox(
                //         height: 10,
                //       ),
                //       const Text(
                //         'Redeem',
                //         style: TextStyle(
                //             fontSize: 15,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.white),
                //       ),
                //       Text(
                //         '$yourpoints',
                //         style: const TextStyle(
                //             fontSize: 40,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.white),
                //       ),
                //       const Text(
                //         'Total Points',
                //         style: TextStyle(fontSize: 30),
                //       ),
                //     ],
                //   ),
                // ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Gifts")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
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
                                    color: const Color.fromARGB(
                                        255, 237, 240, 225),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                color: Color.fromARGB(
                                                    255, 44, 30, 26),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Cash-${document['cash']}',
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 44, 30, 26),
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
        ),
      ),
    );
  }
}
