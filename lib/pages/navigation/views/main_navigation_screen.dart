import 'dart:async';
import 'package:flutter/material.dart';
import '../../home/views/home_page.dart';
import '../../home/views/counselor_home_page.dart';
import '../../explore/views/explore_page.dart';
import '../../agenda/views/agenda_page.dart';
import '../../messages/views/messages_page.dart';
import '../../profile/views/profile_page.dart';
import '../widgets/sabios_bottom_nav_bar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/message_service.dart';
import '../../../services/user_service.dart';
import '../../../models/user_model.dart';

class MainNavigationScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const MainNavigationScreen({
    super.key,
    this.onLogout,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  int _unreadMessagesCount = 0;
  UserModel? _currentUser = UserService.currentUser;
  bool _isLoadingUser = UserService.currentUser == null;
  bool _missingCounselorProfile = false;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initScreen();
  }

  Future<void> _initScreen() async {
    if (_currentUser == null) {
      final user = await UserService.getMe();
      if (!mounted) return;
      setState(() {
        _currentUser = user;
        _isLoadingUser = false;
      });
    }
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    if (_missingCounselorProfile) return;

    _fetchUnreadCount();
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_missingCounselorProfile) {
        _pollingTimer?.cancel();
        return;
      }
      _fetchUnreadCount();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!_isLoadingUser && !_missingCounselorProfile) {
        _startPolling();
      }
    } else if (state == AppLifecycleState.paused) {
      _pollingTimer?.cancel();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchUnreadCount() async {
    try {
      bool isMissing = false;
      final convs = await MessageService.getConversations(
        onProfileStatus: (missing) => isMissing = missing,
      );
      if (!mounted) return;

      if (isMissing) {
        _missingCounselorProfile = true;
        _pollingTimer?.cancel();
        return;
      }

      final activeCount = convs.where((c) => c.lastMessage.isNotEmpty).length;
      setState(() {
        _unreadMessagesCount = _currentIndex == 3 ? 0 : activeCount;
      });
    } catch (_) {}
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 3) {
        _unreadMessagesCount = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUser) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryTeal),
        ),
      );
    }

    final isCounselor = _currentUser?.isCounselor ?? false;

    final homeView = isCounselor
        ? CounselorHomePage(onNavigateToTab: _onTabChanged)
        : HomePage(onNavigateToTab: _onTabChanged);

    final pages = [
      homeView,
      const ExplorePage(),
      AgendaPage(onScheduleNew: () => _onTabChanged(1)),
      const MessagesPage(),
      ProfilePage(onLogout: widget.onLogout),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: SabiosBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
        unreadMessagesCount: _unreadMessagesCount,
      ),
    );
  }
}