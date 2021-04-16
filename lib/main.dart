import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:glm_mobile/utilities/constants.dart';
import 'package:glm_mobile/view/booking.dart';
import 'package:glm_mobile/view/current_booking.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //Route
      initialRoute: '/booking',
      routes: {
        '/booking':           (context) => Booking(),
        // '/current_bookings':  (context) => CurrentBookings(),
      },
      title: 'Pearlstone',
      theme: ThemeData(
        primaryColor: logoYellow,
        canvasColor: appBackgroundFirst,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}