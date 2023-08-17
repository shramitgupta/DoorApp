import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CarpenterWhatToSend extends StatefulWidget {
  const CarpenterWhatToSend({Key? key}) : super(key: key);

  @override
  State<CarpenterWhatToSend> createState() => _CarpenterWhatToSendState();
}

class _CarpenterWhatToSendState extends State<CarpenterWhatToSend> {
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
        title: Text(
          'WHAT TO SEND',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("giftasked").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.active) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.white, // Customize the card background color
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  document['name'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF463F3C),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  document['dphoneno'].toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF463F3C),
                                  ),
                                ),
                                Text(
                                  "Asked:" + document['gifttype'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF463F3C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            document['status'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: document['status'] == 'approved'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
