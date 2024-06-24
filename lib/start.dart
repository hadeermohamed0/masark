import 'package:flutter/material.dart';
const Color myCustomColor = Color(0xFF3E4CC6);
const Color mmColor = Color(0xFF05183F);
class start extends StatefulWidget {
  static const String screenRoute = 'start_screen';

  @override
  _StartScreenState createState() => _StartScreenState();
}
class _StartScreenState extends State<start> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _imageAnimation;
  late Animation<Offset> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _imageAnimation = Tween<Offset>(begin: const Offset(0, -2), end: const Offset(0, 0)).animate(_controller);
    _buttonAnimation = Tween<Offset>(begin: const Offset(0, 2), end: const Offset(0, 0)).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [myCustomColor, Colors.white38],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _imageAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: SizedBox(
                    width: width * 0.8,
                    child: MyImage(),
                  ),
                ),
              ),
              SizedBox(height: height * 0.05),
              SlideTransition(
                position: _buttonAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: mmColor.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  width: width * 0.5,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'notifications_screen');
                    },
                    child: Text(
                      'Start',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: myCustomColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage image = AssetImage('images/masark.png');
    Image myImage = Image(image: image, fit: BoxFit.cover);

    return SizedBox(child: myImage);
  }
}
