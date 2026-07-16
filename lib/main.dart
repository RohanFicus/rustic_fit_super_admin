import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase.
  // Can be passed via --dart-define or directly replaced below.
  const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://giethkxggfmfmmxkittu.supabase.co',
  );
  const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdpZXRoa3hnZ2ZtZm1teGtpdHR1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQyMTcxMjAsImV4cCI6MjA5OTc5MzEyMH0.0UYre4tFlBazwbetDJ8QEuodPzIpzBmM-_a13ybwoPU',
  );

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruscfit Super Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A1B9A)),
        useMaterial3: true,
        fontFamily: 'Inter', // Assuming Inter or similar professional font
      ),
      home: const SplashScreen(),
    );
  }
}
