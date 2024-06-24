import 'package:flutter/material.dart';
import 'package:testm/privacyarb.dart';
import 'package:testm/state.dart';

const Color mColor = Color(0xFF0C3888);
const Color mmColor = Color(0xFF05183F);
class privacy extends StatelessWidget {
  static const String screenRoute = 'privacy_screen';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(
              top: 0,
              right: screenWidth * 0.03,
            ),
            child:
            Container(
              decoration: BoxDecoration(
                color: mColor,
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              width: screenWidth * 0.11,
              height: screenWidth * 0.11,
              child: IconButton(
                icon: Icon(
                  Icons.translate,
                  size: screenWidth * 0.07,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, privacyarb.screenRoute);
                },
              ),
            ),
          ),
        ],
        backgroundColor: mColor,
      ),
      body: Container(
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
                      padding: EdgeInsets.only(
                        top: screenWidth * 0.45,
                      ),
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
                        topEnd: Radius.circular(screenWidth * 0.10),
                        topStart: Radius.circular(screenWidth * 0.10),
                      ),
                      border: Border(
                        top: BorderSide(
                          color: Colors.black38,
                          width: 5,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: screenWidth * 0.05), // نسبة
                        Container(
                          width: screenWidth * 0.90,
                          height: screenWidth * 0.50, // نسبة
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(screenWidth * 0.05), // نسبة
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: screenWidth * 0.05, // نسبة
                                  left: screenWidth * 0.05,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Privacy',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.10, // نسبة
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 0,
                                  left: screenWidth * 0.05, // نسبة
                                  right: screenWidth * 0.05, // نسبة
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text:
                                    'Your privacy is super important to us. By using our app, you agree to our ',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.05, // نسبة
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' and                        ',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.02), // نسبة
                        _buildContinueButton(context),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: screenWidth * 0.20, // نسبة
                    right: screenWidth * 0.10, // نسبة
                    child: Icon(
                      Icons.privacy_tip_sharp,
                      color: Colors.blueAccent,
                      size: screenWidth * 0.10, // نسبة
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: mColor,
        borderRadius: BorderRadius.circular(screenWidth * 0.05), // نسبة
        boxShadow: [
          BoxShadow(
            color: mColor.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      width: screenWidth * 0.70,
      child: MaterialButton(
        onPressed: () {
          Navigator.pushNamed(context, state.screenRoute);
        },
        child: Text(
          'Okay, got it!',
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
