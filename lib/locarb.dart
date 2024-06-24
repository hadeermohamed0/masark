import 'package:flutter/material.dart';
import 'package:testm/loc.dart';
import 'package:testm/privacyarb.dart';
import 'package:testm/statearb.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

const Color mColor = Color(0xFF0C3888);

class locarb extends StatefulWidget {
  static const String screenRoute = 'locarb_screen';


  @override
  _LocArbState createState() => _LocArbState();

}

class _LocArbState extends State<locarb> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  Future<void> _checkAndRequestLocationPermission() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      // إذا كان الإذن مرفوضًا، نطلبه
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {

      await openAppSettings();
    } else if (status.isGranted) {

      _useLocation();
    } else if (status.isRestricted) {

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
    _checkAndRequestLocationPermission();
    super.initState();
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
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
                  Navigator.pushNamed(context, loc.screenRoute);
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
              _buildLocationIconSection(),
              _buildLocationTextSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationIconSection() {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Expanded(
      flex: 5,
      child: Container(
        color: mColor,
        width: double.infinity,
        child:
        FadeTransition(
          opacity: _fadeAnimation,
          child: Icon(
            size: screenHeight * 0.2,
            Icons.location_on_sharp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationTextSection(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 20,top:10),
              child: Text(
                'الموقع',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
              child: Text(
                'نستخدم موقعك للمساعدة في العثور على المحطات القريبة وتوجيهك نحو أفضل الاتجاهات.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
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
                    Navigator.pushNamed(context, privacyarb.screenRoute);
                  },
                  child: const Text(
                    'الإستمرار',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
