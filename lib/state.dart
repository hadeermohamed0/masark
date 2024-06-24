import 'package:flutter/material.dart';
import 'package:testm/dis.dart';
import 'package:testm/normal.dart';
import 'package:testm/privacy.dart';
import 'package:testm/statearb.dart';
const Color mColor = Color(0xFF0B235B);
class state extends StatelessWidget {
  static const String screenRoute = 'state_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 0,
              right: 10,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: mmColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.2),
                    spreadRadius: .7,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              width: 45,
              height: 45,

              child: IconButton(

                icon: const Icon(
                    color: Colors.white,
                    size:30,
                    Icons.translate),


                onPressed: () {

                  Navigator.pushNamed(context, statearb.screenRoute);
                },
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white30,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top:0,
        ),
        child: Container(
          color: Colors.white30,
          height: double.infinity,
          child: Column(

            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Special....OR ',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 25,
                        ),
                        child: Text('Normal?',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  )

                ],
              ),
              SizedBox(height: 10), // Added space before the Row

              Padding(
                padding: const EdgeInsets.only(

                  top: 100,
                  bottom: 100,
                ),
                child: Row(

                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          child:
                          // MyImage(imagePath: 'images/bb.png'),
                          const Icon(
                            Icons.blind_rounded,
                            size: 230,
                            color: mColor,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                            top: 90,

                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: mColor.withOpacity(.9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: 150,
                            child:

                            Container(
                              decoration: BoxDecoration(
                                color: mColor.withOpacity(0.9), // اللون الأساسي للزر
                                borderRadius: BorderRadius.circular(15), // زوايا دائرية
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // لون الظلال
                                    spreadRadius: 2, // مدى انتشار الظلال
                                    blurRadius: 5, // مدى وضوح الظلال
                                    offset: Offset(0, 3), // إزاحة الظلال لتكون أسفل الزر
                                  ),
                                ],
                              ),
                              width: 150, // عرض الزر
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, dis.screenRoute);
                                },
                                child: Text(
                                  'Special',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )

                          ),
                        )
                      ],
                    ),
                    // SizedBox(width: 5),
                    Column(
                      children: [
                        Container(

                          width: 200,
                          child:
                          // MyImage(imagePath: 'images/dd.png'),
                          const Icon(
                            Icons.man_rounded,
                            size: 250,
                            color: mColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 70,
                            left: 25,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: mColor.withOpacity(.9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: 150,
                            child:
                            Container(
                              decoration: BoxDecoration(
                                color: mColor.withOpacity(0.9), // اللون الأساسي للزر
                                borderRadius: BorderRadius.circular(15), // زوايا دائرية
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // لون الظلال
                                    spreadRadius: 2, // مدى انتشار الظلال
                                    blurRadius: 5, // مدى وضوح الظلال
                                    offset: Offset(0, 3), // إزاحة الظلال لتكون أسفل الزر
                                  ),
                                ],
                              ),
                              width: 150, // عرض الزر
                              child:
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, normal.screenRoute);
                                },
                                child: Text(
                                  'Normal',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )

                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );

  }

}
