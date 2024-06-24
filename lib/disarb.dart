import 'package:flutter/material.dart';
import 'package:testm/dis.dart';
import 'package:testm/privacy.dart';

import 'main.dart';

const Color myC = Color(0x93AFD8F3);
const Color myCc = Color(0xFF0C2A5D);
const Color myCu = Color(0xFF5291FA);
const Color myCustomColor = Color(0xFFE3D0CB);

class disarb extends StatefulWidget {
  const disarb({super.key});
  static const String screenRoute ='disarb_screen';

  @override
  _disState createState() => _disState();
}

class _disState extends State<disarb> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 0, right: 10),
            child: Container(
              decoration: BoxDecoration(
                color: mmColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              width: 45,
              height: 45,
              child: IconButton(
                icon: const Icon(
                  Icons.translate,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context,dis.screenRoute);
                },
              ),
            ),
          ),
        ],
        backgroundColor: myCustomColor,
      ),
      body: Container(
        width: double.infinity,
        color: myCc,
        child: Column(
          children: [
            Expanded(
              flex: 23,
              child: Container(
                decoration: const BoxDecoration(
                  color: myCustomColor,
                  borderRadius: BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(60),
                    bottomStart: Radius.circular(60),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 15,
                        right: 15,
                        bottom: 8,
                      ),
                      child: Text(
                        'مسارك',
                        style: TextStyle(
                          fontSize: 75,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 65,
                      ),
                      child: Text(
                        ' مرحبا بك مجددا',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          wordSpacing: 2,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            top: 70,
                          ),
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) => Transform.scale(
                              scale: _animation.value,
                              child: CircleAvatar(
                                backgroundColor: myCu.withOpacity(0.1),
                                radius: 120,
                                child: CircleAvatar(
                                  backgroundColor: myCu.withOpacity(0.2),
                                  radius: 115,
                                  child: CircleAvatar(
                                    backgroundColor: myCu.withOpacity(0.3),
                                    radius: 110,
                                    child: CircleAvatar(
                                      backgroundColor: myC.withOpacity(.8),
                                      radius: 105,
                                      child: CircleAvatar(
                                        backgroundColor: myCustomColor,
                                        radius: 100,
                                        child: Icon(
                                          size: 180,
                                          Icons.mic_none_outlined,
                                          color: myCc.withOpacity(.7),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        '\"حاول ان تقول محطة العتبه\"',
                        style: TextStyle(
                          fontSize: 25,
                          wordSpacing: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: myCc.withOpacity(0),
                width: double.infinity,
                child: const Column(
                  children: [],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
