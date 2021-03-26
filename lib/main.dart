import 'package:flutter/material.dart';
import 'package:glm_mobile/utilities/constants.dart';
import 'package:glm_mobile/view/booking.dart';
import 'package:glm_mobile/view/current_booking.dart';

void main() {
  runApp(MyApp());

//  Yellow FFCA0A
//  Grey 505D58
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
        '/current_bookings':  (context) => CurrentBookings(),
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