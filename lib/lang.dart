import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testm/%20notarb.dart';
import 'package:testm/notifications.dart';

const Color mColor = Color(0xFF0B235B);

class lang extends StatelessWidget {
  static const String screenRoute = 'lang_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automatically Implies Leading: false,
        backgroundColor: Colors.white12,
      ),
      body: Container(
        color: Colors.white12,
        width: double.infinity,
        child: Column(
          children: [
            _buildIconSection(),
            _buildLanguageButtons(context),
          ],
        ),
      ),
    );
  }


  Widget _buildIconSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 40),
          width: 350,
          child: const Icon(
            Icons.translate,
            size: 350,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }

  // قسم الأزرار الخاصة باللغات
  Widget _buildLanguageButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50,left: 20,),
      child: Row(
        children: [
          _buildLanguageButton(
            context,
            'اللغه العربية',
                () {
              Navigator.pushNamed(context, notarb.screenRoute);
            },
          ),
          const SizedBox(width: 65),
          _buildLanguageButton(
            context,
            'English',
                () {
              Navigator.pushNamed(context, notifications.screenRoute);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(
      BuildContext context,
      String language,
      Function() onPressed,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 70,
        bottom: 150,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: mColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        width: 150,
        height: 110,
        child: MaterialButton(
          onPressed: onPressed,
          child: Text(
            language,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
