import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testm/locarb.dart';
import 'package:testm/privacy.dart';

const Color mColor = Color(0xFF0C3888);

class loc extends StatefulWidget {
  static const String screenRoute = 'loc_screen';

  @override
  _LocScreenState createState() => _LocScreenState();
}

class _LocScreenState extends State<loc> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  Future<void> _checkAndRequestLocationPermission() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      // إذا كان الإذن مرفوضًا، نطلبه
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      // إذا تم رفض الإذن نهائيًا، نوجه المستخدم إلى إعدادات التطبيق
      await openAppSettings();
    } else if (status.isGranted) {
      // إذا تم منح الإذن، يمكنك الوصول إلى الموقع
      _useLocation();
    } else if (status.isRestricted) {
      // إذا كان الإذن محدودًا
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("الوصول إلى الموقع محدود."),
        ),
      );
    }
  }

  void _useLocation() {

    print("Location access granted!");
  }

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();  //  AnimationController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

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
                  Navigator.pushNamed(context, locarb.screenRoute);
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
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Icon(
                    size: screenHeight * 0.2,
                    Icons.location_on_sharp,
                    color: Colors.white,
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  border: Border(
                    top: BorderSide(color: Colors.black38, width: 5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: Text(
                        'Location',
                        style: TextStyle(
                          fontSize: screenHeight * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 10, left: 20, bottom: 10),
                      child: Text(
                        'We use your location to help find nearby stations and give you the best directions.',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildContinueButton(context, screenHeight),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, double screenHeight) {
    return Center(
      child: Container(
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
        child: MaterialButton(
          onPressed: () {
            Navigator.pushNamed(context, privacy.screenRoute);
          },
          child: Text(
            'CONTINUE',
            style: TextStyle(
              fontSize: screenHeight * 0.025,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
