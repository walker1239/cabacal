import 'package:caba_cal/bloc_users/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc_users/models/_user.dart';
import 'package:caba_cal/bloc_users/blocs.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';

class CustomAppBar extends PreferredSize {
  final Widget child;
  final double height;

  CustomAppBar({@required this.child, this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: Colors.white70,
      alignment: Alignment.center,
      child: child,
    );
  }
}

class Home extends StatefulWidget{
  User user;
  Home({
    @required this.user,
  });
  
  @override
  HomeState createState() =>HomeState(user:user);

}

class HomeState extends State<Home> {
  User user;
  HomeState({
    @required this.user,
  });
  @override
  Widget build(BuildContext context) {
    var namePosition = MediaQuery.of(context).size.height;
    return MaterialApp(
      // BlocBuilder will listen to changes in AuthenticationState
      // and build an appropriate widget based on the state.
      home: Scaffold(
        appBar:AppBar(title: Text("Cabacal"),),
        body:Center(
          child: Column(
            children: [
              Text("${user.userName}"),
            ],
          ),
        )
      ),
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(100, 0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addListener(() {
            setState(() {});
          });
    super.initState();
  }
  
    @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAE2D5),
      body: Center(
        child: InkWell(
          onTap: () {},
          onHover: (value) {
            if (value) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
          child: Transform.translate(
            offset: _animation.value,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                InsideScreen(),
                AnimatedScreen(controller: _controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InsideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Color(0xfffafbfa),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 3),
            blurRadius: 2.5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('For urban lovers',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffff62b2))),
          SizedBox(
            height: 10.0,
          ),
          Text(
              'As cities never sleep, there are always something going on, no matter what time!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
              )),
          SizedBox(
            height: 20.0,
          ),
          Container(
            height: 40.0,
            child: AnimatedButton(
              width: 120.0,
              height: 40,
              color: Color(0xffff62b2),
              buttonText: 'View details',
            ),
          )
        ],
      ),
    );
  }
}

class AnimatedScreen extends StatefulWidget {
  final AnimationController controller;

  AnimatedScreen({this.controller});

  @override
  _AnimatedScreenState createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  Widget visibleScreen = Container();

  Widget getScreen() {
    if (_animation.value < 0.5) {
      visibleScreen = CoverScreen();
    } else {
      visibleScreen = ImageScreen();
    }
    return visibleScreen;
  }

  @override
  void initState() {
    _animation = Tween(begin: 0.0, end: 1.0).animate(widget.controller)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.rotationY(pi * _animation.value),
      child: getScreen(),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final double height;
  final double width;
  final String buttonText;
  final Color color;

  AnimatedButton({this.height, this.width, this.buttonText, this.color});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  Color textColor;

  @override
  void initState() {
    super.initState();
    textColor = widget.color;
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween(begin: 0.0, end: widget.height).animate(
      CurvedAnimation(
        curve: Curves.easeIn,
        parent: controller,
      ),
    )..addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        width: widget.width,
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(width: 3.0, color: widget.color),
          ),
          child: InkWell(
              onHover: (value) {
                if (value) {
                  controller.forward();
                  setState(() {
                    textColor = Colors.white;
                  });
                } else {
                  controller.reverse();
                  setState(() {
                    textColor = widget.color;
                  });
                }
              },
              onTap: () {
                if(controller.status == AnimationStatus.dismissed) {
                  controller.forward();
                  textColor = Colors.white;
                } else {
                  controller.reverse();
                  textColor = widget.color;
                }
              },
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      height: animation.value,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: widget.color,
                      ),
                    ),
                  ),
                  Center(
                    child: AnimatedDefaultTextStyle(
                      child: Text(widget.buttonText),
                      duration: Duration(milliseconds: 200),
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                      curve: Curves.easeIn,
                    ),
                  )
                ],
              )),
        ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ImageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 3),
            blurRadius: 2.5,
          )
        ]
      ),
      child: kIsWeb ? Container(
        child: Image(
          image: NetworkImage('https://i.picsum.photos/id/679/200/200.jpg'),
        ),
      ): ClipPath(
        clipper: RightCornerClipper(),
        child: ImagePage()
      ),
    );
  }
}

class RightCornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(20, size.height / 2 );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/image.jpg'),
            fit: BoxFit.cover
        ),
      ),
    );
  }
}

class CoverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffff62b2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 3),
            blurRadius: 2.5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 150,
            width: 200,
            decoration: BoxDecoration(color: const Color(0xffff62b2)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.location_city,
                  color: Colors.white,
                  size: 32.0,
                ),
                Text(
                  'City break',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  'From €29',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: const Color(0xffffffff),
                  ),
                )
              ],
            ),
          ),
          ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              color: const Color(0xffffffff),
              height: 50,
              width: 200,
              child: Center(
                child: Text(
                  'View me',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffff62b2),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(size.width / 2 - 10, 0);
    path.lineTo(size.width / 2, 10.0);
    path.lineTo(size.width / 2 + 10, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}