import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ozo_class_reminder/widgets.dart';
import 'main.dart';
import 'color_funct.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();

}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late String userID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("74C69D"),
                hexStringToColor("52B788"),
                hexStringToColor("1B4332")
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    textField("Email", Icons.person_outline, false,
                        usernameController),
                    const SizedBox(
                      height: 20,
                    ),
                    textField("Password", Icons.lock_outlined, true,
                        passwordController),
                    const SizedBox(
                      height: 20,
                    ),
                    firebaseButton(context, "Sign Up", Colors.white, () {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                          email: usernameController.text,
                          password: passwordController.text)
                          .then((value) {
                        FirebaseFirestore.instance.collection("User").doc(value.user?.uid).set({
                          "Email":usernameController.text
                        });
                        FirebaseFirestore.instance.collection("User").doc(value.user?.uid).collection("Classes").doc().set({});
                        print("Created New Account");

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyApp()));
                      }).onError((error, stackTrace) {
                        print("Error ${error.toString()}");
                      });
                    })
                  ],
                ),
              ))),
    );
  }
}
