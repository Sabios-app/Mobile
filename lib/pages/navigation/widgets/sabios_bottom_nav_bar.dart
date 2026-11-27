import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SabiosBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
<<<<<<< Updated upstream
=======
  final int unreadMessagesCount;
  final bool isCounselor;
>>>>>>> Stashed changes

  const SabiosBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
<<<<<<< Updated upstream
=======
    this.unreadMessagesCount = 0,
    this.isCounselor = false,
>>>>>>> Stashed changes
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    final navItems = [
      _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Início'),
      _NavItem(icon: Icons.search_rounded, activeIcon: Icons.search_rounded, label: 'Explorar'),
      _NavItem(icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_today_rounded, label: 'Agenda'),
      _NavItem(icon: Icons.chat_bubble_outline_rounded, activeIcon: Icons.chat_bubble_rounded, label: 'Mensagens', badgeCount: 2),
      _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Perfil'),
=======
    final badge = unreadMessagesCount > 0 ? unreadMessagesCount : null;

    final navItems = isCounselor
        ? [
      _NavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Início',
      ),
      _NavItem(
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_today_rounded,
        label: 'Agenda',
      ),
      _NavItem(
        icon: Icons.chat_bubble_outline_rounded,
        activeIcon: Icons.chat_bubble_rounded,
        label: 'Mensagens',
        badgeCount: badge,
      ),
      _NavItem(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: 'Perfil',
      ),
    ]
        : [
      _NavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Início',
      ),
      _NavItem(
        icon: Icons.search_rounded,
        activeIcon: Icons.search_rounded,
        label: 'Explorar',
      ),
      _NavItem(
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_today_rounded,
        label: 'Agenda',
      ),
      _NavItem(
        icon: Icons.chat_bubble_outline_rounded,
        activeIcon: Icons.chat_bubble_rounded,
        label: 'Mensagens',
        badgeCount: badge,
      ),
      _NavItem(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: 'Perfil',
      ),
>>>>>>> Stashed changes
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.98),
        border: const Border(
          top: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              final isActive = currentIndex == index;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      if (isActive)
                        Positioned(
                          top: 0,
                          child: Container(
                            width: 32,
                            height: 3.5,
                            decoration: const BoxDecoration(
                              color: AppColors.accentOchre,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(
                                isActive ? item.activeIcon : item.icon,
                                size: 23,
                                color: isActive
                                    ? AppColors.primaryTeal
                                    : AppColors.textPlaceholder,
                              ),
                              if (item.badgeCount != null)
                                Positioned(
                                  top: -3,
                                  right: -8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4.5,
                                      vertical: 1.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.notificationDot,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      '${item.badgeCount}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                              color: isActive
                                  ? AppColors.primaryTeal
                                  : AppColors.textPlaceholder,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int? badgeCount;

  _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badgeCount,
  });
}