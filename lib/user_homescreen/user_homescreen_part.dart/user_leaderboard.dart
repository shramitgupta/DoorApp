import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorapp/admin_homescreen/admin_homescreen_parts/carpenter_profile.dart';
import 'package:flutter/material.dart';

class UserLeaderBoard extends StatefulWidget {
  const UserLeaderBoard({super.key});

  @override
  State<UserLeaderBoard> createState() => _UserLeaderBoardState();
}

class _UserLeaderBoardState extends State<UserLeaderBoard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
          'LEADERBOARD',
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
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("carpenterData")
                .orderBy("points",
                    descending: true) // <-- Order by points in ascending order
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];

                      return ListTile(
                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => CarpenterProfile(
                        //         pic: document["cprofilepic"],
                        //         address: document["caddress"],
                        //         age: document["cage"].toString(),
                        //         annaversary: document["canniversarydate"],
                        //         dob: document["cdob"],
                        //         name: document["cname"],
                        //         phoneno: document["cpno"].toString(),
                        //         status: document["cmaritalstatus"],
                        //       ),
                        //     ),
                        //   );
                        // },
                        title: Container(
                          margin: EdgeInsets.symmetric(
                            //vertical: 10,
                            vertical: screenHeight * 0.01,
                            horizontal: screenWidth * 0.001,
                            //horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    top: screenHeight * 0.01,
                                    // bottom: -50.w,
                                    left: screenHeight * 0.01,
                                    right: 0,
                                    child: Container(
                                      constraints: BoxConstraints(
                                        //maxHeight: 60,
                                        maxHeight: screenHeight * 0.06,
                                      ),
                                      padding: EdgeInsets.only(
                                        //top: 20,
                                        top: screenHeight * 0.022,
                                        //bottom: 10,
                                        bottom: screenHeight * 0.01,
                                        //left: 170,
                                        left: screenWidth * 0.2,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.brown.shade900,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Name: ${document["cname"]}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Points: ${document["points"]}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            //height: 5,
                                            width: screenWidth * 0.01,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 15,
                                    margin: const EdgeInsets.only(left: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    shadowColor: Colors.brown.shade900,
                                    child: SizedBox(
                                      //height: 50,
                                      height: screenHeight * 0.057,
                                      //width: 50,
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
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Container(
                        decoration: new BoxDecoration(
                            image: new DecorationImage(
                      image: new AssetImage("images/score.png"),
                      //fit: BoxFit.fill,
                    ))),
                  );
                }
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  CustomButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
