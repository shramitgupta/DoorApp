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
    //double screenWidth = MediaQuery.of(context).size.width;
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
            height: screenHeight,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 195, 162, 132),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: Hero(
                    tag: 'profileImage',
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 10, color: Colors.brown),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 70, 63, 60),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(widget.pic),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: screenHeight * 0.2,
                      width: screenHeight * 0.2,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NAME: ${widget.name}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "Age: ${widget.age.toString()}",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "Phone No: ${widget.phoneno.toString()}",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "Address: ${widget.address}",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "Date Of Birth: ${widget.dob}",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "Marital Status: ${widget.status}",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "Anniversary Date: ${widget.annaversary}",
                        style: TextStyle(fontSize: 20),
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
