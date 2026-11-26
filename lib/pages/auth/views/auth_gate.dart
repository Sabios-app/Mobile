import 'package:flutter/material.dart';
import '../../navigation/views/main_navigation_screen.dart';
import '../../../services/notification_service.dart';
import '../../../services/session_service.dart';
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
  String _selectedRole = 'CLIENT';
  bool _isCheckingSession = true;

  @override
  void initState() {
    super.initState();
    _currentScreen = widget.initialScreen;
    _checkStoredSession();
  }

  Future<void> _checkStoredSession() async {
    try {
      final jwt = await SessionService.getValidToken();
      if (jwt != null && jwt.isNotEmpty) {
        debugPrint('[AuthGate] Sessão válida encontrada. Inicializando notificações e direcionando ao app...');
        await NotificationService.initialize(jwtToken: jwt);
        if (mounted) {
          setState(() {
            _currentScreen = AuthScreenState.authenticatedApp;
            _isCheckingSession = false;
          });
        }
        return;
      }
    } catch (e) {
      debugPrint('[AuthGate] Erro ao verificar sessão persistida: $e');
    }

    if (mounted) {
      setState(() {
        _isCheckingSession = false;
      });
    }
  }

  void _goTo(AuthScreenState screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingSession) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    switch (_currentScreen) {
      case AuthScreenState.welcome:
        return WelcomePage(
          onRegister: () => _goTo(AuthScreenState.roleChoice),
          onLogin: () => _goTo(AuthScreenState.login),
          onSkipToApp: () => _goTo(AuthScreenState.authenticatedApp),
        );

      case AuthScreenState.roleChoice:
        return RoleChoicePage(
          onChooseRole: (role) {
            _selectedRole = role.toUpperCase();
            _goTo(AuthScreenState.register);
          },
          onLogin: () => _goTo(AuthScreenState.login),
          onBack: () => _goTo(AuthScreenState.welcome),
        );

      case AuthScreenState.register:
        return RegisterPage(
          role: _selectedRole,
          onBack: () => _goTo(AuthScreenState.roleChoice),
          onContinue: () => _goTo(AuthScreenState.authenticatedApp),
          onGoToLogin: () => _goTo(AuthScreenState.login),
        );

      case AuthScreenState.login:
        return LoginPage(
          onBack: () => _goTo(AuthScreenState.welcome),
          onContinue: () => _goTo(AuthScreenState.authenticatedApp),
          onGoToRegister: () => _goTo(AuthScreenState.roleChoice),
        );

      case AuthScreenState.authenticatedApp:
        return MainNavigationScreen(
          onLogout: () => _goTo(AuthScreenState.welcome),
        );
    }
  }
}