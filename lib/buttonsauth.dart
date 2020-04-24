import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AuthButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color color;
  final double textSize;

  AuthButton({this.onPressed, this.text, this.color, this.textSize = 16});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(fontSize: textSize, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class AnimLogo extends StatelessWidget {
  final double height;
  AnimLogo({this.height});
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo',
      child: Container(
        child: Image.asset('images/logo.png'),
        height: height,
      ),
    );
  }
}

class Typewriter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TypewriterAnimatedTextKit(
      totalRepeatCount: 1,
      speed: Duration(milliseconds: 200),
      text: ['Flash Chat'],
      textStyle: TextStyle(
        fontSize: 45.0,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
