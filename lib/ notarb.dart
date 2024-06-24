import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:testm/loc.dart';
import 'package:testm/locarb.dart';
import 'package:testm/notifications.dart';
import 'package:testm/privacy.dart';

const Color mColor = Color(0xFF0C3888);

class notarb extends StatefulWidget {
  static const String screenRoute = 'notarb_screen';

  @override
  _NotarbState createState() => _NotarbState();
}

class _NotarbState extends State<notarb> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );


    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('Masark');

      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      );

      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    });
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
      appBar: AppBar(
        backgroundColor: mColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 0, right: 10),
            child: Container(
              decoration: BoxDecoration(
                color: mColor,
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
                  Navigator.pushNamed(context, notifications.screenRoute);
                },
              ),
            ),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          color: mColor,
          child: Column(
            children: [
              _buildNotificationIconSection(),
              _buildNotificationTextSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIconSection() {
    return Expanded(
      flex: 5,
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.only(top: 40),
            width: 300,
            child: const Icon(
              Icons.notifications_on,
              size: 150,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTextSection(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40),
          ),
          border: Border(
            top: BorderSide(color: Colors.black38, width: 5),
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(right:20 , top: 15,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'الإشعارات',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, right: 25, left: 20, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'سنرسل لك إشعارات حول محطات المترو وموقعك الحالي.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildContinueButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: mColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: mColor.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      width: 180,
      child:
      MaterialButton(
        onPressed: () {
          Navigator.pushNamed(context, locarb.screenRoute);
        },
        child: const Text(
          'الإستمرار',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
