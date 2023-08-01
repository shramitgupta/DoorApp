import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorapp/user_homescreen/user_homescreen_part.dart/user_giftdetails.dart';
import 'package:doorapp/user_homescreen/user_homescreen_part.dart/user_pointsused_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPointsUsed extends StatefulWidget {
  const UserPointsUsed({Key? key}) : super(key: key);

  @override
  State<UserPointsUsed> createState() => _UserPointsUsedState();
}

class _UserPointsUsedState extends State<UserPointsUsed> {
  @override
  Widget build(BuildContext context) {
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
          'POINTS USERS',
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('giftasked')
                  .where('userid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                double totalPoints = 0.0;
                for (var item in snapshot.data!.docs) {
                  totalPoints += item['points'];
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BalanceModel(
                      label: 'Points Used',
                      value: totalPoints,
                      decimal: 0,
                    ),
                    const SizedBox(height: 100),
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 70, 63, 60),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserGiftDetails()),
                          );
                        },
                        child: const Text(
                          'Use the Points',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 70, 63, 60),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UserPointsUsedHistory()),
                          );
                        },
                        child: const Text(
                          'Points History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class BalanceModel extends StatelessWidget {
  final String label;
  final dynamic value;
  final int decimal;
  const BalanceModel({
    Key? key,
    required this.label,
    required this.value,
    required this.decimal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.55,
          decoration: const BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Center(
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        Container(
          height: 90,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade100,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: AnimatedCounter(
            count: value,
            decimal: decimal,
          ),
        ),
      ],
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  final int decimal;
  final dynamic count;
  const AnimatedCounter({
    Key? key,
    required this.count,
    required this.decimal,
  }) : super(key: key);

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = _controller;
    setState(() {
      _animation = Tween(begin: _animation.value, end: widget.count)
          .animate(_controller);
    });
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Center(
          child: Text(
            _animation.value.toStringAsFixed(widget.decimal),
            style: const TextStyle(
              color: const Color.fromARGB(255, 70, 63, 60),
              fontSize: 40,
              fontFamily: 'Acme',
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.black,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
