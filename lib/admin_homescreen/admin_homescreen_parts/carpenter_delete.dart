import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorapp/admin_homescreen/admin_homescreen_parts/carpenter_profile.dart';
import 'package:flutter/material.dart';

class CarpenterDelete extends StatefulWidget {
  const CarpenterDelete({Key? key}) : super(key: key);

  @override
  State<CarpenterDelete> createState() => _CarpenterDeleteState();
}

class _CarpenterDeleteState extends State<CarpenterDelete> {
  void deleteCarpenter(String documentId) {
    FirebaseFirestore.instance
        .collection("carpenterData")
        .doc(documentId)
        .delete()
        .then((_) {
      print("Carpenter deleted successfully!");
    }).catchError((error) {
      print("Error deleting carpenter: $error");
    });
  }

  TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("carpenterData")
                  .orderBy("points", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.active) {
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

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search by name',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                },
                                icon: Icon(Icons.clear),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
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
                                                    style: TextStyle(
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
                                          title: Text("Delete Carpenter"),
                                          content: Text(
                                              "Are you sure you want to delete this carpenter?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteCarpenter(document.id);
                                                Navigator.pop(context);
                                              },
                                              child: Text("Delete"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text("Delete"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Expanded(child: Text("No data"));
                  }
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  CustomButton({Key? key, required this.label, required this.onPressed})
      : super(key: key);

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
