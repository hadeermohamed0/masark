import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:testm/ notarb.dart';
import 'package:testm/loc.dart';


const Color mColor = Color(0xFF0C3888);

class notifications extends StatefulWidget {
  static const String screenRoute = 'notifications_screen';

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<notifications> with SingleTickerProviderStateMixin {
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

    // إنشاء أنيميشن التوسع (expand)
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
            child:
            Container(
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
              child:
              IconButton(
                icon: const Icon(
                  Icons.translate,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, notarb.screenRoute);
                },
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: mColor,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Center(
                // استخدام ScaleTransition لإضافة تأثير التوسع للأيقونة
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    width: 300,
                    child: const Icon(
                      size: 150,
                      Icons.notifications_on,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
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
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 10,
                          top: 10
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Notification',
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
                      padding: EdgeInsets.only(top: 10,right: 10,left: 20,bottom: 5),
                      child:
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Be in the know. We\'ll send you updates about metro stations and your current location.',
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
                    const SizedBox(height:0 ),
                    _buildContinueButton(context),
                  ],
                ),
              ),
            ),
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
          Navigator.pushNamed(context, loc.screenRoute);
        },
        child: const Text(
          'CONTINUE',
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
