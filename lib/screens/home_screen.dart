import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/glass_box.dart';
import '../widgets/glowing_button.dart';
import '../widgets/status_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _dbRef = FirebaseDatabase.instance.ref('AlarmSystem');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),
        child: SafeArea(
          child: StreamBuilder(
            stream: _dbRef.onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
              }

              final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>? ?? {};
              
              final bool systemArmed = data['systemArmed'] ?? false;
              final String door1State = data['door1State'] ?? 'CLOSED';
              final bool notificationsEnabled = data['notificationsEnabled'] ?? false;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'SMART SECURE',
                      style: GoogleFonts.orbitron(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'HOME ALARM SYSTEM',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white70,
                        letterSpacing: 2,
                      ),
                    ),
                    const Spacer(),
                    
                    // Main Toggle Button
                    GlowingButton(
                      isArmed: systemArmed,
                      onTap: () {
                        _dbRef.update({'systemArmed': !systemArmed});
                      },
                    ),
                    
                    const Spacer(),
                    
                    // Status and Settings
                    GlassBox(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            StatusIndicator(
                              label: 'Front Door',
                              status: door1State,
                              isAlert: door1State == 'OPEN',
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Divider(color: Colors.white10),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Notifications',
                                  style: TextStyle(color: Colors.white70, fontSize: 16),
                                ),
                                Switch(
                                  value: notificationsEnabled,
                                  activeColor: Colors.cyanAccent,
                                  onChanged: (value) {
                                    _dbRef.update({'notificationsEnabled': value});
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
