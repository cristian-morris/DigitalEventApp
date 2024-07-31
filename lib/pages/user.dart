import 'package:flutter/material.dart';

class User extends StatelessWidget {
  const User({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        elevation: 0,
        title: Text("Digital Event", textAlign: TextAlign.center,),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Usuario"),
      ),
    );
  }
}