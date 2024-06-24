import 'package:flutter/material.dart';
import 'package:testm/Splash.dart';
import 'package:testm/start.dart';
import 'package:testm/lang.dart';
import 'package:testm/ notarb.dart';
import 'package:testm/locarb.dart';
import 'package:testm/notifications.dart';
import 'package:testm/loc.dart';
import 'package:testm/state.dart';
import 'package:testm/statearb.dart';
import 'package:testm/dis.dart';
import 'package:testm/normal.dart';
import 'package:testm/disarb.dart';
import 'package:testm/privacy.dart';
import 'package:testm/privacyarb.dart';

void main() {
runApp(MyApp());
}

class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false, // لتعطيل شارة وضع التصحيح
initialRoute: SplashScreen.screenRoute, // المسار الافتراضي إلى شاشة Splash
routes: {
SplashScreen.screenRoute: (context) => SplashScreen(),
start.screenRoute: (context) => start(),
lang.screenRoute: (context) => lang(),
notarb.screenRoute: (context) => notarb(),
locarb.screenRoute: (context) => locarb(),
notifications.screenRoute: (context) => notifications(),
loc.screenRoute: (context) => loc(),
state.screenRoute: (context) => state(),
statearb.screenRoute: (context) => statearb(),
dis.screenRoute: (context) => dis(),
normal.screenRoute: (context) => normal(),
disarb.screenRoute: (context) => disarb(),
privacy.screenRoute: (context) => privacy(),
privacyarb.screenRoute: (context) => privacyarb(),
},
// إعداد `onUnknownRoute` لتجنب حدوث خطأ عندما لا يتم العثور على المسار
onUnknownRoute: (settings) {
return MaterialPageRoute(builder: (context) => start());
},
);
}
}
