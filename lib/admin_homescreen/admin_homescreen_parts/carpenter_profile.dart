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
        backgroundColor: Colors.brown.shade900,
        title: const Text(
          'PROFILE',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Hero(
                  tag: 'profileImage',
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 10, color: Colors.brown.shade900),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.shade900,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
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
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(
                        'images/logo.png',
                        height: screenHeight * 0.22,
                        //width: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
