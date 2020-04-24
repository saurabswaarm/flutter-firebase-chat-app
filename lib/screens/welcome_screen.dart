import 'package:flash_chat/buttonsauth.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String route = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController1;
  AnimationController animationController2;
  AnimationController animationController3;
  Animation animation2;
  Animation animation3;
  Animation animation4;

  @override
  void initState() {
    //--1st Animation
    animationController1 = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
    animationController1.forward(from: 0.0);

    animationController1.addListener(() {
      // animationController1.isCompleted ? animationController1.reverse(from: 1.0) : print('poo');
      setState(() {});
    });
    //

    //
    animationController2 = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    animationController2.forward();
    animation2 = CurvedAnimation(
      parent: animationController2,
      curve: Curves.bounceOut,
    );

    animation2.addListener(() {
      setState(() {});
    });
    //

    //
    animationController3 = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animationController3.forward();
    animation3 = ColorTween(
      begin: Colors.white,
      end: Colors.lightBlueAccent,
    ).animate(animationController3);
    animation4 = ColorTween(
      begin: Colors.white,
      end: Colors.blueAccent,
    ).animate(animationController3);

    animation3.addListener(() {
      setState(() {});
    });
    animation4.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController1.dispose();
    animationController2.dispose();
    animationController3.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                AnimLogo(height:animationController1.value * 95.0),
                Typewriter(),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            AuthButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.route);
              },
              textSize: animation2.value * 16,
              color: animation3.value,
              text: 'Login',
            ),
            AuthButton(
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.route);
              },
              textSize: animation2.value * 16,
              color: animation4.value,
              text:'Register',
            ),
          ],
        ),
      ),
    );
  }
}
