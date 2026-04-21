import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
// Note: firebase_options.dart will be generated after running 'flutterfire configure'
import 'firebase_options.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. Initialize Firebase first
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  // 2. Run the App UI immediately
  runApp(const HomeAlarmApp());

  // 3. Request Notification Permissions and get the FCM Token in the background
  _initializeNotifications();
}

Future<void> _initializeNotifications() async {
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Grab the unique token for this specific device
      String? token = await messaging.getToken();
      
      if (token != null) {
        // Save it directly to the database so the Cloud Function can find it
        DatabaseReference ref = FirebaseDatabase.instance.ref("AlarmSystem/fcmToken");
        await ref.set(token);
        debugPrint("FCM Token saved to database successfully!");
      }
    } else {
      debugPrint("User declined or has not accepted notification permissions");
    }
  } catch (e) {
    debugPrint("Error initializing notifications: $e");
  }
}

class HomeAlarmApp extends StatelessWidget {
  const HomeAlarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Alarm System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F2027),
        useMaterial3: true,
        colorSchemeSeed: Colors.cyanAccent,
      ),
      home: const HomeScreen(),
    );
  }
}