import 'package:flutter/material.dart';
import '../../home/views/home_page.dart';
import '../../explore/views/explore_page.dart';
import '../../agenda/views/agenda_page.dart';
import '../../messages/views/messages_page.dart';
import '../../profile/views/profile_page.dart';
import '../widgets/sabios_bottom_nav_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const MainNavigationScreen({
    super.key,
    this.onLogout,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabChanged(int index) {
    final isCounselor = _currentUser?.isCounselor ?? false;
    final messagesIndex = isCounselor ? 2 : 3;

    setState(() {
      _currentIndex = index;
<<<<<<< Updated upstream
=======
      if (index == messagesIndex) {
        _unreadMessagesCount = 0;
      }
>>>>>>> Stashed changes
    });
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    final pages = [
=======
    if (_isLoadingUser) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryTeal),
        ),
      );
    }

    final isCounselor = _currentUser?.isCounselor ?? false;

    final pages = isCounselor
        ? [
      CounselorHomePage(onNavigateToTab: _onTabChanged),
      AgendaPage(onScheduleNew: () => _onTabChanged(0)),
      const MessagesPage(),
      ProfilePage(onLogout: widget.onLogout),
    ]
        : [
>>>>>>> Stashed changes
      HomePage(onNavigateToTab: _onTabChanged),
      const ExplorePage(),
      AgendaPage(onScheduleNew: () => _onTabChanged(1)),
      const MessagesPage(),
      ProfilePage(onLogout: widget.onLogout),
    ];

    final safeIndex = _currentIndex >= pages.length ? 0 : _currentIndex;

    return Scaffold(
      body: IndexedStack(
        index: safeIndex,
        children: pages,
      ),
      bottomNavigationBar: SabiosBottomNavBar(
        currentIndex: safeIndex,
        onTap: _onTabChanged,
<<<<<<< Updated upstream
=======
        unreadMessagesCount: _unreadMessagesCount,
        isCounselor: isCounselor,
>>>>>>> Stashed changes
      ),
    );
  }
}
