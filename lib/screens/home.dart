// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_firebase/screens/add_task.dart';
import 'package:todo_app_firebase/screens/description.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String uid =
      ""; // for the initial uid that will later replace with the firebase given uid

  /*   update the uid every time that we get and replace with the empty uid    */
  @override
  void initState() {
    getuid();
    super.initState();
  }

  /*  the get uid of the user and assign it to the empty uid   */
  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    setState(() {
      uid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("To-Do App"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout, // for loging out the current user
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white70,
            child: StreamBuilder(
              /*    takes the data from the firebase as streams and takes action upon on those in builder section   */
              stream: FirebaseFirestore.instance
                  .collection("tasks")
                  .doc(uid)
                  .collection("mytasks")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  /*  if the task already added on the task home page then enable them to the description screen if the card button taped  */
                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DescriptionScreen(
                                title: docs[index]["title"],
                                description: docs[index]["description"],
                              ),
                            ),
                          );
                        },
                        /*  button for the task cards  */
                        child: SizedBox(
                          height: 80,
                          width: double.infinity,
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(20),
                                      child: Text(
                                        docs[index]["title"],
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    /*   for deleting tasks  */
                                    SizedBox(
                                      child: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection("tasks")
                                              .doc(uid)
                                              .collection("mytasks")
                                              .doc(docs[index]["time"])
                                              .delete();
                                        },
                                      ),
                                    ),
                                    /*  mark task as completed  */
                                    SizedBox(
                                      child: IconButton(
                                        icon: Icon(Icons.check),
                                        onPressed: () async {
                                          Fluttertoast.showToast(
                                            msg: "Task Completed!!!",
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
        /*   floating action button part for adding new tasks  */
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTask(),
              ),
            );
          },
        ),
      ),
    );
  }
}
