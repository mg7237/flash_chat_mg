import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flash_chat/CustomWidgets.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'WelcomeScreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  static Duration timerDuration = Duration(seconds: 5);

  AnimationController animationController;
  Animation animation;
  ColorTween colorTween;

  @override
//  void initState() {
//    super.initState();
////    animationController =
////        AnimationController(vsync: this, duration: timerDuration);
////
////    animation =
////        CurvedAnimation(parent: animationController, curve: Curves.bounceIn);
////    animationController.forward();
////
////    animationController.addListener(() {
////      print(animationController.value);
////      print(animationController.status);
////
////      if (animationController.status.toString() ==
////          'AnimationStatus.completed') {
////        animationController.reverse();
////      }
////      if (animationController.status == AnimationStatus.dismissed) {
////        animationController.forward();
////      }
////      setState(() {});
////    });
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    animationController.dispose();
//  }

  @override
  Widget build(BuildContext context) {
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
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 40.0,
                  ),
                ),
                SizedBox(
                  width: 250.0,
                  child: ScaleAnimatedTextKit(
                      onTap: () {
                        print("Tap Event");
                      },
                      text: ['Flash', "Chat"],
                      textStyle:
                          TextStyle(fontSize: 70.0, fontFamily: "Canterbury"),
                      textAlign: TextAlign.start,
                      alignment:
                          AlignmentDirectional.topStart // or Alignment.topLeft
                      ),
                )
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedTextBox(
                color: Colors.green,
                text: 'Sign In',
                onPress: () => Navigator.pushNamed(context, LoginScreen.id)),
            RoundedTextBox(
                color: Colors.blue,
                text: 'Sign Up',
                onPress: () =>
                    Navigator.pushNamed(context, RegistrationScreen.id)),
          ],
        ),
      ),
    );
  }
}
