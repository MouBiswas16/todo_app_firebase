// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addTaskToFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    String uid = user.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection("tasks")
        .doc(uid)
        .collection("mytasks")
        .doc(time.toString())
        .set({
      "title": titleController.text,
      "description": descriptionController.text,
      "time": time.toString(),
    });
    Fluttertoast.showToast(msg: "Data Added!!!");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("New Tasks"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Title",
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Description",
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.purpleAccent.shade100;
                      }
                      return Theme.of(context).primaryColor;
                    }),
                  ),
                  child: Text(
                    "Add Task",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    addTaskToFirebase();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
