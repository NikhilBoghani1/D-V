import 'package:digital_vault/const/constants.dart';
import 'package:digital_vault/screen/login_register/login_register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

            Future<void> _fetchUserName() async {
              User? user = _auth.currentUser;

              if (user != null) {
                try {
                  DocumentSnapshot userDocument =
                  await _firestore.collection('users').doc(user.uid).get();

                  if (userDocument.exists) {
                    setState(() {
            name = userDocument['name'] ?? 'No name found';
            email = userDocument['email'] ?? 'No email found';
          });
        } else {
          print('User document does not exist.');
        }
      } catch (e) {
        print('Error fetching user name: $e');
      }
    } else {
      print('No user is currently logged in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(email.isNotEmpty ? "Hey, $email" : "Loading..."),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.logout),
      //       onPressed: () async {
      //         await _auth.signOut();
      //         Navigator.of(context).pushReplacement(
      //           MaterialPageRoute(
      //             builder: (_) => LoginRegisterScreen(),
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 35),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Image.asset(
                        width: 45,
                        height: 45,
                        "assets/images/user_profile.png",
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: CupertinoColors.systemRed.withOpacity(0.2),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          "Hi $name",
                          style: TextStyle(
                            fontFamily: myConstants.RobotoR,
                            fontSize: 16,
                          ),
                        ),
                      ],
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
