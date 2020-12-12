import 'package:flutter/material.dart';
import 'package:jgamer/coins.dart';
import 'package:provider/provider.dart';
import 'package:jgamer/auth.dart';
import 'constants.dart';
import 'package:jgamer/Home.dart';

enum authMode {
  signinEmail,
  signinGoogle,
  signinFB,
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
  var form = GlobalKey<FormState>();
  authMode currentAuthMode;
  Map userData = {
    "name": null,
    "id": null,
    "email": null,
    "imgUrl": null,
    "password": null
  };
  List userKeys = [];
  var auth = Auth();

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
      duration: Duration(milliseconds: 1000),
    )..forward();
    super.initState();
  }

  void forwardAnimation() {
    animationController.forward();
    animationController2.forward();
  }

  void reverseAnimation() {
    animationController.reverse();
    animationController2.reverse();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var coins = Provider.of<Coins>(context, listen: false);

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
            (currentAuthMode == null)
                ? SingleChildScrollView(
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
                                    left: 10 +
                                        textAnimationController.value * 30),
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
                        AnimatedBuilder(
                          animation: textAnimationController,
                          builder: (_, __) {
                            return Opacity(
                              opacity: textAnimationController.value,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                                margin: EdgeInsets.only(
                                  top: 50,
                                ),
                                child: RaisedButton(
                                  onPressed: () {
                                    forwardAnimation();
                                    setState(() {
                                      currentAuthMode = authMode.signinEmail;
                                    });
                                  },
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ListTile(
                                    leading: Image.asset(
                                      "assets/email.png",
                                      width: 30,
                                      color: Colors.black,
                                      height: 30,
                                    ),
                                    title: Text(
                                      "Sign in with Email",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Quicksand",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        AnimatedBuilder(
                          animation: textAnimationController,
                          builder: (_, __) {
                            return Opacity(
                              opacity: textAnimationController.value,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                                margin: EdgeInsets.only(
                                  top: 10,
                                ),
                                child: RaisedButton(
                                  onPressed: () async {
                                    var res = await auth.loginWithGoogle();
                                    setState(() {
                                      forwardAnimation();
                                      currentAuthMode = authMode.signinGoogle;
                                      userData = res[0];
                                      userKeys = res[1];
                                      coins.loadUser(userKeys[2], userKeys[0]);
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Colors.red[800],
                                  child: ListTile(
                                    leading: Image.asset(
                                      "assets/google.png",
                                      width: 30,
                                      height: 30,
                                    ),
                                    title: Text(
                                      "Sign in with Google",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontFamily: "Quicksand",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        AnimatedBuilder(
                          animation: textAnimationController,
                          builder: (_, __) {
                            return Opacity(
                              opacity: textAnimationController.value,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                                margin: EdgeInsets.only(
                                  top: 10,
                                ),
                                child: RaisedButton(
                                  onPressed: () async {
                                    var res = await auth.loginWithFB();
                                    setState(() {
                                      forwardAnimation();
                                      currentAuthMode = authMode.signinFB;
                                      if (!res["status"]) {
                                        currentAuthMode = null;
                                        reverseAnimation();
                                      } else {
                                        userData = res["data"];
                                        userKeys = res["keys"];
                                        coins.loadUser(
                                            userKeys[2], userKeys[0]);
                                      }
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Colors.indigo[800],
                                  child: ListTile(
                                    leading: Image.asset(
                                      "assets/facebook.png",
                                      width: 30,
                                      height: 30,
                                    ),
                                    title: Text(
                                      "Sign in with Facebook",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontFamily: "Quicksand",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: double.infinity,
                    child: currentAuthMode == authMode.signinEmail
                        ? Container(
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Form(
                                    key: form,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 180),
                                            child: TextFormField(
                                              cursorColor: Colors.white,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Quicksand",
                                              ),
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                labelText: "Email",
                                                fillColor: Colors.white,
                                                focusColor: Colors.white,
                                                hoverColor: Colors.white,
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                labelStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Quicksand"),
                                              ),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return "Enter an email address";
                                                }
                                                if (!value.contains("@")) {
                                                  return "Enter a valid email address";
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                userData["email"] = value;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            obscureText: true,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            cursorColor: Colors.white,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Quicksand",
                                            ),
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              labelText: "Password",
                                              fillColor: Colors.white,
                                              focusColor: Colors.white,
                                              hoverColor: Colors.white,
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              labelStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Quicksand"),
                                            ),
                                            validator: (value) {
                                              if (value.length < 6) {
                                                return "Passwords must be atleast six characters long";
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              userData["password"] = value;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 50,
                                  bottom: 70,
                                  child: FloatingActionButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        child: Center(
                                          child: Container(
                                            height: 150,
                                            width: 150,
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      );
                                      form.currentState.save();
                                      var res = await auth.logInWithEmail(
                                          userData["email"],
                                          userData["password"]);
                                      Navigator.of(context).pop();
                                      if (res[0]) {
                                        coins.loadUser(res[1][2], res[1][0]);
                                        userKeys = res[1];
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (ctx) =>
                                                Home(userData, userKeys),
                                          ),
                                        );
                                      }
                                    },
                                    child: Icon(Icons.arrow_right_alt),
                                    backgroundColor: Colors.indigo[900],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 50, left: 20),
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      setState(() {
                                        currentAuthMode = null;
                                        reverseAnimation();
                                      });
                                    },
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height: double.infinity,
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 50, left: 20),
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      setState(() {
                                        currentAuthMode = null;
                                        reverseAnimation();
                                      });
                                    },
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  height: 200,
                                  margin: EdgeInsets.only(top: 100),
                                  alignment: Alignment.center,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    child: Container(
                                      color: Colors.white,
                                      height: 50,
                                      width: 50,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        child: Image.network(
                                          userData["imgUrl"],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  margin: EdgeInsets.only(top: 250),
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: Text(
                                      userData["name"],
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 50,
                                  bottom: 70,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                Home(userData, userKeys)),
                                      );
                                    },
                                    child: Icon(Icons.arrow_right_alt),
                                    backgroundColor: Colors.indigo[900],
                                  ),
                                ),
                              ],
                            ),
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
