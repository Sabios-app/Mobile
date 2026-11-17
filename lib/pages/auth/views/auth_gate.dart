import 'package:flutter/material.dart';
import '../../navigation/views/main_navigation_screen.dart';
import 'welcome_page.dart';
import 'register_page.dart';
import 'login_page.dart';
import 'role_choice_page.dart';

enum AuthScreenState {
  welcome,
  roleChoice,
  register,
  login,
  authenticatedApp,
}

class AuthGate extends StatefulWidget {
  final AuthScreenState initialScreen;

  const AuthGate({
    super.key,
    this.initialScreen = AuthScreenState.welcome,
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late AuthScreenState _currentScreen;

  @override
  void initState() {
    super.initState();
    _currentScreen = widget.initialScreen;
  }

  void _goTo(AuthScreenState screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case AuthScreenState.welcome:
        return WelcomePage(
          onRegister: () => _goTo(AuthScreenState.roleChoice),
          onLogin: () => _goTo(AuthScreenState.login),
          onSkipToApp: () => _goTo(AuthScreenState.authenticatedApp),
        );

      case AuthScreenState.roleChoice:
        return RoleChoicePage(
          onChooseRole: (role) => _goTo(AuthScreenState.register),
          onLogin: () => _goTo(AuthScreenState.login),
          onBack: () => _goTo(AuthScreenState.welcome),
        );

      case AuthScreenState.register:
        return RegisterPage(
          onBack: () => _goTo(AuthScreenState.welcome),
          onContinue: () => _goTo(AuthScreenState.authenticatedApp),
          onGoToLogin: () => _goTo(AuthScreenState.login),
        );

      case AuthScreenState.login:
        return LoginPage(
          onBack: () => _goTo(AuthScreenState.welcome),
          onContinue: () => _goTo(AuthScreenState.authenticatedApp),
          onGoToRegister: () => _goTo(AuthScreenState.register),
        );

      case AuthScreenState.authenticatedApp:
        return const MainNavigationScreen();
    }
  }
}
