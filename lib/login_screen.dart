import 'package:flutter/material.dart';
import 'constants.dart';

enum authMode {
  signIn,
  signUp,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  AnimationController animationController2;
  AnimationController textAnimationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
      lowerBound: 0,
      upperBound: 1000,
    );
    animationController2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
      lowerBound: 100,
      upperBound: 200,
    );
    textAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    )..forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              child: AnimatedBuilder(
                animation: animationController,
                builder: (_, __) {
                  return Container(
                    color: klightCyan,
                    width: double.infinity,
                    height: animationController.value,
                  );
                },
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: ClipPath(
                    clipper: WhiteBoxClipper(),
                    child: Container(
                        width: 200, height: 200, color: Colors.white))),
            Positioned(
              right: 0,
              top: 0,
              child: ClipPath(
                clipper: CyanClipper(),
                child: Container(
                  width: width,
                  height: height,
                  color: klightCyan,
                ),
              ),
            ),
            Positioned(
              child: ClipPath(
                clipper: LightDeepBlueClipper(),
                child: Container(
                  height: height * 0.7,
                  color: klightDeepBlue,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: animationController2,
              builder: (_, __) {
                return ClipPath(
                  clipper: DeepBlueClipper(),
                  child: Container(
                    width: 2 * animationController2.value,
                    height: 2 * animationController2.value,
                    color: kdeepBlue,
                  ),
                );
              },
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedBuilder(
                    animation: textAnimationController,
                    builder: (_, __) {
                      return Opacity(
                        opacity: textAnimationController.value,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 170,
                              left: 10 + textAnimationController.value * 30),
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CyanClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var width = size.width;
    var height = size.height;
    var path = Path();
    path.moveTo(width, height * 0.65);
    path.quadraticBezierTo(
        width * 0.7, height * 0.7, width * 0.5, height * 0.55);
    path.lineTo(0, 0);
    path.lineTo(width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class LightDeepBlueClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var width = size.width;
    var height = size.height;
    var path = Path();
    path.lineTo(0, height * 0.975);
    path.quadraticBezierTo(width * 0.17, height, width * 0.27, height * 0.9899);
    path.quadraticBezierTo(
        width * 0.6, height * 0.97, width * 0.62, height * 0.65);
    path.quadraticBezierTo(width * 0.65, height * 0.25, width, height * 0.18);
    // path.lineTo(width, height * 0.2);

    path.lineTo(width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class DeepBlueClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var width = size.width;
    var height = size.height;
    var path = Path();
    path.lineTo(0, height);
    path.quadraticBezierTo(
        width * 0.09, height * 0.75, width * 0.4, height * 0.6);
    path.quadraticBezierTo(
        width * 0.8, height * 0.38, width * 0.75, height * 0.15);
    path.quadraticBezierTo(width * 0.725, 0.07, width * 0.75, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class WhiteBoxClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var width = size.width;
    var height = size.height;
    var path = Path();
    path.moveTo(width, 0);
    path.quadraticBezierTo(
        width * 0.8, height * 0.45, width * 0.4, height * 0.6);
    path.quadraticBezierTo(0, height * 0.8, 0, height);
    path.lineTo(width, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
