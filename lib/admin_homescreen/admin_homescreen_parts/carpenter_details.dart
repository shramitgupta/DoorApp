import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorapp/admin_homescreen/admin_homescreen_parts/carpenter_profile.dart';
import 'package:doorapp/admin_homescreen/admin_homescreen_parts/state_list.dart';
import 'package:flutter/material.dart';

import '../../user_homescreen/user_homescreen_part.dart/user_leaderboard.dart';

class CarpenterDetails extends StatefulWidget {
  const CarpenterDetails({Key? key}) : super(key: key);

  @override
  _CarpenterDetailsState createState() => _CarpenterDetailsState();
}

class _CarpenterDetailsState extends State<CarpenterDetails> {
  String selectedState = "Select State";
  String selectedDistrict = "District";
  int getMatchingCarpentersCount(List<QueryDocumentSnapshot> documents) {
    int count = 0;
    for (var document in documents) {
      if ((selectedState == "Select State" ||
              document["state"] == selectedState) &&
          (selectedDistrict == "District" ||
              document["district"] == selectedDistrict)) {
        count++;
      }
    }
    return count;
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
            color: Colors.white,
            size: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.brown.shade900,
        title: const Text(
          'CARPENTER DETAILS',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Container(
            // margin: EdgeInsets.only(right: 15),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("carpenterData")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    int matchingCount =
                        getMatchingCarpentersCount(snapshot.data!.docs);
                    return Text(
                      '$matchingCount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade900,
                      ),
                    );
                  }
                }
                return Container();
              },
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: selectedState,
                  onChanged: (newValue) {
                    setState(() {
                      selectedState = newValue!;
                      selectedDistrict = "District";
                    });
                  },
                  // Populate dropdown with state data
                  items: maincateg.map((state) {
                    return DropdownMenuItem<String>(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: selectedDistrict,
                  onChanged: (newValue) {
                    setState(() {
                      selectedDistrict = newValue!;
                    });
                  },
                  // Populate dropdown with district data
                  items: selectedState == "Select State"
                      ? []
                      : getDistrictList(selectedState).map((district) {
                          return DropdownMenuItem<String>(
                            value: district,
                            child: Text(district),
                          );
                        }).toList(),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("carpenterData")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document =
                              snapshot.data!.docs[index];

                          // Check if data matches selected state and district
                          if ((selectedState == "Select State" ||
                                  document["state"] == selectedState) &&
                              (selectedDistrict == "District" ||
                                  document["district"] == selectedDistrict)) {
                            // Show the ListTile
                            return ListTile(
                              title: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01,
                                    horizontal: screenWidth * 0.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          top: screenHeight * 0.056,
                                          // bottom: -50.w,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            constraints: BoxConstraints(
                                              //maxHeight: 110,
                                              maxHeight: screenHeight * 0.124,
                                            ),
                                            padding: EdgeInsets.only(
                                              //top: 20,
                                              top: screenHeight * 0.01,
                                              //bottom: 10,
                                              bottom: screenHeight * 0.01,
                                              //left: 170,
                                              left: screenWidth * 0.4,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.brown.shade900,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Name: ${document["cname"]}",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                // ignore: prefer_const_constructors
                                                SizedBox(
                                                  //height: 5,
                                                  height: screenHeight * 0.005,
                                                ),
                                                Text(
                                                  "Phone No:${document["cpno"].toString()}",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: screenHeight * 0.005,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'ID: ${document["cdob"].toString()}',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    CustomButton(
                                                        label: 'View Profile',
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CarpenterProfile(
                                                                pic: document[
                                                                    "cprofilepic"],
                                                                address: document[
                                                                    "caddress"],
                                                                age: document[
                                                                        "cage"]
                                                                    .toString(),
                                                                annaversary:
                                                                    document[
                                                                        "canniversarydate"],
                                                                dob: document[
                                                                    "cdob"],
                                                                name: document[
                                                                    "cname"],
                                                                phoneno: document[
                                                                        "cpno"]
                                                                    .toString(),
                                                                status: document[
                                                                    "cmaritalstatus"],
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  ],
                                                )
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
                                            //height: 150,
                                            height: screenHeight * 0.16,
                                            //width: 120,
                                            width: screenWidth * 0.3,
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
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            // Return an empty container when data doesn't match filters
                            return Container();
                          }
                        },
                      );
                    } else {
                      return const Text("No data");
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
    );
  }

  // Function to get the list of districts based on the selected state
  List<String> getDistrictList(String state) {
    switch (state) {
      case "Andhra Pradesh":
        return AndhraPradesh;
      case "Arunachal Pradesh":
        return ArunachalPradesh;
      case "Assam":
        return Assam;
      case "Gujarat":
        return Gujarat;
      case "Bihar":
        return Bihar;
      case "Chhattisgarh":
        return Chhattisgarh;
      case "Goa":
        return Goa;
      case "Haryana":
        return Haryana;
      case "Himachal Pradesh":
        return HimachalPradesh;
      case "Jharkhand":
        return Jharkhand;
      case "Karnataka":
        return Karnataka;
      case "Kerala":
        return Kerala;
      case "Madhya Pradesh":
        return MadhyaPradesh;
      case "Maharashtra":
        return Maharashtra;
      case "Manipur":
        return Manipur;
      case "Meghalaya":
        return Meghalaya;
      case "Mizoram":
        return Mizoram;
      case "Nagaland":
        return Nagaland;
      case "Orissa":
        return Orissa;
      case "Punjab":
        return Punjab;
      case "Rajasthan":
        return Rajasthan;
      case "Sikkim":
        return Sikkim;
      case "Tamil Nadu":
        return TamilNadu;
      case "Telangana":
        return Telangana;
      case "Tripura":
        return Tripura;
      case "Uttar Pradesh":
        return UttarPradesh;
      case "Uttarakhand":
        return Uttarakhand;
      case "West Bengal":
        return WestBengal;
      default:
        return [];
    }
  }
}
