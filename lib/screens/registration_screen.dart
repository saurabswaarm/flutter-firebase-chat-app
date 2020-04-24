import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/buttonsauth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static String route = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool spinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
              inAsyncCall: spinner,
              child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AnimLogo(height: 200),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kInputDecoration.copyWith(hintText: 'Username'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kInputDecoration.copyWith(hintText: 'Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              AuthButton(
                onPressed: () async {
                  setState((){
                    spinner = true;
                  });
                  try {
                    AuthResult newlyCreatedUser =
                        await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    if (newlyCreatedUser.user != null) {
                      setState((){
                        spinner = false;
                      });
                      Navigator.pushNamed(context, ChatScreen.route);
                      print(newlyCreatedUser);
                    }
                  } catch (e) {
                    print('we have an error $e');
                  }
                },
                color: Colors.lightBlueAccent,
                text: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
