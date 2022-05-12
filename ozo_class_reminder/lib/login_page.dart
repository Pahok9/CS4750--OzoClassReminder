import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ozo_class_reminder/signup_page.dart';
import 'package:ozo_class_reminder/widgets.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'color_funct.dart';

class LoginPage extends StatefulWidget {
  @override
  _DemoEditTextPageState createState() => _DemoEditTextPageState();
}

class _DemoEditTextPageState extends State<LoginPage> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("74C69D"),
              hexStringToColor("52B788"),
              hexStringToColor("1B4332")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter
          )
        ),
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      50, MediaQuery.of(context).size.height * 0.05, 50, MediaQuery.of(context).size.height),
                  child: Column(
                    children: <Widget>[
                      logoWidget("assets/images/logo2.png"),
                      const SizedBox(
                        height: 20,
                      ),
                      textField("Email", Icons.person_outline, false,
                          usernameController
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      textField("Password", Icons.lock_outline, true,
                          passwordController
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      firebaseButton(context, "Log In", Colors.yellow, () {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                            email: usernameController.text,
                            password: passwordController.text)
                            .then((value) {
                          print("Logged in successfully");
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MainPage(title: '', index: 0)));
                        }).onError((error, stackTrace) {
                          print("Error ${error.toString()}");
                        });
                      }),
                      firebaseButton(context, "Sign Up", Colors.white, () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUpPage()));
                      }),
                      // signUpButton()
                    ],
                  )
              )
          )
      ),
    );
  }
}


