import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
// Note: firebase_options.dart will be generated after running 'flutterfire configure'
import 'firebase_options.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Initialize Firebase first
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Request Notification Permissions and get the FCM Token
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission();

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // Grab the unique token for this specific device
    String? token = await messaging.getToken();
    
    if (token != null) {
      // Save it directly to the database so the Cloud Function can find it
      DatabaseReference ref = FirebaseDatabase.instance.ref("AlarmSystem/fcmToken");
      await ref.set(token);
      print("FCM Token saved to database successfully!");
    }
  } else {
    print("User declined or has not accepted notification permissions");
  }

  // 3. Run the App UI
  runApp(const HomeAlarmApp());
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