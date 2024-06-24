import 'package:flutter/material.dart';
import 'package:testm/loc.dart';
import 'package:testm/privacy.dart';
import 'package:testm/state.dart';
import 'package:testm/statearb.dart';

const Color mColor = Color(0xFF0C3888);

class privacyarb extends StatelessWidget {
  static const String screenRoute = 'privacyarb_screen';

  @override
  Widget build(BuildContext context) {
    // الحصول على أبعاد الشاشة
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0,
              right: screenWidth * 0.03,
            ),
            child:
            Container(
              decoration: BoxDecoration(
                color: mColor,
                borderRadius: BorderRadius.circular(screenWidth * 0.04), // نسبة
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              width: screenWidth * 0.11, // استخدم نسبة
              height: screenWidth * 0.11, // استخدم نسبة
              child: IconButton(
                icon: Icon(
                  Icons.translate,
                  size: screenWidth * 0.07, // استخدم نسبة
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, privacy.screenRoute);
                },
              ),
            ),
          ),
        ],
        backgroundColor: mColor,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          color: mColor,
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  color: mColor,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.20),
                        width: screenWidth * 0.8,
                        child: Icon(
                          Icons.private_connectivity,
                          size: screenWidth * 0.45,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(40),
                          topStart: Radius.circular(40),
                        ),
                        border: Border(
                          top: BorderSide(color: Colors.black38, width: 5),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.03),
                          Container(
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.22,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: screenHeight * 0.01,
                                    right: screenWidth * 0.05,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'الخصوصية',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.08,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: screenHeight * 0.0,
                                    right: screenWidth * 0.05,
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'خصوصيتك مهمة جداً بالنسبة لنا. باستخدام التطبيق، أنت توافق على ',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'الشروط والأحكام',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' و ',
                                          style: TextStyle(
                                         decoration: TextDecoration.none,
                                            color: Colors.black,
                                        ),
                                        ),
                                        TextSpan(
                                          text: 'سياسة الخصوصية',
                                          style:TextStyle(
                                            decoration: TextDecoration.underline,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          _buildContinueButton(context),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: screenHeight * 0.11,
                      left: screenWidth * 0.15,
                      child: Column(
                        children: [
                          Icon(
                            Icons.privacy_tip_sharp,
                            color: Colors.blueAccent,
                            size: screenWidth * 0.10,
                          ),
                        ],
                      ),
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

  Widget _buildContinueButton(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: mColor,
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        boxShadow: [
          BoxShadow(
            color: mColor.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      width: screenWidth * 0.70,
      child: MaterialButton(
        onPressed: () {
          Navigator.pushNamed(context, state.screenRoute);
        },
        child: Text(
          'حسنًا، فهمت!',
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
