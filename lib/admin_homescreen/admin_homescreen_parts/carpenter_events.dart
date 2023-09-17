import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CarpenterEvents extends StatefulWidget {
  const CarpenterEvents({Key? key}) : super(key: key);

  @override
  State<CarpenterEvents> createState() => _CarpenterEventsState();
}

class _CarpenterEventsState extends State<CarpenterEvents> {
  TextEditingController eventDateController = TextEditingController();
  TextEditingController eventPlaceController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController eventTitleController = TextEditingController();
  TextEditingController eventTimeFromController = TextEditingController();
  TextEditingController eventTimeToController = TextEditingController();

  TimeOfDay? selectedTimeFrom;
  TimeOfDay? selectedTimeTo;

  bool isUploading = false;

  @override
  void dispose() {
    eventDateController.dispose();
    eventPlaceController.dispose();
    eventDescriptionController.dispose();
    eventTitleController.dispose();
    eventTimeFromController.dispose();
    eventTimeToController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 10)),
    ))!;

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        eventDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay pickedTime = (await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ))!;

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          selectedTimeFrom = pickedTime;
          eventTimeFromController.text = formatTimeOfDay(selectedTimeFrom);
        } else {
          selectedTimeTo = pickedTime;
          eventTimeToController.text = formatTimeOfDay(selectedTimeTo);
        }
      });
    }
  }

  String formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) {
      return 'Select Time';
    }
    final now = DateTime.now();
    final selectedDateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final formatter = DateFormat.jm();
    return formatter.format(selectedDateTime);
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
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
        backgroundColor: Colors.green,
      ),
    );
  }

  void clearFields() {
    eventDateController.clear();
    eventPlaceController.clear();
    eventDescriptionController.clear();
    eventTitleController.clear();
    eventTimeFromController.clear();
    eventTimeToController.clear();
    selectedTimeFrom = null;
    selectedTimeTo = null;
  }

  Future<void> addEvent() async {
    setState(() {
      isUploading = true;
    });

    final eventDate = eventDateController.text.trim();
    final eventPlace = eventPlaceController.text.trim();
    final eventDescription = eventDescriptionController.text.trim();
    final eventTitle = eventTitleController.text.trim();
    final eventTimeFrom = eventTimeFromController.text.trim();
    final eventTimeTo = eventTimeToController.text.trim();

    if (eventDate.isEmpty ||
        eventPlace.isEmpty ||
        eventDescription.isEmpty ||
        eventTimeFrom.isEmpty ||
        eventTimeTo.isEmpty ||
        eventTitle.isEmpty) {
      showErrorSnackbar('Please fill all fields.');
      setState(() {
        isUploading = false;
      });
      return;
    }

    showLoadingDialog();

    final currentTime = Timestamp.now();

    final eventData = {
      "eventTitle": eventTitle,
      "eventDate": eventDate,
      "eventPlace": eventPlace,
      "eventDescription": eventDescription,
      "eventTimeFrom": eventTimeFrom,
      "eventTimeTo": eventTimeTo,
      "time": currentTime,
    };

    try {
      await FirebaseFirestore.instance.collection("events").add(eventData);
      Navigator.pop(context); // Hide the loading dialog
      showSuccessSnackbar('Event added successfully!');
      clearFields();
    } catch (error) {
      showErrorSnackbar('Error: $error');
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  Future<void> deleteEvent(String documentId) async {
    bool confirmDelete = false;

    // Show a confirmation dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        // User confirmed deletion, proceed to delete the event
        FirebaseFirestore.instance
            .collection("events")
            .doc(documentId)
            .delete()
            .then((_) {
          showSuccessSnackbar('Event deleted successfully!');
        }).catchError((error) {
          showErrorSnackbar('Error deleting event: $error');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("events")
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }

                final events = snapshot.data?.docs ?? [];

                if (events.isEmpty) {
                  return Center(
                    child: Text("No events found."),
                  );
                }

                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index].data() as Map<String, dynamic>;
                    final documentId = events[index].id;
                    return EventListItem(
                      event: event,
                      documentId: documentId,
                      onDelete: () => deleteEvent(documentId),
                    );
                  },
                );
              },
            ),
          ),
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
                    return SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: eventTitleController,
                                  cursorColor: Colors.brown.shade900,
                                  decoration: InputDecoration(
                                    labelText: 'Event Title',
                                    labelStyle: TextStyle(
                                      color: Colors.brown.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        width: 3,
                                        color: Colors.brown.shade900,
                                      ),
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
                                  controller: eventDescriptionController,
                                  cursorColor: Colors.brown.shade900,
                                  decoration: InputDecoration(
                                    labelText: 'Event Description',
                                    labelStyle: TextStyle(
                                      color: Colors.brown.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        width: 3,
                                        color: Colors.brown.shade900,
                                      ),
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
                                  controller: eventPlaceController,
                                  cursorColor: Colors.brown.shade900,
                                  decoration: InputDecoration(
                                    labelText: 'Event Venue',
                                    labelStyle: TextStyle(
                                      color: Colors.brown.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        width: 3,
                                        color: Colors.brown.shade900,
                                      ),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        controller: eventDateController,
                                        cursorColor: Colors.brown.shade900,
                                        onTap: () {
                                          _selectDate(context);
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Event Date',
                                          labelStyle: TextStyle(
                                            color: Colors.brown.shade900,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                              width: 3,
                                              color: Colors.brown.shade900,
                                            ),
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
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          if (!isUploading) {
                                            _selectTime(context, true);
                                          }
                                        },
                                        child: TextFormField(
                                          controller: eventTimeFromController,
                                          enabled: false,
                                          cursorColor: Colors.brown.shade900,
                                          decoration: InputDecoration(
                                            labelText: 'Time From',
                                            labelStyle: TextStyle(
                                              color: Colors.brown.shade900,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                width: 3,
                                                color: Colors.brown.shade900,
                                              ),
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
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          if (!isUploading) {
                                            _selectTime(context, false);
                                          }
                                        },
                                        child: TextFormField(
                                          controller: eventTimeToController,
                                          enabled: false,
                                          cursorColor: Colors.brown.shade900,
                                          decoration: InputDecoration(
                                            labelText: 'Time To',
                                            labelStyle: TextStyle(
                                              color: Colors.brown.shade900,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                width: 3,
                                                color: Colors.brown.shade900,
                                              ),
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
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                child: const Text('Add Event'),
                                onPressed: () {
                                  addEvent();
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 7.0),
                                  backgroundColor: Colors.brown.shade900,
                                  shape: const StadiumBorder(),
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                child: const Text('Close'),
                                onPressed: () {
                                  clearFields();
                                  Navigator.pop(context);
                                },
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
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class EventListItem extends StatelessWidget {
  final Map<String, dynamic> event;
  final String documentId;
  final VoidCallback onDelete;

  EventListItem({
    required this.event,
    required this.documentId,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        decoration: BoxDecoration(
          color: Colors.brown.shade200,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        height: 170,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    event['eventTitle'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  InkWell(
                    onTap:
                        onDelete, // Call the onDelete callback to delete the event
                    child: Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/logo.png"),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 75,
                    width: 75,
                  ),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          event['eventDate'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 6),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          event['eventDescription'],
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(event['eventPlace']),
                  Text("${event['eventTimeFrom']} - ${event['eventTimeTo']}"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
