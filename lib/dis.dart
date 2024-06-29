import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:testm/disarb.dart';
import 'package:testm/privacy.dart';
import 'package:http/http.dart' as http;

import 'normal.dart';

const Color myC = Color(0x93AFD8F3);
const Color myCc = Color(0xFF0C2A5D);
const Color myCu = Color(0xFF5291FA);
const Color myCustomColor = Color(0xFFE3D0CB);

class dis extends StatefulWidget {
  const dis({super.key});
  static const String screenRoute ='dis_screen';

  @override
  _disState createState() => _disState();
}

class _disState extends State<dis> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3,),
          (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>normal(destination:LatLng(30.037033,31.238362),),));
      },
    );
    getSearch();
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
                  Navigator.pushNamed(context,disarb.screenRoute);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 15,
                        right: 15,
                        bottom: 25,
                      ),
                      child: Text(
                        'Masark',
                        style: TextStyle(
                          fontSize: 55,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      child: Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 35,
                          letterSpacing: 2,
                          wordSpacing: 2,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
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
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        '\"Try Saying Mahta Atba\"',
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

getSearch()async{
  var request = http.Request('GET', Uri.parse('https://a02a-156-197-63-233.ngrok-free.app/SearchView/?search_value=سعد زغلول'));


  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    log(await response.stream.bytesToString());
  }
  else {
  print(response.reasonPhrase);
  }


}