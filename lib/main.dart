import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'pages/auth/views/auth_gate.dart';

void main() {
  runApp(const SabiosApp());
}

class SabiosApp extends StatelessWidget {
  final AuthScreenState initialScreen;

  const SabiosApp({
    super.key,
    this.initialScreen = AuthScreenState.welcome,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sábios',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: AuthGate(initialScreen: initialScreen),
    );
  }
}

