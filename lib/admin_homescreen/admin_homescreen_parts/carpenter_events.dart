import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

/// Flutter code sample for [showModalBottomSheet].

class CarpenterEvents extends StatefulWidget {
  const CarpenterEvents({super.key});

  @override
  State<CarpenterEvents> createState() => _CarpenterEventsState();
}

class _CarpenterEventsState extends State<CarpenterEvents> {
  TextEditingController eventdateController = TextEditingController();
  TextEditingController eventplaceController = TextEditingController();
  TextEditingController eventdiscriptionController = TextEditingController();
  Future<void> _selectDOB(BuildContext context) async {
    // Calculate the last selectable date, for example, 10 years from now
    DateTime lastSelectableDate = DateTime.now().add(Duration(days: 365 * 10));

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: lastSelectableDate, // Set the last selectable date
    );

    if (pickedDate != null) {
      setState(() {
        eventdateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  bool isUploading = false;

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Event added successfully!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uploading'),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Please wait...'),
            ],
          ),
        );
      },
    );
  }

  void showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green, // You can customize the background color
        behavior: SnackBarBehavior.floating, // You can adjust the behavior
      ),
    );
  }

  Future<void> eventsadd() async {
    log('hi');
    setState(() {
      isUploading = true;
    });

    String eventdate = eventdateController.text.trim();
    String eventplace = eventplaceController.text.trim();
    String eventdiscription = eventdiscriptionController.text.trim();

    if (eventdate.isEmpty || eventplace.isEmpty || eventdiscription.isEmpty) {
      showErrorSnackbar('Please fill all fields.');
      setState(() {
        isUploading = false;
      });
      return;
    }

    eventdateController.clear();
    eventplaceController.clear();
    eventdiscriptionController.clear();
    if (eventdate.isNotEmpty &&
        eventdiscription.isNotEmpty &&
        eventplace.isNotEmpty) {
      showLoadingDialog(); // Show the loading dialog
      Timestamp currentTime = Timestamp.now();
      Map<String, dynamic> eventsData = {
        "eventdate": eventdate,
        "eventplace": eventplace,
        "eventdiscription": eventdiscription,
        "time": currentTime,
      };

      try {
        await FirebaseFirestore.instance.collection("events").add(eventsData);
        // Data uploaded successfully, show success message
        Navigator.pop(context); // Hide the loading dialog
        showSuccessSnackbar('Event added successfully!');
      } catch (error) {
        // Handle any errors that may occur during the upload
        showErrorSnackbar('Error: $error');
      }

      setState(() {
        isUploading = false;
      });
    } else {
      log('fill data');
      setState(() {
        isUploading = false;
      });
    }
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.brown.shade900,
        title: const Text(
          'ADD EVENTS',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(
            child: ElevatedButton(
              child: const Text('ADD EVENTS'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
                backgroundColor: Colors.brown.shade900,
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: screenHeight * 0.4,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: eventdiscriptionController,
                                enabled:
                                    !isLoading, // Disable the field when isLoading is true
                                cursorColor: Colors.brown.shade900,
                                decoration: InputDecoration(
                                  labelText: 'Enter Event Discription',
                                  labelStyle:
                                      TextStyle(color: Colors.brown.shade900),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        width: 3, color: Colors.brown.shade900),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 3,
                                      color: Colors.brown.shade900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: eventplaceController,
                                enabled:
                                    !isLoading, // Disable the field when isLoading is true
                                cursorColor: Colors.brown.shade900,
                                decoration: InputDecoration(
                                  labelText: 'Enter Event Venue',
                                  labelStyle:
                                      TextStyle(color: Colors.brown.shade900),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        width: 3, color: Colors.brown.shade900),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 3,
                                      color: Colors.brown.shade900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: eventdateController,
                                enabled: !isLoading,
                                cursorColor: Colors.brown.shade900,
                                onTap: () {
                                  _selectDOB(context);
                                },
                                decoration: InputDecoration(
                                  labelText: 'Enter Date',
                                  labelStyle:
                                      TextStyle(color: Colors.brown.shade900),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        width: 3, color: Colors.brown.shade900),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 3,
                                      color: Colors.brown.shade900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              child: const Text('Add Events'),
                              onPressed: () {
                                eventsadd();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 7.0),
                                backgroundColor: Colors.brown.shade900,
                                shape: const StadiumBorder(),
                              ),
                            ),
                            ElevatedButton(
                              child: const Text('Close'),
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 7.0),
                                backgroundColor: Colors.brown.shade900,
                                shape: const StadiumBorder(),
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
        ],
      ),
    );
  }
}
