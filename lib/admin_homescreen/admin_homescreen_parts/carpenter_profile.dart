import 'package:flutter/material.dart';

class CarpenterProfile extends StatefulWidget {
  const CarpenterProfile(
      {required this.address,
      required this.age,
      required this.annaversary,
      required this.dob,
      required this.name,
      required this.phoneno,
      required this.status,
      required this.pic,
      super.key});
  final String pic;
  final String name;
  final String age;
  final String phoneno;
  final String address;
  final String dob;
  final String status;
  final String annaversary;

  @override
  State<CarpenterProfile> createState() => _CarpenterProfileState();
}

class _CarpenterProfileState extends State<CarpenterProfile> {
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
          'PROFILE',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 10),
                      image: DecorationImage(
                        image: NetworkImage(widget.pic),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: screenHeight * 0.2,
                    width: screenWidth * 0.4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Text(
                        "NAME: ${widget.name}",
                        style: TextStyle(
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Text(
                        "Age: ${widget.age.toString()}",
                        style: TextStyle(
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Text(
                        "Phone No: ${widget.phoneno.toString()}",
                        style: TextStyle(
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Text(
                        "Address: ${widget.address}",
                        style: TextStyle(
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Text(
                        "Date Of Birth: ${widget.dob}",
                        style: TextStyle(
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Text(
                        "Maritial Status: ${widget.status}",
                        style: TextStyle(
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Text(
                        "Anniversary Date: ${widget.annaversary}",
                        style: TextStyle(
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
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
